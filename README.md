# Laminator - Prospectus

A MNML LMNL processing library on an XML stack (XProc, XSLT, iXML)

MNML LMNL is Minimally Annotated Markup in LMNL
LMNL is the Layered Markup and Annotation Language (sc Tennison and Piez, 2001)

LMNL is a data model supporting a range of applications in text processing.

MNML LMNL is a LMNL subset selected to support an application profile.

Laminator is an application built using MNML LMNL on an XML stack, leveraging and capitalizing on these various dependencies:

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

To this end, one aim to keep this repository as lightweight as possible - unlike applications of the Laminator (under development elsewhere) the core library should have nothing but the core code, its testing infrastructure and documentation. The Laminator pipelines easy to deploy and use as a git submodule, or to graft into an XProc-based project.

(Hence you will not find demonstrations of how to use the Laminator here. Even documentation will be a work in progress until functionality is stable and well tested. Oct 2025.)

Each process will take the form of a pipeline; any pipeline may (as XProc) call imported pipelines from elsewhere in the repository. External dependencies should be noted.

## The name

LMNL is of course the *layered* markup and annotation language.

Its MNML subset is focused on providing for this capability of a markup regimen supporting overlap, namely that it support such 'layering' and even overloading of semantic categories, in the metadata (the what is known) embedded in markup.

## Application requirements

These pipelines, while performing simple and basic operations over LMNL markup 'sawtooth syntax', should also be useful for working with texts, and specifically markup in application to texts, in arbitrary ways. The goal is to support - or to be capable of extension to support - any and every manipulation of tagged (marked up) strings or data within a text under study, and without the encumbrances and awkwardness imposed by XML's necessary fragmentation of overlapping structures and phenomena into an element hierarchy.

In order to support workflows using LMNL (i.e. 'sawtooth') syntax, Laminator provides logic both to parse and read it, and to create it from the system's internal representation of the xMNML (instance) model.

This is both in order that it work well in workflows where hand editing is called for, and to provide for "tag writing" (markup injection) as a technique or method for manipulation of xMNML documents.

xMNML is a *partial implementation* of a LMNL data model, expressed in XML. Laminator is in essence an xMNML processing library, with supporting capabilities.

In addition to parsing and serializing (reading and writing) LMNL syntax, other capabilities for Laminator can include:

- Generic casting of XML to MNML LMNL
  - Any XML but especially TEI, with customization provisions
- Merging of xMNML instances
  - 'text alike' (matching on offsets) and 'text unalike' (matching in other ways) scenarios
- Merging of standoff range descriptions into xMNML
- Generating XML from MNML LMNL
  - filtered
  - providing segmentation across element boundaries
- Validation and querying?
- Generating graphs and visualizations (for example, range maps)

---
page created Oct 23 2025
