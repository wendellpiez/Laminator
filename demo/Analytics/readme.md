# Analytics Demo

So far ...

Pipeline overlap-grid.xpl produces an SVG diagram of the overlaps in a MNML LMNL input document. It is bound by default to the sample [Paradise Lost](../baselines/data/PLfragment.lmnl), but any MNML LMNL document should also work.
The overlaps are shown both in a report (each range is listed with the ranges that overlap it at start and end) and as a grid showing the patterns of overlap.

The XSLT also has the beginnings of a function library for assessing range relations. - given two ranges, do they overlap or not?

(Note that this can be determined by calculating from offsets and extents, but the XSLT uses a document traversal method.)

A set of SVGs for a set of LMNL documents can be produced by calling this pipeline from another - see [../baselines/xMNML_REFRESH.xpl](../baselines/xMNML_REFRESH.xpl) for an example of such batch processing.

