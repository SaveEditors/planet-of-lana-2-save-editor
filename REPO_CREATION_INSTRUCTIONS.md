# SaveEditors Repo Creation Instructions

This file defines the required process for every SaveEditors project so all editors publish the same way and automatically fit the org main page strategy.

Hard rule: a new editor is not considered created until it is added to the org homepage catalog (`SaveEditors.github.io/editors.json`).

## 1) Mandatory standards for every editor repo

1. Repository name format: `kebab-case` and end with `-save-editor` when applicable.
2. App entry file must be `index.html` in repo root (for GitHub Pages root deploy).
3. No hardcoded local machine paths in app code or README.
4. Footer links must point to the real org repo and org profile:
   - `https://github.com/SaveEditors/<repo-name>`
   - `https://github.com/SaveEditors/<repo-name>/issues`
   - `https://github.com/SaveEditors`
5. `README.md` should describe the editor only. Org process/rules belong in this file, not product README copy.
6. Keep all static assets relative so repo works on Pages without path rewrites.

## 2) Required repo creation workflow (PowerShell)

From the project folder:

```powershell
git init
git branch -M main
git add .
git commit -m "Initial release"
gh repo create SaveEditors/<repo-name> --public --source . --remote origin --push
```

If commit fails for identity:

```powershell
git config --global user.name "SaveEditors"
git config --global user.email "you@example.com"
```

Immediately after creating/pushing the repo:

1. Open `SaveEditors.github.io/editors.json`.
2. Add a new object for the editor repo.
3. Commit and push `SaveEditors.github.io`.
4. Verify the new card appears on `https://saveeditors.github.io/`.

## 3) Required GitHub Pages setup (per editor repo)

1. Open repo on GitHub.
2. Go to `Settings` -> `Pages`.
3. Source: `Deploy from a branch`.
4. Branch: `main`, folder: `/ (root)`.
5. Save.

Expected editor URL:

`https://saveeditors.github.io/<repo-name>/`

If you only see normal repo files on GitHub, Pages is not enabled yet.

## 4) Main homepage strategy (links all editors)

Use a dedicated org site repo:

- Repo name: `SaveEditors.github.io`
- Purpose: one landing page that links every editor
- This is the org homepage URL: `https://saveeditors.github.io/`

### Required structure in `SaveEditors.github.io`

- `index.html` (landing page with editor cards)
- `editors.json` (single source of truth for editor links)

Recommended `editors.json` item shape:

```json
[
  {
    "name": "Planet of Lana 2 - Save Editor",
    "repo": "https://github.com/SaveEditors/planet-of-lana-2-save-editor",
    "play": "https://saveeditors.github.io/planet-of-lana-2-save-editor/",
    "tags": ["Steam", "Game Pass", "UWP"]
  }
]
```

Rule: whenever a new editor repo is created, add one entry to `editors.json` in the same work session.  
This keeps the homepage authoritative and prevents “orphaned” repos.

## 5) Definition of done for a new editor

1. Repo exists under `SaveEditors/<repo-name>`.
2. Pages is live at `https://saveeditors.github.io/<repo-name>/`.
3. Footer repo/issues/org links are correct.
4. Main homepage data (`SaveEditors.github.io/editors.json`) has an entry for the new editor.
5. New editor card is visible on `https://saveeditors.github.io/`.
