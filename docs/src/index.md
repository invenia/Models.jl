# Models

## Why does this package exist?

[Models.jl](https://gitlab.invenia.ca/invenia/research/Models.jl) defines the [`Template`](@ref) and [`Model`](@ref) types as well as a common API for constructing a generic model in downstream packages, including:

* Calling [`fit`](@ref) on a [`Template`](@ref).
* Calling [`predict`](@ref) on a [`Model`](@ref).
* Assigning traits such as [`EstimateTrait`](@ref) and [`OutputTrait`](@ref).
* Testing interfaces and downstream dependencies with [`TestUtils`](@ref).

For common examples of the interface being implemented see [BaselineModels.jl](https://gitlab.invenia.ca/invenia/research/BaselineModels.jl).

## Contents
```@contents
Pages = ["api.md", "testutils.md"]
```
