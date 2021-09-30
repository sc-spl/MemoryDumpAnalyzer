if not exist "%1-output" mkdir "%1-output"

set outputFolder=%1-output

powershell -ExecutionPolicy RemoteSigned -Command "%~dp0\AnalyzeMemoryDump.ps1 -commandsFolderName %~dp0\Commands -pathToDumpFile %1 -outputFolderName %outputFolder% -runInParallel"