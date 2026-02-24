
## Approach

Avoid cultivating unrealistic expectations and go one step at a time.

- Focus on applications first, not the feature set
- Or even "generalization" and "standardization"
- While maintaing a generalizing perspective
- Not *quite* TDD but using testing to help support formalization, specification, documentation
- Layers!
  - Base functionality offered as XProc library
  - Application sits on top
- At the same time, this is art, not engineering - seek to avoid unused complexity and feature creep

## Reducing the feature set

LMNL is great but **structured annotations** are

- Mind-blowing and distracting for users and devs
- Arguably only a nice-to-have for an XML application

<details><summary>Rabbit Hole Entrance</summary>

*Annotations* on ranges are the LMNL analogue to XML attributes on elements, *except*: LMNL annotations

  - Keep their positions / are considered ordered
  - Can be like-named (isonymous) with siblings
  - Can have annotations
  - Can have markup
  - Are like micro-documents attached to ranges
</details>

... So we reduce to **MNML** - Minimally Annotated Markup in LMNL

The model is still LMNL, but with annotations limited to name-value pairs, like attributes in XML.

## Build from there

Demonstration applications in this repository show some small but interesting uses for the libraries on their own.

A few of the applications that are supported (to some extent), or might be:

- Indexing
- Text extraction of arbitrary (marked) segments for analysis
- Aligning versions of a text, or a text with translations or other *apparatus*
- Layering auto-generated or handmade feature sets over text
- Standoff annotation and annotation libraries

Etc. etc.

## Some day, annotations?

Not-very-formal [specifications for MNML LMNL](../../specs/readme.md) are on this site.

A couple of ideas for structured annotations, evading the syntactic complications, are also [documented on this site](../../specs/annotations.md).

---
end
