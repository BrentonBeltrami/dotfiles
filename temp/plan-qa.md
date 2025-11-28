---
description: Generate an actionable, dependency-ordered tasks.md for the feature based on available design artifacts.
handoffs:
  - label: Create Feature Specification
    agent: speckit.specify
    prompt: Take the Q&A summary and create a detailed feature specification
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Goal: Conduct a thorough but concise question-and-answer session with the user to gather all necessary information for building a comprehensive feature plan. Store the conversation history and optionally generate outputs based on user preference.

Execution steps:

1. **Initialize Conversation File**
   - Create or overwrite `conversation.md` at the project root
   - Add header with timestamp: `# Feature Planning Q&A - [YYYY-MM-DD HH:MM]`
   - If `$ARGUMENTS` provided, add section: `## Initial Feature Description\n\n$ARGUMENTS`

2. **Determine Question Scope**
   - Analyze the initial feature description (if provided) or ask for a brief feature description
   - Based on the feature description, identify which categories require clarification
   - Prioritize questions in this order:
     1. Feature description & user problem (HIGHEST PRIORITY)
     2. Success criteria & edge cases
     3. Technical requirements (database, API, UI)
     4. Dependencies & integration points (LOWEST PRIORITY unless critical)

3. **Question Categories to Cover** (adapt based on feature complexity):

   **Feature Description & User Problem:**
   - What problem does this feature solve?
   - Who are the primary users/personas?
   - What is the core user goal?
   - What is explicitly out of scope?

   **Success Criteria & Edge Cases:**
   - How will we know this feature is complete?
   - What are the critical success metrics?
   - What edge cases or error scenarios must be handled?
   - What happens when things go wrong?

   **Technical Requirements (Database, API, UI):**
   - What data needs to be stored (entities, relationships)?
   - What API endpoints or server logic is required?
   - What UI components or pages are needed?
   - Are there performance or scalability requirements?

   **Dependencies & Integration Points:**
   - Does this integrate with existing features?
   - Are there external services or APIs involved?
   - What existing code will be affected?
   - Are there security or authentication considerations?

4. **Interactive Q&A Session**

   **Question Format Rules:**
   - Ask ONE question at a time
   - For questions with clear discrete options (2-5 choices):
     * Analyze all options and determine the most suitable based on best practices, project context, and risk reduction
     * Present your recommended option prominently at the top with reasoning (1-2 sentences)
     * Format as: `**Recommended:** Option [X] - <reasoning>`
     * Present all options in a clear Markdown table:

     | Option | Description |
     |--------|-------------|
     | A | <Option A description> |
     | B | <Option B description> |
     | C | <Option C description> |
     | Custom | Provide your own answer |

     * Add: `You can reply with the option letter (e.g., "A"), accept the recommendation by saying "yes" or "recommended", or provide your own answer.`

   - For open-ended questions:
     * Provide your suggested answer based on best practices and context
     * Format as: `**Suggested:** <your proposed answer> - <brief reasoning>`
     * Add: `You can accept the suggestion by saying "yes" or "suggested", or provide your own answer.`

   - After each user answer:
     * If user says "yes", "recommended", or "suggested", use your stated recommendation/suggestion
     * Otherwise, validate and accept their answer
     * Immediately append to `conversation.md`:
       ```
       ## Q[N]: [Question text]
       **Asked:** [timestamp]
       **Answer:** [final answer]
       [Optional context/reasoning if relevant]
       ```
     * Save the file after each Q&A exchange

   - Continue asking questions until:
     * You have sufficient information to create a comprehensive plan, OR
     * User signals completion ("done", "that's enough", "proceed"), OR
     * You've asked enough questions to cover the critical categories (use judgment - typically 5-10 questions for most features)

5. **Adaptive Question Flow**
   - Start with 1-2 questions about the feature description & user problem
   - Based on those answers, adapt subsequent questions to the specific feature type
   - Skip categories that aren't relevant (e.g., don't ask about database schema for a pure UI refactor)
   - If a question's answer makes follow-up questions unnecessary, skip them
   - Prioritize depth over breadth - get actionable details in critical areas

6. **Completion & Output Options**

   After the Q&A session concludes, append a summary section to `conversation.md`:
   ```
   ## Summary
   **Total Questions Asked:** [N]
   **Session Duration:** [start time] - [end time]
   **Categories Covered:**
   - Feature description & user problem: [✓/✗]
   - Success criteria & edge cases: [✓/✗]
   - Technical requirements: [✓/✗]
   - Dependencies & integration: [✓/✗]
   ```

   Then present the user with output options:

   ```
   Q&A session complete! Conversation saved to: conversation.md

   What would you like to do next?

   A) Generate a concise summary and save to plan.md
   B) Generate a concise summary and pipe to /speckit.specify
   C) Do both A and B
   D) Just save the conversation (already done)

   Please reply with your choice (A, B, C, or D).
   ```

   Based on user selection:
   - **Option A:** Create a `plan.md` file with a structured summary of the Q&A (include feature overview, requirements, success criteria, technical approach, and next steps)
   - **Option B:** Generate the same summary and pass it to `/speckit.specify` using the SlashCommand tool
   - **Option C:** Do both A and B sequentially
   - **Option D:** Confirm conversation.md was saved and end

7. **Plan Summary Format** (for Options A, B, C):

   When generating a plan summary, use this structure:

   ```markdown
   # [Feature Name] - Implementation Plan

   **Generated from Q&A Session:** [timestamp]
   **Full conversation:** conversation.md

   ## Feature Overview
   [1-2 paragraphs summarizing the feature and user problem]

   ## Key Requirements
   [Bulleted list of core requirements from Q&A]

   ## Success Criteria
   [Clear, measurable criteria for feature completion]

   ## Technical Approach

   ### Database Changes
   [Schema changes, new tables, relationships - or "None" if not applicable]

   ### API/Server Changes
   [New endpoints, business logic, services - or "None" if not applicable]

   ### UI Changes
   [Components, pages, user flows - or "None" if not applicable]

   ## Edge Cases & Error Handling
   [Critical edge cases and how they'll be handled]

   ## Dependencies & Integration Points
   [Existing code affected, external services, etc. - or "None" if isolated]

   ## Open Questions
   [Any remaining uncertainties or decisions to be made]

   ## Recommended Next Steps
   [Ordered list of implementation steps based on the Fullstack Feature Implementation order from CLAUDE.md]
   ```

Behavior rules:

- **Be conversational but concise** - Keep questions clear and focused
- **Adapt dynamically** - Don't rigidly follow categories if they're not relevant
- **Save frequently** - Write to conversation.md after each Q&A exchange
- **Provide guidance** - Offer recommendations/suggestions for all questions to help users make informed decisions
- **Respect user signals** - If user wants to end early, summarize what you have and proceed
- **Use structured formats** - Tables and clear formatting help trigger potential interactive UI elements
- **Stay focused on planning** - Avoid implementation details; gather requirements and approach
- **Validate answers** - Ensure answers are clear and actionable before moving on
- **Quality over quantity** - Better to have 5 excellent questions than 15 mediocre ones

Context for initial question generation: $ARGUMENTS
