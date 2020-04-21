# Design

This page details the key features of the design of [Models.jl](https://github.com/invenia/Models.jl), which exists to solve the issue highlighted by the following quote:

> ML researchers tend to develop general purpose solutions as self-contained packages.
> A wide variety of these are available as open-source packages ...
> Using generic packages often results in a glue-code system design pattern, in which a massive amount of supporting code is written to get data into and out of general-purpose packages.
> Glue-code is costly in the long term because it tends to freeze a system to the peculiarities of a specific package; testing alternatives may become prohibitively expensive....
> **An important strategy for combating glue-code is to wrap black-box packages into common API’s.**
> This allows supporting infrastructure to be more reusable and reduces the cost of changing packages.

-- [Sculley et al 2015](https://papers.nips.cc/paper/5656-hidden-technical-debt-in-machine-learning-systems)

[Models.jl](https://github.com/invenia/Models.jl) provides a common API for mostly preexisting models to allow them to all be used in the same way.
As such, the most important thing is that it itself has a common API.
Here are some facts about that API:

## Models and Templates

A [`Model`](@ref) is an object that can be used to make predictions via calling [`predict`](@ref).
A [`Template`](@ref) is an object that can create a [`Model`](@ref) by being [`fit`](@ref) to some data.

All information about how to perform [`fit`](@ref), such as hyper-parameters, is stored inside the [`Template`](@ref).
This is different from some other APIs which might, for example, pass hyper-parameters as keyword arguments to [`fit`](@ref).
The [`Template`](@ref) based API is superior to these as it means [`fit`](@ref) is always the same.
One does not have to carry both a [`Model`](@ref) type, and a varying collection of keyword arguments, which would get complicated when composing wrapper models.


## Calling `fit` and `predict`

```julia
model = Models.fit(
    template,
    outputs::AbstractMatrix,  # always Features x Observations
    inputs::AbstractMatrix,   # always Variates x Observations
    weights=uweights(Float32, size(outputs, 2))
)::Model
```

```julia
outputs = Models.predict(
    model,
    inputs::AbstractMatrix  # always Features x Observations
)::AbstractMatrix  # always Variates x Observations
```

[`fit`](@ref) takes in a [`Template`](@ref) and some *data* and returns a [`Model`](@ref) that has been fit to the data.
[`predict`](@ref) takes a [`Model`](@ref)  (that has been [`fit`](@ref) from a [`Template`](@ref)) and produces a predicted output.

Important facts about [`fit`](@ref) and [`predict`](@ref):
 - `outputs` and `inputs` always have observations as the second dimension -- even if it is  [`SingleOutput`](@ref) (that just means that it will be a `1 x num_obs` output. (See [Docs on Julia being column-major](https://docs.julialang.org/en/v1/manual/performance-tips/#Access-arrays-in-memory-order,-along-columns-1))
 - The functions must accept any `AbstractMatrix` for the `inputs` and `outputs` ([`fit`](@ref) only). If the underlying implementation needs a plain dense `Matrix` then [`fit`](@ref)/[`predict`](@ref) should perform the conversion.
 - [`fit`](@ref) always accepts a `weights` argument. If the underlying [`Model`](@ref) does not support weighted fitting, then [`fit`](@ref) should throw and error if the weights that passed in and are not all equal.
 - [`fit`](@ref)/[`predict`](@ref) take no keyword arguments, or any other arguments except the ones shown.

## Traits

This package largely avoids using complicated abstract types, or relying on a [`Model`](@ref) having a particular abstract type.
Instead we use [traits](https://invenia.github.io/blog/2019/11/06/julialang-features-part-2/) to determine [`Model`](@ref) behavior.

Here are the current [`Model`](@ref) traits in use and their possible values:
 - [`estimate_type`](@ref) -  determines what kinds of estimates the [`Model`](@ref) outputs.
   - [`PointEstimate`](@ref): Predicts point-estimates of the most likely values.
   - [`DistributionEstimate`](@ref): Estimates distributions over possible values.
 - [`output_type`](@ref) - determines how many output variates a [`Model`](@ref) can learn
   - [`SingleOutput`](@ref): Fits and predicts on a single output only.
   - [`MultiOutput`](@ref): Fits and predicts on multiple outputs at a time.

The traits always agree between the [`Model`](@ref) and the [`Template`](@ref).
Every [`Model`](@ref) and [`Template`](@ref) should define all the listed traits.

This package uses traits implemented such that the trait function returns an `abstract type` (rather than an instance).
That means to check a trait one uses:
```julia
if estimate_type(model) isa DistributionEstimate
```
and to dispatch on a trait one uses:
```
foo(::Type{<:DistributionEstimate}, ...)
```
