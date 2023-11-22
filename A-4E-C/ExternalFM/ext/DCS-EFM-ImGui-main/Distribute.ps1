# DISTRIBUTE.PS1|CREATED 23-JUN-2022|LAST MODIFIED 23-JUN-2022

# Once the CMake project is generated and built using Visual Studio you may use
# this scrip to create a archival release.

Param(
	[Switch]$verbose,
	[String]$version
)

Set-Variable scriptName -Option Constant -Value $MyInvocation.MyCommand.Name
Set-Variable scriptDir -Option Constant -Value $PSScriptRoot
$logFile = $scriptDir + "\" + $scriptName + ".log"

Function Get-Usage {
	$errorMessage = $scriptName + ": -version [-verbose]"
	Write-Error $errorMessage
}

If ($version -Eq $null -Or $version -Eq "") {
	Get-Usage
	Exit 1
}

echo "" *> $logFile
Write-Host "Packing Distribution." *>> $logFile

$distributeDir = $scriptDir + "\Distribute\FmGui-" + $version
$distributeDirLib = $distributeDir + "\lib"
$distributeDirInclude = $distributeDir + "\include"

# New-Item -ItemType Directory -Force -Path ".\Build" *>> $logFile
# Set-Location ".\Build"
# cmake.exe ..
# MSBuild
# Set-Location ".\.."

New-Item -ItemType Directory -Force -Path $distributeDir *>> $logFile
New-Item -ItemType Directory -Force -Path $distributeDirLib *>> $logFile
New-Item -ItemType Directory -Force -Path $distributeDirInclude *>> $logFile

Copy-Item .\Include\FmGui.hpp -Destination $distributeDirInclude *>> $logFile
Copy-Item .\Build\Release\* -Destination ($distributeDirLib + "\release") *>> $logFile
Copy-Item .\Build\Debug\* -Destination ($distributeDirLib + "\debug") *>> $logFile

Copy-Item .\README.md -Destination $distributeDir *>> $logFile
Copy-Item .\LICENSE.txt -Destination $distributeDir *>> $logFile
Copy-Item .\CHANGELOG.md -Destination $distributeDir *>> $logFile

Compress-Archive -Literal $distributeDir -Force -Destination ($distributeDir + ".zip")

Write-Host "Distribution Successful." *>> $logFile

If ($verbose) {
	Get-Content $logFile
}

Exit 0
