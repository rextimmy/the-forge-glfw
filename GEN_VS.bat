@echo off

echo 1) Vulkan 1.1
echo 2) Direct3D 12
CHOICE /C 12 /M "Select a Renderer API:"

IF ERRORLEVEL 2 GOTO D3D12
IF ERRORLEVEL 1 GOTO VK

:VK
set RENDERER=-DD3D12=OFF -DVULKAN=ON
goto BUILD
:D3D12
set RENDERER=-DD3D12=ON -DVULKAN=OFF
goto BUILD

:BUILD
echo %RENDERER%
cd "build"
cmake ../ -G "Visual Studio 15 2017" -A x64 %RENDERER%

pause
exit /b 0
