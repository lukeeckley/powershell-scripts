#
# Office 365 Authentication Examples
#
# Copy and Paste the example needed. This will allow you to re-run scripts
# without being prompted for credentials or creating a new session every time.
#
# The connection behaves differently depending on whether using the ISE or
# running in a console window.
#   

#
# This is connecting to Exchange Online
#
# Check if running in a console window or ISE
If ($host.name -eq 'ConsoleHost') { # Running in console
    If ($global:Office365Creds -and $global:PSSession) {
        # Already have creds and session
        Import-PSSession $global:PSSession -DisableNameChecking -AllowClobber -Verbose:$False | Out-Null
    } Else {
        # Create creds and session
        $User=$env:username
        $UserUPN=Get-ADUser $User | Select-Object -ExpandProperty UserPrincipalName
        $global:Office365Creds = $host.ui.PromptForCredential("","Please enter your Office 365 Credentials","$UserUPN","")
        $global:PSSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $Office365Creds -Authentication Basic -AllowRedirection:$True
        Import-PSSession $global:PSSession -DisableNameChecking -AllowClobber -Verbose:$False | Out-Null
    }
} Else { # Running in ISE
    $User=$env:username
    $UserUPN=Get-ADUser $User | Select-Object -ExpandProperty UserPrincipalName
    If (-Not (Test-Path variable:Office365Creds)) {
        $Office365Creds = $host.ui.PromptForCredential("","Please enter your Office 365 Credentials","$UserUPN","")
    }

    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $Office365Creds -Authentication Basic -AllowRedirection:$True
    Import-PSSession $Session -DisableNameChecking -AllowClobber -Verbose:$False | Out-Null
}       

#
# This is connecting to Security and Compliance
#
# Check if running in a console window or ISE
If ($host.name -eq 'ConsoleHost') { # Running in console
    If ($global:Office365Creds -and $global:PSSession) {
        # Already have creds and session
        Import-PSSession $global:PSSession -DisableNameChecking -AllowClobber -Verbose:$False | Out-Null
    } Else {
        # Create creds and session
        $User=$env:username
        $UserUPN=Get-ADUser $User | Select-Object -ExpandProperty UserPrincipalName
        $global:Office365Creds = $host.ui.PromptForCredential("","Please enter your Office 365 Credentials","$UserUPN","")
        $global:PSSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $Office365Creds -Authentication Basic -AllowRedirection:$True
        Import-PSSession $global:PSSession -DisableNameChecking -AllowClobber -Verbose:$False | Out-Null
    }
} Else { # Running in ISE
    $User=$env:username
    $UserUPN=Get-ADUser $User | Select-Object -ExpandProperty UserPrincipalName
    If (-Not (Test-Path variable:Office365Creds)) {
        $Office365Creds = $host.ui.PromptForCredential("","Please enter your Office 365 Credentials","$UserUPN","")
    }

    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $Office365Creds -Authentication Basic -AllowRedirection:$True
    Import-PSSession $Session -DisableNameChecking -AllowClobber -Verbose:$False | Out-Null
}
