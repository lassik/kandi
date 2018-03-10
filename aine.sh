#!/bin/sh
set -eu
exec </dev/null 2>&1
doc="$(basename "$0")"
doc="${doc%%.sh}"
cd "$(dirname "$0")"
echo "Entering directory '$PWD'"
command -V pdflatex >/dev/null
command -V bibtex >/dev/null
set -x
rm -f "$doc".aux "$doc".bbl "$doc".blg "$doc".log "$doc".pdf "$doc".toc
pdflatex "$doc" >/dev/null
bibtex "$doc"
pdflatex "$doc" >/dev/null
pdflatex "$doc"
