#!/bin/sh
set -eux
command -V markdown-pdf >/dev/null
markdown-pdf \
    --paper-format A4 \
    --remarkable-options '{"breaks": false}' \
    -o essee.pdf \
    essee.md
