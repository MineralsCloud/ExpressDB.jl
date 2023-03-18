@testset "Test distances between dictionaries" begin
    x = Dict('a' => 10, 'b' => 3, 'c' => 5)
    y = Dict('a' => 8, 'c' => 3, 'e' => 8)
    @test distance(x, y) == 9
end

@testset "Test distances between formulae" begin
    x = Formula("H2O")
    y = Formula("H2S")
    @test distance(x, y) == √2
end
