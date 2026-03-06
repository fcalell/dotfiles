#!/bin/bash
# Block: use dedicated tools (Read, Grep, Glob, Edit) instead of shell equivalents.
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

if echo "$COMMAND" | grep -qE '^\s*(cat|head|tail|grep|rg|find|sed|awk)\s'; then
  TOOL=$(echo "$COMMAND" | grep -oE '^\s*(cat|head|tail|grep|rg|find|sed|awk)' | xargs)
  case "$TOOL" in
    cat|head|tail) ALT="Read" ;;
    grep|rg)       ALT="Grep" ;;
    find)          ALT="Glob" ;;
    sed|awk)       ALT="Edit" ;;
  esac
  echo "Blocked: use the $ALT tool instead of '$TOOL'." >&2
  exit 2
fi

exit 0
