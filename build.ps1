if(!(Test-Path "bin")) {
    mkdir "bin"
}

if(!(Test-Path "obj")) {
    mkdir "obj"
}

if(!(Test-Path "winrt")) {
    Write-Host
    Write-Host "Generating Windows Runtime include files..."
    Write-Host

    .\tools\cppwinrt.exe -v -input local

    Write-Host
}

Write-Host "Generating .winmd..."
Write-Host

.\build-midl.ps1

Write-Host
Write-Host "Generating code..."
Write-Host

.\tools\cppwinrt.exe -v -input .\CppWinRTTest.winmd -reference local -component .

if($LASTEXITCODE -ne 0) {
    Write-Error "Build failed!"
    return;
}

Write-Host
Write-Host "Compiling code..."
Write-Host

cd "obj"
cl /c /nologo /EHsc /std:c++17 /Ycpch.h /Zi /await (ls -Recurse ../*.cpp)
cd ..

if($LASTEXITCODE -ne 0) {
    Write-Error "Build failed!"
    return;
}

Write-Host
Write-Host "Linking..."

link /NOLOGO (ls -Recurse "obj/*.obj") windowsapp.lib /MACHINE:x86 /DEBUG /OUT:"bin/CppWinRTTest.exe" /PDB:"bin/CppWinRTTest.pdb"

if($LASTEXITCODE -ne 0) {
    Write-Error "Build failed!"
    return;
}

Write-Host
Write-Host "CppWinRTTest > bin\CppWinRTTest.exe"
Write-Host
Write-Host "Build succeeded!"


