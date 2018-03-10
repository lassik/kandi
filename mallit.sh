#!/bin/sh
# Muokkaa laitoksen LaTeX-mallipohjat käyttökuntoon.
set -eu
cd "$(dirname "$0")"
echo "Entering directory '$PWD'"
command -V iconv >/dev/null
set -x
test -f mallit.tar.bz2
for file in kuvaesimerkki.eps lahteet.bib malli.tex tktltiki.cls; do
    test ! -e "$file"
    # Pura tiedosto tar-paketista.
    tar -xf mallit.tar.bz2 "$file"
    # Muunna Windows-rivinvaihdot Unix-muotoon.
    LC_ALL=C tr -d '\r' <"$file" >"$file".tmp1
    # Muunna merkistökoodaus Latin-9:stä UTF-8:ksi.
    iconv -f iso-8859-9 -t utf8 "$file".tmp1 >"$file".tmp2
    # Korjaa myös LaTeX:in käsitys merkistökoodauksesta (inputenc).
    sed 's/latin9/utf8x/g' <"$file".tmp2 >"$file".tmp3
    rm -f "$file".tmp1 "$file".tmp2
    mv -f "$file".tmp3 "$file"
done
mv -f lahteet.bib malli.bib
sed 's/bibliography{lahteet}/bibliography{malli}/' <malli.tex >malli.tex.tmp
mv -f malli.tex.tmp malli.tex
for doc in aine kandi; do
    test ! -e "$doc".bib
    test ! -e "$doc".tex
    cp -fp malli.sh "$doc".sh
    cp -fp malli.bib "$doc".bib
    cp -fp malli.tex "$doc".tex
    sed "s/bibliography{malli}/bibliography{$doc}/" <"$doc".tex >"$doc".tex.tmp
    mv -f "$doc".tex.tmp "$doc".tex
done
