
# Overlap Meets Invisible XML

### Invisible XML Symposium 2026

#### Wendell Piez

#### February 26 2026

DRAFT of Feb 23 2026

Project: https://github.com/wendellpiez/Laminator

This coverage: https://github.com/wendellpiez/Laminator/tree/main/papers/iXMLSymposium2026

## LMNL Markup - an example

Take a look at [a small LMNL document](../demo/Housekeeper144-146.lmnl)

```
[excerpt}
[s}[l [n}144{n]}He manages to keep the upper hand{l]
[l [n}145{n]}On his own farm.{s] [s}He's boss.{s] [s}But as to hens:{l]
[l [n}146{n]}We fence our flowers in and the hens range.{l]{s]
{excerpt
  [title}The Housekeeper{] [author}Robert Frost{] [date}1915{]]
```

This is declarative, descriptive markup not very unlike TEI.

But not XML.

- Tags ... constructed differently
- `[s}...{s]` and `[l}...{l]` overlap
- Behind the scenes, a *range model*

## LMNL 2001

LMNL: The Layered Markup and Annotation Language (Tennison and Piez 2001)

Proposed as a research project in the form of an open source initiative.

(No SDO, no megacorp, no killer app, just an interesting problem)

We saw many interesting developments and contributions.

<details><summary>Several full and partial implementations were built ...</summary>

By (at least)
  Gavin Nicol;
  Jeni Tennison;
  (Wendell Piez);
  Alexander Czmiel;
  Gregor Middell;
  Paul Caton
  (and please remind me if you should be on this list!)

</details>

<details><summary>Plus significant contributions by others in the form of reactions, critiques, and competing efforts</summary>

Many acronyms should be listed including CONCUR, TeX/MECS, GODDAG, CLIX, JITTs, SGF, XCONCUR, EARMARK (and others)

</details>

<small>*Personal aside*: I have always been gratified by the serious welcoming attention given to LMNL. Thank you everyone!</small>

## LMNL 2026?

Developers have long since moved on.

The technology has also caught up and passed us.

The playing field is much more ... variable.

Even in XML, with new capabilities the need is not so pressing

- XPath/XSLT 3.1 - accumulators, HOFs, etc.
- XProc 3
- Invisible XML

Where overlap rears its ugly head, either

- Problems are recognized, patterns are recognized and solutions are 'only work', or
- People learn to live with reduced expectations

*... while I am still looking and wondering ...*

## The Approach

<center><big><b>... the Laminator ...</b></big></center>

Read more about the approach in [a companion document.](approach.md)

## The Implementation

**The Laminator** is a new project on Github offering functionality over xMNML (a LMNL range model).

TL/DR - xMNML is an XML representation of a MNML model, where MNML is a formal subset of LMNL.

In the Laminator, an XProc 3 pipeline executes in three steps what [in 2012](https://github.com/wendellpiez/Luminescent) required thirteen (13) XSLT passes:

1. Invisible XML parse renders sequence of tags and text
1. Linking tags
1. Measuring ranges

... generating an XML-based 'database' of the LMNL model - xMNML

Designed for range processing including

  - Range operations - filtering, merging, mapping, analyzing, explicating
  - Casting range sets into hierarchies
  - Serializing to notations including XML and LMNL

## The iXML grammar

Summary of intent:

- Input (text) is construed as a sequence of tags with text
- Tags include **start**, **end** and **empty** (zero-length) range markers
- `{`, `[` and `\` are reserved as open markup delimiters (and provided with escapes `\[` `\{` and `\\`)
- Any tag can have annotations (end tags too)
- Whitespace is not preserved in tags (maybe some day, for capturing lineno/offset)
- Matching up tags happens in subsequent stages, not here

[See the grammar in the repository](../../lib/xMNML/up/sawtooth-syntax/src/mnml-lmnl.ixml).

## Processing steps - data intake

- Parse the syntax - iXML grammar
- Build the model - XProc pipeline

For example, a [demo pipeline](../../demo/baselines/xMNML-BUILD.xpl) will run a pair of baseline documents through a parsing sequence, produce the model and save it as XML.

Parsing and processing results are [saved for inspection](../../demo/baselines/cache/).

Interim steps - iXML parse before linking, linking before measuring - are also shown.

Some cases of good and bad syntax, offering some stress testing for the parser, are shown in [a pipeline in the library](../../lib/xMNML/up/sawtooth-syntax/TEST_WFCHECK-SAWTEETH.xpl).

NB - this sequence of steps - parsing from LMNL tags - is only part of the Laminator's data acquisition model, and not the only way to produce xMNML. 

## A demonstration or two

Demonstrations are [all available to examine, download and run](../../demo/).

Here, jump straight to [see some results from the *Sonnets* demonstration](../../demo/Sonnets/sonnet-list.md).

Or check out the [StoryLines demo](https://github.com/wendellpiez/Laminator/blob/main/demo/StoryLines/readme.md) - read to the bottom and don't be shy.

[Analytics demos](../../demo/Analytics/) scratch the surface of LMNL analytics.

## See the code

All the code can be found [in Github](). Please fork or borrow. MIT License.

The code base is entirely XProc, XSLT and iXML. (So far. Planned projects will also use HTML/CSS/Javascript)

It has been developed and tested using XML Calabash 3.0.x with Saxon-HE and MarkupBlitz.

## `<soCalled>`Plans`</soCalled>`

Working toward being able to do useful things, most especially in Digital Humanities.

So a current project, **Scholia 2026** -

- Electronic (in-browser) graded readers for language study
  - TEI, XML and LMNL backbone
  - HTML+CSS+JS for viewing, PDF for printing
- Printed worksheets for transcription exercises - language study - *scriptorium* method 

## Making the case

- When do you need an alternative data format?
  - *You decide* - XProc (with XSLT and iXML) makes it possible

- An application can be built on a concept, but a standard for interchange will require
  - Specifications
  - Reference implementation(s)
  - Test suites ... (ask me how I know)

- When the code is declarative, a specification becomes intelligible
  - Each layer of description supports the next one up
  - This design is resilient and adaptable as well as functional
  - An *intelligible* specification is a *useful* and *meaningful* one 

- No data interchange requirement? Do your thing and don't worry.

## Grateful acknowledgements

So many thanks and acknowledgements are due - the list is very long -

*Thanks to organizers and event support staff*

<details><summary>Thanks everyone!</summary>

![Thanks 2026](../thanks2026.svg "Thanks 2026")

</details>



---
