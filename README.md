# MemoryDumpAnalyzer
Powershell script for running most common windbg commands against memory dump file and saving the output. 

## Prerequisites

Requires CDB installed. Can be downloaded from here: https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/

Expects that you have SOSEX and NetExt.

## How it works

The script takes commands from *Commands* folder and executes them one by one against memory dump file. Output of the command execution is saved to the *output-commandFileName.txt* file in the *Output* folder. One can add custom commands to the folder or disable existing ones (only files with .txt extension are picked up). If several commands are present in the file, they should be separated by a semicolon symbol.

Example of the command file content (wda.txt):

```
!wdae
```

SOS, SOSEX and NetExt are loaded by default, so you don't need to worry about it. Also, NetExt index is built and saved to the same folder as memory dump. 

```
Note 1: SOSEX index is not built by default since there are no out of the box commands which utilize it.
```

```
Note 2: Output folder is cleared by default. Use clearOutputFolder parameter if the behavior is not desired.
```



## Usage examples

Analyze using default settings:

```powershell
.\AnalyzeMemoryDump.ps1 -pathToDumpFile "C:\TempDownloads\w3wp.DMP"
```

Analyze and save the output to specific folder:

```powershell
.\AnalyzeMemoryDump.ps1 -pathToDumpFile "C:\TempDownloads\w3wp.DMP" -outputFolderName "C:\TempDownloads\Output"
```

Run the operations in parallel:

```powershell
.\AnalyzeMemoryDump.ps1 -pathToDumpFile "C:\TempDownloads\w3wp.DMP" -runInParallel
```

Do not clear the output folder before adding new files:

```powershell
.\AnalyzeMemoryDump.ps1 -pathToDumpFile "C:\TempDownloads\w3wp.DMP" -clearOutputFolder $false
```

There are also the following parameters which define the locations of the files on your machine:

```powershell
-pathToSymbols "C:\symbols"
-pathToCDB "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\cdb.exe"
-pathToSOS "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\sos.dll"
-pathToSOSEX "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\sosex.dll"
-pathToNetExt "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\netext.dll"
```

