# Project punchlist

κάτθανʼ ὁμῶς ὅ τʼ ἀεργὸς ἀνὴρ ὅ τε πολλὰ ἐοργώς. (Iliad IX 320)
"And alike will perish the man who is useless, and he who does much"

For those who know the history, it is easiest to think of Laminator as a (partial) LMNL implementation in an XProc/XSLT-based library, suitable for reuse and adaptation, but interesting not only for what it does, but what it is: an other-worldly XML alternative on an XML-based platform.

---

next steps

    - NestedNarrative demo
  - start polishing slides
  - return to sonnets demo (XSL-FO/PDF?)

further

- Regression testing
- Schematon over repo XProc
- `directory-manifest`

plan CI/CD under local git commit hook (not GHA)

until then, regression test by hand using XProc and XSpec

Sooner - prototype Range Mapper demo on this site with a working library
Later - develop out as a submodule used in a different application (Scholia202x)
  (meanwhile, prototype Scholia in the  XProc Zone sc http://www.xproc.zone)
  
Provide instructions for using as a Git submodule?

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
