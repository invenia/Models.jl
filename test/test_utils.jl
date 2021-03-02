@testset "test_utils.jl" begin

    estimates = (PointEstimate, DistributionEstimate)
    outputs = (SingleOutput, MultiOutput)

    @testset "$est, $out, PointPredictInput" for (est, out) in Iterators.product(estimates, outputs)
        temp = FakeTemplate{est, out}()
        test_interface(temp)
    end    

    @testset "Vector inputs case" begin
        temp = FakeTemplate{PointEstimate, SingleOutput}()
        test_interface(temp; inputs=[rand(5), rand(5)], outputs=rand(1, 2))
    end

    @testset "$est, $out, PointOrDistributionPredictInput" for (est, out) in Iterators.product(estimates, outputs)
        Models.predict_input_type(m::Type{<:FakeTemplate}) = PointOrDistributionPredictInput
        Models.predict_input_type(m::Type{<:FakeModel}) = PointOrDistributionPredictInput

        temp = FakeTemplate{est, out}()
        test_interface(temp)
    end 

    @testset "Vector inputs case" begin
        temp = FakeTemplate{PointEstimate, SingleOutput}()
        test_interface(
            temp; 
            inputs=[rand(5), rand(5)], 
            outputs=rand(1, 2), 
            distribution_inputs=[MvNormal(5, m) for m in 1:2]
        )
    end

end
