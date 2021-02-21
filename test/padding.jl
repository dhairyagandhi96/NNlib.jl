@testset "padding constant" begin
  x = rand(2, 2, 2)  
  
  y = @inferred pad_constant(x, (3, 2, 4, 5))
  @test size(y) == (7, 11, 2)
  @test y[4:5, 5:6, :] ≈ x
  y[4:5, 5:6, :] .= 0
  @test all(y .== 0)

  y = @inferred pad_constant(x, (3, 2, 4, 5), 1.2, dims=(1,3))
  @test size(y) == (7, 2, 11)
  @test y[4:5, :, 5:6] ≈ x
  y[4:5, :, 5:6] .= 1.2
  @test all(y .== 1.2)

  gradtest(x -> pad_constant(x, (2,2,2,2)), rand(2,2,2))
end

@testset "padding repeat" begin
  x = rand(2, 2, 2)  
  
  # y = @inferred pad_repeat(x, (3, 2, 4, 5))
  y = pad_repeat(x, (3, 2, 4, 5))
  @test size(y) == (7, 11, 2)
  @test y[4:5, 5:6, :] ≈ x

  # y = @inferred pad_repeat(x, (3, 2, 4, 5), dims=(1,3))
  y = pad_repeat(x, (3, 2, 4, 5), dims=(1,3))
  @test size(y) == (7, 2, 11)
  @test y[4:5, :, 5:6] ≈ x

  @test pad_repeat(reshape(1:9, 3, 3), (1,2)) ==
        [1  4  7
        1  4  7
        2  5  8
        3  6  9
        3  6  9
        3  6  9]
    
  @test pad_repeat(reshape(1:9, 3, 3), (2,2), dims=2) ==
       [1  1  1  4  7  7  7
        2  2  2  5  8  8  8
        3  3  3  6  9  9  9]

  gradtest(x -> pad_repeat(x, (2,2,2,2)), rand(2,2,2))
end


