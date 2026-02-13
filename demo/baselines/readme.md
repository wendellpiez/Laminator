# Laminator Baseline Examples

## Pipelines

### Regression testing

`TEST_xMNML-BUILD.xpl` parses and processes the examples found and compares the xMNML results to the expected results, stored in the [expected](expected) folder.

Running it provides regression testing for the parsing and building algorithms.

### Mini demo

`PL-EXTRACTION.xpl` shows some rudimentary MNML processing. The pipeline processes the example document (**Paradise Lost** fragment) and returns a list of all ranges found with the given type name, provided as a parameter. So all `np` (noun phrase) ranges can be listed, or all `s` (sentence ranges).s

The listing shows locations by line numbers, found by querying for overlapping `l` (line) ranges.

[A result](expected/PL-range-survey.xml) from running this pipeline (with 's' and 'np' as parameter values) can be found in the [expected](expected) folder.

The pipeline logic is generic and applies to any MNML document. The range type(s) to be returned are given as a parameter to the XSLT performing the query. For purposes of reporting locations, this XSLT assumes that `l` ranges (for lines) with `n` annotations appear (for line numbering, as in the examples) to provide this information.

## LMNL Examples

### Frost

[From Robert Frost's 'The Housekeeper'](Housekeeper144-146.lmnl) - this sample is as small as possible while still being complete, self-contained and sensible. It illustrates basic overlap.

 - `[excerpt} ... {excerpt]` the excerpt (with metadata annotated)
 - `[s} ... {s]` marks sentences
 - `[l {n}n{]} ... {line]` marks lines (numbered)
 
Sentences overlap lines.

### Milton

[Lines 1-26 of Milton's Paradise Lost](PLfragment.lmnl) - illustrates some (most) 'edges' of MNML syntax

 - Sibling rivalry - `np` (*noun phrase*) ranges overlap other `np` ranges
 - An annotation on an end tag (`ref` on `np#5`)

In order to disambiguate cases where ranges might nest or overlap (when they have the same **gi** - generic identifier - or type name) identifiers are used on the tags, for `[np#1}...{np#1}`. In this example, all `np` ranges are marked with such IDs even where not needed (such as on `np#6` and `np#7`, neither of which overlap any other `np`, even while `np#6` encloses `np#7`).

Thanks to Patrick and Matthew, creators of Just-in-time Trees (JITTs), for promoting this example.

---
