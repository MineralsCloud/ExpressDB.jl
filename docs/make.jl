using ExpressDB
using Documenter

DocMeta.setdocmeta!(ExpressDB, :DocTestSetup, :(using ExpressDB); recursive=true)

makedocs(;
    modules=[ExpressDB],
    authors="singularitti <singularitti@outlook.com> and contributors",
    repo="https://github.com/MineralsCloud/ExpressDB.jl/blob/{commit}{path}#{line}",
    sitename="ExpressDB.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://MineralsCloud.github.io/ExpressDB.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/MineralsCloud/ExpressDB.jl",
    devbranch="main",
)
