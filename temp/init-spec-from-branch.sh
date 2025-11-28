#!/usr/bin/env bash

set -e

JSON_MODE=false
ARGS=()
i=1
while [ $i -le $# ]; do
    arg="${!i}"
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --help|-h)
            echo "Usage: $0 [--json] <feature_description>"
            echo ""
            echo "Initializes spec directory structure based on current branch name."
            echo "Works with any branch name - no naming pattern required."
            echo ""
            echo "Options:"
            echo "  --json              Output in JSON format"
            echo "  --help, -h          Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 'Add user authentication system'"
            echo "  $0 --json 'Implement OAuth2 integration for API'"
            exit 0
            ;;
        *)
            ARGS+=("$arg")
            ;;
    esac
    i=$((i + 1))
done

FEATURE_DESCRIPTION="${ARGS[*]}"
if [ -z "$FEATURE_DESCRIPTION" ]; then
    echo "Usage: $0 [--json] <feature_description>" >&2
    echo "Error: Feature description is required" >&2
    exit 1
fi

# Function to find the repository root by searching for existing project markers
find_repo_root() {
    local dir="$1"
    while [ "$dir" != "/" ]; do
        if [ -d "$dir/.git" ] || [ -d "$dir/.specify" ]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

# Resolve repository root
SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if git rev-parse --show-toplevel >/dev/null 2>&1; then
    REPO_ROOT=$(git rev-parse --show-toplevel)
    HAS_GIT=true
else
    REPO_ROOT="$(find_repo_root "$SCRIPT_DIR")"
    if [ -z "$REPO_ROOT" ]; then
        echo "Error: Could not determine repository root. Please run this script from within the repository." >&2
        exit 1
    fi
    HAS_GIT=false
fi

cd "$REPO_ROOT"

# Get current branch name
if [ "$HAS_GIT" = true ]; then
    BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

    # Extract feature number if branch name matches pattern (###-feature-name), otherwise leave empty
    if echo "$BRANCH_NAME" | grep -qE '^[0-9]{3}-'; then
        FEATURE_NUM=$(echo "$BRANCH_NAME" | grep -oE '^[0-9]{3}')
    else
        FEATURE_NUM=""
    fi
else
    echo "Error: Git repository not detected. This command requires git." >&2
    exit 1
fi

SPECS_DIR="$REPO_ROOT/specs"
mkdir -p "$SPECS_DIR"

FEATURE_DIR="$SPECS_DIR/$BRANCH_NAME"
mkdir -p "$FEATURE_DIR"

TEMPLATE="$REPO_ROOT/.specify/templates/spec-template.md"
SPEC_FILE="$FEATURE_DIR/spec.md"

# Only copy template if spec.md doesn't already exist
if [ ! -f "$SPEC_FILE" ]; then
    if [ -f "$TEMPLATE" ]; then
        cp "$TEMPLATE" "$SPEC_FILE"
    else
        touch "$SPEC_FILE"
    fi
else
    >&2 echo "[specify] Note: $SPEC_FILE already exists, skipping template copy"
fi

# Set the SPECIFY_FEATURE environment variable for the current session
export SPECIFY_FEATURE="$BRANCH_NAME"

if $JSON_MODE; then
    printf '{"BRANCH_NAME":"%s","SPEC_FILE":"%s","FEATURE_NUM":"%s"}\n' "$BRANCH_NAME" "$SPEC_FILE" "$FEATURE_NUM"
else
    echo "BRANCH_NAME: $BRANCH_NAME"
    echo "SPEC_FILE: $SPEC_FILE"
    echo "FEATURE_NUM: $FEATURE_NUM"
    echo "SPECIFY_FEATURE environment variable set to: $BRANCH_NAME"
fi
