module ExpressDB

using ChemicalFormula: Formula
using CrystallographyBase: Cell
using ExpressBase: Calculation, SelfConsistentField
using UUIDs: UUID

abstract type Data end
abstract type MaterialsData <: Data end
struct Crystal <: MaterialsData
    id::UUID
    formula::Formula
    structure::Cell
    pointgroup::String
    spacegroup::UInt16
    nsites::UInt64
end
abstract type CalculationData <: Data end

end
