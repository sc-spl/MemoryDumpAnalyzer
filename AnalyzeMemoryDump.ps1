﻿[CmdletBinding()]
param
(
    [Parameter(mandatory=$true)]
    [string] $pathToDumpFile,
    [string] $commandsFolderName = ".\Commands",
    [string] $outputFolderName = ".\Output",
    [string] $pathToSymbols = "C:\symbols",
    [string] $pathToCDB = "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\cdb.exe",
    [string] $pathToSOS = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\sos.dll",
    [string] $pathToSOSEX = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\sosex.dll",
    [string] $pathToNetExt = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\netext.dll",
    [bool]   $clearOutputFolder = $true,
    [switch] $runInParallel = $false
)

function RunCommandAndSaveOutput([string] $pathToDump, [string] $command, [string] $pathToOutputFile, [string] $pathToNetExtIndex, [bool] $runInBackground)
{
    $command = ReplaceKnownVariables -command $command

    $wrappedCommand = "`".load $pathToSOS;.load $pathToSOSEX;.load $pathToNetExt;!symfix;.reload;!windex /load $pathToNetExtIndex;.logopen $pathToOutputFile;$command;.logclose;q`"";

    if($runInBackground -eq $true)
    {
        $arguments = @("-z", $pathToDump, "-y", $pathToSymbols, "-c", $wrappedCommand)
        Start-Process -WindowStyle hidden -FilePath $pathToCDB -ArgumentList $arguments;    
    }
    else
    {
        & $pathToCDB -z $pathToDump -y $pathToSymbols -c $wrappedCommand
    }
}

function ReplaceKnownVariables([string] $command)
{
    $command = $command.Replace('$pathToDumpFile', $pathToDumpFile);
    $command = $command.Replace('$commandsFolderName', $commandsFolderName);
    $command = $command.Replace('$outputFolderName', $outputFolderName);
    return $command;
}

function RunCommandsFromFolder([string] $pathToDump, [string] $commandsFolderName, [string] $outputFolderName)
{
    #create NetExt index
    $pathToNetExtIndex = $pathToDump + ".idx"
	RunCommandAndSaveOutput -pathToDump $pathToDump -command "!windex /save $pathToNetExtIndex" -runInBackground $false

    #create output folder
    if ($clearOutputFolder -eq $true)
    { 
        Remove-Item -Path $outputFolderName -Force -Recurse -ErrorAction Ignore
    }

    New-Item -ItemType directory -Path $outputFolderName -ErrorAction Ignore

    $outputFolderName = (Resolve-Path -Path $outputFolderName).Path

    #executing commands
    $commandFiles = Get-ChildItem $commandsFolderName"\*.txt" | Select-Object
	
    foreach ($file in $commandFiles)
    {
        $commandContent = Get-Content $file.FullName
        $outputFile = $outputFolderName + "\output-" + $file.Name

        RunCommandAndSaveOutput -pathToDump $pathToDump -command $commandContent -pathToOutputFile $outputFile -pathToNetExtIndex $pathToNetExtIndex -runInBackground $runInParallel.IsPresent
    }
}

RunCommandsFromFolder -pathToDump $pathToDumpFile -commandsFolderName $commandsFolderName -outputFolderName $outputFolderName