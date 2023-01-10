module ExpressDB

using ChemicalFormula: Formula
using CrystallographyBase: Cell
using ExpressBase: Calculation, SelfConsistentField
using UUIDs: UUID

abstract type Data end
struct Crystal <: Data
    id::UUID
    formula::Formula
    structure::Cell
    pointgroup::String
    spacegroup::UInt16
    nsites::UInt64
end

end
