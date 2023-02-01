# module Files

using Configurations: @option
using Glob: GlobMatch

@option struct ExpressFileTree
    root_dir::String
    input_pattern::Union{String,Regex,GlobMatch}
    output_pattern::Union{String,Regex,GlobMatch}
end

# end