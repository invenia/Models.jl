"""
    Models.TestUtils

Provides test fakes, [`FakeTemplate`](@ref) and [`FakeModel`](@ref), that are useful for
testing downstream dependencies, and [`test_interface`](@ref) for testing the Models API has
been correctly implemented.
"""
module TestUtils
using Distributions
using Models
using NamedDims
using StatsBase
using Test

export FakeModel, FakeTemplate
export test_interface

"""
    FakeTemplate{E <: EstimateTrait, O <: OutputTrait, I <: InjectTrait} <: Template

This template is a [test double](https://en.wikipedia.org/wiki/Test_double) for testing
purposes. It should be defined (before fitting) with a `predictor`, which can be changed by
mutating the field.

## Fields
- `predictor::Function`: predicts the outputs of the [`FakeModel`](@ref).
   It is `(num_variates, inputs) -> outputs`, where the `num_variates` will be memorized
   during `fit`.

## Methods
- [`fit`](@ref) does not learn anything, it just creates an instance of the corresponding [`Model`](@ref).
- [`predict`](@ref) applies the `predictor` to the inputs.
"""
mutable struct FakeTemplate{E<:EstimateTrait, O<:OutputTrait, I<:InjectTrait} <: Template
    predictor::Function
end

"""
    FakeTemplate{PointEstimate, SingleOutput, PointInject}()

A [`Template`](@ref) whose [`Model`](@ref) will predict 0 for each observation.
"""
function FakeTemplate{PointEstimate, SingleOutput, PointInject}()
    FakeTemplate{PointEstimate, SingleOutput, PointInject}() do num_variates, inputs
        @assert(num_variates == 1, "$num_variates != 1")
        inputs = NamedDimsArray{(:features, :observations)}(inputs)
        return NamedDimsArray{(:variates, :observations)}(
            zeros(1, size(inputs, :observations))
        )
    end
end

"""
    FakeTemplate{PointEstimate, MultiOutput, PointInject}()

A [`Template`](@ref) whose [`Model`](@ref) will predict a vector of 0s for each observation.
The input and output will have the same dimension.
"""
function FakeTemplate{PointEstimate, MultiOutput, PointInject}()
    FakeTemplate{PointEstimate, MultiOutput, PointInject}() do num_variates, inputs
        inputs = NamedDimsArray{(:features, :observations)}(inputs)
        return NamedDimsArray{(:variates, :observations)}(
            zeros(num_variates, size(inputs, :observations))
        )
    end
end

"""
    FakeTemplate{DistributionEstimate, SingleOutput, PointInject}()

A [`Template`](@ref) whose [`Model`](@ref) will predict a univariate normal
distribution (with zero mean and unit standard deviation) for each observation.
"""
function FakeTemplate{DistributionEstimate, SingleOutput, PointInject}()
    FakeTemplate{DistributionEstimate, SingleOutput, PointInject}() do num_variates, inputs
        @assert(num_variates == 1, "$num_variates != 1")
        inputs = NamedDimsArray{(:features, :observations)}(inputs)
        return NoncentralT.(3.0, zeros(size(inputs, :observations)))
    end
end

"""
    FakeTemplate{DistributionEstimate, MultiOutput, PointInject}()

A [`Template`](@ref) whose [`Model`](@ref) will predict a multivariate normal
distribution (with zero-vector mean and identity covariance matrix) for each observation.
"""
function FakeTemplate{DistributionEstimate, MultiOutput, PointInject}()
    FakeTemplate{DistributionEstimate, MultiOutput, PointInject}() do num_variates, inputs
        std_dev = ones(num_variates)
        return [Product(Normal.(0, std_dev)) for _ in 1:size(inputs, 2)]
    end
end

"""
    FakeTemplate{DistributionEstimate, MultiOutput, DistributionInject}()

A [`Template`](@ref) whose [`Model`](@ref) will accept a vector of distributions to predict 
a multivariate normal distribution (with means matching those of the passed distributions
and identity covariance matrix) for each observation.
"""
function FakeTemplate{DistributionEstimate, MultiOutput, DistributionInject}()
    FakeTemplate{DistributionEstimate, MultiOutput, DistributionInject}() do num_variates, inputs
        std_dev = ones(num_variates)
        means = mean.(inputs)
        return [Product(Normal.(m, std_dev)) for m in means]
    end
end

"""
    FakeTemplate{DistributionEstimate, MultiOutput, PointOrDistributionInject}()

A [`Template`](@ref) whose [`Model`](@ref) will accept real-valued or distribution inputs to 
predict a multivariate normal distribution (with means matching those of the passed 
observations and identity covariance matrix) for each observation.
"""
function FakeTemplate{DistributionEstimate, MultiOutput, PointOrDistributionInject}()
    FakeTemplate{DistributionEstimate, MultiOutput, PointOrDistributionInject}() do num_variates, inputs
        std_dev = ones(num_variates)
        means = _handle_inputs(inputs)
        return [Product(Normal.(m, std_dev)) for m in means]
    end
end

_handle_inputs(inputs::AbstractVector{<:Normal}) = mean.(inputs)
_handle_inputs(inputs::AbstractMatrix) = [mean(inputs[m, :]) for m in 1:size(inputs, 2)]

"""
    FakeModel

A fake Model for testing purposes. See [`FakeTemplate`](@ref) for details.
"""
mutable struct FakeModel{E<:EstimateTrait, O<:OutputTrait, I<:InjectTrait} <: Model
    predictor::Function
    num_variates::Int
end

Models.estimate_type(::Type{<:FakeModel{E, O, I}}) where {E, O, I} = E
Models.output_type(::Type{<:FakeModel{E, O, I}}) where {E, O, I} = O
Models.inject_type(::Type{<:FakeModel{E, O, I}}) where {E, O, I} = I

Models.estimate_type(::Type{<:FakeTemplate{E, O, I}}) where {E, O, I} = E
Models.output_type(::Type{<:FakeTemplate{E, O, I}}) where {E, O, I} = O
Models.inject_type(::Type{<:FakeTemplate{E, O, I}}) where {E, O, I} = I

function StatsBase.fit(
    template::FakeTemplate{E, O, I},
    outputs,
    inputs,
    weights=uweights(Float32, size(outputs, 2))
) where {E, O, I}
    outputs = NamedDimsArray{(:variates, :observations)}(outputs)
    num_variates = size(outputs, :variates)
    return FakeModel{E, O, I}(template.predictor, num_variates)
end

StatsBase.predict(m::FakeModel, inputs::AbstractMatrix) = m.predictor(m.num_variates, inputs)
StatsBase.predict(m::FakeModel, inputs::AbstractVector{<:Normal}) = m.predictor(m.num_variates, inputs)

"""
    test_interface(template::Template; inputs=rand(5, 5), outputs=rand(5, 5))

Test that subtypes of [`Template`](@ref) and [`Model`](@ref) implement the expected API.
Can be used as an initial test to verify the API has been correctly implemented.
"""
function test_interface(template::Template; kwargs...)
    @testset "Models API Interface Test: $(nameof(typeof(template)))" begin
        test_interface(
            template, 
            estimate_type(template), 
            output_type(template),
            inject_type(template); 
            kwargs...
        )
    end
end

function test_interface(
    template::Template, ::Type{PointEstimate}, ::Type{SingleOutput}, ::Type{PointInject};
    inputs=rand(5, 5), outputs=rand(1, 5),
)
    predictions = test_common(template, inputs, outputs)
    @test predictions isa NamedDimsArray{(:variates, :observations), <:Real, 2}
    @test size(predictions) == size(outputs)
    @test size(predictions, 1) == 1
end

function test_interface(
    template::Template, ::Type{PointEstimate}, ::Type{MultiOutput}, ::Type{PointInject};
    inputs=rand(5, 5), outputs=rand(2, 5),
)
    predictions = test_common(template, inputs, outputs)
    @test predictions isa NamedDimsArray{(:variates, :observations), <:Real, 2}
    @test size(predictions) == size(outputs)
end

function test_interface(
    template::Template, ::Type{DistributionEstimate}, ::Type{SingleOutput}, ::Type{PointInject};
    inputs=rand(5, 5), outputs=rand(1, 5),
)
    predictions = test_common(template, inputs, outputs)
    @test predictions isa AbstractVector{<:ContinuousUnivariateDistribution}
    @test length(predictions) == size(outputs, 2)
    @test all(length.(predictions) .== size(outputs, 1))
end

function test_interface(
    template::Template, ::Type{DistributionEstimate}, ::Type{MultiOutput}, ::Type{PointInject};
    inputs=rand(5, 5), outputs=rand(3, 5)
)
    predictions = test_common(template, inputs, outputs)
    @test predictions isa AbstractVector{<:ContinuousMultivariateDistribution}
    @test length(predictions) == size(outputs, 2)
    @test all(length.(predictions) .== size(outputs, 1))
end

function test_interface(
    template::Template, ::Type{DistributionEstimate}, ::Type{MultiOutput}, ::Type{DistributionInject};
    inputs=[Normal(m, 1) for m in 1:5], outputs=rand(3, 5)
)
    predictions = test_common(template, inputs, outputs)
    @test predictions isa AbstractVector{<:ContinuousMultivariateDistribution}
    @test length(predictions) == size(outputs, 2)
    @test all(length.(predictions) .== size(outputs, 1))
end

function test_interface(
    template::Template, ::Type{DistributionEstimate}, ::Type{MultiOutput}, ::Type{PointOrDistributionInject};
    inputs=rand(5, 5), outputs=rand(3, 5), distribution_inputs=[Normal(m, 1) for m in 1:5],
)
    predictions = test_common(template, inputs, outputs)
    @test predictions isa AbstractVector{<:ContinuousMultivariateDistribution}
    @test length(predictions) == size(outputs, 2)
    @test all(length.(predictions) .== size(outputs, 1))

    model = fit(template, outputs, inputs)
    predictions = predict(model, distribution_inputs)
    @test predictions isa AbstractVector{<:ContinuousMultivariateDistribution}
    @test length(predictions) == size(outputs, 2)
    @test all(length.(predictions) .== size(outputs, 1))
end

function test_names(template, model)
    template_type_name = string(nameof(typeof(template)))
    template_base_name_match = match(r"(.*)Template", template_type_name)
    @test template_base_name_match !== nothing  # must have Template suffix

    model_type_name = string(nameof(typeof(model)))
    model_base_name_match = match(r"(.*)Model", model_type_name)
    @test model_base_name_match !== nothing  # must have Model suffix

    # base_name must agreee
    @test model_base_name_match[1] == template_base_name_match[1]
end

function test_common(template, inputs, outputs)

    model = fit(template, outputs, inputs)

    @test template isa Template
    @test model isa Model

    @testset "type names" begin
        test_names(template, model)
    end

    @testset "test fit/predict errors" begin
        @test_throws MethodError predict(template, inputs)  # can only predict on a model
        @test_throws MethodError fit(model, outputs, inputs)  # can only fit a template
    end

    @testset "test weights can also be passed" begin
        weights = uweights(Float32, size(outputs, 2))
        model_weights = fit(template, outputs, inputs, weights)
    end

    @testset "traits" begin
        @test estimate_type(template) == estimate_type(model)
        @test output_type(template) == output_type(model)
        @test inject_type(template) == inject_type(model)
    end

    @testset "submodels" begin
        @test length(submodels(template)) == length(submodels(model))
        foreach(test_names, submodels(template), submodels(model))
    end

    predictions = predict(model, inputs)
    return predictions
end

end
