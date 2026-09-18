# xMNML Specification

This document describes xMNML, an XML-based representation of a MNML LMNL Tag Sequence.

## Primary and secondary properties

xMNML exposes a number of properties of the ranges it captures. Its design depends on a principle of strategic redundancy: essentially, the strategy is to optimize operations by exposing relevant properties as proxy data points *representing* intrinsic proprerties, while not erasing them. This means that the secondary property can at any time be checked and corrected against the intrinsic property on which it is based.

An example is the **extent** of a range, which measures the length of its string value. xMNML gives an `extent` as an explicit value on an element named `start`, `empty` or (even) `end`. At the same time, the tags in the tag stream occur interspersed into elements representing the text value itself - and these elements can be measured and their string lengths calculated. It is possible in theory for a represented value (maybe a start tag says a range has an extent of 10) and an actual given value to diverge  (if the length of the text in question is 9, 11 or 100).

Because the given `extent` value in the xMNML instance is considered secondary to the actual extent as a measurement of the data (enclosed by start and end tags of the range), it can always be corrected.

At the same time, as long as secondary properties are known to be correct it facilitates a great economy of operations when comparing and relating ranges, considered apart from their values.

The element survey below notes which properties are secondary and how they are defined. These definitions also imply the rewriting rules, whenever secondary properties may need to be calibrated ("refreshed") against the actual document.

## xMNML document architecture

### RelaxNG Schema

Along with definitions here, a RelaxNG schema maintained in the Laminator implementation can be used to describe the xMNML tag sequence model as it is used in the Laminator libraries, and in relation to the complementary [LAYERS](LAYERS_spec.md) model.

## Element tag library


## Model

The normative representation in XML for an xMNML document can be defined by a schema and a set of constraints.

[The schema is here: ../lib/xMNML/rules/xMNML.rnc](../lib/xMNML/rules/xMNML.rnc)

It describes a flat structure with links providing for node traversal among its elements, which represent a series of text segments (spans) interspersed with tags (start tags, end tags, empties). Each tag is marked to show properties of the range it is used to delimit. Any tag may be provided with children (elements) for annotations belonging to its range.

The constraints:

- Names of tags (generic identifiers) must be XML names
- Each range has a distinctive rID (XML NMTOKEN)
- Start tags and end tags must pair up one for one on the basis of the same rID, with starts appearing first. Empty tags have distinctive rIDs.
- Ranges on IDs are distinctive
- Tags and text spans are given in order of appearance (offsets)
  1. Start tags for ranges in order longest to shortest
  2. Empty range tags
  3. End tags for ranges in order shortest to longest
- End tags appear following their start tags
- Where ranges overlap others with the same GI, an ID part (name suffix) is given to disambiguate between overlap and nesting.
- Every range in which a text segment appears (that is, it starts with or before the text and ends with or after it) is noted in its `@cf` attribute

These constraints are not yet fully externalized, expressed and testable outside the running code - this is work in progress.

Additionally, many of these properties show logical interdependencies with other properties captured in xMNML. The major example of this is that tag-ordering requirements can be validated against stipulated range offsets and extents (lengths), and vice-versa. This is convenient for processing as it provides extra checks and controls over referential integrity across the node network (of related ranges).


Text
