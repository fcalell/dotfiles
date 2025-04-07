#!/usr/bin/env bash
set -e

if [ "$#" -ne 1 ]; then
  echo "Usage: md2pdf <file.md>"
  exit 1
fi

input="$1"
if [[ ! -f "$input" ]]; then
  echo "❌ File not found: $input"
  exit 1
fi
if [[ "$input" != *.md ]]; then
  echo "❌ Input file must have a .md extension."
  exit 1
fi

output="${input%.md}.pdf"
TEMPLATE_PATH="$HOME/.config/pandoc/templates/eisvogel.latex"

if [[ ! -f "$TEMPLATE_PATH" ]]; then
  echo "❌ eisvogel template not found at: $TEMPLATE_PATH"
  echo "   Download it from:"
  echo "   https://github.com/Wandmalfarbe/pandoc-latex-template"
  exit 1
fi

echo "📄 Converting $input → $output ..."
pandoc "$input" -o "$output" \
  --from markdown \
  --template="$TEMPLATE_PATH" \
  --listings \
  -V colorlinks=true \
  -V linkcolor=blue \
  -V geometry:margin=1in \
  -V fontsize=12pt \
  -V mainfont="Noto Sans"

echo "✅ Done! Output: $output"
