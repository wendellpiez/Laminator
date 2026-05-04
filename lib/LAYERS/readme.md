# LAYERS model

back all this up with regression tests! :-)

TODO
  clean up for git, comment, readme, and commit current work
  build test for round-tripping through LAYERS
  expose top-level pipelines
    parse_MNML-LMNL.xpl - two result ports, xMNML and LAYERS
    parse_MNML-LMNL-diagnostic.xpl (caches outputs etc. - wip/placeholder okay)
      can intercept a hanging parse (when too deep?)
  build LAYERS schema / integrate this?
  build XML builder
  sketch out pathways for operations
    filter
    merge
    modify (parameterize XSLT?)
    OHCO support in LAYERS (with builder)
in
  xMNML-to-ranges
    calls xmnml_range-index.xsl
  sawteeth-to-ranges.xpl
  xml-to-ranges.xpl
    calls xml_range-builder.xsl (uses an accumulator to calculate offsets)
    
out
  range-xmlbuilder.xsl
  ranges-to-xMNML.xsl - inscriber (xMNML writer, e.g. for ripping)
    ../misc/xMNML-reinscribe.xsl
 
  ranges-XML-ripper.xpl (goes via xMNML)
  ranges-XML-builder.xpl (goes straight)
  

Test / example

Combine two instances

Paradise Lost intro
  lines
  sentences

demo
  PLlines.lmnl
  PLsentences.lmnl

  pipeline to combine and serialize


read
sawtooth-to-xMNML
xMNML-to-LAYERS

combine

LAYERS-to-xMNML XSLT (../misc/xMNML-reinscribe.xsl)

