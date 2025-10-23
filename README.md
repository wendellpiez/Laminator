# Laminator - Prospectus

A MNML LMNL processing library on an XML stack (XProc, XSLT, iXML)

MNML LMNL is Minimally Annotated Markup in LMNL. LMNL is the Layered Markup and Annotation Language (sc Tennison and Piez, 2001).

LMNL is a data model supporting applications in text processing. In contrast to XML (or object-serialization notations such as JSON) it represents a text not as a hierarchy of elements, but as a sequence of characters with a set of ranges over those characters. Ranges can be named (typically by their type) and annotated (in MNML LMNL, minimally, using controlled values or simple strings). Annotations can include tagging such as identifiers or classifications that expose higher-level semantic relations between ranges.

Applications for which this approach to markup is well suited include the analysis, translation and representation of literary texts.

Laminator is a library of functions and utilities supporting MNML LMNL (syntax and operations) on an XML stack, leveraging and capitalizing on these various dependencies:

- XML and TEI (Text Encoding Initiative)
- XProc, a pipelining and data processing language, with its implementations
- XSLT and kindred XML-centric technologies
- HTML and the web platform (for browser views)
- iXML - Invisible XML - parsing technology

## Application interface

In its initial stages, the Laminator takes the form of a set of XProc 3.0/3.1 pipelines, to be executed using an XProc engine either from the command line (when working as a developer), within a development environment, or automated under CI/CD (continuous integration/continuous development).

For more on XProc:

- [XProc 3.0/3.1 Community Portal](https://xproc.org/)
- [XProc Zone](https://wendellpiez.github.io/xproc-zone/)

Laminator pipelines do not support end-user applications: instead, they support *generic processes* in support of operations found to be useful in applications.

To this end, one aim is to keep this repository as lightweight as possible - unlike applications of the Laminator (under development elsewhere) the core library should have nothing but the core code, its testing infrastructure and documentation. The Laminator pipelines should be easy to deploy and use as a git submodule, or to graft into an XProc-based project.

(Hence you will not find demonstrations of how to use the Laminator here. Even documentation will be a work in progress until functionality is stable and well tested. Oct 2025.)

Each process will take the form of a pipeline; any pipeline may (as XProc) call imported pipelines from elsewhere in the repository. External dependencies should be noted in documentation.

## The name "Laminator"

LMNL is of course the *layered* markup and annotation language.

The MNML subset is focused on providing for the capability specifically of a markup regimen supporting overlap, with the specific intent to allow or such layering and even overloading of semantic categories, in the metadata (the "what is known") embedded in markup.

With the Laminator, adding and removing new layers, and examining and assessing them, should be easy, fun and rewarding of insights.

## Application requirements

These pipelines, while performing simple and basic operations over LMNL markup 'sawtooth syntax', should also be useful for working with texts, and specifically markup in application to texts, in arbitrary ways. The goal is to support - or to be capable of extension to support - any and every manipulation of tagged (marked up) strings or data within a text under study, and without the encumbrances and awkwardness imposed by XML's necessary fragmentation of overlapping structures and phenomena into an element hierarchy.

In order to support workflows using LMNL (i.e. 'sawtooth') syntax, Laminator provides logic both to parse and read it, and to create it from the system's internal representation of the xMNML (instance) model.

This is both so that it works well in workflows where hand editing is called for, and in order to provide for "tag writing" (markup injection) as a technique or method for manipulation of xMNML documents.

xMNML is a *partial implementation* of a LMNL data model, expressed in XML. Laminator is in essence an xMNML processing library, with supporting capabilities.

In addition to parsing and serializing (reading and writing) LMNL syntax, other capabilities for Laminator can include:

- Generic casting of XML to MNML LMNL
  - Any XML but especially TEI, with customization provisions
- Merging of xMNML instances
  - scenarios include 'text alike' (matching on offsets) and 'text unalike' (matching in other ways)
  - Merging of standoff range descriptions into xMNML
- Generating XML from MNML LMNL
  - filtered
  - providing segmentation across element boundaries
- Validation and querying?
- Generating graphs and visualizations (for example, range maps)

## Relation to LMNL, the Layered Markup and Annotation Language (2001 -)

The current project is an initiative of the developer (solely), with no direct connection to earlier initiatives. I remain grateful to all contributors and collaborators, and to those who have encouraged this work in its various forms, and not only the work on LMNL (since 2001) but also and more generally, work on data models and text processing altogether.

MNML LMNL is a LMNL subset selected to support an application profile while being comparatively easy to specify and implement. S pecifically, MNML LMNL constrains annotations on ranges to name-value pairs akin to XML attributes, rather than supporting entire LMNL document sets (annotated and tagged) as annotation properties and contents. The rationale here is that we already have means to handle hierarchies - the bang is not worth the buck, in this case.

For an implementation of (nearly all of) LMNL, and for history, refer to the [Luminescent project](https://github.com/wendellpiez/Luminescent) repository.

Wendell Piez, 2025

---
page created Oct 23 2025
