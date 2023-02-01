module ExpressDB

using ChemicalFormula: Formula
using CrystallographyBase: Cell, MonkhorstPackGrid
using EquationsOfStateOfSolids: EquationOfStateOfSolids
using Pseudopotentials: ExchangeCorrelationFunctional, Pseudization
using UUIDs: UUID

export Crystal, SimpleScf, EosFitting, PhononDos

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
struct SimpleScf <: CalculationData
    id::UUID
    ecutwfc::Number
    kmesh::MonkhorstPackGrid
    xc::ExchangeCorrelationFunctional
    pseudization::Pseudization
end
struct EosFitting <: CalculationData
    input_eos::EquationOfStateOfSolids
    final_eos::EquationOfStateOfSolids
end
struct PhononDos <: CalculationData
    id::UUID
    qmesh::MonkhorstPackGrid
    dosmesh::MonkhorstPackGrid
end

end
