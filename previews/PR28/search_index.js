var documenterSearchIndex = {"docs":
[{"location":"api.html#API","page":"API","title":"API","text":"","category":"section"},{"location":"api.html#Abstract-Types","page":"API","title":"Abstract Types","text":"","category":"section"},{"location":"api.html","page":"API","title":"API","text":"Template\nModel","category":"page"},{"location":"api.html#Models.Template","page":"API","title":"Models.Template","text":"Template\n\nA Template is an untrained Model that can be fit to data. Defined as well are the traits:\n\noutput_type: SingleOutput or MultiOutput.\nestimate_type: PointEstimate or DistributionEstimate.\n\n\n\n\n\n","category":"type"},{"location":"api.html#Models.Model","page":"API","title":"Models.Model","text":"Model\n\nA Model is a trained Template with which one can predict on inputs. Defined as well are the traits:\n\noutput_type: SingleOutput or MultiOutput.\nestimate_type: PointEstimate or DistributionEstimate.\n\n\n\n\n\n","category":"type"},{"location":"api.html#Common-API","page":"API","title":"Common API","text":"","category":"section"},{"location":"api.html","page":"API","title":"API","text":"fit\npredict\nsubmodels\nestimate_type\noutput_type\npredict_input_type","category":"page"},{"location":"api.html#StatsBase.fit","page":"API","title":"StatsBase.fit","text":"fit(::Template, output::AbstractMatrix, input::AbstractMatrix, [weights]) -> Model\n\nFit the Template to the output and input data and return a trained Model. Convention is that weights defaults to StatsBase.uweights(Float32, size(outputs, 2))\n\n\n\n\n\n","category":"function"},{"location":"api.html#StatsBase.predict","page":"API","title":"StatsBase.predict","text":"predict(model::Model, inputs::AbstractMatrix)\npredict(model::Model, inputs::AbstractVector{<:AbstractVector})\n\nPredict targets for the provided the collection of inputs and Model.\n\nA Model subtype for which the predict_input_type(model) is  PointPredictInput will only need to implement a predict function that operates  on an AbstractMatrix of inputs.  \n\nIf the estimate_type(model) is PointEstimate then this function should return another AbstractMatrix in which each column contains the prediction for a single input.\n\nIf the estimate_type(model) is DistributionEstimate then this function should return a AbstractVector{<:Distribution}.\n\n\n\n\n\n","category":"function"},{"location":"api.html#Models.submodels","page":"API","title":"Models.submodels","text":"submodels(::Union{Template, Model})\n\nReturn all submodels within a multistage model/template.\n\nSubmodels are models within a model that have their own inputs (which may or may not be combined with outputs of earlier submodels, before actually being passed as input to the submodel). Such multistage models take a tuple of inputs (which may be nested if the submodel itself has submodels). The order of submodels returned by submodels is as per the order of the inputs in the tuple.\n\nFor single-stage models, (i.e. ones that simply take a matrix as input), this returns an empty tuple. Wrapper models which do not expose their inner models to seperate inputs, including ones that only wrap a single model, should not define submodels as they are (from the outside API perspective) single-stage models.\n\n\n\n\n\n","category":"function"},{"location":"api.html#Models.estimate_type","page":"API","title":"Models.estimate_type","text":"estimate_type(::T) where T = output_type(T)\n\nReturn the [EstimateTrait] of the Model or Template.\n\n\n\n\n\n","category":"function"},{"location":"api.html#Models.output_type","page":"API","title":"Models.output_type","text":"output_type(::T) where T = output_type(T)\n\nReturn the [OutputTrait] of the Model or Template.\n\n\n\n\n\n","category":"function"},{"location":"api.html#Models.predict_input_type","page":"API","title":"Models.predict_input_type","text":"predict_input_type(::T) where T = predict_input_type(T)\n\nReturn the [PredictInputTrait] of the Model or Template.\n\n\n\n\n\n","category":"function"},{"location":"api.html#Traits","page":"API","title":"Traits","text":"","category":"section"},{"location":"api.html","page":"API","title":"API","text":"EstimateTrait\nPointEstimate\nDistributionEstimate\nOutputTrait\nSingleOutput\nMultiOutput\nPredictInputTrait\nPointPredictInput\nPointOrDistributionPredictInput","category":"page"},{"location":"api.html#Models.EstimateTrait","page":"API","title":"Models.EstimateTrait","text":"EstimateTrait\n\nThe EstimateTrait specifies if the model outputs a point or distribution estimate, denoted by PointEstimate or DistributionEstimate, respectively.\n\n\n\n\n\n","category":"type"},{"location":"api.html#Models.PointEstimate","page":"API","title":"Models.PointEstimate","text":"PointEstimate <: EstimateTrait\n\nSpecifies that the Model returns real-valued response variables.\n\n\n\n\n\n","category":"type"},{"location":"api.html#Models.DistributionEstimate","page":"API","title":"Models.DistributionEstimate","text":"DistributionEstimate <: EstimateTrait\n\nSpecifies that the Model returns a distribution over the response variables.\n\n\n\n\n\n","category":"type"},{"location":"api.html#Models.OutputTrait","page":"API","title":"Models.OutputTrait","text":"OutputTrait\n\nThe OutputTrait specifies if the model supports single or multiple response variables, denoted by SingleOutput or MultiOutput, respectively.\n\n\n\n\n\n","category":"type"},{"location":"api.html#Models.SingleOutput","page":"API","title":"Models.SingleOutput","text":"SingleOutput <: OutputTrait\n\nSpecifies that the Model returns a single, univariate response variable.\n\n\n\n\n\n","category":"type"},{"location":"api.html#Models.MultiOutput","page":"API","title":"Models.MultiOutput","text":"MultiOutput <: OutputTrait\n\nSpecifies that the Model returns a multivariate response variable.\n\n\n\n\n\n","category":"type"},{"location":"api.html#Models.PredictInputTrait","page":"API","title":"Models.PredictInputTrait","text":"PredictInputTrait\n\nThe PredictInputTrait specifies if the model supports point or distribution inputs to predict, denoted by PointPredictInput or PointOrDistributionPredictInput.\n\n\n\n\n\n","category":"type"},{"location":"api.html#Models.PointPredictInput","page":"API","title":"Models.PointPredictInput","text":"PointPredictInput <: PredictInputTrait\n\nSpecifies that the Model accepts real-valued input variables to predict.\n\n\n\n\n\n","category":"type"},{"location":"api.html#Models.PointOrDistributionPredictInput","page":"API","title":"Models.PointOrDistributionPredictInput","text":"PointOrDistributionPredictInput <: PredictInputTrait\n\nSpecifies that the Model accepts real-values or a joint distribution over the input  variables to predict.\n\n\n\n\n\n","category":"type"},{"location":"design.html#Design","page":"Design","title":"Design","text":"","category":"section"},{"location":"design.html","page":"Design","title":"Design","text":"This page details the key features of the design of Models.jl, which exists to solve the issue highlighted by the following quote:","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"ML researchers tend to develop general purpose solutions as self-contained packages. A wide variety of these are available as open-source packages ... Using generic packages often results in a glue-code system design pattern, in which a massive amount of supporting code is written to get data into and out of general-purpose packages. Glue-code is costly in the long term because it tends to freeze a system to the peculiarities of a specific package; testing alternatives may become prohibitively expensive.... An important strategy for combating glue-code is to wrap black-box packages into common API’s. This allows supporting infrastructure to be more reusable and reduces the cost of changing packages.","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"– Sculley et al 2015","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"Models.jl provides a common API for mostly preexisting models to allow them to all be used in the same way. As such, the most important thing is that it itself has a common API. Here are some facts about that API:","category":"page"},{"location":"design.html#Models-and-Templates","page":"Design","title":"Models and Templates","text":"","category":"section"},{"location":"design.html","page":"Design","title":"Design","text":"A Model is an object that can be used to make predictions via calling predict. A Template is an object that can create a Model by being fit to some data.","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"All information about how to perform fit, such as hyper-parameters, is stored inside the Template. This is different from some other APIs which might, for example, pass hyper-parameters as keyword arguments to fit. The Template based API is superior to these as it means fit is always the same. One does not have to carry both a Model type, and a varying collection of keyword arguments, which would get complicated when composing wrapper models.","category":"page"},{"location":"design.html#Calling-fit-and-predict","page":"Design","title":"Calling fit and predict","text":"","category":"section"},{"location":"design.html","page":"Design","title":"Design","text":"model = StatsBase.fit(\n    template::Template,\n    outputs::AbstractMatrix,  # always Features x Observations\n    inputs::AbstractMatrix,   # always Variates x Observations\n    weights=uweights(Float32, size(outputs, 2))\n)::Model","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"# estimate_type(model) == PointEsimate\noutputs = StatsBase.predict(\n    model::Model,\n    inputs::AbstractMatrix  # always Features x Observations\n)::AbstractMatrix  # always Variates x Observations\n\n# estimate_type(model) == DistributionEstimate\noutputs = StatsBase.predict(\n    model::Model,\n    inputs::AbstractMatrix  # always Features x Observations\n)::AbstractVector{<:Distribution}  # length Observations","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"fit takes in a Template and some data and returns a Model that has been fit to the data. predict takes a Model  (that has been fit from a Template) and produces a predicted output.","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"Important facts about fit and predict:","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"outputs and inputs always have observations as the second dimension – even if it is  SingleOutput (that just means that it will be a 1 x num_obs output. (See Docs on Julia being column-major)\nThe functions must accept any AbstractMatrix for the inputs and outputs (fit only). If the underlying implementation needs a plain dense Matrix then fit/predict should perform the conversion.\nfit always accepts a weights argument. If the underlying Model does not support weighted fitting, then fit should throw and error if the weights that passed in and are not all equal.\nfit/predict take no keyword arguments, or any other arguments except the ones shown.","category":"page"},{"location":"design.html#Traits","page":"Design","title":"Traits","text":"","category":"section"},{"location":"design.html","page":"Design","title":"Design","text":"This package largely avoids using complicated abstract types, or relying on a Model having a particular abstract type. Instead we use traits to determine Model behavior.","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"Here are the current Model traits in use and their possible values:","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"estimate_type -  determines what kinds of estimates the Model outputs.\nPointEstimate: Predicts point-estimates of the most likely values.\nDistributionEstimate: Estimates distributions over possible values.\noutput_type - determines how many output variates a Model can learn\nSingleOutput: Fits and predicts on a single output only.\nMultiOutput: Fits and predicts on multiple outputs at a time.\npredict_input_type - determines which datatypes a Model can accept at predict time.\nPointPredictInput: Real valued input variables accepted at predict time.\nPointOrDistributionPredictInput: Either real valued or distributions of input variables accepted at predict time.","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"The traits always agree between the Model and the Template. Every Model and Template should define all the listed traits. If left undefined, the PredictInputTrait will have the default value of PointPredictInput.","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"This package uses traits implemented such that the trait function returns an abstract type (rather than an instance). That means to check a trait one uses:","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"if estimate_type(model) isa DistributionEstimate","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"and to dispatch on a trait one uses:","category":"page"},{"location":"design.html","page":"Design","title":"Design","text":"foo(::Type{<:DistributionEstimate}, ...)","category":"page"},{"location":"testutils.html#TestUtils","page":"TestUtils","title":"TestUtils","text":"","category":"section"},{"location":"testutils.html","page":"TestUtils","title":"TestUtils","text":"TestUtils","category":"page"},{"location":"testutils.html#Models.TestUtils","page":"TestUtils","title":"Models.TestUtils","text":"Models.TestUtils\n\nProvides test fakes, FakeTemplate and FakeModel, that are useful for testing downstream dependencies, and test_interface for testing the Models API has been correctly implemented.\n\n\n\n\n\n","category":"module"},{"location":"testutils.html#Interface-Tests","page":"TestUtils","title":"Interface Tests","text":"","category":"section"},{"location":"testutils.html","page":"TestUtils","title":"TestUtils","text":"test_interface","category":"page"},{"location":"testutils.html#Models.TestUtils.test_interface","page":"TestUtils","title":"Models.TestUtils.test_interface","text":"test_interface(template::Template; inputs=rand(5, 5), outputs=rand(5, 5))\n\nTest that subtypes of Template and Model implement the expected API. Can be used as an initial test to verify the API has been correctly implemented.\n\n\n\n\n\n","category":"function"},{"location":"testutils.html#Note-on-PredictInputTrait-Interface-Tests","page":"TestUtils","title":"Note on PredictInputTrait Interface Tests","text":"","category":"section"},{"location":"testutils.html","page":"TestUtils","title":"TestUtils","text":"In the case where the PredictInputTrait is PointOrDistributionPredictInput the the Models API requires only that the distribution in question is Sampleable. When using Models.TestUtils.test_interface to test a model where distributions can be passed to predict, the user should provide inputs of the distribution type appropriate to their model. In the example below the CustomModel accepts MvNormal distributions to predict.  ","category":"page"},{"location":"testutils.html","page":"TestUtils","title":"TestUtils","text":"using CustomModels\nusing Distributions\nusing Models.TestUtils\n\ntest_interface(\n    CustomModelTemplate();\n    distribution_inputs=[MvNormal(5, 1) for _ in 1:5],\n)","category":"page"},{"location":"testutils.html#Test-Fakes","page":"TestUtils","title":"Test Fakes","text":"","category":"section"},{"location":"testutils.html","page":"TestUtils","title":"TestUtils","text":"Modules = [Models.TestUtils]\nFilter = t -> occursin(\"Fake\", string(t))","category":"page"},{"location":"testutils.html#Models.TestUtils.FakeModel","page":"TestUtils","title":"Models.TestUtils.FakeModel","text":"FakeModel\n\nA fake Model for testing purposes. See FakeTemplate for details.\n\n\n\n\n\n","category":"type"},{"location":"testutils.html#Models.TestUtils.FakeTemplate","page":"TestUtils","title":"Models.TestUtils.FakeTemplate","text":"FakeTemplate{E <: EstimateTrait, O <: OutputTrait} <: Template\n\nThis template is a test double for testing purposes. It should be defined (before fitting) with a predictor, which can be changed by mutating the field.\n\nFields\n\npredictor::Function: predicts the outputs of the FakeModel.  It is (num_variates, inputs) -> outputs, where the num_variates will be memorized  during fit.\n\nMethods\n\nfit does not learn anything, it just creates an instance of the corresponding Model.\npredict applies the predictor to the inputs.\n\n\n\n\n\n","category":"type"},{"location":"testutils.html#Models.TestUtils.FakeTemplate-Union{Tuple{}, Tuple{MultiOutput}, Tuple{DistributionEstimate}} where MultiOutput where DistributionEstimate","page":"TestUtils","title":"Models.TestUtils.FakeTemplate","text":"FakeTemplate{DistributionEstimate, MultiOutput}()\n\nA Template whose Model will accept real value variables to predict a multivariate normal distribution (with zero-vector mean and identity covariance matrix) for each observation.\n\n\n\n\n\n","category":"method"},{"location":"testutils.html#Models.TestUtils.FakeTemplate-Union{Tuple{}, Tuple{MultiOutput}, Tuple{PointEstimate}} where MultiOutput where PointEstimate","page":"TestUtils","title":"Models.TestUtils.FakeTemplate","text":"FakeTemplate{PointEstimate, MultiOutput}()\n\nA Template whose Model will accept real value variables to predict a vector of 0s for each observation. The input and output will have the same dimension.\n\n\n\n\n\n","category":"method"},{"location":"testutils.html#Models.TestUtils.FakeTemplate-Union{Tuple{}, Tuple{SingleOutput}, Tuple{DistributionEstimate}} where SingleOutput where DistributionEstimate","page":"TestUtils","title":"Models.TestUtils.FakeTemplate","text":"FakeTemplate{DistributionEstimate, SingleOutput}()\n\nA Template whose Model will accept real value variables to predict a univariate normal distribution (with zero mean and unit standard deviation) for each observation.\n\n\n\n\n\n","category":"method"},{"location":"testutils.html#Models.TestUtils.FakeTemplate-Union{Tuple{}, Tuple{SingleOutput}, Tuple{PointEstimate}} where SingleOutput where PointEstimate","page":"TestUtils","title":"Models.TestUtils.FakeTemplate","text":"FakeTemplate{PointEstimate, SingleOutput}()\n\nA Template whose Model will accept real value variables to predict 0 for each observation.\n\n\n\n\n\n","category":"method"},{"location":"index.html#Models","page":"Index","title":"Models","text":"","category":"section"},{"location":"index.html#Why-does-this-package-exist?","page":"Index","title":"Why does this package exist?","text":"","category":"section"},{"location":"index.html","page":"Index","title":"Index","text":"Models.jl defines the Template and Model types as well as a common API for constructing a generic model in downstream packages, including:","category":"page"},{"location":"index.html","page":"Index","title":"Index","text":"Calling fit on a Template.\nCalling predict on a Model.\nAssigning traits such as EstimateTrait and OutputTrait.\nTesting interfaces and downstream dependencies with TestUtils.","category":"page"},{"location":"index.html#Contents","page":"Index","title":"Contents","text":"","category":"section"},{"location":"index.html","page":"Index","title":"Index","text":"Pages = [\"design.md\", \"api.md\", \"testutils.md\"]","category":"page"}]
}
