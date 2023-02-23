using ChemicalFormula: Formula
using CrystallographyBase: Cell, MonkhorstPackGrid
using EquationsOfStateOfSolids: EquationOfStateOfSolidsParameters
using Pseudopotentials: ExchangeCorrelationFunctional, Pseudization
using UUIDs: UUID

export Crystal, ScfSettings, EosFittingSettings, VDosSettings

abstract type Data end
struct UniqueData{T<:Data} <: Data
    id::UUID
    data::T
end
abstract type Material <: Data end
struct Crystal <: Material
    formula::Formula
    structure::Cell
    pointgroup::String
    spacegroup::UInt16
    nsites::UInt64
end
abstract type CalculationSettings <: Data end
struct ScfSettings <: CalculationSettings
    ecutwfc::Number
    kmesh::MonkhorstPackGrid
    xc::ExchangeCorrelationFunctional
    pseudization::Pseudization
end
struct EosFittingSettings <: CalculationSettings
    scf::ScfSettings
    pressures::Vector{<:Number}
    init_params::EquationOfStateOfSolidsParameters
end
struct VDosSettings <: CalculationSettings
    qmesh::MonkhorstPackGrid
    dosmesh::MonkhorstPackGrid
end
