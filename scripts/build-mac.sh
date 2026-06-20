#!/bin/bash
# Ejecuta esto UNA VEZ tú (o en CI) para generar el deliverable.
# La persona que recibe el .app / .exe NO necesita npm ni nada.
set -e
cd "$(dirname "$0")"
echo "→ Instalando dependencias de build..."
npm install
echo "→ Generando app para macOS..."
npm run build:mac
echo ""
echo "✓ Listo. Entrega estos archivos (están en dist/):"
ls -lh dist/*.zip 2>/dev/null || ls -lh dist/
