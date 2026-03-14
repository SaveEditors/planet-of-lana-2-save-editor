# Planet of Lana 2 - Save Editor TODO

## Implementation

- [ ] Replace raw chapter IDs with a full chapter/scene name map in all selectors and summary cards.
- [ ] Add a GUID alias importer (`.json`) so custom names can be loaded without editing source code.
- [ ] Add a GUID diff panel that compares current save GUIDs vs a selected baseline save.
- [ ] Add a safe edit mode toggle that hides advanced/raw fields unless explicitly enabled.
- [ ] Implement undo/redo history for field edits (at least 50 steps).
- [ ] Add a field lock system so selected values cannot be changed by bulk actions.
- [ ] Add batch search/replace for GUID lists with validation before apply.
- [ ] Extend coordinate tools with numeric nudge buttons and snap-to-grid options.
- [ ] Add import/export presets for common edits (100%, chapter unlock, custom progression pack).
- [ ] Add parser plugin hooks so new mapped fields can be registered from external JSON definitions.
