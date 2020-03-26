# Models

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://invenia.github.io/Models.jl/stable/)
[![Latest](https://img.shields.io/badge/docs-latest-blue.svg)](https://invenia.github.io/Models.jl/dev/)

[![Build Status](https://travis-ci.com/invenia/Models.jl.svg?branch=master)](https://travis-ci.com/invenia/Models.jl)
[![Codecov](https://codecov.io/gh/invenia/Models.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/invenia/Models.jl)

[![code style blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

## Why does this package exist?

[Models.jl](https://github.com/invenia/Models.jl) defines the `Template` and `Model` types as well as a common API for constructing a generic model in downstream packages, including:

* Calling `fit` on a `Template`.
* Calling `predict` on a `Model`.
* Assigning traits such as `EstimateTrait` and `OutputTrait`.
* Testing interfaces and downstream dependencies with `TestUtils`.
