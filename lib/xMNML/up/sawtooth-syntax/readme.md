# Parsing LMNL Sawtooth Syntax into xMNML

For iXML, try MarkupBlitz.

## Conceptual map

Cornered rectangles - i.e., only XML and LMNL - will take the form of persistent data objects on your system. Everything else is internal to pipelines and not visible to the end user, only to developers and builders.

```mermaid
flowchart TD
    lmnlIN[LMNL] -->|iXML| lmnlTAGS(MNML tag sequence)
    lmnlTAGS -->|XSLT matcher| MATCHED(matched)
    MATCHED -->|XSLT measurer| XMNML{xMNML}
    lmnlOUT --> lmnlIN
    XMNML -->|rip| XMLOUT1[XML]
    XMNML--> xmnmlOUT{xMNML}
    xmnmlOUT --> XMNML
    XMNML -->|build| xmlOUT2[XML]
    xmlOUT2 --> XMNML
    xmlOUT2 --> lmnlIN
    XMNML --> lmnlOUT[LMNL]
    xmnmlOUT --> lmnlOUT
    xmlOUT2 --> lmnlOUT
```

