# TestUtils

```@docs
TestUtils
```

## Interface Tests
```@docs
test_interface
```

### Note on PredictInputTrait Interface Tests

In the case where the [`PredictInputTrait`](@ref) is [`DistributionPredictInput`](@ref) or [`PointOrDistributionPredictInput`](@ref) the the Models API requires only that the distribution in question is `Sampleable`.
When using [`Models.TestUtils.test_interface`](@ref) to test a model where distributions can be passed to [`predict`](@ref), the user should provide `inputs` of the distribution type appropriate to their model.
In the example below the `CustomModel` accepts `MvNormal` distributions to `predict`.  

```julia
using CustomModels
using Distributions
using Models.TestUtils

test_interface(
    CustomModelTemplate();
    distribution_inputs=[MvNormal(5, 1) for _ in 1:5],
)
```

## Test Fakes
```@autodocs
Modules = [Models.TestUtils]
Filter = t -> occursin("Fake", string(t))
```
