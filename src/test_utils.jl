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
    FakeTemplate{E <: EstimateTrait, O <: OutputTrait, I <: PredictInputTrait} <: Template

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
mutable struct FakeTemplate{E<:EstimateTrait, O<:OutputTrait, I<:PredictInputTrait} <: Template
    predictor::Function
end

"""
    FakeTemplate{PointEstimate, SingleOutput, PointPredictInput}()

A [`Template`](@ref) whose [`Model`](@ref) will accept real value variables to predict 0
for each observation.
"""
function FakeTemplate{PointEstimate, SingleOutput, I}() where {I<:PredictInputTrait}
    FakeTemplate{PointEstimate, SingleOutput, I}() do num_variates, inputs
        @assert(num_variates == 1, "$num_variates != 1")
        inputs = _handle_inputs(inputs)
        return NamedDimsArray{(:variates, :observations)}(
            zeros(1, size(inputs, :observations))
        )
    end
end

"""
    FakeTemplate{PointEstimate, MultiOutput, PointPredictInput}()

A [`Template`](@ref) whose [`Model`](@ref) will accept real value variables to predict a
vector of 0s for each observation. The input and output will have the same dimension.
"""
function FakeTemplate{PointEstimate, MultiOutput, I}() where {I<:PredictInputTrait}
    FakeTemplate{PointEstimate, MultiOutput, I}() do num_variates, inputs
        inputs = _handle_inputs(inputs)
        return NamedDimsArray{(:variates, :observations)}(
            zeros(num_variates, size(inputs, :observations))
        )
    end
end

"""
    FakeTemplate{DistributionEstimate, SingleOutput, PointPredictInput}()

A [`Template`](@ref) whose [`Model`](@ref) will accept real value variables to predict a
univariate normal distribution (with zero mean and unit standard deviation) for each
observation.
"""
function FakeTemplate{DistributionEstimate, SingleOutput, I}() where {I<:PredictInputTrait}
    FakeTemplate{DistributionEstimate, SingleOutput, I}() do num_variates, inputs
        @assert(num_variates == 1, "$num_variates != 1")
        inputs = _handle_inputs(inputs)
        return NoncentralT.(3.0, zeros(size(inputs, :observations)))
    end
end

"""
    FakeTemplate{DistributionEstimate, MultiOutput, PointPredictInput}()

A [`Template`](@ref) whose [`Model`](@ref) will accept real value variables to predict a
multivariate normal distribution (with zero-vector mean and identity covariance matrix) for
each observation.
"""
function FakeTemplate{DistributionEstimate, MultiOutput, I}() where {I<:PredictInputTrait}
    FakeTemplate{DistributionEstimate, MultiOutput, I}() do num_variates, inputs
        std_dev = ones(num_variates)
        inputs = _handle_inputs(inputs)
        return [Product(Normal.(0, std_dev)) for _ in 1:size(inputs, 2)]
    end
end

"""
    _handle_inputs(inputs::AbstractMatrix)
    _handle_inputs(inputs::AbstractVector{<:Sampleable})

Process the inputs to `predict` appropriately depending on whether they are real valued or 
distributions over input variables.
"""
function _handle_inputs(inputs::AbstractVector{<:Sampleable})
    return NamedDimsArray{(:features, :observations)}(hcat([mean(inputs[i]) for i in 1:size(inputs, 1)]...))
end

_handle_inputs(inputs::AbstractMatrix) = NamedDimsArray{(:features, :observations)}(inputs)

"""
    FakeModel

A fake Model for testing purposes. See [`FakeTemplate`](@ref) for details.
"""
mutable struct FakeModel{E<:EstimateTrait, O<:OutputTrait, I<:PredictInputTrait} <: Model
    predictor::Function
    num_variates::Int
end

Models.estimate_type(::Type{<:FakeModel{E, O, I}}) where {E, O, I} = E
Models.output_type(::Type{<:FakeModel{E, O, I}}) where {E, O, I} = O
Models.predict_input_type(::Type{<:FakeModel{E, O, I}}) where {E, O, I} = I

Models.estimate_type(::Type{<:FakeTemplate{E, O, I}}) where {E, O, I} = E
Models.output_type(::Type{<:FakeTemplate{E, O, I}}) where {E, O, I} = O
Models.predict_input_type(::Type{<:FakeTemplate{E, O, I}}) where {E, O, I} = I

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
StatsBase.predict(m::FakeModel, inputs::AbstractVector{<:Sampleable}) = m.predictor(m.num_variates, inputs)

"""
    test_interface(template::Template; inputs=rand(5, 5), outputs=rand(5, 5))

Test that subtypes of [`Template`](@ref) and [`Model`](@ref) implement the expected API.
Can be used as an initial test to verify the API has been correctly implemented.
"""
function test_interface(
    template::Template; 
    inputs=rand(5,5), 
    outputs=_default_outputs(template),
    distribution_inputs=[MvNormal(5, m) for m in 1:5],
    kwargs...
)
    @testset "Models API Interface Test: $(nameof(typeof(template)))" begin
        predictions = test_common(template, inputs, outputs)
        test_estimate_type(estimate_type(template), predictions, outputs)
        test_output_type(output_type(template), predictions, outputs)
        test_predict_input_type(predict_input_type(template), template, outputs, inputs, distribution_inputs)
    end
end

function _default_outputs(template)
    @assert(output_type(template) <: OutputTrait, "Invalid OutputTrait")
    if output_type(template) == SingleOutput
        return rand(1, 5)
    else output_type(template) == MultiOutput
        return rand(2, 5)
    end
end

function test_estimate_type(::Type{PointEstimate}, predictions, outputs)
    @test predictions isa NamedDimsArray{(:variates, :observations), <:Real, 2}
    @test size(predictions) == size(outputs)
end

function test_estimate_type(::Type{DistributionEstimate}, predictions, outputs)
    @test predictions isa AbstractVector{<:ContinuousDistribution}
    @test length(predictions) == size(outputs, 2)
end

function test_output_type(::Type{SingleOutput}, predictions, outputs)
    @test all(length.(predictions) .== size(outputs, 1))
    @test all(length.(predictions) .== 1)
end

function test_output_type(::Type{MultiOutput}, predictions, outputs)
    if  eltype(predictions) <: Distribution
        @test all(length.(predictions) .== size(outputs, 1))
        @test all(length.(predictions) .> 1)
    else
        @test size(predictions, 1) == size(outputs, 1)
        @test size(predictions, 1) > 1
    end
end

function test_predict_input_type(::Type{PointPredictInput}, template, outputs, inputs, distribution_inputs) 
    model = fit(template, outputs, inputs)
    @test hasmethod(Models.predict, (typeof(model), typeof(inputs)))
end

function test_predict_input_type(::Type{PointOrDistributionPredictInput}, template, outputs, inputs, distribution_inputs)
    model = fit(template, outputs, inputs)
    @test hasmethod(Models.predict, (typeof(model), typeof(distribution_inputs)))
    predictions = predict(model, distribution_inputs)
    test_estimate_type(estimate_type(template), predictions, outputs)
    test_output_type(output_type(template), predictions, outputs)
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
        @test predict_input_type(template) == predict_input_type(model)
    end

    @testset "submodels" begin
        @test length(submodels(template)) == length(submodels(model))
        foreach(test_names, submodels(template), submodels(model))
    end

    predictions = predict(model, inputs)
    return predictions
end

end
