# module Reports

using Dates: DateTime

export Report

mutable struct Report
    id::UUID
    user::String
    date::DateTime
end

# end
