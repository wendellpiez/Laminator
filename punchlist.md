# Project punchlist

κάτθανʼ ὁμῶς ὅ τʼ ἀεργὸς ἀνὴρ ὅ τε πολλὰ ἐοργώς. (Iliad IX 320)
"And alike will perish the man who is useless, and he who does much"

For those who know the history, it is easiest to think of Laminator as a (partial) LMNL implementation in an XProc/XSLT-based library, suitable for reuse and adaptation, but interesting not only for what it does, but what it is: an other-worldly XML alternative on an XML-based platform.

If LMNL means nothing to you, think of xMNML - the 'pivot' format used by Laminator, as an XML-based serialization not of a document hierarchy, but document-as-qualified-text, the 'text' in xMNML being considered any continuous range or substring of text treated as sequence of characters. This model can be straightforwardly mapped to its own syntax (which happens to be LMNL 'sawtooth' syntax) as well as processed with operations over its ranges. Critically - and differentiating it from the conventional XML hierarchy - in xMNML (and MNML conceptually as well as LMNL, of which MNML is a formal subset), *ranges can overlap* and *multiple concurrent hierarchies* are normal, because no hierarchy rules over others.

This makes MNML and xMNML useful technologies for applications over documents that reward treating overlap as a 'normal' phenomenon, easily represented and not relying on second-order logic (in baroque transformations) to make XML do complicated things, that are easy with LMNL ranges. When hierarchies are only implicit, we can work with more than one hierarchy at a time. When hierarchies get in the way, we can do without.

For researchers, this is interesting because it turns the world of XML upside down, sometimes in unexpected ways. Things that are easy are now not so easy, but things that are hard in XML are just ... easy. An example is merging two documents with the same text but different structures.

And one thing that is not so hard is to turn a range model back into a hierarchy - so we still have XML any time we need it.

As a demonstration, this site offers an application of MNML, producing SVG graphics from MNML LMNL inputs.

A second project, Scholia 2026, is planned to use Laminator for its own overlap-sensitive operations.

This is very loose with no timeline, as all the code is being prototyped elsewhere.

---

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
