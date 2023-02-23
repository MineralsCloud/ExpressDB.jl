# module Files

export listfiles, readby

using Configurations: OptionField, @option
using FileTrees: FileTree, mapsubtrees, path
using Glob: GlobMatch

import Configurations: from_dict

abstract type SearchRule end
@option "simple" struct SimpleRule <: SearchRule
    input_pattern::GlobMatch
    output_pattern::GlobMatch
    root_dir::String = pwd()
end

function listfiles(patterns::Pair{GlobMatch,GlobMatch}, root_dir=pwd())
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
listfiles(patterns::Pair{<:AbstractString,<:AbstractString}, args...) =
    listfiles(GlobMatch(first(patterns)) => GlobMatch(last(patterns)), args...)

function readby(files, parsers::Pair)
    parsers = (parser === nothing ? identity : parser for parser in parsers)
    input_parser, output_parser = parsers
    return map(files) do (input, output)
        str₁, str₂ = read(input, String), read(output, String)
        in, out = input_parser(str₁), output_parser(str₂)
        in => out
    end
end

materialize(config::SimpleRule) =
    listfiles(config.input_pattern => config.output_pattern, config.root_dir)

from_dict(::Type{SimpleRule}, ::OptionField{:input_pattern}, ::Type{GlobMatch}, str) =
    GlobMatch(str)
from_dict(::Type{SimpleRule}, ::OptionField{:output_pattern}, ::Type{GlobMatch}, str) =
    GlobMatch(str)

# end