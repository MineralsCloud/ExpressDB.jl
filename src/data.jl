using ChemicalFormula: Formula, unicode
using CrystallographyBase: Cell, MonkhorstPackGrid, cellvolume
using EquationsOfState: EquationOfStateOfSolidsParameters
using Pseudopotentials: ExchangeCorrelationFunctional, Pseudization
using Query: @from, @unique
using UUIDs: UUID, uuid4

export UniqueData, Crystal, ScfSettings, EosFittingSettings, VDosSettings, Calculation
export maketable

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
    pressures::Vector
    init_params::EquationOfStateOfSolidsParameters
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

function maketable(data::AbstractVector{Crystal})
    return @from datum in data begin
        @select {
            formula = unicode(datum.formula),
            volume = cellvolume(datum.structure),
            datum.pointgroup,
            spacegroup = Int16(datum.spacegroup),
        }
    end
end
function maketable(data::AbstractVector{ScfSettings})
    return @from datum in data begin
        @let kmesh = datum.kmesh
        @select {
            datum.ecutwfc,
            grid = Int.(kmesh.mesh),
            shift = Int.(kmesh.isdatumshift),
            datum.xc,
            datum.pseudization,
        }
    end
end
function maketable(data::AbstractVector{EosFittingSettings})
    t = @from datum in data begin
        @from pressure in datum.pressures
        @let scf = datum.scf
        @select {
            pressure,
            grid = Int.(scf.kmesh.mesh),
            shift = Int.(scf.kmesh.is_shift),
            scf.xc,
            scf.pseudization,
        }
    end
    return t |> @unique()
end
