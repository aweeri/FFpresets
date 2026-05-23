# FFpresets

An ULTRA-lightweight video conversion tool built directly into your Windows right-click context menu. The idea is simple - it lets you run ffmpeg commands that you most often need without having to mess with filenames and remembering the exact arguments.

---

## Features

* **Customisability:** Adding your own preset takes zero time and knowledge.
* **Right-Click Integration:** Access the tool instantly by right-clicking any video file.
* **Smart Filtering:** The menu option only shows up when right-clicking video files, keeping the context menu uncluttered.
* **Interactive CLI Menu:** Uses the lightest framework possible to provide a clean user experience.
* **Self-Contained Installation:** The tiny installer moves the necessary scripts to a persistent system directory, meaning you can safely delete the downloaded data after installation.

---

## Installation

1. Run`install.bat`.
2. Accept the User Account Control (UAC) prompt to allow the registry changes.
3. Once finished, you can delete the original downloaded folder.

*Note: If FFmpeg isn't detected on your system, the script will provide a quick winget command you can then run to get it installed.*

---

## How to Use

1. **Right-click** a video file.
2. Select **Convert with FFpresets...**
3. Navigate the menu using the **Up/Down arrow keys**
4. Press **Enter** to start the conversion. The newly processed file will be saved in the same directory as the original video.

---

## Adding Your Own Presets

You can easily expand or modify the preset list by editing the configuration area inside `ffpresets.bat` before you run the installer.

1. Open `C:\ProgramData\FFpresets\ffpresets.bat` in any text editor.
2. Locate the `:: --- PRESET CONFIGURATION ---` section.
3. Increment the `PRESET_COUNT` variable value by 1.
4. Add your new variables at the bottom of the preset list using the next sequential number. For example, to add a sixth preset:

```bat
set "PRESET_6_NAME=My Custom WebM Preset"
set "PRESET_6_SUFFIX=_custom.webm"
set "PRESET_6_ARGS=-c:v libvpx-vp9 -b:v 2M -c:a libopus"

That's all you need~!

---

## Uninstallation

If you ever need to remove it, run the `uninstall.bat` file as an administrator. The uninstaller cleanly wipes all associated registry keys, deletes the deployed script files from your system, and removes its own installation directory.