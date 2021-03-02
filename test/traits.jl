struct DummyTemplate <: Template end
struct DummyModel <: Model end

@testset "traits.jl" begin

    estimates = (PointEstimate, DistributionEstimate)
    outputs = (SingleOutput, MultiOutput)

    @testset "$est, $out" for (est, out) in Iterators.product(estimates, outputs)

        @testset "Errors if traits are not defined" begin
            @test_throws MethodError estimate_type(DummyTemplate)
            @test_throws MethodError output_type(DummyTemplate)

            @test_throws MethodError estimate_type(DummyModel)
            @test_throws MethodError output_type(DummyModel)
        end

        @testset "Traits are defined" begin
            estimate_type(m::Type{<:DummyTemplate}) = est
            estimate_type(m::Type{<:DummyModel}) = est

            output_type(m::Type{<:DummyTemplate}) = out
            output_type(m::Type{<:DummyModel}) = out

            @test estimate_type(DummyTemplate) == estimate_type(DummyModel) == est
            @test output_type(DummyTemplate) == output_type(DummyModel) == out
        end

    end

    @testset "PredictInputTrait" begin
        
        @testset "Default" begin
            @test predict_input_type(DummyTemplate) == predict_input_type(DummyModel) == PointPredictInput
        end 

        @testset "PointOrDistributionPredictInput is defined" begin
            predict_input_type(m::Type{<:DummyTemplate}) = PointOrDistributionPredictInput
            predict_input_type(m::Type{<:DummyModel}) = PointOrDistributionPredictInput
            
            @test predict_input_type(DummyTemplate) == 
                predict_input_type(DummyModel) == 
                PointOrDistributionPredictInput
        end
    end
end
