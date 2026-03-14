# Planet of Lana 2 - Save Editor

![Planet of Lana 2 - Save Editor Header](assets/readme-header.svg)

A friendly save editor for `Planet of Lana II: Children of the Leaf` that runs locally in your browser or desktop shell.

All editors homepage: [`https://saveeditors.github.io/`](https://saveeditors.github.io/)

![Planet of Lana 2 Save Editor Screenshot](assets/readme-screenshot-app.png)

## What You Can Edit Right Now

- Story progression: current chapter, current scene, and record chapter/scene values.
- Position data: current and record map coordinates (`x/y`) through fields and draggable map markers.
- Journal progression: known journal GUID entries, objective marker GUID, and GUID payload list editor.
- Mui bond/progression: the full parsed Mui boolean progression array.
- Core slot stats: playtime, deaths, timestamp, story flag, version, slot index.
- Runtime settings (when `settings` file is present): debug/menu related toggles, input sensitivity/deadzone, graphics flags, locale/UI mode.

## Not Confirmed / Not Exposed Yet

- Coins, currency, XP, or level-up economy systems are not currently mapped in this game’s save format here.
- A standalone “inventory class” is not confirmed yet; progression is currently driven mostly by journal GUID payload + Mui array + mapped slot/story fields.
- Unknown byte regions are shown for research but kept out of normal editing.

## Quick Start (PowerShell)

Run from this folder:

- Browser mode: `.\Start-PlanetLana2SaveEditor.ps1 -Mode web`
- Electron mode: `.\Start-PlanetLana2SaveEditor.ps1 -Mode electron`
- Build portable EXE: `.\Start-PlanetLana2SaveEditor.ps1 -Mode build`

Optional:

- Change port: `.\Start-PlanetLana2SaveEditor.ps1 -Mode web -Port 9000`
- Don’t auto-open browser: `.\Start-PlanetLana2SaveEditor.ps1 -Mode web -NoOpen`

## Save Paths (Windows)

- Steam: `%USERPROFILE%\AppData\LocalLow\Wishfully\Planet of Lana 2\*.sav`
- Game Pass / Microsoft Store: `%LOCALAPPDATA%\Packages\<Planet of Lana II package family>\SystemAppData\wgs\`

## Project Files

- `index.html`: main app (single-file, GitHub Pages friendly)
- `main.js` / `preload.js`: Electron wrapper for local file dialogs/writes
- `Start-PlanetLana2SaveEditor.ps1`: one-command launcher (`web`, `electron`, `build`)
- `scripts/Capture-ReadmeScreenshot.ps1`: refreshes README screenshot from a live run

## Notes

- Browser backups/exports are download-based due browser sandbox limits.
- Desktop mode can write backups beside the source save.
- Unknown fields stay intentionally conservative until they are validated.

Project checklist: see [`TODO.md`](TODO.md).
