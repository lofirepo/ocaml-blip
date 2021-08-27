[![Build Status](https://travis-ci.org/p2pcollab/ocaml-blip.svg?branch=master)](https://travis-ci.org/p2pcollab/ocaml-blip)

# BLIP

BLIP is an OCaml implementation of the BLoom-then-flIP algorithm as described in the paper [BLIP: Non-interactive Differentially-Private Similarity Computation on Bloom filters](https://scholar.google.com/scholar?cluster=16665581281970888&hl=en)

BLIP is distributed under the AGPL-3.0-only license.

## Installation

``blip`` can be installed via `opam`:

    opam install blip

## Building with Nix

Set up Nix Flakes, then run:

    nix build

## Developing with Nix

To get a development shell with all dependencies and build tools installed, run:

    nix develop

## Building

To build from source, generate documentation, and run tests, use `dune`:

    dune build
    dune build @doc
    dune runtest -f -j1 --no-buffer

In addition, the following `Makefile` targets are available
 as a shorthand for the above:

    make all
    make build
    make doc
    make test

## Documentation

The documentation and API reference is generated from the source interfaces.
It can be consulted [online][doc] or via `odig`:

    odig doc blip

[doc]: https://p2pcollab.net/doc/ocaml/blip/
