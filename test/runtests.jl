using Distributions: Normal, MvNormal
using Models
using Models.TestUtils
using NamedDims: NamedDimsArray
using Test

@testset "Models.jl" begin
    include("traits.jl")
    include("test_utils.jl")
end
