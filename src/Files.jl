# module Files

export listfiles

using Configurations: @option
using FileTrees: FileTree, mapsubtrees, path
using Glob: GlobMatch

@option struct ExpressFileTree
    root_dir::String
    input_pattern::Union{String,Regex,GlobMatch}
    output_pattern::Union{String,Regex,GlobMatch}
end

function listfiles(patterns::Pair, root_dir=pwd())
    tree = FileTree(expanduser(root_dir))
    io = map(patterns) do pattern
        files = String[]
        mapsubtrees(tree, pattern) do subtree
            push!(files, abspath(path(subtree)))
        end
        files
    end
    return Tuple(io)
end

materialize(config::ExpressFileTree) =
    listfiles(config.input_pattern => config.output_pattern, config.root_dir)

# end