# xMNML Specifications

**M**inimally A**n**notated **M**arkup in **L**MNL

In this folder find specifications for MNML LMNL including syntax and model, as well as for Laminator components.

This file presents a summary overview.

## Producing the specifications

Run the pipeline PRODUCE-FROM-MARKDOWN.xpl. It reads the [Markdown source file]( src/spec/mnml-specification.md) and produces reference versions:

* [NISO STS version](view/mnml-spec-sts.xml)
* [HTML (web page) version](view/mnml-spec-working.html)
* [Markdown reading version](MNML_SPECIFICATION.md)

Note that the Markdown reading version is a convenience only, as this page will display formatted when browsing the repository.

HTML and STS versions given are closer to the source data and hence more authoritative.

## MNML LMNL - Summary

MNML LMNL is designed with these goals in mind:

- It should be transparent and easy to work with
- It should be open-ended and generic with respect to applications
- It should be based on open standards and not require proprietary tools, license fees or special access to run
- At the same time it takes advantage of XML and the XML Stack, avoiding wheel design

MNML follows the design of LMNL *except*

- Range annotations must be name-value pairs like XML attributes: they cannot be marked up or provided with annotations - consequently MNML LMNL is (pretty much) "just like XML except allows overlap"
- LMNL atoms, comments, PIs and declarations are not supported
- No provision is made for namespaces (XML or other) - they are just names

This reduction is in view of several considerations:

- We have XML (the standard and the technology) - for hierarchies and providing a functional programming platform.
- Coming at markup technologies *ex nihilo* is not necessary despite its theoretical interest. As a thought experiment, LMNL has already served its purpose(s).
- An interchange format such as LMNL (syntax) needs a feature set, but an application must be judged on its functionality. The applications presently in view simply don't need structured annotations so badly. We save time, effort, and fuel by leaving them out for the present

## Syntax

A syntax designed to represent data conforming to MNML Syntax is defined by an iXML grammar and described here in specification documents. Parsing data using Invisible XML, an XML file is delivered; this can be further enhanced to produce xMNML in XML, valid to the xMNML model and extra-schema constraints such as naming rules.

[The grammar is here: ../lib/xMNML/rules/xMNML.rnc](../lib/xMNML/rules/xMNML.rnc)

Examples of conformant syntax with the xMNML produced therefrom can be found in the [../demo/baselines/](../demo/baselines/) folder (and other demo folders).

Additionally, a mixed set of instances ported from earlier work can be tested for syntactic correctness in the [../sources/Luminescent/](../sources/Luminescent/) folder.

# Summary

xMNML supports only a subset of the original concept of LMNL.

What it leaves out:

  - Structured and marked up annotations (annotation as LMNL document)
  - Comments
  - Any analogs to XML processing instructions, entities or declarations
  - LMNL atoms (outside the Unicode character set)

What it includes:

  - Unicode
  - Markup
  - Annotated tagging (like XML)
  - Overlap

For some ideas on how to provide for LMNL annotations, see the [Annotation Concepts](annotations.md) document.

---
end
