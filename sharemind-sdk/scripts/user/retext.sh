#!/bin/bash
set -e -x

# ReText is installed as we have README files written in Markdown.
# Enable Preview mode by default and install a separate stylesheet so the
# code snippets in preview are more legible.
mkdir -p "${HOME}/.config/ReText project/"

wget https://github.com/a-mt/retext-themes/raw/master/Github/github.css \
    -O "${HOME}/.config/ReText project/github.css"

cat << EOF > "${HOME}/.config/ReText project/ReText.conf"
[General]
defaultPreviewState=normal-preview
useWebKit=true
styleSheet=${HOME}/.config/ReText project/github.css

[ColorScheme]
codeSpans=#da4453
lineNumberArea=#EFEBE7
lineNumberAreaText=#BCB8B5
marginLine=#3daee9
markdownLinks=#2980b9
EOF

cat << EOF > "${HOME}/.config/ReText project/stylesheet-attribution.txt"
Github stylesheet (github.css) and color scheme from https://github.com/a-mt/retext-themes, 
authored by EndangeredMassa.
EOF
