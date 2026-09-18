# Laminator Testing

Testing for the Laminator is distributed throughout the libraries and often integrated with code.

But since everything is XProc we can also run it from this subdirectory.

Various tests serviceable for diagnostics and demonstration:

- ../demo/baselines/TEST_LAYERS_ROUNDTRIP.xpl

- ../demo/baselines/TEST_xMNML-BUILD.xpl

- plus other pipelines in ../demo

Also

- ../lib/LAYERS/testing/RUN_LAYERS-ROUNDTRIP.xpl

- ../lib/LAYERS/testing/LAYERS-BUILD.xpl - for diagnostic?

- ../lib/LAYERS/testing/TEST_LAYERS-to-LMNL.xpl

- ../lib/xMNML/in/sawtooth-syntax/TEST_WFCHECK-SAWTEETH

- ../lib/xMNML/in/sawtooth-syntax/DEMO-SAWTEETH.xpl

## XProc file naming conventions

An XProc file name in ALL CAPS is an indication that the XProc is designed to run standalone, with no runtime bindings required. Specifically, it is configured with all inputs and options, and probably produces results in the file system.

A file (base) name ending `_source` indicates that it accepts a binding on an input port named 'source'.

A lower-case name is probable a pipeline designed to be used as a module or component in higher-level runtimes (pipelines), although they are often also configured to run standalone, as self-tests.

## Play-driven Development (PDD)

> Engineering is the art of deciding which decisions do not have to be made.

The current project should be considered engineering only in the sense that it takes the form of software, and building software is much like other kinds of building.

But if small can resemble great, this can resemble engineering also in the sense that it attempts to make something particular and practical, by solving a very general problem.

In most important respects it is more of an open laboratory experiment using unorthodox methods to produce results no one has asked for, which may be only *accidentally* revealing.

As such, there is a large gap between what is offered here, and the kind of specification that could support a second interoperable implementation of the encoding scheme(s) recommended. That being said, while the gap is broad, a functional frame is there, and documents now in place can be refined.

Play-driven development is the lightest-weight possible paradigm for a single developer working alone without supervision or much of a plan. Under PDD, testing is ad hoc and minimalistic, while at the same time every opportunity is taken to save future labor -- and spare mystification -- by maintaining documentation and providing tests.

What distinguishes PDD from behavior-driven or test-driven development is primarily that the first test is considered to be the application itself. While this presents the developer with a chicken/egg conundrum, if this is solved - if an application can be conceived that can serve effectively (at least for practical purposes) as its own test - then this can become the germ of an "actual" application. (In reality, this is not really so easy and creates a higher-order design problem. To deal with this the game is split into several games, which is one reason we have so many layers to our LAYERS, etc.)

The model is the famous easy-bake oven, wherein actual muffins may be baked.

Accordingly, applications and pipelines can generally "test themselves" (be tested in execution), while they may also have test scenarios available (if minimally documented) nearby. Mileage varies, but that is the point.

The idea is that PDD can be complemented by a more rigorous and disciplined approach to testing at such point as *confidence in the generality of LMNL itself* becomes a requirement -- probably because the number of LMNL (or MNML LMNL) implementations is growing. Until then, the Laminator's "proof" can be in the works it is capable of producing.

-----
20260904
