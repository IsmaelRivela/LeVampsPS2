#!/bin/bash
# Launcher .app (~50 KB) — cabe en el límite de 10 MB del formulario.
# Requiere internet + Chrome (recomendado) o Safari.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="LeVamps Portfolio.app"
OUT_DIR="$ROOT/dist-launcher"
APP_PATH="$OUT_DIR/$APP_NAME"
RES="$APP_PATH/Contents/Resources"
MACOS="$APP_PATH/Contents/MacOS"

rm -rf "$APP_PATH"
mkdir -p "$RES" "$MACOS"

cp "$ROOT/entrega.html" "$RES/entrega.html"

ICON_SRC="$ROOT/build/icon.png"
if [ -f "$ICON_SRC" ]; then
  ICONSET="$(mktemp -d)/icon.iconset"
  MASTER="$(mktemp).png"
  mkdir -p "$ICONSET"

  # Recorte cuadrado centrado → tamaños exigidos por macOS
  sips -c 1024 1024 "$ICON_SRC" --out "$MASTER" >/dev/null
  sips -z 16 16     "$MASTER" --out "$ICONSET/icon_16x16.png" >/dev/null
  sips -z 32 32     "$MASTER" --out "$ICONSET/icon_16x16@2x.png" >/dev/null
  sips -z 32 32     "$MASTER" --out "$ICONSET/icon_32x32.png" >/dev/null
  sips -z 64 64     "$MASTER" --out "$ICONSET/icon_32x32@2x.png" >/dev/null
  sips -z 128 128   "$MASTER" --out "$ICONSET/icon_128x128.png" >/dev/null
  sips -z 256 256   "$MASTER" --out "$ICONSET/icon_128x128@2x.png" >/dev/null
  sips -z 256 256   "$MASTER" --out "$ICONSET/icon_256x256.png" >/dev/null
  sips -z 512 512   "$MASTER" --out "$ICONSET/icon_256x256@2x.png" >/dev/null
  sips -z 512 512   "$MASTER" --out "$ICONSET/icon_512x512.png" >/dev/null
  sips -z 1024 1024 "$MASTER" --out "$ICONSET/icon_512x512@2x.png" >/dev/null
  iconutil -c icns "$ICONSET" -o "$RES/icon.icns"

  rm -f "$MASTER"
  rm -rf "$(dirname "$ICONSET")"
fi

cat > "$MACOS/launcher" << 'LAUNCHER'
#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
RES="$DIR/../Resources"
HTML="$RES/entrega.html"
URL="file://$HTML"

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [ -x "$CHROME" ]; then
  exec "$CHROME" --app="$URL" --new-window --window-size=1280,720
fi

open "$HTML"
LAUNCHER

chmod +x "$MACOS/launcher"

cat > "$APP_PATH/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>es</string>
  <key>CFBundleExecutable</key>
  <string>launcher</string>
  <key>CFBundleIdentifier</key>
  <string>com.levamps.portfolio.launcher</string>
  <key>CFBundleName</key>
  <string>LeVamps Portfolio</string>
  <key>CFBundleDisplayName</key>
  <string>LeVamps Portfolio</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0.0</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>CFBundleIconFile</key>
  <string>icon</string>
  <key>LSMinimumSystemVersion</key>
  <string>10.13</string>
  <key>NSHighResolutionCapable</key>
  <true/>
</dict>
</plist>
PLIST

cd "$OUT_DIR"
ZIP_NAME="LeVamps-Portfolio-Launcher-mac.zip"
rm -f "$ZIP_NAME"
ditto -c -k --sequesterRsrc --keepParent "$APP_NAME" "$ZIP_NAME"

echo ""
echo "✓ App:  $APP_PATH"
echo "✓ Zip:  $OUT_DIR/$ZIP_NAME"
du -sh "$APP_PATH" "$OUT_DIR/$ZIP_NAME"
