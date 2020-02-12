# Models

[![Latest](https://img.shields.io/badge/docs-latest-blue.svg)](https://invenia.pages.invenia.ca/Models.jl/)
[![Build Status](https://gitlab.invenia.ca/invenia/Models.jl/badges/master/build.svg)](https://gitlab.invenia.ca/invenia/Models.jl/commits/master)
[![Coverage](https://gitlab.invenia.ca/invenia/Models.jl/badges/master/coverage.svg)](https://gitlab.invenia.ca/invenia/Models.jl/commits/master)

This package defines the `Model` type and a common API for constructing a generic model, including

* Model Fitting (`fit`, `predict`)
* Model Traits (`output_type`, `estimate_type`)
* Test utils for testing downstream interfaces (`FakeModel`)

For common examples of the interface being implemented see [BaselineModels.jl](https://gitlab.invenia.ca/invenia/research/BaselineModels.jl).
