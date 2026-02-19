# Analytics Demo

So far ...

Pipeline [overlap-grid.xpl](overlap-grid.xpl) produces an SVG diagram of the overlaps in a MNML LMNL input document. It is bound by default to the sample [Paradise Lost](../baselines/data/PLfragment.lmnl), but any MNML LMNL document should also work.

Some results are saved in the [out/](out/) folder.

A set of SVGs for a set of LMNL documents can be produced by [MAKE-GRIDS.xpl](MAKE-GRIDS.xpl), which calls the other pipeline. Its source documents are hard-coded but adjustable.

**Update**: yes, it works, but - because this is a grid (ha) - the SVG increases exponentially in size relative to the number of ranges in the document. Accordingly the Frankenstein sample SVG is almost 500GB. So another approach is called for. One concept is to graph not the ranges, but the range types. Meanwhile, the search for other good alternatives to range maps (as far as analytical views go) is still underway.

At least for smaller documents (and for as big an SVG as your browser can swallow), the overlaps are shown both in a report (each range is listed with the ranges that overlap it at start and end) and as a grid showing the patterns of overlap.

The XSLT also has the beginnings of a function library for assessing range relations. Given two ranges, do they overlap or not?

---
end
