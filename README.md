# FFpresets

An ULTRA-lightweight video conversion tool built directly into your Windows right-click context menu. The idea is simple - it lets you run ffmpeg commands that you most often need without having to mess with filenames and remembering the exact arguments.


<img width="100%" alt="{68C5E2A8-E2E0-4A79-8841-796FFFB7A3A3}" src="https://github.com/user-attachments/assets/f9d0dc38-a93c-47c8-aeed-4404af54eaf2" />
<img width="100%" alt="{AE30784A-2611-487A-8923-4DBC5272031A}" src="https://github.com/user-attachments/assets/e6143260-0cc2-433e-8c89-b6e296eb744f" />



---

## Features

* **Customisability:** Adding your own preset takes zero time and knowledge.
* **Right-Click Integration:** Access the tool instantly by right-clicking any video file.
* **Smart Filtering:** The menu option only shows up when right-clicking video files, keeping the context menu uncluttered.
* **Interactive CLI Menu:** Uses the lightest framework possible to provide a clean user experience.
* **Self-Contained Installation:** The tiny installer moves the necessary scripts to a persistent system directory, meaning you can safely delete the downloaded data after installation.

---

## Installation

1. Download this repository in a `.zip` formfactor.
2. Extract it anywhere.
3. Run`install.bat`.
4. Accept the User Account Control (UAC) prompt to allow the registry changes.
5. Once finished, you can delete the original downloaded folder.

*Note: If FFmpeg isn't detected on your system, the script will provide a quick winget command you can then run to get it installed.*

---

## How to Use

1. **Right-click** a video file.
2. Select **Convert with FFpresets...**
3. Navigate the menu using the **Up/Down arrow keys**
4. Press **Enter** to start the conversion. The newly processed file will be saved in the same directory as the original video.

---

## Adding Custom Presets

You can customize the preset list by editing the variables inside `ffpresets.bat`.

### Add a Preset to an Existing Tab

1. Open `C:\ProgramData\FFpresets\ffpresets.bat` in a text editor.
2. Locate the `:: --- PRESET CONFIGURATION ---` section.
3. Find your target tab category.
4. Increase the tab's preset count by 1 (e.g., update `TAB_1_PRESET_COUNT=4` to `5`).
5. Append your new variables at the bottom of that tab's section using the next sequential number.

**Example (Adding a 5th preset to Tab 1):**
```bat
set "T1_P5_NAME=My Custom WebM Preset"
set "T1_P5_SUFFIX=_custom.webm"
set "T1_P5_ARGS=-c:v libvpx-vp9 -b:v 2M -c:a libopus"
```

---

### Add a New Tab Category

1. Locate the master `TAB_COUNT` variable at the top of the configuration section.
2. Increase this master count by 1.
3. Create a new tab block using the next sequential tab number for all variables (e.g., `TAB_7_NAME`, `TAB_7_PRESET_COUNT`).
4. Define the individual presets for your new tab following the standard naming convention (e.g., `T7_P1_NAME`, `T7_P1_SUFFIX`, `T7_P1_ARGS`).

---

## Uninstallation

If you ever need to remove it, run the `C:\ProgramData\FFpresets\uninstall.bat` file as an administrator. The uninstaller cleanly wipes all associated registry keys, deletes the deployed script files from your system, and removes its own installation directory.
