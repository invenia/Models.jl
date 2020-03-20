## Design Documentation

This page details the key features of the design of BaselineModels.

BaselineModels exists to solve the issue highlighted by following quote:

> ML researchers tend to develop general purpose solutions as self-contained packages.
> A wide variety of these are available as open-source packages ...
> Using generic packages often results in a glue-code system design pattern, in which a massive amount of supporting code is written to get data into and out of general-purpose packages.
> Glue-code is costly in the long term because it tends to freeze a system to the peculiarities of a specific package; testing alternatives may become prohibitively expensive....
> **An important strategy for combating glue-code is to wrap black-box packages into common API’s.**
> This allows supporting infrastructure to be more reusable and reduces the cost of changing packages.

-- [Sculley et al 2015](https://papers.nips.cc/paper/5656-hidden-technical-debt-in-machine-learning-systems)

BaselineModels provides a common API for mostly preexisting models to allow them to all be used in the same way.
As such, the most important thing is that it itself has a common API.
Here are some facts about that API:

### Models and Templates

A **model** is an object that can be used to make predictions via calling `predict`.
A **template** is an object that can create a *model* by being `fit` to some data.

All information about how to perform `fit`, such as hyper-parameters, is stored inside the *template*.
This is different from some other APIs which might for example pass those as keyword arguments to `fit`.
The template based API is superior to these as it means `fit` is always the same.
One does not have to carry both a model type, and a varying collection of keyword arguments, which would get complicated when composing wrapper models.


### `fit` and `predict`

```julia
model = StatsBase.fit(
    template,
    outputs::AbstractMatrix,  # always Features x Observations
    inputs::AbstractMatrix,   # always Variates x Observations
    weights=uweights(Float32, size(outputs, 2))
)::Model
```

```julia
outputs = StatsBase.predict(
    model,
    inputs::AbstractMatrix  # always Features x Observations
)::AbstractMatrix  # always Variates x Observations
```

`fit` takes in a *template* and some *data* and returns a `Model` that has been fit to the data.
`predict` takes a `Model`  (that has been `fit` from a *template*) and produces a predicted output.

Important facts about `fit` and `predict`:
 - `outputs` and `inputs` always have observations as the second dimension -- even if it is  [`SingleOutput`](@ref) (that just means that it will be a `1 x num_obs` output. (See [Docs on Julia being column-major](https://docs.julialang.org/en/v1/manual/performance-tips/#Access-arrays-in-memory-order,-along-columns-1))
 - The functions must accept any `AbstractMatrix` for the `inputs` and `outputs` (`fit` only). If the underlying implementation needs a plain dense `Matrix` then `fit`/`predict` should perform the conversion.
 - `fit` always accepts a `weights` argument. If the underlying model does not support weighted fitting, then `fit` should throw and error if the weights that passed in and are not all equal.
 - `fit`/`predict` take no keyword arguments, or any other arguments except the ones shown.

### Traits

This package largely avoids using complicated abstract types, or relying on a model having a particular abstract type.
Instead we use [traits](https://invenia.github.io/blog/2019/11/06/julialang-features-part-2/) to determine model behavior.

Here are the current model traits in use and their possible values:
 - `estimate_type` -  determines what kinds of estimates the model outputs.
   - `PointEstimate`: Predicts point-estimates of the most likely values.
   - `DistributionEstimate`: Estimates distributions over possible values.
 - `output_type` - determines how many output variates a model can learn
   - `SingleOutput`: Fits and predicts on a single output only.
   - `MultiOutput`: Fits and predicts on multiple outputs at a time.

The traits always agree between the model and the template.
Every model and template should define all the listed traits.

This package uses traits implemented such that the trait function returns an `abstract type` (rather than an instance).
That means to check a trait one uses:
```julia
if estimate_type(model) isa DistributionEstimate
```
and to dispatch on a trait one uses:
```
foo(::Type{<:DistributionEstimate}, ...)
```
