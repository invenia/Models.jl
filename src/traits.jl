# Estimate Type Trait - specifies if the model outputs a point or distribution estimate
"""
    EstimateTrait

The `EstimateTrait` specifies if the model outputs a point or distribution estimate, denoted
by [`PointEstimate`](@ref) or [`DistributionEstimate`](@ref), respectively.
"""
abstract type EstimateTrait end

"""
    PointEstimate <: EstimateTrait

Specifies that the [`Model`](@ref) returns real-valued response variables.
"""
abstract type PointEstimate <: EstimateTrait end

"""
    DistributionEstimate <: EstimateTrait

Specifies that the [`Model`](@ref) returns a distribution over the response variables.
"""
abstract type DistributionEstimate <: EstimateTrait end

"""
    estimate_type(::T) where T = output_type(T)

Return the [`EstimateTrait`] of the [`Model`](@ref) or [`Template`](@ref).
"""
estimate_type(::T) where T = estimate_type(T)
estimate_type(T::Type) = throw(MethodError(estimate_type, (T,)))  # to prevent recursion

"""
    OutputTrait

The `OutputTrait` specifies if the model supports single or multiple response variables,
denoted by [`SingleOutput`](@ref) or [`MultiOutput`](@ref), respectively.
"""
abstract type OutputTrait end

"""
    SingleOutput <: OutputTrait

Specifies that the [`Model`](@ref) returns a single, univariate response variable.
"""
abstract type SingleOutput <: OutputTrait end

"""
    MultiOutput <: OutputTrait

Specifies that the [`Model`](@ref) returns a multivariate response variable.
"""
abstract type MultiOutput <: OutputTrait end

"""
    output_type(::T) where T = output_type(T)

Return the [`OutputTrait`] of the [`Model`](@ref) or [`Template`](@ref).
"""
output_type(::T) where T = output_type(T)
output_type(T::Type) = throw(MethodError(output_type, (T,)))  # to prevent recursion

"""
    PredictInputTrait

The `PredictInputTrait` specifies if the model supports point or distribution inputs to `predict`,
denoted by [`PointPredictInput`](@ref) or [`PointOrDistributionPredictInput`](@ref).
"""
abstract type PredictInputTrait end

"""
    PointPredictInput <: PredictInputTrait

Specifies that the [`Model`](@ref) accepts real-valued input variables to `predict`.
"""
abstract type PointPredictInput <: PredictInputTrait end

"""
    PointOrDistributionPredictInput <: PredictInputTrait

Specifies that the [`Model`](@ref) accepts real-values or a joint distribution over the input 
variables to `predict`.
"""
abstract type PointOrDistributionPredictInput <: PredictInputTrait end

"""
    predict_input_type(::T) where T = predict_input_type(T)

Return the [`PredictInputTrait`] of the [`Model`](@ref) or [`Template`](@ref).
"""
predict_input_type(::T) where T = predict_input_type(T)
predict_input_type(T::Type) = throw(MethodError(predict_input, (T,)))  # to prevent recursion

predict_input_type(::Type{<:Model}) = PointPredictInput
predict_input_type(::Type{<:Template}) = PointPredictInput
