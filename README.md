![Laminator logotype](./laminator-logotype.svg)

# LMNL Laminator 

A MNML LMNL processing library on an XML stack (XProc, XSLT, iXML)

MNML LMNL is Minimally Annotated Markup in LMNL (a LMNL subset). LMNL is the Layered Markup and Annotation Language (Tennison and Piez, 2001), pronounced 'liminal'. (MNML LMNL is hence 'minimal liminal'.)

Think of XML, for *markup languages*, except - (1) with a distinctive syntax, and (2) allowing overlap.

```
[excerpt [author}Robert Frost{][date}1915{][title}The Housekeeper{] }
[s}[l [n}144{]}He manages to keep the upper hand{l]
   [l [n}145{]}On his own farm.{s] [s}He's boss.{s] [s}But as to hens:{l]
   [l [n}146{]}We fence our flowers in and the hens range.{l]{s]
{excerpt]
```

In this repository you will find working code, demonstrations, and links to demonstrations. The implementation is XML-based: it uses [XProc](https://xproc.org/) and relies on XSLT and [Invisible XML](https://invisiblexml.org/). The supported subset of LMNL (MNML) aligns closely with XML, for easy handling and production of XML and HTML data and documents, as both input and output.


LMNL markup ('sawteeth' or 'sawtooth syntax') is designed to be workable 'by hand' in a text editor, but LMNL can also be generated from XML or other structured data. 

## Overview

### In this repository

- [demo](demo) has demonstrations you can inspect and run off line (requires XProc and provided [source data](sources))
- [lib](lib) contains XProc, XSLT, and other code supporting xMNML, an XML-based representation of a document as a range model
- [papers](papers) contains any papers written so far, or links to them
- [sources](sources) contains source data ready for inspection or play
- [specs](specs/) - some work in progress toward Specifications - what is said here is not formal, but not wrong either; and links are provided to the formalisms (grammmar, schema etc.)
- [testing]() - tests are dispersed through the repository but documented and linked here

### Dependencies (2026)

The code base uses **XSLT** and **XProc** wherever possible, with occasional use of **RelaxNG**, **Schematron** and other technologies native to the XML stack. Parsing MNML LMNL syntax is dependent on an XProc **Invisible XML** step. Pipelines in the repository will deliver results using a generic XProc 3.0/3.1 engine such as XML Calabash or Morgana IIIse. Both of these processors (at this time) require Java 17.

Internal (transitory) data sets are also maintained in XML.

**XQuery** is not currently used, although since XSLT and XProc  rely heavily on XPath, the code base is largely transparent to XQuery. An XQuery-based implementation is also conceivable and could reuse much of the architecture and logic in this library.

Developers who are newcomers to markup languages may want to work with LMNL and XML in parallel. Ultimately, LMNL capabilities should *not* depend on XML capabilities or on Java (for example, LMNL operations might be supported by Javascript in a browser. This line of development is set aside for now mainly because close XML integration is so useful.

### XProc file names

A naming convention provides hints on how XProc pipelines are intended to be used.

An all-upper-case file name (apart from the `.xpl` suffix) indicates that the XProc pipeline is designed to be run like a self-contained script, with no arguments. Its internal settings give it access to everything it needs.

Lower-case file names are used for XProc pipelines that are designed to be run primarily as steps in other pipelines, and they may require runtime bindings or settings (to be set by a calling pipeline). Sometimes they are provided with defaults for testing.

A file name in upper case except with a lower-case suffix, typically `_source`, indicates that the pipeline is meant as a primary entry point, but that a binding on an input port, named `source` in this case, must be provided. An example is the pipeline that provides MNML LMNL syntax validation checking, 
[lib/xMNML/in/sawtooth-syntax/MNML-WFCHECK-source.xpl](lib/MNML-WFCHECK-source.xpl), which serves as a wrapper for the component pipeline [lib/xMNML/in/sawtooth-syntax/mnml-lmnl_wf-check.xpl](lib/xMNML/in/sawtooth-syntax/mnml-lmnl_wf-check.xpl).

### Prior work and acknowledgements

At different times there have been LMNL processors, both partial and complete (if not always well tested), developed by Jeni Tennison, Gavin Nicol, Alex Czmiel, Gregor Middell, Paul Caton, John Cowan and others. (Please let me know if you should be on this list.) The current developer (Wendell Piez) participated in this work from its inception, presenting my own XSLT- and XProc-based implementation, [Luminescent](https://github.com/wendellpiez/Luminescent/tree/master), in 2012.

LMNL was only one of a number of conceptual solutions offered to the "overlap problem" in XML, and their discoverers, advocates, and friendly critics have been as important to it as its direct contributors. These include C. M. Sperberg-McQueen; Claus Huitfeld; Steven J. DeRose; Patrick Durusau; Andreas Witt, Oliver Schonefeld and Maik Stührenberg; Fabio Vitali and associates; Allen Renear and associates (for work on the semantics of markup); Desmond Schmidt; Ronald Dekker and associates; and too many conferencers, students and colleagues to name.

## Prospectus - the Laminator

LMNL is a data model supporting applications in text processing. In contrast to XML (or object-serialization notations such as JSON) it represents a text not as a hierarchy of elements (or other constituent parts), but as a **set of ranges** defined over a  **sequence of characters**. Ranges can be named (typically by their type) and *annotated*. In MNML LMNL (the LMNL subset respected by Laminator), annotations must carry only controlled values or simple strings, but this is enough for identifiers or classifications asserting higher-level semantic properties, including links (relations) between ranges or into structured datasets. Since ranges can overlap other ranges, LMNL does not form hierarchies and represents overlap as overlap.

Applications for which this approach to markup is well suited include the analysis, translation and representation of literary texts.

Laminator is a library of functions and utilities supporting MNML LMNL (syntax and operations) on an XML stack, leveraging and capitalizing (as noted) on these various externalities:

- XML and TEI (Text Encoding Initiative)
- XProc, a pipelining and data processing language, with its implementations
- XSLT and kindred XML-centric technologies
- HTML, SVG and the web platform (for browser views)
- iXML - Invisible XML - parsing technology

### Capabilities

In addition to parsing and serializing (reading and writing) LMNL syntax, the Laminator offers (or will offer):

- Making MNML LMNL from XML
- Processing MNML LMNL
  - Filtering ranges
  - Renaming ranges
  - Query
- Merging documents
  - Scenarios include 'text alike' (matching on offsets) and 'text unalike' (matching in other ways)
  - Range inferencing - new ranges based on heuristics and analysis
- Generating XML
  - Rebuilding hierarchies of interest
  - 'Gracefully degrade' multiple concurrent hierarchies into XML-conventional notations (e.g. milestones)
- Validation
  - Validation against xMNML rules to support process integrity
  - Schemas and constraint sets for documents showing overlap
- Generating graphs and visualizations (for example, range maps)

If you have an interest and you can't find more information in the libraries, please send word ([Github Issues](https://github.com/wendellpiez/Laminator/issues) or email to the repository owner).

Browse the repository for more details.

### Staging applications

Simple applications using XProc and the Laminator libraries are available for study: see the [demo](demo) folder. These include producing SVG visualizations and XML-based analytic results.

For more on XProc:

- [XProc 3.0/3.1 Community Portal](https://xproc.org/)
- [XProc Zone](https://wendellpiez.github.io/xproc-zone/) - by the author

### The name “Laminator”

LMNL is of course the *Layered* Markup and Annotation Language.

With the Laminator, adding and removing new layers, and examining and assessing them, should be easy, fun and rewarding of insights.

### Relation to LMNL, the Layered Markup and Annotation Language (from 2002)

The current project is an initiative of the developer (solely), with no *direct* connection (and many indirect connections) to earlier initiatives. I remain grateful to all contributors and collaborators, and to those who have encouraged this work in its various forms, and not only the work on LMNL (since 2002) but also and more generally, work on data models and text processing altogether.

MNML LMNL is a LMNL subset selected to support a useful and interesting application profile, while being easy to specify and implement (at least by comparison). Part of the rationale is that as long as we stick close to XML technologies (which XProc and iXML permit us to do), we can turn to XML when we have well-defined hierarchies.

The MNML subset is focused on providing for the capability specifically of a markup regimen supporting overlap, with the intent of allowing such layering and even overloading of semantic categories, in the metadata (the "what is known") embedded in markup.

> How do we know we know we know?
> We use markup to make it so.

For an earlier implementation of (nearly all of) LMNL (for the most part using obsolescent tools), and for more history, refer to the [Luminescent project](https://github.com/wendellpiez/Luminescent) repository.

Wendell Piez, 2025-2026

---
page created Oct 23 2025 edited 2026
