# NeoVim's Setup Utils on Windows
# Le Tan (tamlokveer at gmail.com)
# https://github.com/tamlok/tnvim

param([switch]$Force=$false, [string]$WorkingDirectory='')

function Main
{
    Write-Host 'Welcome! Let me help you setup NeoVim on Windows'

    if ($WorkingDirectory -ne '') {
        Set-Location -Path "$WorkingDirectory"
    }

    Write-Host "Working directory is" (Get-Location).Path

    Check-Admin

    Print-Usage

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $action = Get-Action

    switch ($action) {
        1 { Install-Neovim }
        2 { Setup-Neovim }
        3 { Write-Host 'Bye!'; exit 0 }
        default {Write-Error 'Invalid action'; exit -1}
    }
}

function Print-Usage
{
    Write-Host "Usage:"
    Write-Host "-Force: force to update configurations"
    Write-Host ""
}

function Get-Action
{
    Write-Host ''
    Write-Host 'Actions:'
    Write-Host '1. Install Neovim'
    Write-Host '2. Setup Neovim'
    Write-Host '3. Exit'
    Write-Host ''

    $action = Read-Host -Prompt 'Please choose the right action to perform'

    return $action
}

function Install-Neovim
{
    Write-Host ''
    Write-Host '==Install Neovim=='
    $targetLocation = Read-Host -Prompt 'Enter the location you want to put Neovim'
    if ($targetLocation -eq "" -or !(Test-Path -Path $targetLocation)) {
        Write-Error "Target location does not exist $targetLocation"
        exit -1
    }


    $release = Get-Neovim-Latest-Release
    Write-Host 'Downloading latest Neovim...'

    $targetZipFile = $env:TEMP + '\' + $release.File
    Invoke-WebRequest -Uri $release.Url -OutFile $targetZipFile -UseBasicParsing

    $targetFolder = $targetLocation + '\nvim-win64'
    if (Test-Path -Path $targetFolder) {
        Write-Host "Target folder $targetFolder exists and will be removed"

        Remove-Directory-Recursively $targetFolder
    }

    if (!(Unzip-Neovim $targetZipFile $targetLocation -Force)) {
        Remove-Item $targetZipFile -Force
        Write-Error "Failed to unzip $targetZipFile to $targetFolder"
        exit -1
    }

    Remove-Item $targetZipFile -Force

    Add-Nvim-Bat $targetFolder

    Add-Neovim-To-Path $targetFolder

    Add-Neovim-To-Context-Menu $targetFolder
}

function Get-Neovim-Latest-Release
{
    $file = 'nvim-win64.zip'
    $regularExp = '"browser_download_url":"(https://github.com/neovim/neovim/releases/[^"]+/' + $file + ')"'
    $url = 'https://api.github.com/repos/neovim/neovim/releases/latest'
    $content = Invoke-WebRequest -Uri $url -UseBasicParsing
    $match = $content -match $regularExp
    if (!$match) {
        Write-Error "Failed to fetch information of Neovim releases"
        exit -1
    }

    $release = New-Object PSObject | Select-Object Url, File
    $release.Url = $Matches[1]
    $release.File = $file

    return $release
}

function Unzip-Neovim
{
    Param([string]$zipFile, [string]$outputFolder)
    $ret = Expand-Archive $zipFile -DestinationPath $outputFolder
    return $true
}

function Add-Nvim-Bat
{
    Param([string]$nvimFolder)

    $cmd = '@start nvim-qt.exe %*'
    $destinationFile = "$nvimFolder\bin\qvim.bat"
    Out-File -Encoding ascii -LiteralPath $destinationFile -InputObject $cmd
}

function Add-Neovim-To-Path
{
    Param([string]$nvimFolder)

    $oldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path

    $binFolder = "$nvimFolder\bin"
    if (!$oldPath.contains($binFolder)) {
        if ($oldPath.EndsWith(';')) {
            $newPath = "$oldPath$binFolder"
        } else {
            $newPath = "$oldPath;$binFolder"
        }

        Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value "$newPath"
    }

    Write-Host "Added NeoVim to Path $nvimFolder"
}

function Add-Neovim-To-Context-Menu
{
    Param([string]$nvimFolder)

    $neovimKeyStr = 'Registry::HKEY_CLASSES_ROOT\*\shell\Neovim'
    if ((Get-Item -LiteralPath "$neovimKeyStr") -eq $null) {
        Write-Host "Create registry key $neovimKeyStr"
        New-Item "$neovimKeyStr" > $null
    }

    $displayName = 'Edit with Neovim'
    Set-ItemProperty -LiteralPath "$neovimKeyStr" -Name '(Default)' -Value "$displayName"
    $icon = "`"$nvimFolder\bin\nvim-qt.exe`""
    Set-ItemProperty -LiteralPath "$neovimKeyStr" -Name 'Icon' -Value "$icon"

    $commandKeyStr = "$neovimKeyStr\command"
    if ((Get-Item -LiteralPath "$commandKeyStr") -eq $null) {
        Write-Host "Create registry key $commandKeyStr"
        New-Item "$commandKeyStr" > $null
    }

    $command = "`"$nvimFolder\bin\nvim-qt.exe`" `"%1`""
    Set-ItemProperty -LiteralPath "$commandKeyStr" -Name '(Default)' -Value "$command"
}

function Remove-Directory-Recursively
{
    Param([string]$directory)

    if (!(Test-Path -Path "$directory")) {
        return
    }

    Get-ChildItem -Path "$directory" -Recurse | Remove-Item -Recurse
    Remove-Item "$directory" -Recurse
}

function Run-As-Admin
{
    Param([string]$command)

    $myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent();
    $myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID);
    $adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator;

    if ($myWindowsPrincipal.IsInRole($adminRole)) {
        Invoke-Expression $command
    } else {
        $cmd = "& '$command'"
        Start-Process "$PSHome\powershell.exe" -Wait -Verb RunAs -WorkingDirectory (Get-Location).Path -ArgumentList $cmd
    }
}

function Setup-Neovim
{
    Write-Host ''
    Write-Host '==Setup Neovim=='

    $vimBinFolder = Get-Neovim-Folder
    $vimFilesFolder = $env:USERPROFILE + '\AppData\Local\nvim'
    $vimUtilsFolder = (Get-Item "$vimBinFolder").Parent.FullName + '\share\nvim\runtime\tnvim_utils'

    Do-Setup-Neovim $vimBinFolder $vimFilesFolder $vimUtilsFolder
}

function Get-Neovim-Folder
{
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

    $nvim = Get-Command 'nvim' -ErrorAction SilentlyContinue
    if ($nvim -eq $null) {
        Write-Host "Failed to locate Neovim"
        exit -1
    }

    $nvimFolder = (Get-Item $nvim.Path).Directory.FullName

    Write-Host "Neovim is found in $nvimFolder"
    return $nvimFolder
}

function Do-Setup-Neovim
{
    param([string]$binFolder, [string]$filesFolder, [string]$utilsFolder)

    robocopy ".\" "$filesFolder" /E /MT /XD .git > $null
}

function Check-Admin
{
    $myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent();
    $myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID);
    $adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator;

    if ($myWindowsPrincipal.IsInRole($adminRole)) {
        return
    } else {
        Write-Host "Continue as Administrator"

        $arguments = "-NoExit -ExecutionPolicy Bypass -File `"$PSCommandPath`""
        if ($Force) {
            $arguments += ' -Force'
        }
        $arguments += " -WorkingDirectory `"" + (Get-Location).Path + '"'

        Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments
        exit 0
    }
}

Main
