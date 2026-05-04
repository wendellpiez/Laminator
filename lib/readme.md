# Laminator libraries

Generic code for working with MNML LMNL.

See the readme documents and code base for the current state.

Test pipelines and XSpec tests can be found close to their test targets.


## TODO

BUILD OUT 'RANGES' model support
  XSLT xMNML-ranges.xsl ../demo/baselines/data/PLfragment.lmnl
  Schema for RANGES model 

  with XSpec tests for regression testing
  capabilities: MERGE; INSCRIBE; produce XML (xMNML/out/xMNML-build-xml.xsl)
REFRESH/TEST ALL DEMOS
Rearrange 'lib'
  clear out 'misc'
  fix up TEI
  document


## xMNML

An XML-based format representing a LMNL document as a sequence of tags (as elements) interleaving text (as elements).

## RANGES

ArRANGEd Standoff

This is also an XML-based format, representing the LMNL range model in 'bare bones' form as a collection of sequences of ranges ('layers') defined in reference to a text.

A transparent, bidirectional, lossless conversion pathway between xMNML and RANGES provides the library with a synthesis of their capabilities.

Generally speaking, xMNML comes into play when working directly with LMNL "sawtooth" syntax.

The RANGES model comes into play when we wish to perform operations directly on the range sequences, for example merging two range sequences to provide a document combining two sets of markup (possibly overlapping).


## Functions and capabilities

Planned and underway:

xMNML -> RANGES
RANGES -> xMNML (from xMNML/out/xMNML-reinscribe.xsl)

demo roundtrip
RUNALL to run everything for testing
finish todo / document
clean up!

### Acquisition

- Parsing LMNL syntax (MNML subset) to build xMNML (XML)
- Converting XML into xMNML

### Expression

- Producing LMNL syntax from xMNML - LMNL serialization
- Producing XML from xMNML - building trees from ranges
- 'Ripping' XML when possible

### Support

- Serializing XML in LMNL syntax
- Process xMNML natively:
  - To modify documents
  - To filter and merge range sets
  - Validation, diagnostics, restoration
  - Analytics

## Conceptual map

A mermaid flowchart diagram shows the moving pieces.

Any process can be assumed to be XSLT even if functionally very simple ('tag writing').

TBD (potentially) - shortcuts implemented as direct transformations (while we are doing our best to factor out complexity) - e.g. the XML builder could work on both xMNML and RANGES inputs

```mermaid
flowchart TD
    lmnlIN[LMNL] -.->|iXML| lmnlTAGS(MNML tag sequence)
    subgraph parser
    lmnlTAGS -.->|matcher XSLT| MATCHED(matched)
    MATCHED -.->|measurer XSLT| XMNML{xMNML}
    end
    
    lmnlOUT -.-> lmnlIN
    XMNML -.->|serialize| lmnlOUT[LMNL]
    XMNML  -.->|index| RANGES[[RANGES]]
    RANGES -.->|inscribe| XMNML
 
    XMNML  -->|build| xmlOUT[XML]
    XMNML  -->|rip| xmlOUT[XML]
    xmlOUT --> lmnlOUT

```

A few pathways are not shown in the picture, for example converting directly from XML straight into xLMNL or RANGES, not via LMNL tagging.

The RANGES model is useful

- For certain kinds of operations such as filtering and merging range sets
  - remove all ranges of certain kinds
  - supplement with new range sets indexed into the text
    - just add the new ranges and unify IDs
  - rewrite ranges into marked segments (converting start/end to empty milestones)
  - sort ranges into layers (hierarchies) / capture MCH
  - navigate a schema (proxy) to create an instance? (alternative to XML build)

- For normalizing, cleaning up, testing an xMNML document for integrity
  - a well-ordered, complete and correct xMNML document will convert losslessly, otherwise not



### Version prior to April 2026

Cornered rectangles - i.e., only XML and LMNL - will take the form of persistent data objects on your system. Everything else is internal to pipelines and not visible to the end user, only to developers and builders.

```mermaid
flowchart TD
    lmnlIN[LMNL] -->|iXML| lmnlTAGS(MNML tag sequence)
    lmnlTAGS -->|matcher XSLT| MATCHED(matched)
    MATCHED -->|measurer XSLT| XMNML{xMNML}
    lmnlOUT --> lmnlIN
    XMNML -->|rip| XMLOUT1[XML]
    XMNML-->|transform| xmnmlOUT{xMNML}
    XMLOUT1 --> lmnlOUT
    XMLOUT1 --> XMNML
    XMNML -->|build| xmlOUT2[XML]
    xmlOUT2 --> XMNML
    xmlOUT2 --> lmnlOUT
    XMNML -->|serialize| lmnlOUT[LMNL]
    xmnmlOUT --> lmnlOUT
    xmnmlOUT --> XMNML
```

Here is the same architecture, except with more labels, and the MNML LMNL parsing steps are reduced to a black box, "XProc/iXML Pipeline".

```mermaid
flowchart TD
    lmnlIN[LMNL] -->|XProc/iXML pipeline| XMNML{xMNML}
    lmnlOUT --> lmnlIN
    XMNML -->|rip| XMLOUT1[XML]
    XMNML-->|xform| xmnmlOUT{xMNML}
    XMLOUT1 -->|serialize| lmnlOUT
    XMLOUT1 -->|rip| XMNML
    XMNML -->|build| xmlOUT2[XML]
    xmlOUT2 -->|rip| XMNML
    xmlOUT2 -->|serialize| lmnlOUT
    XMNML -->|serialize| lmnlOUT[LMNL]
    xmnmlOUT -->|serialize| lmnlOUT
    xmnmlOUT -->|xform| XMNML
```

### Ripping and building: xMNML to XML, XML to xLMNL

In the diagram, *build* refers to a process that produces XML from xMNML by a hierarchical node traversal - guaranteeing XML results from any xMNML input, at the cost of splitting ranges across element boundaries when they overlap.

In contrast, *rip* refers to a process that emits XML from xMNML -- or an xMNML 'tag stream' from XML -- using some form of 'tag writing'.

This is a cheap-and-easy (and fast) way to convert xMNML when its fitness for such conversion is known in advance; and such fitness can be assessed according to known rules (in brief: no overlap; correctly nested start-end sequencing; no anonymous ranges or annotations, or annotations with the same name on the same range). But it will fail in the face of unhandled overlap among ranges in the xMNML source, when the results break the XML end-tag matching rule.

And XML always safely "rips" into xMNML because XML has no overlap to be a problem in xMNML, if that were a problem.

Both "ripping" and "building" can include other operations in the conversion, such as removing ranges of certain types (so corresponding elements do not break hierarchies), rewriting end-tag/start-tag pairs into XML 'milestones', or other manipulations. Careful "ripping" from XML can be a good way to see overlaps that are not rendered explicitly in source XML, but can become true ranges (marked with starts and ends) when ripped.

---
end

