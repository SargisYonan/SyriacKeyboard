## SyriacKeyboard
Install Syriac / Assyrian keyboards and fonts on macOS.

macOS 12.0 (Monterey) and newer already include Assyrian keyboard layouts. This project installs the built-in keyboard layout you choose and copies a bundled set of Syriac fonts. On older macOS versions, it falls back to the legacy keyboard layouts bundled in this repo.

<p align="center">
<img src="syriac_fonts_examples.png">
</p>

## Easy Install
For non-technical users, use the packaged macOS app:

1. Download [`Syriac-Keyboard-Installer-macOS.zip`](https://github.com/SargisYonan/SyriacKeyboard/releases/latest/download/Syriac-Keyboard-Installer-macOS.zip) from the latest release.
2. Unzip it.
3. Open `Syriac Keyboard Installer.app`.
4. If macOS warns that the app is from an unidentified developer, right-click the app, choose `Open`, then confirm.
5. Choose either `Syriac QWERTY` or `Syriac Arabic`.
6. Reboot when the installer finishes.

## Script Install
If you prefer the scripts directly:

1. Download this repository on to your Mac.
2. Open the folder.
3. Run `setup.command` for the built-in Syriac QWERTY layout.
4. Run `setup_arabic_phonetic.command` for the built-in Syriac Arabic layout.
5. Reboot when prompted.

## Included Fonts
The installer currently copies these fonts into your user font library:

- `NohadraSyriac-Amedia.otf`
- `NohadraSyriac-Sapna.otf`
- `NotoSansSyriac-Regular.ttf`
- `NotoSansSyriacEastern-Black.otf`
- `Ramsina-Regular.ttf`
- `Adiabene.otf`
- `Antioch.otf`
- `Batnan.otf`
- `BatnanBold.otf`
- `Ctesiphon.otf`
- `Edessa.otf`
- `Jerusalem.otf`
- `JerusalemBold.otf`
- `JerusalemItalic.otf`
- `JerusalemOutline.otf`
- `Kharput.otf`
- `Malankara.otf`
- `Mardin.otf`
- `MardinBold.otf`
- `Midyat.otf`
- `Nisibin.otf`
- `NisibinOutline.otf`
- `QenNeshrin.otf`
- `Talada.otf`
- `TurAbdin.otf`
- `Urhoy.otf`
- `UrhoyBold.otf`

### Notes
On modern macOS versions, the keyboards appear in the input menu as `Syriac – QWERTY` and `Syriac – Arabic`.

You can also add them manually from:

`System Settings > Keyboard > Text Input > Edit... > + > Assyrian`

The packaged installer app can be rebuilt locally with:

```sh
./build_installer_app.command
```
