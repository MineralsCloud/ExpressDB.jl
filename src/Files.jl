# module Files

export listfiles

using Configurations: @option
using FileTrees: FileTree, Path, files
using Glob: GlobMatch

@option struct ExpressFileTree
    root_dir::String
    input_pattern::Union{String,Regex,GlobMatch}
    output_pattern::Union{String,Regex,GlobMatch}
end

function listfiles(patterns, root_dir=pwd())
    tree = FileTree(root_dir)
    return map((patterns.first, patterns.second)) do pattern
        subtree = tree[pattern]
        abspath.(Path.(files(subtree)))
    end
end

# end