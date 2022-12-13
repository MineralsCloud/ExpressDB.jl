module ExpressDB

using ExpressBase: Calculation, SelfConsistentField
using UUIDs: UUID

abstract type Data end
struct Material <: Data
    id::UUID
    formula::String
    structure::Cell
    pointgroup::Int
    spacegroup::Int
    nsites::Int
    phase::String
end

end
