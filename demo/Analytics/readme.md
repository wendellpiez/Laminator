# Analytics Demo

Various kinds of analytics are core features of Luminescent and should (eventually) be available in [the lib folder](../../lib/).

Also, other demonstrations may have analytic aspects - for example, the demonstration pipeline [PL-EXTRACTION](../baselines/PL-EXTRACTION.xpl) is essentially analytic (with some [results here](../baselines/out/PL-range-survey.xml)).

This subdirectory contains *rudimentary* and *alternative* analytics and experiments.

So far ...

## Range type grid showing overlaps

Pipeline [overlap-grid.xpl](overlap-grid.xpl) produces an SVG diagram of the overlaps among range types (generic identifier or GIs) in a MNML LMNL input document. It is bound by default to the sample [Paradise Lost](../baselines/data/PLfragment.lmnl), but any MNML LMNL document should also work.

Some results are saved in the [out/](out/) folder.

A set of SVGs for a set of LMNL documents can be produced by [MAKE-GRIDS.xpl](MAKE-GRIDS.xpl), which calls the other pipeline. Its source documents are hard-coded but adjustable.

Run over *Frankenstein*, this produces a graph with an interesting finding: in the Frankenstein document, apparently `volume` markup overlaps `page` markup. In this case, the apparent oddity is a reflection of the hybrid (monstrous) nature of the markup itself - pages are numbered and marked from the 1831 edition, but the volume demarcations occur only in the 1818 edition.

---
end
