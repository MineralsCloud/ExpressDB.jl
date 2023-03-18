@testset "Test distances between dictionaries" begin
    x = Dict('a' => 10, 'b' => 3, 'c' => 5)
    y = Dict('a' => 8, 'c' => 3, 'e' => 8)
    @test distance(x, y) == 9
end
