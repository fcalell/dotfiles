#!/bin/bash
INPUT=$(</dev/stdin)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] && exit 0

case "$FILE_PATH" in
  *.ts|*.tsx|*.js|*.jsx|*.css) ;;
  *) exit 0 ;;
esac

# Walk up from the file to find the nearest node_modules/.bin/biome
DIR=$(dirname "$FILE_PATH")
while [ "$DIR" != "/" ]; do
  if [ -x "$DIR/node_modules/.bin/biome" ]; then
    "$DIR/node_modules/.bin/biome" check --write --unsafe "$FILE_PATH" 2>&1 || true
    exit 0
  fi
  DIR=$(dirname "$DIR")
done
exit 0
