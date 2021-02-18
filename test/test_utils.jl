@testset "test_utils.jl" begin

    @testset "FakeTemplate{PointEstimate, SingleOutput, PointInject}" begin
        temp = FakeTemplate{PointEstimate, SingleOutput, PointInject}()
        test_interface(temp)

        temp = FakeTemplate{PointEstimate, SingleOutput, PointInject}()
        test_interface(temp; inputs=[rand(5), rand(5)], outputs=rand(1, 2))
    end

    @testset "FakeTemplate{PointEstimate, MultiOutput, PointInject}" begin
        temp = FakeTemplate{PointEstimate, MultiOutput, PointInject}()
        test_interface(temp)
    end

    @testset "FakeTemplate{DistributionEstimate, SingleOutput, PointInject}" begin
        temp = FakeTemplate{DistributionEstimate, SingleOutput, PointInject}()
        test_interface(temp)
    end

    @testset "FakeTemplate{DistributionEstimate, MultiOutput, PointInject}" begin
        temp = FakeTemplate{DistributionEstimate, MultiOutput, PointInject}()
        test_interface(temp)
    end

    @testset "FakeTemplate{DistributionEstimate, MultiOutput, DistributionInject}" begin
        temp = FakeTemplate{DistributionEstimate, MultiOutput, DistributionInject}()
        test_interface(temp)
    end

    @testset "FakeTemplate{DistributionEstimate, MultiOutput, PointOrDistributionInject}" begin
        temp = FakeTemplate{DistributionEstimate, MultiOutput, PointOrDistributionInject}()
        test_interface(temp)
    end

end
