# module Reports

using Dates: DateTime

export Report

abstract type Indexer end

mutable struct Report
    id::UUID
    user::String
    date::DateTime
end

# end
