#! /bin/sh

set -eu

INSTALL_DIR=$( cd "$( dirname "$0" )" && pwd )
APPLESCRIPT_SOURCE="$INSTALL_DIR/ui/SyriacKeyboardInstaller.applescript"
BUILD_DIR="$INSTALL_DIR/build"
DIST_DIR="$INSTALL_DIR/dist"
APP_NAME="Syriac Keyboard Installer.app"
APP_PATH="$BUILD_DIR/$APP_NAME"
DIST_APP_PATH="$DIST_DIR/$APP_NAME"
ZIP_PATH="$DIST_DIR/Syriac-Keyboard-Installer-macOS.zip"
PAYLOAD_DIR="$APP_PATH/Contents/Resources/payload"

rm -rf "$APP_PATH"
mkdir -p "$BUILD_DIR"
mkdir -p "$DIST_DIR"
rm -rf "$DIST_APP_PATH" "$ZIP_PATH"

osacompile -o "$APP_PATH" "$APPLESCRIPT_SOURCE"

mkdir -p "$PAYLOAD_DIR"
cp "$INSTALL_DIR/setup.command" "$PAYLOAD_DIR/"
cp "$INSTALL_DIR/setup_arabic_phonetic.command" "$PAYLOAD_DIR/"
cp -R "$INSTALL_DIR/fonts" "$PAYLOAD_DIR/"
cp -R "$INSTALL_DIR/legacy" "$PAYLOAD_DIR/"
cp "$INSTALL_DIR/README.md" "$PAYLOAD_DIR/"

chmod 755 "$PAYLOAD_DIR/setup.command" "$PAYLOAD_DIR/setup_arabic_phonetic.command"

cp -R "$APP_PATH" "$DIST_APP_PATH"
ditto -c -k --sequesterRsrc --keepParent "$DIST_APP_PATH" "$ZIP_PATH"

echo ""
echo "Built:"
echo "$DIST_APP_PATH"
echo ""
echo "Zipped:"
echo "$ZIP_PATH"
