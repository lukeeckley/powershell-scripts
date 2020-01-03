#
# Install Remote Server Administration Tools (RSAT) in Windows 10 
# Luke Eckley 12/2019
#
# WARNING: This script performs extra steps to access Windows Update Online and avoid using WSUS. 
#          If you can access Windows Update you only need to run the following:
#          Get-WindowsCapability -name RSAT* -Online | Add-WindowsCapability -Online
#

# Run "As Admin"
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
 }
}

# Download directly from Windows Update and not WSUS
$ServicingPath = “HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Servicing”
If (!(Test-Path -Path $ServicingPath)) {
    New-Item -Path $ServicingPath
    New-ItemProperty -Path $ServicingPath -PropertyType DWord -Name "RepairContentServerSource” -Value 2
} Else {
    Set-ItemProperty -Path $ServicingPath -Name “RepairContentServerSource” -Value 2
}

# Install *ALL* RSAT packages
Get-WindowsCapability -name RSAT* -Online | Add-WindowsCapability -Online

# Revert changes to Windows Update settings. Uncomment to revert changes back to prevent computer from accessing
# Windows Update Online
#Remove-Item -Path $ServicingPath
