"""
    Models.TestUtils

Provides test fakes, [`FakeTemplate`](@ref) and [`FakeModel`](@ref), that are useful for
testing downstream dependencies, and [`test_interface`](@ref) for testing the Models API has
been correctly implemented.
"""
module TestUtils
using Distributions: Normal, MultivariateNormal
using Models
using NamedDims
using StatsBase
using Test

export FakeModel, FakeTemplate
export test_interface

"""
    FakeTemplate{E <: EstimateTrait, O <: OutputTrait} <: Template

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
mutable struct FakeTemplate{E<:EstimateTrait, O<:OutputTrait} <: Template
    predictor::Function
end

"""
    FakeTemplate{PointEstimate, SingleOutput}()

A [`Template`](@ref) whose [`Model`](@ref) will predict 0 for each observation.
"""
function FakeTemplate{PointEstimate, SingleOutput}()
    FakeTemplate{PointEstimate, SingleOutput}() do num_variates, inputs
        @assert(num_variates == 1, "$num_variates != 1")
        inputs = NamedDimsArray{(:features, :observations)}(inputs)
        return NamedDimsArray{(:variates, :observations)}(
            zeros(1, size(inputs, :observations))
        )
    end
end

"""
    FakeTemplate{PointEstimate, MultiOutput}()

A [`Template`](@ref) whose [`Model`](@ref) will predict a vector of 0s for each observation.
The input and output will have the same dimension.
"""
function FakeTemplate{PointEstimate, MultiOutput}()
    FakeTemplate{PointEstimate, MultiOutput}() do num_variates, inputs
        inputs = NamedDimsArray{(:features, :observations)}(inputs)
        return NamedDimsArray{(:variates, :observations)}(
            zeros(num_variates, size(inputs, :observations))
        )
    end
end

"""
    FakeTemplate{DistributionEstimate, SingleOutput}()

A [`Template`](@ref) whose [`Model`](@ref) will predict a univariate normal
distribution (with zero mean and unit standard deviation) for each observation.
"""
function FakeTemplate{DistributionEstimate, SingleOutput}()
    FakeTemplate{DistributionEstimate, SingleOutput}() do num_variates, inputs
        @assert(num_variates == 1, "$num_variates != 1")
        inputs = NamedDimsArray{(:features, :observations)}(inputs)
        return Normal.(zeros(size(inputs, :observations)))
    end
end

"""
    FakeTemplate{DistributionEstimate, MultiOutput}()

A [`Template`](@ref) whose [`Model`](@ref) will predict a multivariate normal
distribution (with zero-vector mean and identity covariance matrix) for each observation.
"""
function FakeTemplate{DistributionEstimate, MultiOutput}()
    FakeTemplate{DistributionEstimate, MultiOutput}() do num_variates, inputs
        std_dev = ones(num_variates)
        return [MultivariateNormal(std_dev) for _ in 1:size(inputs, 2)]
    end
end

"""
    FakeModel

A fake Model for testing purposes. See [`FakeTemplate`](@ref) for details.
"""
mutable struct FakeModel{E<:EstimateTrait, O<:OutputTrait} <: Model
    predictor::Function
    num_variates::Int
end

Models.estimate_type(::Type{<:FakeModel{E, O}}) where {E, O} = E
Models.output_type(::Type{<:FakeModel{E, O}}) where {E, O} = O

Models.estimate_type(::Type{<:FakeTemplate{E, O}}) where {E, O} = E
Models.output_type(::Type{<:FakeTemplate{E, O}}) where {E, O} = O

function StatsBase.fit(
    template::FakeTemplate{E, O},
    outputs,
    inputs,
    weights=uweights(Float32, size(outputs, 2))
) where {E, O}
    outputs = NamedDimsArray{(:variates, :observations)}(outputs)
    num_variates = size(outputs, :variates)
    return FakeModel{E, O}(template.predictor, num_variates)
end

StatsBase.predict(m::FakeModel, inputs) = m.predictor(m.num_variates, inputs)

"""
    test_interface(template::Template; inputs=rand(5, 5), outputs=rand(5, 5))

Test that subtypes of [`Template`](@ref) and [`Model`](@ref) implement the expected API.
Can be used as an initial test to verify the API has been correctly implemented.
"""
function test_interface(template::Template; kwargs...)
    @testset "Models API Interface Test: $(nameof(typeof(template)))" begin
        test_interface(template, estimate_type(template), output_type(template); kwargs...)
    end
end

function test_interface(
    template::Template, ::Type{PointEstimate}, ::Type{SingleOutput};
    inputs=rand(5, 5), outputs=rand(1, 5),
)
    predictions = test_common(template, inputs, outputs)

    @test predictions isa NamedDimsArray{(:variates, :observations), <:Real, 2}
    @test size(predictions) == size(outputs)
    @test size(predictions, 1) == 1
end

function test_interface(
    template::Template, ::Type{PointEstimate}, ::Type{MultiOutput};
    inputs=rand(5, 5), outputs=rand(2, 5),
)
    predictions = test_common(template, inputs, outputs)
    @test predictions isa NamedDimsArray{(:variates, :observations), <:Real, 2}
    @test size(predictions) == size(outputs)
end

function test_interface(
    template::Template, ::Type{DistributionEstimate}, ::Type{SingleOutput};
    inputs=rand(5, 5), outputs=rand(1, 5),
)
    predictions = test_common(template, inputs, outputs)
    @test predictions isa Vector{<:Normal{<:Real}}
    @test length(predictions) == size(outputs, 2)
    @test all(length.(predictions) .== size(outputs, 1))
end

function test_interface(
    template::Template, ::Type{DistributionEstimate}, ::Type{MultiOutput};
    inputs=rand(5, 5), outputs=rand(3, 5)
)
    predictions = test_common(template, inputs, outputs)
    @test predictions isa Vector{<:MultivariateNormal{<:Real}}
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
    end

    @testset "submodels" begin
        @test length(submodels(template)) == length(submodels(model))
        foreach(test_names, submodels(template), submodels(model))
    end

    predictions = predict(model, inputs)
    return predictions
end

end
