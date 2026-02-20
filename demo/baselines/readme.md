# Laminator Baseline Examples

## Pipelines

### Regression testing

`TEST_xMNML-BUILD.xpl` parses and processes the examples found and compares the xMNML results to the expected results, stored in the [expected](expected) folder.

Running it provides regression testing for the parsing and building algorithms.

### Open-hood examples

The pipeline xMNML_REFRESH.xpl will produce xMNML results from parsing all the files given in the `data` folder, along with the interim results produced by the pipeline, which runs in three steps. So:

- [cache/1_parsed/](cache/1_parsed/) contains results of parsing the MNML LMNL inputs with the iXML grammar. Expect errors for files that are not syntactically conformant.
- [cache/2_linked/](cache/2_linked/) shows the same results with text now escaped (for markup delimiters) and matching tags linked.
- [cache/3_xmnml/](cache/3_xmnml/) shows the final xMNML, now with range offsets and extents marked.

Inspect these to understand the relatively simple operations performed in parsing MNML LMNL (syntax) into xMNML.

Why do this?

- Many things can be done with xMNML, including building hierarchies (XML) and other applications
- LMNL syntax may also be useful for certain kinds of operations and interchange including under automation (*tag writing*)
- Round-tripping between LMNL syntax and the xMNML model gives us a 'vector of control'

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
