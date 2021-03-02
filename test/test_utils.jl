@testset "test_utils.jl" begin

    estimates = (PointEstimate, DistributionEstimate)
    outputs = (SingleOutput, MultiOutput)
    predict_inputs = (PointPredictInput, PointOrDistributionPredictInput)

    @testset "$est, $out, $pin" for (est, out, pin) in Iterators.product(estimates, outputs, predict_inputs)
        temp = FakeTemplate{est, out, pin}()
        test_interface(temp)
    end    

    @testset "Vector inputs case" begin
        temp = FakeTemplate{PointEstimate, SingleOutput, PointPredictInput}()
        test_interface(temp; inputs=[rand(5), rand(5)], outputs=rand(1, 2))
    end

end
