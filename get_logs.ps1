function Get-Logs {
    <#
    .SYNOPSIS
    Searches for Regex line in remote logs
    
    .DESCRIPTION
    Searches for logs on remote hosts for a defined regex
    
    .PARAMETER ComputerName
    Computer name in fqdn
    
    .PARAMETER Path
    The path of the logs
    
    .PARAMETER Regex
    The regex parameters you want to search for
    
    .PARAMETER vCenterCred
    Credentials for vCenter. Most likely IDLDAP/EU
    
    .PARAMETER GuestCred
    Guest credentials. Most likely Cloud/EU
    
    .EXAMPLE
    Invoke-Script -Computer TestServer01 -vCenter vCenter001 -Script "Chef-Client" -vCenterCred $Cred1 -GuestCred $Cred2
    
    .NOTES
    2019-01-31 - Rui Duarte
    #>
    [cmdletbinding()]
    Param ( 
        [parameter(Mandatory = $true)]
        [string[]]$ComputerName,
        
        [parameter(Mandatory = $true)]
        [string[]]$path,
        
        [parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [string]$regex,

        [Parameter(Mandatory = $false)]
        [pscredential]$outpath
    )
    
               
    Process {
        ForEach ($Computer in $ComputerName) {
            Invoke-Command -ComputerName $computer -ScriptBlock {get-content -Path $path }
        }
    }

    end {
        Disconnect-VIServer -Force -Confirm:$false             
    }
}
