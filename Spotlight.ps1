#
#
# Spotlight.ps1 - Copy any new Spotlight photos from Microsoft to a folder on the desktop.
# Why?: I like to set these photos as my desktop background :)
# Notes: I am making the new file names the MD5 Hash of the file. I just need them to be unique and shorter than the default
#        file name.
# 
#

Add-Type -AssemblyName System.Drawing

$SourceDir = "$($env:LOCALAPPDATA)\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\"
$SourceFiles = Get-ChildItem -Path $SourceDir

$DestDir = "$($env:USERPROFILE)\Desktop\Spotlight\"
If (!(Test-Path -Path "$($DestDir)")) {
    New-Item -ItemType Directory -Force -Path "$($DestDir)"
}

$DestFiles = Get-ChildItem -Path $DestDir

$NewPicCount = 0

Foreach ($File in $SourceFiles) {
    $FilePath = "$($SourceDir)$($File.Name)"
    $JPG = New-Object System.Drawing.Bitmap $FilePath
    If ($JPG.Width -gt 1900) {                
        $MD5Hash = (Get-FileHash $FilePath -Algorithm MD5).Hash
        If (!(Test-Path -Path "$($DestDir)$($MD5Hash).jpg")) {            
            Copy-Item $FilePath -Destination "$($DestDir)$($MD5Hash).jpg"
            #Write-Host "Copied new wallpaper to $($DestDir)$($MD5Hash).jpg"
            $NewPicCount++
        }            
    }
}

If ($NewPicCount -gt 0) {
    $wshell = New-Object -ComObject Wscript.Shell
    [void]$wshell.Popup("Copied $NewPicCount New Spotlight Photos",0,"Done",64+0)
}
