# !/usr/bin/env bash

document_path="$HOME/bragdoc.txt"

read -p "Enter text to append: " user_input

datetime=$(date +"%Y-%m-%d %H:%M:%S")
formatted_text="$datetime : $user_input"

echo "$formatted_text" >>"$document_path"
