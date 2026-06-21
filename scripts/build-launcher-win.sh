#!/bin/bash
# Launcher Windows (~300 KB zip) — cabe en el límite de 10 MB del formulario.
# Genera carpeta + zip para Windows (Chrome o Edge + entrega.html).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="$ROOT/dist-launcher-win"
ZIP_NAME="LeVamps-Portfolio-Launcher-win.zip"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

cp "$ROOT/entrega.html" "$OUT_DIR/entrega.html"
cp "$ROOT/scripts/LeVamps Portfolio.bat" "$OUT_DIR/LeVamps Portfolio.bat"

cd "$OUT_DIR"
rm -f "$ZIP_NAME"
zip -r -q "$ZIP_NAME" "entrega.html" "LeVamps Portfolio.bat"

echo ""
echo "✓ Carpeta: $OUT_DIR"
echo "✓ Zip:     $OUT_DIR/$ZIP_NAME"
du -sh "$OUT_DIR" "$OUT_DIR/$ZIP_NAME"
