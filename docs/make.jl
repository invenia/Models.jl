using Documenter
using Models
using Models.TestUtils

makedocs(;
    modules=[Models],
    format=Documenter.HTML(;
        prettyurls=false,
        assets=[
            "assets/invenia.css",
        ],
    ),
    pages=[
        "Index" => "index.md",
        "Design" => "design.md",
        "API" => "api.md",
        "TestUtils" => "testutils.md",
    ],
    repo="https://github.com/invenia/Models.jl/blob/{commit}{path}#L{line}",
    sitename="Models.jl",
    authors="Invenia Technical Computing Corporation",
    strict=true,
    checkdocs=:exports,
)

deploydocs(;
    repo="github.com/invenia/Models.jl",
    push_preview=true,
)
