# Models

## Why does this package exist?

[Models.jl](https://github.com/invenia/Models.jl) defines the [`Template`](@ref) and [`Model`](@ref) types as well as a common API for constructing a generic model in downstream packages, including:

* Calling [`fit`](@ref) on a [`Template`](@ref).
* Calling [`predict`](@ref) on a [`Model`](@ref).
* Assigning traits such as [`EstimateTrait`](@ref) and [`OutputTrait`](@ref).
* Testing interfaces and downstream dependencies with [`TestUtils`](@ref).

## Contents
```@contents
Pages = ["design.md", "api.md", "testutils.md"]
```
