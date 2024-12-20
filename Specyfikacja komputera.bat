@echo off
title Computer Specifications
echo.
echo Gathering computer specifications...
echo.

set RAM=0
set GPU_RAM=0
set GPU=
set RAM_SPEED=0

for /f "tokens=2 delims==" %%a in ('wmic cpu get name /format:list ^| findstr /i "Name"') do set CPU=%%a

rem Use PowerShell to get total RAM in GB
for /f "tokens=*" %%a in ('powershell -command "(Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB"') do set RAM=%%a

rem Use PowerShell to get the name and memory of the graphics card
for /f "tokens=*" %%a in ('powershell -command "Get-WmiObject Win32_VideoController | Select-Object -ExpandProperty Name"') do (
    set GPU=%%a
)

for /f "tokens=*" %%a in ('powershell -command "Get-WmiObject Win32_VideoController | Measure-Object -Property AdapterRAM -Sum | ForEach-Object { [math]::round($_.Sum / 1GB) }"') do (
    set /a GPU_RAM=%%a
)

rem Get RAM speed
for /f "tokens=*" %%a in ('powershell -command "Get-WmiObject Win32_PhysicalMemory | Select-Object -ExpandProperty Speed"') do (
    set RAM_SPEED=%%a
)

for /f "tokens=2 delims==" %%a in ('wmic os get caption /format:list ^| findstr /i "Caption"') do set OS=%%a
for /f "tokens=2 delims==" %%a in ('wmic baseboard get product /format:list ^| findstr /i "Product"') do set Motherboard=%%a

rem Display the results
echo.
echo Operating System: %OS%
echo Processor Model: %CPU%
echo Motherboard: %Motherboard%
echo RAM: %RAM% GB %RAM_SPEED% MHz
echo Graphics Card: %GPU% %GPU_RAM% GB
echo.

pause
exit