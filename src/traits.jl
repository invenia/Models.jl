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
    InjectTrait

The `InjectTrait` specifies if the model supports point or distribution injections to predict,
denoted by [`PointInject`](@ref) or [`DistributionInject`](@ref), respectively.
"""
abstract type InjectTrait end

"""
    PointInject <: InjectTrait

Specifies that the [`Model`](@ref) accepts real-valued input variables to `predict`.
"""
abstract type PointInject <: InjectTrait end

"""
    DistributionInject <: InjectTrait

Specifies that the [`Model`](@ref) accepts a distribution over the input variables to `predict`.
"""
abstract type DistributionInject <: InjectTrait end

"""
    PointOrDistributionInject <: InjectTrait

Specifies that the [`Model`](@ref) accepts real-values or a distribution over the input 
variables to `predict`.
"""
abstract type PointOrDistributionInject <: InjectTrait end

"""
    inject_type(::T) where T = inject_type(T)

Return the [`InjectTrait`] of the [`Model`](@ref) or [`Template`](@ref).
"""
inject_type(::T) where T = inject_type(T)
inject_type(T::Type) = throw(MethodError(inject_type, (T,)))  # to prevent recursion

inject_type(::Type{<:Model}) = PointInject
inject_type(::Type{<:Template}) = PointInject
