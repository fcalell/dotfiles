#!/bin/bash
# Block: never cd into subdirectories. Run all commands from project root.
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

if echo "$COMMAND" | grep -qE '(^|;|&&|\|\|)\s*cd\s'; then
  echo "Blocked: do not cd into subdirectories. Run commands from project root using relative paths." >&2
  exit 2
fi

exit 0
