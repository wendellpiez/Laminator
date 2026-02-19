# xMNML Specifications

**M**inimally A**n**notated **M**arkup in **L**MNL

## MNML LMNL - Summary

MNML follows the design of LMNL *except*

- Range annotations must be name-value pairs like XML attributes: they cannot be marked up or provided with annotations - consequently MNMLL LMNL is (pretty much) "just like XML except allows overlap"
- LMNL atoms, comments, PIs and declarations are not supported
- No provision is made for namespaces (XML or other) - they are just names

This reduction is in view of two considerations:

- We have XML (the standard and the technology) - for hierarchies and providing a functional programming platform
- We have iXML - better stronger capabilities for text handling altogether
- We have extensive study resources in XML and HTML - not starting from scratch, and have no need to plan to do so         

## Syntax

A syntax supported to represent data conforming to the xMNML model is defined by an iXML grammar. Parsing data using Invisible XML, an XML file is delivered; this can be further enhanced to produce xMNML in XML, valid to the xMNML model and extra-schema constraints such as naming rules.

[The grammar is here: ../lib/xMNML/rules/xMNML.rnc](../lib/xMNML/rules/xMNML.rnc)

Examples of conformant syntax with the xMNML produced therefrom can be found in the [../demo/baselines/](../demo/baselines/) folder (and other demo folders).

Additionally, a mixed set of instances ported from earlier work can be tested for syntactic correctness in the [../sources/Luminescent/](../sources/Luminescent/) folder.

## Model

The normative representation in XML for an xMNML document can be defined by a schema and a set of constraints.

[The schema is here: ../lib/xMNML/rules/xMNML.rnc](../lib/xMNML/rules/xMNML.rnc)

It describes a flat structure with links providing for node traversal among its elements, which represent a series of text segments (spans) interspersed with tags (start tags, end tags, empties). Each tag is marked to show properties of the range it is used to delimit. Any tag may be provided with children (elements) for annotations belonging to its range.

The constraints:

- Names of tags (generic identifiers) must be XML names
- Each range has a distinctive rID (XML NMTOKEN)
- Start tags and end tags must pair up one for one on the basis of the same rID, with starts appearing first. Empty tags have distinctive rIDs.
- Ranges on IDs are distinctive
- Tags and text spans must be given in order of appearance (offsets)
  1. Start tags for ranges in order longest to shortest
  2. Empty range tags
  3. End tags for ranges in order shortest to longest
- End tags occur following their start tags
- Where ranges overlap others with the same GI, an ID part (name suffix) is given to disambiguate between overlap and nesting.
- Every range in which a text segment appears (that is, it starts with or before the text and ends with or after it) is noted in its `@cf` attribute

These constraints are not yet fully externalized, expressed and testable outside the running code - this is work in progress.

The xMNML information set and data format is designed with these goals in mind:

- It should be transparent and easy to work with
- It should be open-ended and generic with respect to applications
- At the same time it takes advantage of XML and the XML Stack, avoiding wheel design

# Soft specifications

xMNML supports only a subset of the original concept of LMNL.

What it leaves out:
  - Structured and marked up annotations - each annotation can encapsulat a LMNL document
  - Comments, any analogue to XML processing instructions, LMNL atoms (outside the Unicode character set)

These are best dealt with in the context of actual application requirements.

For some ideas on how to provide for LMNL annotations, see the [Annotation Concepts](annotations.md) document.

---
end
