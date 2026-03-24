#! /bin/sh

##
# @author Sargis Yonan (sargis@yonan.org)
# @date 3 May 2020
# @file setup_arabic_phonetic.command
#
# @brief Enable the built-in Syriac Arabic keyboard or install the legacy keyboard on a Mac
# @usage ./setup_arabic_phonetic.command
#
# @note macOS 12.0 (Monterey) and newer use the built-in Assyrian keyboard.
# @note Older macOS versions fall back to the legacy keyboard bundled in this repo.
##

# Get the directory in which the installation script lives.
INSTALL_DIR=$( cd "$( dirname "$0" )" && pwd )
# Push into the script directory to get relative paths to work.
pushd "$INSTALL_DIR" > /dev/null

MACOS_MAJOR_VERSION=$(sw_vers -productVersion | cut -d '.' -f 1)

BUILTIN_LAYOUT_ID="-31486"
BUILTIN_LAYOUT_NAME="Syriac-Arabic"
LEGACY_LAYOUT_ID="0x0001045a"
LEGACY_LAYOUT_NAME="Syriac (Arabic Phonetic)"
LEGACY_LAYOUT_FILE="$INSTALL_DIR/legacy/SyriacArabicPhonetic.keylayout"
KEYBOARD_LAYOUT_DIR="$HOME/Library/Keyboard Layouts"

add_input_source_if_missing() {
    PREF_KEY="$1"
    MATCH_PATTERN="$2"
    INPUT_SOURCE_PLIST="$3"

    if defaults read com.apple.HIToolbox "$PREF_KEY" 2>/dev/null | grep -Fq "$MATCH_PATTERN"; then
        echo "$MATCH_PATTERN is already present in $PREF_KEY."
        return
    fi

    echo "Adding $MATCH_PATTERN to $PREF_KEY..."
    defaults write com.apple.HIToolbox "$PREF_KEY" -array-add "$INPUT_SOURCE_PLIST"
}

if [ "$MACOS_MAJOR_VERSION" -ge 12 ]; then
    echo "Enabling the built-in Syriac Arabic keyboard on the system..."

    BUILTIN_LAYOUT_PLIST="<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>$BUILTIN_LAYOUT_ID</integer><key>KeyboardLayout Name</key><string>$BUILTIN_LAYOUT_NAME</string></dict>"

    add_input_source_if_missing AppleSelectedInputSources "$BUILTIN_LAYOUT_NAME" "$BUILTIN_LAYOUT_PLIST"
    add_input_source_if_missing AppleInputSourceHistory "$BUILTIN_LAYOUT_NAME" "$BUILTIN_LAYOUT_PLIST"
    add_input_source_if_missing AppleEnabledInputSources "$BUILTIN_LAYOUT_NAME" "$BUILTIN_LAYOUT_PLIST"
else
    echo "macOS $(sw_vers -productVersion) does not include the built-in Syriac Arabic keyboard."
    echo "Installing the legacy $LEGACY_LAYOUT_NAME keyboard instead..."

    mkdir -p "$KEYBOARD_LAYOUT_DIR"
    cp "$LEGACY_LAYOUT_FILE" "$KEYBOARD_LAYOUT_DIR"

    LEGACY_LAYOUT_PLIST="<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>$LEGACY_LAYOUT_ID</integer><key>KeyboardLayout Name</key><string>$LEGACY_LAYOUT_NAME</string></dict>"

    add_input_source_if_missing AppleSelectedInputSources "$LEGACY_LAYOUT_NAME" "$LEGACY_LAYOUT_PLIST"
    add_input_source_if_missing AppleInputSourceHistory "$LEGACY_LAYOUT_NAME" "$LEGACY_LAYOUT_PLIST"
    add_input_source_if_missing AppleEnabledInputSources "$LEGACY_LAYOUT_NAME" "$LEGACY_LAYOUT_PLIST"
fi

## Install Fonts ##

##
# @var FONT_FILES
# @brief The list of all of fonts to install
FONT_FILES=`find fonts -maxdepth 1 -type f \( -iname '*.otf' -o -iname '*.ttf' -o -iname '*.ttc' -o -iname '*.dfont' \) | sort`

##
# @var FONT_INSTALL_DIR
# @brief The location to install the fonts on the system
FONT_INSTALL_DIR="$HOME/Library/Fonts"

# Make the fonts directory if it does not exist.
mkdir -p "$FONT_INSTALL_DIR"
# Loop through all of the fonts to install, and copy them one-by-one.
for F in $FONT_FILES
do
     echo "Installing font: $F"
     cp "$F" "$FONT_INSTALL_DIR"
done

# Toggle the keyboard input menu in the menu bar.
defaults write com.apple.TextInputMenu visible -bool true

# restart UI/keyboard servers
killall cfprefsd
killall SystemUIServer

# Pop back into the original directory.
popd > /dev/null

echo ""
echo "Installation complete."
echo ""

if [ "${SYRIAC_KEYBOARD_SKIP_REBOOT_PROMPT:-0}" = "1" ]; then
    exit 0
fi

echo "Reboot the system for changes to take effect."
while true; do
    read -p "Would you like to reboot now? [Y|n]: " yn
    case $yn in
        [Yy]* ) echo "Rebooting system. Please type root password." && sudo reboot; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer Y or n.";;
    esac
done
