#! /bin/sh

##
# @author Sargis Yonan (sargis@yonan.org)
# @date 3 May 2020
# @file setup.command
#
# @brief A simple script to install the Syriac keyboard and OpenType fonts on a Mac
# @usage ./setup.command
#
# @note Reboot the system after installation completes.
# @note Possible points of future obsolescences to check for if this script stops working:
#       1. Lack of support for .rsrc keyboard extensions on macOS
#       2. Not being able to add keyboards via the ~/Library/Keyboard\ Layouts directory
#       3. Not being able to install OpenType fonts via the ~/Library/Fonts directory
#       4. plist changes disallowing property writes to com.apple.HIToolbox
##

while [[ $# -gt 0 ]]
do
	key="$1"

INSTALL_ARABIC_PHONETIC_TYPE=0

case $key in
    -a|--arabic|--ap)
    INSTALL_ARABIC_PHONETIC_TYPE=1
    shift # past argument
    ;;
    -h|--help)
    help
    shift # past argument
    ;;
    *)    # unknown option
    shift # past argument
    ;;
esac
done

# Get the directory in which the installation script lives.
INSTALL_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# Push into the script directory to get relative paths to work.
pushd "$INSTALL_DIR" > /dev/null

SYRIAC_PHONETIC_RESOURCE_FILE="SyriacPhonetic.rsrc"
SYRIAC_ARABIC_PHONETIC_KEYLAYOUT_FILE="SyriacArabicPhonetic.keylayout"

##
# @var KEYBOARD_LAYOUT_DIR
# @brief The keyboard resource file installation destination.
# @note Using the home directory's version of Keyboard Layouts (instead of the the root or Network path)
#       to avoid having to be the root user for this script to work. This shouldn't affect the capabilities
#       of the script.
KEYBOARD_LAYOUT_DIR="/Users/$USER/Library/Keyboard Layouts/"

# Create the keyboard layout directory if it does not exist.
mkdir -p "$KEYBOARD_LAYOUT_DIR"	

if [[ $INSTALL_ARABIC_PHONETIC_TYPE == 1 ]]; then
	echo "Loading the Syriac Arabic Phonetic keyboard onto the system..."

	# Copy the keyboard layout file to the keyboard layout directory
	cp "$SYRIAC_ARABIC_PHONETIC_KEYLAYOUT_FILE" "$KEYBOARD_LAYOUT_DIR"

	# Add the Syriac Phonetics keyboard to the list of system keyboard inputs
	defaults write com.apple.HIToolbox AppleSelectedInputSources -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>0x0001045a</integer><key>KeyboardLayout Name</key><string>Syriac (Arabic Phonetic)</string></dict>'
	defaults write com.apple.HIToolbox AppleInputSourceHistory -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>0x0001045a</integer><key>KeyboardLayout Name</key><string>Syriac (Arabic Phonetic)</string></dict>'
	defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>0x0001045a</integer><key>KeyboardLayout Name</key><string>Syriac (Arabic Phonetic)</string></dict>'
else
	echo "Loading the Syriac Phonetics keyboard onto the system..."

	# Copy the phonetic resource file to the keyboard layout directory
	cp "$SYRIAC_PHONETIC_RESOURCE_FILE" "$KEYBOARD_LAYOUT_DIR"

	# Add the Syriac Phonetics keyboard to the list of system keyboard inputs
	defaults write com.apple.HIToolbox AppleSelectedInputSources -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>0x0001045a</integer><key>KeyboardLayout Name</key><string>Syriac Phonetic</string></dict>'
	defaults write com.apple.HIToolbox AppleInputSourceHistory -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>0x0001045a</integer><key>KeyboardLayout Name</key><string>Syriac Phonetic</string></dict>'
	defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>0x0001045a</integer><key>KeyboardLayout Name</key><string>Syriac Phonetic</string></dict>'
fi

## Install Fonts ##

##
# @var FONT_FILES
# @brief The list of all of fonts to install
FONT_FILES=`ls fonts/*.otf`

##
# @var FONT_INSTALL_DIR
# @brief The location to install the fonts on the system
FONT_INSTALL_DIR="/Users/$USER/Library/Fonts"

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

echo "Reboot the system for changes to take effect."
while true; do
    read -p "Would you like to reboot now? [Y|n]: " yn
    case $yn in
        [Yy]* ) echo "Rebooting system. Please type root password." && sudo reboot; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer Y or n.";;
    esac
done
