module Models

import StatsBase: fit, predict

export Model, Template
export fit, predict, estimate_type, output_type
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
   fit(::Template, output, input) -> Model

Fit the [`Template`](@ref) to the `output` and `input` data and return a trained
[`Model`](@ref).
"""
function fit end

"""
    predict(::Model, input)

Predict targets for the provided `input` and [`Model`](@ref).

Returns a predictive distribution or point estimates depending on the [`Model`](@ref).
"""
function predict end

include("traits.jl")
include("test_utils.jl")

end # module
