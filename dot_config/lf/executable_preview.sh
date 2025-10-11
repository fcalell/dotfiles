#!/bin/bash

file="$1"
width="$2"
height="$3"
x="$4"
y="$5"

if [[ -d "$file" ]]; then
    # Directory preview with eza
    eza --tree --color=always --icons "$file"
elif [[ "$(file -Lb --mime-type "$file")" =~ ^text ]]; then
    # Text file preview with bat
    bat --color=always --style=numbers --line-range=:500 "$file"
else
    # Binary file info
    file -Lb "$file"
fi
