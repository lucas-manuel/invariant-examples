# Invariant Examples

[![Foundry][foundry-badge]][foundry]

[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg

## Overview

This repository functions as an accessible example for Foundry developers to experiment and learn about invariant testing.

This repository is a work in progress, and will be updated continuously.
Issues with suggestions are encouraged!

## Setup

This project was built using [Foundry](https://book.getfoundry.sh/). Refer to installation instructions [here](https://github.com/foundry-rs/foundry#installation).

```sh
git clone git@github.com:lucas-manuel/invariant-example.git
cd invariant-example
forge install
```

## Running Tests

Foundry considers all functions that start with `invariant_` to be invariant tests. To run them, you can use the following commands:

- To run open invariant tests: `make open-invariant`
- To run bounded invariant tests: `make bounded-invariant`
- To run unbounded invariant tests: `make unbounded-invariant`

## Call Summaries

`invariant_call_summary` functions are not invariants, they are used to illustrate how the probability distribution of function calls within a given invariant test works.
