@testset "test_utils.jl" begin

    @testset "FakeTemplate{PointEstimate, SingleOutput, PointPredictInput}" begin
        temp = FakeTemplate{PointEstimate, SingleOutput, PointPredictInput}()
        test_interface(temp)

        temp = FakeTemplate{PointEstimate, SingleOutput, PointPredictInput}()
        test_interface(temp; inputs=[rand(5), rand(5)], outputs=rand(1, 2))
    end

    @testset "FakeTemplate{PointEstimate, MultiOutput, PointPredictInput}" begin
        temp = FakeTemplate{PointEstimate, MultiOutput, PointPredictInput}()
        test_interface(temp)
    end

    @testset "FakeTemplate{DistributionEstimate, SingleOutput, PointPredictInput}" begin
        temp = FakeTemplate{DistributionEstimate, SingleOutput, PointPredictInput}()
        test_interface(temp)
    end

    @testset "FakeTemplate{DistributionEstimate, MultiOutput, PointPredictInput}" begin
        temp = FakeTemplate{DistributionEstimate, MultiOutput, PointPredictInput}()
        test_interface(temp)
    end

    @testset "FakeTemplate{DistributionEstimate, MultiOutput, DistributionPredictInput}" begin
        temp = FakeTemplate{DistributionEstimate, MultiOutput, DistributionPredictInput}()
        test_interface(temp)
    end

    @testset "FakeTemplate{DistributionEstimate, MultiOutput, PointOrDistributionPredictInput}" begin
        temp = FakeTemplate{DistributionEstimate, MultiOutput, PointOrDistributionPredictInput}()
        test_interface(temp)
    end

end
