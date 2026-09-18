# LMNL Annotations

The MNML LMNL subset supports only name-value annotations, so this is not possible:

```
[poem [teiHeader [sourceDesc}....{sourceDesc}]} ... {poem]`
```

Here, an annotation has its own annotation. (The **`sourceDesc`** is out of place.)
 
In LMNL this was nominally supported. It raises enough complications for both parsing and processing, however, that it seems useful to keep these features outside the basic functionality, as a way of keeping specifications, code and tests all simpler.

Meanwhile some simple creative uses of plain-text annotations include links to other files - which can be any format at all subject, to implementors' choices.

## Some ideas

### Change the syntax

Use annotation tagging delimiters `[>` and `<]` instead of range delimiters `[}{]`

Since annotations do not overlap this should work?

Or, make an annotation naming syntax discrete from range GIs?

```
[@ann}annotation{@ann]
```

or maybe (better?)

```
[#range [ann}annotation{ann]}range of text{range#]
```

### Don't use markup

Instead of treating them as code literals, use annotations as pointers:

```
[comment [file}comment.lmnl{note]} ... {comment]
```

Then a parser doesn't have to do anything (beyond parse what is retrieved), while processing becomes dependent on file traversal.

Potential issues: limiting the pointer syntax to avoid markup delimiters 

At the other end of the pointer could be XML or LMNL (or anything) as well as plain text.



---
end