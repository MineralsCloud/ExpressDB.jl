using ChemicalFormula: unicode
using CrystallographyBase: cellvolume
using Query: @from, @unique

export maketable

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
