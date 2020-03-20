@testset "test_utils.jl" begin

    @testset "FakeTemplate{PointEstimate, SingleOutput}" begin
        temp = FakeTemplate{PointEstimate, SingleOutput}()
        test_interface(temp)
    end

    @testset "FakeTemplate{PointEstimate, MultiOutput}" begin
        temp = FakeTemplate{PointEstimate, MultiOutput}()
        test_interface(temp)
    end

    @testset "FakeTemplate{DistributionEstimate, SingleOutput}" begin
        temp = FakeTemplate{DistributionEstimate, SingleOutput}()
        test_interface(temp)
    end

    @testset "FakeTemplate{DistributionEstimate, MultiOutput}" begin
        temp = FakeTemplate{DistributionEstimate, MultiOutput}()
        test_interface(temp)
    end

end
