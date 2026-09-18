


# MNML Specification

> Warning: this is a **PRESENTATION** version of this document. *NOT FOR EDITING*.

## Front matter


MNML Specification

## Introduction

MNML (pronounced "minimal") is Minimally Annotated Markup in LMNL (pronounced "liminal").

LMNL is the Layered Markup and Annotation Language (Piez and Tennison 2002).

This document specifies MNML, designed as a formal subset of LMNL: all MNML documents are also LMNL documents. However, LMNL is not defined here. Because LMNL is taken on as a design constraint, inferences can be made about it inasmuch as features of MNML LMNL must also be true of LMNL at large. But while all MNML documents are also LMNL documents, the reverse is not the case. As a subset, MNML LMNL follows all the rules of LMNL, and then adds some.

Features of LMNL excluded from MNML are out of scope for this document. They include structured and annotated annotations, LMNL atoms, and potentially other features. [Annotations](./annotations.md) are discussed in a companion article.

As a specification, this document seeks to be abstract and notional, and thus to represent no particular point of view. Where first person pronounds occur, "we" can refer to users of LMNL, present and former, or people who talk about or used to talk about LMNL or MNML LMNL.

## Scope of definitions

As a LMNL subset, MNML LMNL is a data model. Along with this model we propose a syntax called **MNML LMNL syntax**. It is also related to the LMNL initiative in replicating, for the most part, the proposed "sawtooth" or "sabertooth" syntax associated with the LMNL proposal and used to illustrated LMNL examples.

As noted, LMNL and LMNL syntax are not defined or even fully described here.

An instance of the LMNL data model is a **MNML (LMNL) document**; the model describes it and its constituent parts, the conceptual structures it provides to support information processing and retrieval. Along with these structures, a definitive mapping is described from this syntax into the model.

In addition to the MNML model as an abstraction, two other artifacts are defined specifically for the Laminator implementation of MNML LMNL: an XML-based **tag sequence model** called xMNML, and another XML-based **range model**, called LAYERS. These descriptions are not normative even for MNML LMNL (much less LMNL in general), but they are useful inasmuch as they describe its implementation in the Laminator.


* [XMNML Specification](xMNML_spec.md)
* [LAYERS model Specification](LAYERS_spec.md)

LAYERS stands for *Layered Assembly of Enumerated Range Sequences*.

## Axioms and assumptions

### Conformance

MNML LMNL is defined as an abstract range model, enabling a **text** or **text value**, a string, to be addressed by means of its **ranges**, abstractly defined entities describing their text contents and amending or decorating the text with annotations. Conformance to these specifications requires an implementation that uses this model (or, internally, another model to exactly the same effect) to provide for rules-based processing of information so described -- a set of ranges over a text -- to create new information sets. These may be LMNL range models, which can be written out and expressed as LMNL or XML syntax instances. They may also be encoded in plain text; JSON or other object notation; XML; or binary formats.

Because of this, LMNL or MNML LMNL conformance ("does the application use the model?") may sometimes be difficult to verify by formal means, even assuming specifications to be clear and complete.

In contrast, conformance to MNML LMNL syntax -- i.e., the fitness of a given string for processing as MNML LMNL -- can be defined (as below), at least in part, by reference to the grammar used to describe it (and in the Laminator, to configure its processing). An instance that does not parse unambiguously with this grammar can be stipulated to be out of bounds, and the parser will be able to tell us why.

Accordingly, while the syntax can be provided with unit tests offering coverage of its features (and some testing of this kind can be found in the Laminator code base), the larger question of whether a piece of software is "using LMNL" or even "MNML LMNL" must be determined at the interface between this software and its users, including other LMNL users, and not (or not only) by whether and how it resembles the Laminator (or any other implementation) in either its results or its operations -- even while systems should be returning the same results for the same operations. (Some XML-based and object-based systems, especially those that use offsets over string values to identify ranges, are already 'LMNL-like'.)

Note however that we do not yet [20260915] seek to define either an API, or a query language, for LMNL or MNML LMNL. Both of these will require again addressing the conformance and testability questions.

### Relation to LMNL

These specifications seek to *describe* LMNL while *defining* MNML LMNL processing to support LMNL, or more specifically the features of LMNL captured and codified in the MNML subset. Features of LMNL that are not implemented by MNML LMNL may also be described, but nothing said here should be taken as a normative statement regarding LMNL itself, whether applying to a feature that is in scope for MNML LMNL (such as overlapping ranges), or one that is not (such as structured and annotated annotations).

### Files, strings and documents

The "base unit" for parsing (processing) MNML LMNL data is a UTF-8 string. In these specifications we describe operations over files, but an implementation does not have to work with files as such, to qualify as a MNML LMNL processor, as the same operations can be performed over strings maintained in any form, and irrespective of the particular input/output operations related to maintenance and persistence.

Since MNML LMNL has no inclusion mechanism defined in the model (applications may merge documents according to their own requirements), there is practical synonymy between *file* and *instance*. *Document* describes the same entity again, except regarded as an abstraction. A MNML document can be produced from any file whose content is a string using the prescribed syntax; such a string, stored as a file, is a MNML file and also -- when parsed -- is a MNML instance.

For purposes of this (preliminary) specification, such a string is defined as any UTF-8 character sequence that can be parsed unambiguously using the iXML grammar for LMNL syntax designated by Laminator, namely `../lib/xMNML/in/sawtooth-syntax/src/mnml-lmnl-explicit.ixml` at the time of writing, and deliver XML results from an Invisible XML parse of the input with this grammar.

The rules enforced by this grammar are expected to correspond (never to conflict) with the rules of the syntax described here. If and where they are found to vary, conformance itself must be considered undefined until the issues in question are resolved and documents revised or updated accordingly.

The purpose of close alignment with the Laminator and its iXML implementation here is to center its grammar as the locus of control for the supported syntax, not to create a dependency on Laminator or iXML. If treating this grammar as normative poses any kind of problem with regard to system dependencies (in future), the specification can be externalized or abstracted from the grammar in question, or from iXML in general.

An alternative LMNL or even MNML LMNL implementation might opt for a different syntax altogether (or many of them), in addition to or instead of sawtooth syntax.

### Characters: Unicode normalization, whitespace, notation and naming

UTF-8 is considered as a character sequence without normalization, where each character is distinguishable by a position in the sequence in combination with a code point for the character (or other unambiguous representation). If normalization of a UTF-8 string results in a detectably different UTF-8 string, they are not considered the same: strings are the same only if they are also the same at the codepoint level, i.e. when decomposed into characters, with no further adjustment or normalization.

In specifications and documentation, we may sometimes use regular expression notation for character classes (`\n` for new line, etc.), but this is a convenience and the notation has no special meaning for MNML LMNL.

Throughout these specifications, line feeds in inputs are assumed to have been normalized to Unix-conventional `LF`, i.e. no `CR` characters are given in the data. Ensure your `CR` or `CR/LF` have been converted to `LF` to avoid any issues.

[TODO: test to see if iXML parse enforces this?]

Whitespace defined as in XML: `\s+` where `\s` is `LF|TAB|SPACE`. All whitespace in the data (not in tags) is considered part of the data stream and not subject to normalization, improvement or correction.

In order to help ensure alignment with XML systems, names are specified as in XML: `\i\c*` (in XPath regular expression syntax).

## MNML LMNL Syntax

MNML LMNL is defined in two parts, which can be used together or separately. MNML LMNL Syntax takes after LMNL syntax, nicknamed 'sawteeth' (by John C) or 'saberteeth' (by Alex Cz), and may be referred to as such.

### Syntax Description

MNML LMNL Syntax defines how a string of characters is to be rendered as a markup stream to a MNML application. For convenience, the markup stream resulting from a syntax parse can be described as an XML document. A MNML LMNL Syntax parser is *NOT* required to emit or expose such an XML structure, but what it does emit must be rich enough (no information loss) that such a document could be produced from its result using appropriate means (depending on its form).

Such an XML document representation of the LMNL markup stream or tag sequence is implicit in the Laminator iXML grammar for MNML LMNL syntax, but the iXML grammar should be considered as informative with respect to its design, not normative. (The iXML grammar in the implementation captures additional information for convenience in this implementation. If it is useful, we can codify this XML and provide a schema for it.)

Strings of characters, or documents, that do not conform to the grammar, are not considered to be MNML LMNL syntax instances, and must be reported as such. A conforming syntax parser MAY refuse to process such an instance, rejecting it with an exception, and it MUST have a processing mode that supports this behavior, stopping and reporting an exception (nominal error) for the first detected syntax violation in any nominated input. In other words, where inputs do not conform to the grammar, a conforming processor MUST make available a report of detected errors or ambiguities to a downstream processor, if it does not error out as just described.

In addition to matching the requirements of the grammar with respect to character sequencing (rendering useful distinctions between tagging and text content), a string must also conform to a few rules for *regularity* in tagging, which enable the straightforward and unambiguous construction, by automated means, of the corresponding information structure in an implementation. For example, every start tag is required to have a single (determinable) matching end tag.

To help specify these clearly, they are given at the end of the syntax description.

#### iXML grammar

See the file at [../lib/xMNML/in/sawtooth-syntax/src/mnml-lmnl-explicit.ixml](../lib/xMNML/in/sawtooth-syntax/src/mnml-lmnl-explicit.ixml).

An iXML grammar is given for MNML LMNL syntax in the Laminator processor. It defines an XML target format for an Invisible XML parse of MNML LMNL Sawteeth instances, producing an XML format suitable for futher processing.

(For comparison, older iXML grammars may also be available, but none should be considered definitive of anything.)

If any conflicts are found between that document and statements made here, *both* interpretations must be considered in question until adequate reconciliation has been made. Commit dates for relevant files *MAY* be taken into consideration if there are discrepancies between this description, and the implementation offered. An implementation must always determine the "right thing" in any case.

#### Escape syntax

Three characters, reserved to support tagging in LMNL syntax, are not to be used otherwise in text streams: the two open bracket characters `[` and `{`, and the reverse solidus `\`.

Sawtooth syntax uses the open brackets `[` and `{` as its *open tag delimiters* (or 'start tag delimiters'). The close brackets `]` and `}` are the corresponding *close tag* (or 'end tag') delimiters. These characters are used to make tags.

Because these characters direct a parser to read tags, representing the characters themselves can be accommodated with an escaped sequence as a representation, using the `\` character as the escape. So: `\[` and `\{` for `[` and `{` respectively, and `\\` for the reverse solidus itself (`\`).

Unlike XML, LMNL syntax does not support escape sequences for character references, parsed entities or marked escaped (CDATA) sections.

The **close delimiters** `]` and `}` are not provided with an escaped form: they do not need it, and their use would complicate internal indexing. When they appear in content they can simply be used like any other character.

##### Summary


* Escape "[" as `\[` and "{" as `\{`. Escape "" as `\\`
* Nothing else is to be escaped
* Using `\` followed by anything but the characters `[` `{` or `\` results in an error
* Using `[` or `{` to indicate anything but tagging results in an error

### Tagging

Ranges are defined by the presence of corresponding start and end tags in the data, whose placement is taken to mark the start and end of the range. Tag correspondence is determined by matching the range name (generic identifier) and (if present) tag identifier.

XXX examples TBD XXX

A grammar can be used to distinguish tagging from text, but in order to render an internal range model from tagging, ambiguities must be avoided; consequently, more regularities are also observable in tagged LMNL-syntax documents.

#### Start and end tags

Start tags (or "open tags") in LMNL begin with `[` and end with `}`.

The open delimiter `[` is followed immediately by a range name, *optional* annotations, and the close delimiter `{`. So: `[start}`.

End tags (or "close tags") are exactly the same, except they open with `{` and end with `]`. So, `{start]` is the *end tag* for a range named "start".

Each end tag matches a single start tag appearing before it, and is matched by it. Empty tags are not matched (even with other tags of the same name), as they are taken to start and end in one place.

A range is opened with its start tag and closed with its end tag. The end tag matching a given start tag, and closing its range, is the next end tag appearing after all intervening start tags with the same name (including ID), working forward, have been closed. If no such start tags intervene (the usual case), the end tag is the next end tag whose name matches.

XXX [EXAMPLE] XXX

Component IDs on tags can be used to indicate overlap between two ranges given the same range (type) name, as also described below.

XXX [EXAMPLE] XXX

#### Annotations

An annotation looks like a small range given in a start tag, end tag or empty tag, except:


* No tags (start, end or empty) may appear in its value, before the annotation's own end tag is given
* An annotation end tag takes the form `{]`, with no name required or permitted
* Whitespace can appear between annotations, for legibility, and must precede a first annotation given; such whitespace is not considered part of the data set and may not be respected (considered in processing
* The characters "[" "{" "" MUST be escaped, as elsewhere, and will result in errors if found outside such a sequence.

Also note: annotations MAY be given on end tags as well as on start tags. End tag annotations are considered to appear in order after the start tag annotations (in their given order) for the same range.

##### Order of annotations

The order of annotations on a range will persist, unless deliberately altered, in processing. In other words, annotations on ranges are ordered, and preserve the order in which they are given in the syntax, modulo other interventions. Annotations may use the same names as other annotations on the same range. They maintain distinct identities even when homologous.

To keep the model simple, however, the fact that an annotation is given on a start or an end tag is *not* considered to be information. A LMNL processor may freely rewrite a range's annotations to appear on either its start tag or end tag, or to split the annotations between them, provided their order is respected. So an annotation given on an end tag might be moved to a start tag in reserialized outputs.

#### Empty tags for empty ranges

#### Tag ordering

Tags appear in a given order in the syntax, but this order is not retained in the model, In the model, ranges can be put into order, but tag order is not given, and must be undefined in some scenarious, such as merging two LMNL documents into one by consolidating ranges.

XXX [with examples of slippage] XXX

Slippage can also occur in annotation placement on between the start and end tags on a given range. Annotation order on a range should be respected, but all annotations can be given on a start tag or end tag, or split between them, without affecting the range.

#### Rules for regularity

Each start tag must correspond to exactly one end tag, which follows it in the character stream. This **correspondence** between start and end tags is the closest thing in LMNL to the XML end-tag-matching rule [XXX ref XXX]: the difference is that end tags in MNML LMNL do not have to be the first end tag after the start tag they match.

As in XML, each end tag must similarly correspond to exactly one start tag, which precedes it.

By default, documents containing start and end tags with no matching tag should not be processed or discarded, instead producing exceptions and stopping. A processor **MAY** provide modes with exception handling for these problems, but they should be only enabled explicitly and come with defenses (such as runtime warnings).

Empty tags (for empty ranges) are not matched to corresponding tags, and empty ranges, even with the same name as other ranges marked by start and end tags in the same document, have no effect for purposes of matching.

A processor *MAY* report a warning when a tag component ID (a name suffix with `=`) is given on an empty tag range name, as it has no effect in the general case. (It has no effect unless it conflicts with another ID, in which case it is an error.) Empty range tags never need tag component IDs since they do not correspond with (match to) other tags but are "self-closing".

Tag component IDs do *not* have to be distinct across the document, as they suffice, along with the other rules of tag matching, to provide for marking up arbitrary overlap [XXX link XXX]. But overloading them with semantics (using "meaningful IDs") is not generally advisable, as they can be rewritten internally and are not guaranteed to persist when a document is rewritten.

## MNML LMNL Range Model

### Naming

As noted, names in MNML LMNL must follow the XML naming rules (XXX ref XXX). This is primarily in order to achieve seamless mapping MNML LMNL data into XML-based systems in which names are constrained.

This rule is relaxed slightly for the name "tag ID" component, which by itself may start with any name character (`\c`), not only an XML name-start character (`\i`).

So a name with no ID component matches `\i\c*` while a name and ID component together match `(\i\c*)=(\c+)`. A tag may not have an empty string as an ID component.

#### Range (type) name or Generic Identifier (gi)

A **range name** is given to a range to distinguish it from other ranges. Usually such distinctions are made not among individual ranges, but among range types. For example, a document may have many ranges named "paragraph".

#### Anonymous ranges and annotations

Anonymous ranges and annotations (that have no names assigned) *are* permitted in MNML LMNL, but not considered advisable, as a good use case for them has not emerged (at time of writing).

XXX COMEBACKTO XXX is this a good idea or does the Principle of Least Surprise suggest we exclude them?

#### Range name 'tag ID' component

A range name *may* have an ID component, called its "tag ID", to distinguish a range from others with the same generic identifier. The ID component is given as a suffix to the name prepended with an equal sign '='. This is ordinarily done only to disambiguate tagging in cases of *arbitrary overlap*, as ID components are not intended for any other useful purpose. Such an identifier *MAY* be preserved internally so it can be used again when a document is serialized (written out) again, after processing, for the convenience of users; but applications are also free to rewrite them or add them if necessary or useful. When a truly persistent identifier is needed (in contrast) one can be provided as an annotation: do not use the tag ID for this purpose.

If a tag ID appears on a start or end tag indicates it is to be matched *only* with the corresponding (end or start) tag with the same combination of range (type) name (GI) and tag ID.

XXX TODO EXAMPLE XXX

Note that the ID component of a name is typically *not* used as an internal identifier and should not be overloaded for this purpose, but simply used as a name part. (Think of it as the first name given to disambiguate a surname among siblings.)

Annotation names are not distinguished with ID components: the character `=` is not permitted in annotation names, and results in an error.

For convenience in working with XML names, all names in LMNL syntax (not their ID parts) must follow the XML naming rules -- informally, names much match `\i\c*` in XPath regex syntax.

#### Homonymy and synonymy

Two ranges are **homonymous** if they have the same type name (GI), irrespective of a tag ID. More loosely they are said to have the same **type**. LMNL as conventionally used will reflect XML practice in this, for example naming all paragraphs `p` or `para`(these being ranges in LMNL, not elements).

It must be kept in mind, however, that two ranges have the same type by virtue of being named the same, and nothing else - type assignment is nominal, and types need not be defined intensionally (for example, as sharing defined characteristics or properties) or tested in any way, but are merely accepted as assigned and defined extensionally. A type is what it is (a kind of string, presumably), and two ranges are the same type because their tags (range type names or generic identifiers) say they are.

If two ranges have the same name (irrespective of ID) *and* their annotations are the same with respect to their names, values and their given order, the ranges can be described as **synonymous** - they 'say the same (thing)'. It may be wise to design such that this does not occur, but it is not prohibited as it may in theory reflect features or properties of interest.

XXX [Examples] XXX

#### Avoiding synonymy - range name overloading

Ranges that are both synonymous and congruent can be especially problematic as they appear to be identical in all respects, but their identities are retained in the model (visible to application processing). Without a warrant from application logic, a processor is not free to collapse them or remove one in favor of the other. To avoid the confusion this can cause, annotations can be used (so ranges of the same nominal type are homonymous, but not synonymous). Alternatively range names can be overloaded, as was sometimes done in SGML. So not just `div` but `div1`, `div2` etc. can make suitable range names, with the numeral indicating the nominal "depth" of the range, if interpolating a hierarchy by the relative enclosure. (And a `div0/div1/div2` hierarchy can be rendered as a plain `div/div/div` hierarchy in an application.)

Since the model can "see" enclosure but not hierarchy, this is good to have: the names help clarify both range boundaries and the (nominally or provisionally) "intended" hierarchy in the overloaded names. At the same time, the information as given (in this case, the nesting level) is subject to testing and validation. Rather than a necessary reflection of the design of the document, such tagging -- or so it becomes possible to regard it -- becomes a claim made with respect to it.

Another way to put it is that since the (hierarchical) "model of the text" is not given by the schema or syntax, it becomes a significant and emergent property of the instance or set of instances being described.

#### Colons in names

Colons in names are like any other name character, but applications may appropriate them for use. For example, binding names to namespaces the way XML does can be a useful way of differentiating between range families (layers) explicitly in the tagging. But this is true of any permitted character: such application semantics are not part of MNML LMNL as such and are not expected to be portable across implementations (work the same), without prior coordination. In general, MNML LMNL processors are not expected to do anything special with colons or names containing colons.

In brief: there is nothing special about colons in names in MNML LMNL, but there might be in LMNL applications.

### Document frontier ('base layer')

A "base layer" is available to any LMNL document irrespective of other ranges indicated by markup, consisting of the document text value itself. This is also called the "frontier". It does not appear as a range in the model, but inasmuch as layers (selections of ranges) can be built on other layers, all layers in the model are considered to reference the base layer.

When documents start with a start tag, and end with the end tag corresponding to the start tag, they have at least one range congruent with (whose value is the same as and which starts and ends in the same place) the base layer.

Note that whitespace after the last end tag of a document is sufficient to make the frontier (the document base layer) different from the value of the range that was closed with that tag.

In LMNL, each annotation has its own frontier (base layer), namely its text content, but since MNLM LMNL annotations constitute name/value pairs (with no structure or markup), their frontiers are effectively the same as their values.

### Ranges, annotations and values


* ranges have identity and are distinguishable from other ranges by:
* the specific frontier (UTF string value) they are bound to
* relation to frontier (offset and extent)
* their names, annotations and provenance
* because they are distinguishable does not mean they are not 'the same' if an application says they are
* in rare cases they are not distinguishable
* up to an application to determine whether they are 'the same'

In MNML LMNL, "values" are always strings. Applications may cast strings into typed data or object structures to support features, but this is not part of MNML LMNL. No special provision is made for numeric data types, Booleans, dates and durations or any complex data at the syntax level, while applications (including validators) are free to constrain these strings appropriately.

The values of all ranges in LMNL are determined in reference to their *base layer* (the document frontier), which does not change even if ranges are reallocated from one layer to another. (In the Laminator, ranges can be in only one layer at a time.)

This having been said, the value of a range corresponds to the value of the text appearing before its start and end tags, excluding any other tagging.

The value of an annotation corresponds with the value of the text appearing before the end-annotation delimiter `{]`.

Note that two ranges that are not congruent can have *equal* values (their texts can be the same) without the values being the same, as such, as they can be distinguished by the different segments they occupy in the frontier.

#### Range values and the xMNML model

In the LAYERS model, the frontier (base layer) is exposed in its simple form, but in the xMNML LMNL model, it is split across nominal **text value** elements, which are keyed to the ranges the enclose (cover) them by virtue of linking to their start tag markers.

This makes the xMNML model a virtual "database" to the MNML LMNL document. Given a range, finding all the text that belongs only to that range is straightforward; as those text values are represented in the model separately, each with links to its own ranges, finding all the ranges covering or overlapping with the given range can be done without looking at the entire text, or all ranges.

#### Terminology of range relations

One range can *enclose* another range if it starts before or with it and ends after or with it. An enclosed range, however, is *not* said to be "contained" by its enclosing range, inasmuch as there is no generally *necessary* hierarchy among arbitrary ranges, whose semantics may be entirely disjunct, in the general case. Are pages inside the chapter, or is the chapter inside the pages?

Two ranges that do not overlap are considered to be *discrete*.

A range *precedes* another range if it ends before, or with, the other's start, and *follows* another range if it starts after, or with, the other's end.

Two ranges are coterminous if any of their start or end positions occur together. A range that ends where another range starts is coterminous with it, but discrete, which makes the ranges continuous and adjoining, while their values (substrings of the base layer) are *contiguous* -- or it may start where another starts - they are coterminous, and one encloses the other.

Note that these rules mean that the binding of tags to ranges happens *irrespective of tag ordering* at any given position of text. The start tags for two ranges that start together can come in either order: to a MNML LMNL processor, they start in the same position and are co-terminous in either case.

A MNML LMNL processor *MAY* optionally trace tag ordering internally, for use when possible or useful in offering either warnings (if tag re-ordering is considered noteworthy) or options to preserve tag ordering where possible. (The Laminator processing library does *not* currently do this [20260914], although it does preserve tag line numbers and offsets of tags in a LMNL syntax source document, which could be used similarly.)

Annotations are not considered to be contiguous with other annotations even when they are not separated with whitespace in the syntax. They *are* considered to be ordered with respect to their parent or home range, but MNML LMNL does not require retaining whitespace as given in a source syntax instance, when processing or serializing.

Two ranges that start *and* end in the same place are considered *congruent*. Every range in a set of congruent ranges encloses each of the other ranges in the set, as enclosure is *mutual* among congruent ranges, as are overlap and discreteness among ranges that are overlapping or discrete. Note that an enclosing or enclosed range is *not* said to overlap the range that encloses it or is enclosed by it, even though the ranges are coterminous, but not discrete.

Any given pair of ranges in the same layer will be


* congruent,
* *or* enclosing/enclosed,
* *or* overlapping,
* *or* discrete

Ranges allocated to separate layers in a LMNL document do not have these relations, although layers can always be merged, in which case they do.

[XXX] examples TODO [XXX]

This distinction corresponds to whether there is complete, or partial, or no concurrence in the values of the ranges considered as substrings of the document's value, or (equivalently) references to its base layer -- that is, not only by their text sequence but also their placement within the document. Simply, the values of two congruent ranges are the same; the value of an enclosed range can be found as a substring in an enclosing range's value; two overlapping ranges will have some value (a substring of each) in common (within the base layer); and two discrete ranges will not claim any substrings in common from the base layer -- even if their values are the same, regarded as strings.

XXX [EXAMPLE] XXX

Congruent ranges with the same type name are "colliding" or "in collision". (As in "Worlds", referencing the book by Velikovsky.) Even when ranges collide, processors must respect range identity and persistence in naming, values and annotations.

XXX [EXAMPLE] XXX

#### Arbitrary overlap ('self-overlap')

*Arbitrary overlap* describes when two ranges with the same type name overlap one another. In the literature on overlapping structures in markup, this condition is called "self-overlap"; a better name (thinks a developer) might be "sibling rivalry". An example of this is when ranges are marked for indexing, with no special distinctions made among the ranges so marked that would motivate distinctive type names. The most convenient way to do this is simply to mark the terms and let indexing software do the rest.

Arbitrary overlap raises a question for the parser as to whether two ranges named the same are overlapping, or enclosing/enclosed. Tag IDs (range name component IDs) are provided in the syntax to provide for disambiguating the two possible cases (extrapolating to all possible cases).

XXX [EXAMPLE] XXX

## Layers

Because ranges can be congruent - more than one range can span across the same value in the base layer - there is no limit to how many ranges can be identified for on a document. Additionally, ranges can be, in general, defined implicitly instead of explicit, i.e., determined (defined or observed) by the application of rules or their descriptions using standoff markup. Until a model is instantiated internally, that is, not all ranges must be defined by enumeration (for example, in markup).

This openness makes the primary work of a MNML LMNL processor the management and marshalling of ranges, by family and by type, arbitrarily according to applicaition logic. The **layers** feature of the MNML LMNL model is proposed to help make such processing tractable, so that it can be specified, planned and implemented.

At present, there is no normative way and no single recommended way to specify that ranges belong to layers, in the syntax. To the extent that this is a requirement (it usually is not), a naming convention can be applied to tags. For example, in a simple case, upper-case tag names could identify ranges for one layer, while lower-case names identify ranges for another.) Application logic can then be used to separate ranges out into layers.

This makes it easier to optimize processing internally for operations such as casting from LMNL into XML, where distinguishing ranges layers can be convenient.

### Layers and hierarchies

A layer is an arbitrary set of ranges enumerated explicitly. A layer may be created either by parsing markup and allocating ranges into layers according to application logic, or dynamically inside a processor.

Overlapping ranges *MAY* be assigned to the same layer; in the case of arbitrary overlap, this may be normal. At the same time, when ranges assigned to layers align so as to make hierarchies, this is detectable, as noted below.

By default, the Laminator parses a MNML instance into a version in which all ranges are collected together in a single layer, including overlapping ranges. Ranges always reference the base layer (string contents) of the document, no matter what layer(s) they are assigned to.

Layers are an optional feature of LMNL in the sense that whatever a processor does internally, designers are always free to use the simplest possible arrangement - a single layer of ranges sitting over a single base layer.

Being able to discriminate between sets of ranges, by allocating them into separate layers, is also a useful thing to be able to do. A single LMNL instance may have an indefinite number of layers; these are not even always evident in the syntax, but may be implicit or introduced dynamically or interactively. The layers in a LMNL document are not intrinsic to it. Instead, they need to be considered as useful to applications in both *maintaining* and *interfacing* with families of ranges, whose categories (and indeed, whose entire 'life cycle') will depend on the applications in view.

Internally, Laminator maintains a LAYERS model for handling and working with layers.

#### Layers and Ordered Hierarchies of Content Objects (OHCO)

To be *well nested* is a property of a set of ranges and accordingly of a layer. It means that no ranges in the layer overlap any others in the same layer. Such a set of ranges can be straightforwardly cast into a hierarchical structure with no adjustment of range boundaries or splitting, reallocation or hiding of ranges or range markers. It is said to be an "OHCO" layer, in reference to the "OHCO" model of Renear, Mylonas and Durand (1993).

#### Multiple Concurrent Hierarchies (MCH)

An "MCH" layer is a set of ranges that does not qualify as an OHCO - some ranges within the set are found to overlap others. However, of the cases of overlap, none of the ranges overlap any others *with the same name* - i.e., *homonymous*. For example, a set of div ranges may overlap a set of page ranges, but none of the page ranges overlap pages, and none of the divs overlap divs. This is called "MCH" because the structure represents *multiple concurrent hierarchies*.

Where ranges show arbitrary overlap - where there are ranges that overlap other ranges with the same name (and therefore presumed to represent the same type) - we have neither OHCO nor MCH.

These categories make casting into hierarchies much easier, since they can be detected early and acted on whenever appropriate. As secondary properties they are also subject to testing and updating -- since applications are liable to make changes that invalidate them, they must be kept in order internally.

## Validation

LMNL semantics, like all semantics, are made in part by making a *selection* from available alternatives, which selection is not foreordained or predetermined, but which are constrained by those alternatives in ways that can make such selection meaningful. Those alternatives are stipulated by the applicable set of rules.

For example, the MNML tagging rules stipulate that a document that fails to parse using the grammar, is out of bounds: its ranges are not rendered and cannot be checked.

Once syntax rules are followed, however, ranges can be rendered, and become visible to processors, making them subject to new sets of constraints at higher levels.

XML provides a model of this architecture, and MNML LMNL is analogous, allowing for differences such as the lack of a formal schema language that accounts for overlap.

The fact that such a schema language is yet to come (at time of writing) does not mean that we cannot validate MCH - we only need to define it in terms we can test. The Laminator LAYERS model provides a way to do this, as might (similarly) any implementation of LMNL layers, where distinctions between sets of ranges can be made.

We can broadly distinguish between two layers:

Syntax checking is analogous to XML well-formedness checking, providing assurances for processability but not much more. This constitutes MNML LMNL Syntax Conformance.

Checks on vocabulary, annotations, annotation usage, structure, overlap or lack thereof, hierarchy, MCH, and arbitrary (expression-based) assertions can and should be done by applications.

## Application scenarios

The Laminator offers an implementation platform both for processing documents rendered as range models, and also for maintaining such documents in the form of markup. Both parsing and serialization -- reading and writing sawtooth syntax -- are supported, for any MNML LMNL.

However, parsing is not the only way to create LMNL documents and serialization is not the only way they can be exposed for further work. They can be created by any programmatic means, and outputs can include LMNL tagging, XML markup or anything else (especially any other text-based format).

The Laminator uses XProc to organize and orchestrate this open-ended set of processes. One important feature XProc offers for this is in its composability: the Laminator offers pipelines that can be combined as utilities in other pipelines. Specialized processing for particular tagging (application) profiles can be layered on top of the general capabilities given by the library.

Interestingly, this can be done in several different ways, using approaches with different strengths and weaknesses, making solutions to certain kinds of document (range) manipulation problems more or less tractable. Knowing the full range of these approaches is the best way of avoiding the unnecessary complexity that results from an operation done "the hard way" when an easy way is available.

It is not likely that a LMNL-based operation or Laminator pipeline will be ever be as good as generic XML and XSLT for structural transformations, as the model is not built for those.

At the same time, for some operations especially those relating to the management of overlapping ranges, and the structures in which they are found, MNML LMNL is highly convenient, and it is difficult to describe or limit the kinds of markup applications that might benefit from its capabilities:


* Extraction of plain text cross-sections based on arbitrary criteria (markup or inferencing)
* Traceable production of XML from 'sloppy' sources
* Any kind of range-based processing
* Modeling more complex and higher-order data structures
* Discontinuity, range identity

### Methods and methodologies

One of the most interesting features of the pipeline architecture is its openness to various complementary approaches to text and document processing, which have different strengths. The Laminator not only parses and writes LMNL and XML syntax, it also orchestrates XSLT (and XQuery), and it supports processing "raw text", that is, LMNL -- or XML -- tags-as-text. These approaches to document or range modification can be used together as well as separately.

LMNL has a broad range of potential applications that can be usefully distinguished, by scale and complexity; by the nature and form of the source data (whether sourced in XML, marked up automatically or by hand or ported in some other way); and by the required results. The differences between the methods may not be in their capabilities as much as in how easy they are to develop, apply and reuse when needed.

Indeed, the approaches listed here are only those prompted by experience with XProc-based pipelines. An XQuery-based, or a non-XML MNML LMNL engine, might offer others as well.

#### METHOD: SYNTAX WRANGLING with MNML LMNL syntax - sawteeth

MNML LMNL syntax has an iXML grammar, but parsing with a grammar is not the only conceivable way to work with this syntax and produce viable LMNL outputs. A MNML LMNL file is also a string and can be worked on using string processing.

Care must be taken to ensure syntax is still correct after such modifications -- no differently from modifying an XML file by hand, or as a string, an early parse after such a modification provides assurances that the information (however modified) remains intact and legible. Because LMNL constrains the order of annotations appearing on a range, it is even a little more amenable than XML to this approach.

#### METHOD: manipulating xMNML (tagged text model)

xMNML can be produced by parsing MNML syntax, or by conversion from XML with a deterministic mapping (treating XML as a notation representing a range model), or by other means, including programmatic ones.

An xMNML instance can also be serialized again using LMNL syntax, or it can be cast to XML using either of two methods, *ripping* and *building*. Ripping is quick-and-dirty but often effective. Building is more fault tolerant and more generalized.

Any document that can be "built" into XML can also be "ripped" into XML by subjecting it to certain modifications first, to resolve overlaps handled implicitly in "building". These modifications, or indeed any modifications, can be effected by changing the xMNML document within the XProc pipeline that handles reading and writing it.

Some operations over LMNL ranges and their values are easily accomplished using the xMNML model as a 'range retrieval' database.

Refreshing xMNML - rules for rewriting IDs and text to an updated range set - this can be done by casting to LAYERS and back.

Use case: text segmenting by exporting selected ranges

#### METHOD: manipulating LAYERS (range model)

Merging and filtering ranges and range families are even easier to do over LAYERS than over xMNML.

It also presents the document's value (base layer) as a single string, making it useful for analysis of the data with no markup in play. For example, a LAYERS instance can be input to a process that interpolates and introduces new ranges reflecting analysis of the text in a new LAYERS document that can then be written to LMNL or XML.

Because the LAYERS model also permits storing, internally, structures that are not transparently expressible using the syntax -- such as sets of ranges that happen to form clean hierarchies (OHCO or MCH) -- they can also be useful for operations that can take advantage of these structures.

A generic XSLT can convert any LAYERS instance into the corresponding xMNML instance. Another one can create LAYERS from any xMNML. LAYERS instances can also be created directly from XML using a utility for that purpose.

#### METHOD: SYNTAX WRANGLING WITH XML - 'slurping' and 'ripping'

To 'slurp' MNML is to create xMNML or LAYERS (the internal formats used by the Laminator) directly from XML, without writing LMNL syntax first. Simple XSLTs can do this and it saves steps and cycles.

To 'rip' XML is to write xMNML tag sequence out in XML format. Every start range marker becomes an XML start tag, while end range markers become end tags etc. As long as annotation names are distinct on their ranges (since name collisions among sibling attributes is illegal in XML), and as long as tags *happen to nest* -- what we get from ripping is a text file that *happens to be XML*.

Necessary provisions can be carried out up front to suppress or rewrite where overlap prevents a clean mapping into XML. Such provisions can include introducing new (discontinous) 'wrapper' ranges to substite in for ranges that overlap, or marking their starts and ends with empties, which the ripper casts into XML empty elements for marking using a 'milestone' convention.

## Policy on AIs and code generation

No generative AIs have been used for specifications, code, tests, examples or documentation in this project.

Exceptions to the "no AI assistance" rule may sometimes be relaxed (git commit messages); and code *MAY* be automatically generated and executed within the repository or applications (for example, for validation or under CI/CD), only not with LLMs or other non-deterministic means, either as authors of code or "agents in the loop".

## Questions and open issues

### Scaling (document size) and caching

Parsing and tag-matching operations should scale O(n) i.e. linear to the size of inputs - do they?


* Length of frontier
* 'Density' of ranges - how many ranges per character?
* 'Weight' of ranges - how heavily annotated?
* Depth of nesting (enclosure) in tag matching
* Where are the current bottlenecks? (including starting JVM)

### Metadata conventions and failsafes

LMNL makes no special provision for document metadata as a constituent element of LMNL instances.

In part this is because (unlike XML) LMNL is not used strictly for structured data, but for loosely-structured or unstructured data; so it is less amenable than XML to including tagged structures in document contents within the document as such.

It is very convenient, that is, to "keep the metadata out of the frontier", and in LMNL, that means keeping metadata in annotations, the natural place for it.

Such annotations can include information regarding titles/creators/encoders/dates, identifiers and hashes of data contents, for robustness.

Unfortunately, MNML LMNL limits annotations to name-value pairs so they cannot be provided with further structure except implicitly (not in the LMNL model).

Accordingly, two approaches are recommended:


* Include links to structured metadata
* Accompany all LMNL with `readme` documents in their repositories, in a containing folder

Suggestion: use TEI Headers for your Digital Humanities project metadata.
