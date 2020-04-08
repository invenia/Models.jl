module Models

import StatsBase: fit, predict

export Model, Template
export fit, predict, submodels, estimate_type, output_type
export EstimateTrait, PointEstimate, DistributionEstimate
export OutputTrait, SingleOutput, MultiOutput

"""
   Template

A Template is an untrained [`Model`](@ref) that can be [`fit`](@ref) to data.
Defined as well are the traits:
- [`output_type`](@ref): [`SingleOutput`](@ref) or [`MultiOutput`](@ref).
- [`estimate_type`](@ref): [`PointEstimate`](@ref) or [`DistributionEstimate`](@ref).
"""
abstract type Template end

"""
   Model

A Model is a trained [`Template`](@ref) with which one can [`predict`](@ref) on inputs.
Defined as well are the traits:
- [`output_type`](@ref): [`SingleOutput`](@ref) or [`MultiOutput`](@ref).
- [`estimate_type`](@ref): [`PointEstimate`](@ref) or [`DistributionEstimate`](@ref).
"""
abstract type Model end

"""
   fit(::Template, output, input, [weights]) -> Model

Fit the [`Template`](@ref) to the `output` and `input` data and return a trained
[`Model`](@ref).
Convention is that `weights` defaults to `uweights(Float32, size(outputs, 2))``
"""
function fit end

"""
    predict(::Model, input)

Predict targets for the provided `input` and [`Model`](@ref).

Returns a predictive distribution or point estimates depending on the [`Model`](@ref).
"""
function predict end

"""
    submodels(model|template)

Returns all submodels within a multistage model/template.
Submodels are models within a model that have their own inputs (which may or may not be
combined whith outputs of earlier models, before actually inputting them).
Such multistage models take a tuple of inputs (which may be nested if the submodel itself
has submodels).
The order of inner models return by `submodels` is as per the order of the inputs in the
tuple.

For single-stage models, (i.e. ones that simply take a matrix as input), this returns a
empty tuple.
Wrapper models which do not expose their inner models to seperate inputs, including ones
that only wrap a single model, should **not** define `submodels` as they are
(from the outside API perspective) single-stage models.
"""
submodels(::Union{Template, Model}) = ()


include("traits.jl")
include("test_utils.jl")

end # module
