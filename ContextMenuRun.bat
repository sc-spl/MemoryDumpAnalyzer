if not exist "%1-output" mkdir "%1-output"

set outputFolder=%1-output

powershell -ExecutionPolicy RemoteSigned -Command "C:\Code\MemoryDumpAnalyzer\AnalyzeMemoryDump.ps1 -commandsFolderName C:\Code\MemoryDumpAnalyzer\Commands -pathToDumpFile %1 -outputFolderName %outputFolder% -runInParallel"