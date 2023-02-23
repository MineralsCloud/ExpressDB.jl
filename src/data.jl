using ChemicalFormula: Formula
using CrystallographyBase: Cell, MonkhorstPackGrid
using EquationsOfStateOfSolids: Parameters
using Pseudopotentials: ExchangeCorrelationFunctional, Pseudization
using UUIDs: UUID, uuid4

import DataFrames: DataFrame

export UniqueData, Crystal, ScfSettings, EosFittingSettings, VDosSettings, Calculation

abstract type Data end
struct UniqueData{T<:Data} <: Data
    id::UUID
    data::T
end
UniqueData(data::Data) = UniqueData(uuid4(), data)
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
    init_params::Parameters
end
struct VDosSettings <: CalculationSettings
    qmesh::MonkhorstPackGrid
    dosmesh::MonkhorstPackGrid
end
abstract type CalculationOutput <: Data end
mutable struct Calculation <: Data
    material::Material
    settings::CalculationSettings
    output::CalculationOutput
end

function DataFrame(data::Data)
    return DataFrame(Dict(f => getfield(data, f) for f in propertynames(data)))
end
