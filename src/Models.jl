module Models

import StatsBase: fit, predict

export Model, Template
export fit, predict, submodels, estimate_type, output_type, predict_input_type
export EstimateTrait, PointEstimate, DistributionEstimate
export OutputTrait, SingleOutput, MultiOutput
export PredictInputTrait, 
   PointPredictInput, 
   DistributionPredictInput, 
   PointOrDistributionPredictInput

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
   fit(::Template, output::AbstractMatrix, input::AbstractMatrix, [weights]) -> Model

Fit the [`Template`](@ref) to the `output` and `input` data and return a trained
[`Model`](@ref).
Convention is that `weights` defaults to `StatsBase.uweights(Float32, size(outputs, 2))`
"""
function fit end

"""
    predict(model::Model, inputs::AbstractMatrix)
    predict(model::Model, inputs::AbstractVector{<:AbstractVector})

Predict targets for the provided the collection of `inputs` and [`Model`](@ref).

A [`Model`](@ref) subtype for which the `predict_input_type(model)` is 
[`PointPredictInput`](@ref) will only need to implement a `predict` function that operates 
on an `AbstractMatrix` of inputs.  

If the `estimate_type(model)` is [`PointEstimate`](@ref) then this function should return
another `AbstractMatrix` in which each column contains the prediction for a single input.

If the `estimate_type(model)` is [`DistributionEstimate`](@ref) then this function should
return a `AbstractVector{<:Distribution}`.
"""
function predict end

function predict(model::Model, inputs::AbstractVector{<:AbstractVector})
   return predict(model, reduce(hcat, inputs))
end

"""
    submodels(::Union{Template, Model})

Return all submodels within a multistage model/template.

Submodels are models within a model that have their own inputs (which may or may not be
combined with outputs of _earlier_ submodels, before actually being passed as input to the submodel).
Such multistage models take a tuple of inputs (which may be nested if the submodel itself
has submodels).
The order of submodels returned by `submodels` is as per the order of the inputs in the
tuple.

For single-stage models, (i.e. ones that simply take a matrix as input), this returns an
empty tuple.
Wrapper models which do not expose their inner models to seperate inputs, including ones
that only wrap a single model, should **not** define `submodels` as they are
(from the outside API perspective) single-stage models.
"""
submodels(::Union{Template, Model}) = ()


include("traits.jl")
include("test_utils.jl")

end # module
