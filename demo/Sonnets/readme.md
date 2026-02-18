# Sonnets Bubble Diagram Demo

A redux of a demonstration shown at Balisage 2014 (White Flint, MD) 

(See the paper in the [Balisage proceedings](https://www.balisage.net/Proceedings/vol13/html/Piez01/BalisageVol13-Piez01.html).)

So far we have two pipelines. See each one for more info.

Run ./SONNET-BUBBLER.xpl to produce new sonnet diagrams from the set.

Find the LMNL sonnets [in their source folder](../../sources/Sonneteer/sonnets/).

Add new sonnets to the set with authors, titles and ids and diagrams will be produced for them as well.

Find results in the [out](out/) folder as indicated by the pipelines.

Then, run SONNET-LISTER.xpl to list the sonnets with snapshot diagrams.

## About the Sonneteer and this markup

This is a LMNL version of a data set available as an XML demonstration since 2003.

The markup takes the form of two overlapping hierarchies:

- A line/stanza hierarchy - ranges include lines and line groups such as couplets, quatrains, sestets and octaves.

- A phrase/sentence hierarchy - range types include **s** for sentance and **phr** for phrase. Sentences are always aggregates of one or more phrases.


