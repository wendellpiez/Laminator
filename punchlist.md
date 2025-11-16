# Project punchlist

This is very loose with no timeline, as all the code is being prototyped elsewhere.

1. Set up XProc under CI/CD (model on oscal-xproc3).
   - run XProc XSLT smoke test
   - run parsing regression test suite
   - research XSpec under XProc under CI/CD

2. Develop functions (capabilities) under testing
   - a `lib` directory provides entry points
   - demo application works by stitching these together
   - don't forget rangle plot SVGs

4. Provide instructions for using as a Git submodule

## Pipelines planned

Pipelines in **bold** are in place and working elsewhere (require porting over and testing)

- **XML to LMNL**
- XML to xMNML (nice to have)
- **LMNL to xMNML** (we have)
- xMNML to XML (with filter) - naive cast, with warnings (port from Luminescent)
- xMNML to LMNL (with filter) - canonical
- xMNML merge (assembling multiple xMNMLs)
- xLMNL rewrite - doesn't validate, instead corrects - develop this incrementally

- xLMNL enhancers
  - sentence / phrase segmenters (iXML -> XML -> LMNL -> xMNML) (**prototyped**)
  - word taggers
  - etc.

## MNML LMNL

See more definitions and descriptions in the code base.

**M**inimally A**n**notated **M**arkup in **L**MNL (MNML) is LMNL (the Layered Markup and Annotation Language) *except*

- Range annotations must be name-value pairs like XML attributes: they cannot be marked up or provided with annotations - consequently MNMLL LMNL is (pretty much) "just like XML except allows overlap"
- LMNL atoms, comments, PIs and declarations are not supported (don't need them in my applications)
- No provision is made for namespaces (XML or other) - they are just names
- Not every edge may be tested (e.g.: annotations on end tags)

This reduction is in view of two considerations:

- We have XML (the standard and the technology) - for hierarchies and providing a functional programming platform
- We have iXML - better stronger capabilities for text handling altogether
- We have extensive study resources in XML and HTML - not starting from scratch, and have no need to plan to do so
