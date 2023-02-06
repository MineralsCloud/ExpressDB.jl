# module Files

export listfiles, SimpleRule

using Configurations: OptionField, @option
using FileTrees: FileTree, mapsubtrees, path
using Glob: GlobMatch

import Configurations: from_dict

abstract type SearchRule end
@option "simple" struct SimpleRule <: SearchRule
    root_dir::String
    input_pattern::GlobMatch
    output_pattern::GlobMatch
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
    return first(io) .=> last(io)
end

materialize(config::SimpleRule) =
    listfiles(config.input_pattern => config.output_pattern, config.root_dir)

from_dict(::Type{SimpleRule}, ::OptionField{:input_pattern}, ::Type{GlobMatch}, str) =
    GlobMatch(str)
from_dict(::Type{SimpleRule}, ::OptionField{:output_pattern}, ::Type{GlobMatch}, str) =
    GlobMatch(str)

# end
