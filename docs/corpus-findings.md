# Corpus Findings

This project's current editor surface is based on the local Planet of Lana II save corpus already available during development.

## Corpus summary

- 8 valid `slot_0.sav` files were compared.
- The samples span early progression through a 100% save.
- All samples parse as the same NRBF/BinaryFormatter-style structure.

## High-confidence fields

The following gameplay fields are already supported with strong evidence from the corpus:

- elapsed playtime
- deaths
- story flag
- current location
- record location
- current objective
- journal list size and contents
- 20-entry Mui progress array

## Unknown-field outcome

After excluding full parsed record ranges:

- no stable uncovered gameplay regions remained in the tested corpus
- the earlier large unknown-field list was mostly scanner noise
- remaining diagnostics should be treated as research material only

## Release implication

The app should prefer:

- structured editing for known parsed fields
- diagnostics-only treatment for unmapped bytes
- promotion of new fields only after wider corpus comparison or type decompilation
