using Documenter, Models

makedocs(;
    modules=[Models],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://gitlab.invenia.ca/invenia/Models.jl/blob/{commit}{path}#L{line}",
    sitename="Models.jl",
    authors="Invenia Technical Computing Corporation",
    assets=[
        "assets/invenia.css",
        "assets/logo.png",
    ],
    strict=true,
    html_prettyurls=false,
    checkdocs=:none,
)
