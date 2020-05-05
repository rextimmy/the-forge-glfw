@echo off

Parser ./demo_vs.hlsl -vs -E main -Fo ../d3d12/demo.vert -hlsl
Parser ./demo_fs.hlsl -fs -E main -Fo ../d3d12/demo.frag -hlsl

Parser ./demo_vs.hlsl -vs -E main -Fo ../vulkan/demo.vert -glsl
Parser ./demo_fs.hlsl -fs -E main -Fo ../vulkan/demo.frag -glsl

pause
exit /b 0
