# Analytics Demo

Various kinds of analytics are core features of Luminescent and should (eventually) be available in [the lib folder](../../lib/).

Also, other demonstrations may have analytic aspects - for example, the demonstration pipeline [PL-EXTRACTION](../baselines/PL-EXTRACTION.xpl) is essentially analytic (with some [results here](../baselines/out/PL-range-survey.xml)).

This subdirectory contains *rudimentary* and *alternative* analytics and experiments.

So far ...

### Range extraction

`PL-EXTRACTION.xpl` shows some rudimentary MNML processing. The pipeline processes the example document (**Paradise Lost** fragment) and returns a list of all ranges found with the given type name, provided as a parameter. So all `np` (noun phrase) ranges can be listed, or all `s` (sentence ranges).s

The listing shows locations by line numbers, found by querying for overlapping `l` (line) ranges.

[A result](expected/PL-range-survey.xml) from running this pipeline (with 's' and 'np' as parameter values) can be found in the [expected](expected) folder.

The pipeline logic is generic and applies to any MNML document. The range type(s) to be returned are given as a parameter to the XSLT performing the query. For purposes of reporting locations, this XSLT assumes that `l` ranges (for lines) with `n` annotations appear (for line numbering, as in the examples) to provide this information.

Along similar lines, QUOTES_EXTRACTION.xpl extracts quotes (ranges marked `q`, `quote` or `said`) from a sequence of documents, and writes the composite results into a file in the `out` folder. Note: some quotes are long!

## Range type grid showing overlaps

Pipeline [overlap-grid.xpl](overlap-grid.xpl) produces an SVG diagram of the overlaps among range types (generic identifier or GIs) in a MNML LMNL input document. It is bound by default to the sample [Paradise Lost](../baselines/data/PLfragment.lmnl), but any MNML LMNL document should also work.

(It may be asked why this is SVG. Answer is, there is no good answer - an HTML table would do just as well. What is more interesting is the question raised by this question, namely what information are we seeking and how is it best discovered and represented. YMMV.) 

Some results are saved in the [out/](out/) folder. Additionally, a report of overlaps across the range types is produced as pipeline output. 

A set of reports, with SVGs, for a set of LMNL documents can be produced by [MAKE-GRIDS.xpl](MAKE-GRIDS.xpl), which calls the other pipeline. Its source documents are hard-coded but adjustable.

Run over *Frankenstein*, this produces a graph with an interesting finding: in the Frankenstein document, apparently `volume` markup overlaps `page` markup. In this case, the apparent oddity is a reflection of the hybrid (monstrous) nature of the markup itself - pages are numbered and marked from the 1831 edition, but the volume demarcations occur only in the 1818 edition.

---
end
