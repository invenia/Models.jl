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
- [`output_type`](@ref): SingleOutput or MultiOutput
- [`estimate_type`](@ref): PointEstimate or DistributionEstimate
"""
abstract type Template end

"""
   Model

A Model is a trained [`Template`](@ref) with which one can [`predict`](@ref) on inputs.
Defined as well are the traits:
- [`output_type`](@ref): SingleOutput or MultiOutput
- [`estimate_type`](@ref): PointEstimate or DistributionEstimate
"""
abstract type Model end

"""
   fit(::Template, output, input) -> Model

Fit the `Template` to the `output` and `input` data and return a trained `Model`.
"""
function fit end

"""
    predict(::Model, input)

Predict targets for the provided `input` and `Model`.

Returns a predictive distribution or point estimates depending on the `Model`.
"""
function predict end

include("traits.jl")
include("test_utils.jl")

end # module
