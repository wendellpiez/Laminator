# LMNL Annotations

The MNML LMNL subset supports only name-value annotations, so this is not possible:

```
[poem [teiHeader [sourceDesc}....{sourceDesc}]} ... {poem]`
```

Here, an annotation has its own annotation. (The **`sourceDesc`** is out of place.)
 
In LMNL this was nominally supported. It raises enough complications for both parsing and processing, however, that it seems useful to keep these features outside the basic functionality, as a way of keeping specifications, code and tests all simpler.

Meanwhile some simple creative uses of plain-text annotations include links to other files - which can be any format at all subject, to implementors' choices.

---
end