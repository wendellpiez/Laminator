# Range Maps

One of the interesting possibilities of LMNL markup is the exploration of narrative and rhetorical structures in literary texts.

This demonstration shows a generalized approach to range mapping: drawing diagrams reflecting the internal organization of a LMNL document, or the lack thereof.

With that in mind, the current maps are crude and provide only a hint of what should eventually be possible, with some effort, tuning and design sense.

## Pipelines

[PRODUCE-RANGE-MAPS.xpl](PRODUCE-RANGE-MAPS.xpl) produces a set of range maps from a configuration kept in the pipeline.

[BUILD-BLANK-MAPSPEC.xpl](BUILD-BLANK-MAPSPEC.xpl) makes a 'blank' range map specification for a new LMNL instance. Currently set to operate on one of the samples, it can be called with any LMNL document on the source port to make a new range map specification covering its ranges.

## The maps

The current map is a variant on the classic Bubble Diagram as applied to narrative structure as indicated by LMNL markup.

(See a 2015 example of such a bubble diagram here: XXX)

Instead of bubbles, ranges are represented by rectangles with square or rounded corners, arranged diagonally from top-left to bottom-right.

The configuration for any range map dictates:

 - Which ranges are to shown
 - Vertical sizing and displacement for easier visual distinction
 - SVG properties are assigned to any range lozenge (rectangle) - color, border width, fill opacity etc.
 - Special features for qualified ranges (filtered by annotation value)
 - Labels hard-coded or derived from the document

## The texts

<details><summary>
*Frankenstein 1831*</summary>

Borrowed from Luminescent, this transcription of the Mary Shelley novel has a history back to e-text centers of the 1990s. The text of the 1831 edition is used, since this is the edition still most commonly read. (Since its revisions are at the line and word-choice level, a representation of the novel's structure is the same as the 1818 edition.) Despite these being obscured in later print editions, the three-volume structure of the novel as originally published is also shown.

![Range map of Frankenstein, by Mary Shelley](out/Frankenstein1831_range-map.svg)
</details>


<details><summary>*Julian and Maddalo*</summary>

Also borrowed from Luminescent. This shows a verse structure with a nested narrative.

![Range map of Julian and Maddalo, by Percy Shelley](out/JulianandMaddalo_range-map.svg)

</details>

<details><summary>*Peregrines' Demise* by Lucian of Samosata</summary>

The original text was downloaded from Perseus and worked by the author.

It shows several overlapping structures including:

- episodes mainly but not entirely overlapping paragraphs
- episodes overlapping marked pages
- pages overlapping paragraphs
- speeches (extended quotes) overlapping all of these
- verse quotations

![Peregrinus' Demise, by Lucian of Samosata](out/PeregrinesEnd_range-map.svg)
</details>


