$ref = (ls "C:\Windows\System32\WinMetadata\*.winmd") | %{ "/reference" + $_.FullName }
cd "obj"
foreach ($idl in ls "..\*.idl") {
    midl /winrt /metadata_dir "C:\Windows\System32\WinMetadata" /h "nul" /nomidl $ref $idl

    if($LASTEXITCODE -ne 0) {
        Write-Error "Build failed!"
        return;
    }
}

mdmerge /metadata_dir "C:\Windows\System32\WinMetadata" /partial /i . /o ..\
if($LASTEXITCODE -ne 0) {
    Write-Error "Build failed!"
    return;
}

cd ..