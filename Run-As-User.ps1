# Run-As-User
# Run a scriptblock as another user. I have tried to make this script as robust as possible.

# Creds
# Prepopulating the username field
$User = $env:UserName
$Domain = $env:UserDomain
$FirstName = Get-ADUser $User | Select-Object -ExpandProperty GivenName
$AltUser = "$($Domain)\$($FirstName)DA"
# Useful to keep the $AltCreds variable to re-run this script without having to enter credentials.
If (-Not (Test-Path variable:AltCreds)) {
    $AltCreds = $Host.UI.PromptForCredential("","Please enter your Credentials","$AltUser","")
}

function Retry-Creds
{
    $AltCreds = $Host.UI.PromptForCredential("","Please enter your Credentials","$AltUser","")
    Run-Scriptblock
}

# Scriptblock
$commands = @'    
    $UserName = ($env:UserName).Trim()
    $UserDomain = ($env:UserDomain).Trim()
    Write-Host "whoami: $UserDomain\$UserName"        
    Get-ADUser $Username
    pause
'@

# Run the scriptblock with $AltCreds
# -PassThru returns a process object for each spawned process. This allows us to WaitForExit() on the spawned process
# NOTE: Add -WindowStyle Hidden to Start-Process to hide the new powershell process. This scriptblock will execute but we won't see anything.
function Run-Scriptblock
{
    Try
    {
        $AltPowershell = Start-Process $PSHOME\powershell.exe -LoadUserProfile -Credential $AltCreds -ArgumentList '-Command', $commands -WorkingDirectory 'C:\Windows\System32' -PassThru
        $AltPowershell.WaitForExit()
    }
    Catch
    {
        If ($_.Exception.Message -eq "This command cannot be run due to the error: The user name or password is incorrect.")
        {
            Retry-Creds
        }
        Else
        {
            Write-Host "ERROR: $($_.Exception.Message)"
        }
    }
}

Run-Scriptblock
