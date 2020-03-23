# Models

## Why does this package exist?

[Models.jl](https://github.com/invenia/Models.jl) defines the `Template` and `Model` types as well as a common API for constructing a generic model in downstream packages, including:

* Calling `fit` on a `Template`.
* Calling `predict` on a `Model`.
* Assigning traits such as `EstimateTrait` and `OutputTrait`.
* Testing interfaces and downstream dependencies with `TestUtils`.

## Contents
```@contents
Pages = ["api.md", "testutils.md"]
```
