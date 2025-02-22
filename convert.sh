#!/bin/bash

# Dateinamen
input_file="Things TWW.md"
#css_source_file="index.html"
output_file="Things_TWW.html"
css_file="temp_css.txt"

# Extrahiere das CSS aus der bestehenden HTML-Datei
# awk '/<style type="text\/css">/,/<\/style>/' "$css_source_file" > "$temp_css_file"

# Konvertiere das Markdown zu HTML mit pandoc
pandoc "$input_file" -o "$output_file" --metadata pagetitle="Things TWW" --standalone --metadata title="Things TWW"

# Füge das CSS direkt vor </head> in die HTML-Datei ein
awk -v css_file="$css_file" '
    BEGIN {
        while ((getline line < css_file) > 0) {
            css = css line "\n"
        }
        close(css_file)
    }
    { print }
    /<\/head>/ { print css }
' "$output_file" > temp.html && mv temp.html "$output_file"

# Lösche die temporäre CSS-Datei
#rm "$temp_css_file"

# Erfolgsmeldung
if [ $? -eq 0 ]; then
  echo "Die HTML-Datei wurde erfolgreich erstellt: $output_file"
else
  echo "Ein Fehler ist aufgetreten."
fi
