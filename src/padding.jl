export pad_constant

"""
    pad_constant(x, pad::Tuple, val=0; [dims])

Pad the array `x` with the constant value `val`.

`pad` is a tuple of integers `(l1, r1, ..., ln, rn)`
of some length `2n` specifying the left and right padding size
in each of the dimensions in `dims`.

If `dims` is not given, it defaults to the first `n` dimensions.  
"""
function pad_constant(x::AbstractArray, pad::NTuple{N,Int}, val=0; 
                    dims=1:N÷2) where N
  length(dims) == N÷2 ||
    throw(ArgumentError("The number of dims should be equal to the number of padding dimensions"))
  for (i, d) in enumerate(dims)
    x = pad_constant(x, (pad[2i-1], pad[2i]), val; dims=d)
  end  
  return x
end

function pad_constant(x::AbstractArray, pad::NTuple{2,Int}, val=0; 
                    dims::Int=1)
  sz = size(x)
  l, r = pad
  szl = (sz[1:dims-1]..., l, sz[dims+1:end]...)
  szr = (sz[1:dims-1]..., r, sz[dims+1:end]...) 
  xl = fill!(similar(x, eltype(x), szl), val)
  xr = fill!(similar(x, eltype(x), szr), val)
  return cat(xl, x, xr, dims=dims) 
end
