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

Specifies that the [`Model`](@ref) returns a posterior distribution over the response variables.
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
