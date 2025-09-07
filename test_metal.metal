// Minimal Metal shader for sanity checks
#include <metal_stdlib>
using namespace metal;

kernel void add_arrays(const device float* inA [[ buffer(0) ]],
                       const device float* inB [[ buffer(1) ]],
                       device float* out   [[ buffer(2) ]],
                       uint gid            [[ thread_position_in_grid ]])
{
  out[gid] = inA[gid] + inB[gid];
}

