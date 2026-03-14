# Planet of Lana 2 - Save Editor (Release Instructions)

Use editor without downloading HERE: [`https://saveeditors.github.io/planet-of-lana-2-save-editor/`](https://saveeditors.github.io/planet-of-lana-2-save-editor/)

## Deployment Notes + Default Save Locations

- Repo: `planet-of-lana-2-save-editor`
- Deployment target: GitHub Pages (static root) and optional Electron desktop shell.
- Keep relative asset paths so both Pages and zipped desktop releases work without rewrites.
- Windows default save locations:
  - Steam: `%USERPROFILE%\AppData\LocalLow\Wishfully\Planet of Lana 2\*.sav`
  - Game Pass / Microsoft Store: `%LOCALAPPDATA%\Packages\<Planet of Lana II package family>\SystemAppData\wgs\`

## What this package is

This release is a browser-first save editor for Planet of Lana 2, with an optional Electron desktop shell.

## Quick start

1. Extract files to any folder.
2. Open PowerShell in that folder.
3. Run:
   - `.\Start-PlanetLana2SaveEditor.ps1 -Mode web`
4. Open the local URL shown in the terminal.

Optional desktop shell:

- `.\Start-PlanetLana2SaveEditor.ps1 -Mode electron`

## Save paths (Windows)

- Steam: `%USERPROFILE%\AppData\LocalLow\Wishfully\Planet of Lana 2\*.sav`
- Game Pass: `%LOCALAPPDATA%\Packages\<package family>\SystemAppData\wgs\`

## Main SaveEditors homepage

`https://saveeditors.github.io/`
