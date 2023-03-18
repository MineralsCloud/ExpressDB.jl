function distance(x::AbstractDict, y::AbstractDict)
    keys₁, keys₂ = keys(x), keys(y)
    common_keys = keys₁ ∩ keys₂
    distinct_keys = symdiff(keys₁, keys₂)
    # Euclidean distance for common keys
    distance = sum(abs2, x[key] - y[key] for key in common_keys)
    # Sum of absolute differences for non-overlapping keys
    for key in distinct_keys
        distance += key in keys₁ ? x[key]^2 : y[key]^2
    end
    return sqrt(distance)
end
