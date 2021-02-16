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

    @testset "Inject Trait" begin
        
        @testset "Default" begin
            @test inject_type(DummyTemplate) == inject_type(DummyModel) == PointInject
        end 

        injects = (DistributionInject, PointOrDistributionInject)

        @testset "$inj is defined" for inj in injects
            inject_type(m::Type{<:DummyTemplate}) = inj
            inject_type(m::Type{<:DummyModel}) = inj
            
            @test inject_type(DummyTemplate) == inject_type(DummyModel) == inj
        end
    end

end
