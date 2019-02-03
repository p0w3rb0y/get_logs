function Get-Logs {
    <#
    .SYNOPSIS
    Searches for Regex strings in remote logs
    
    .DESCRIPTION
    Searches for logs on remote hosts for a defined regex, due to time constraints it will not ask you for credentials, you will have to run from with your local creds. It will not run in parallel.
    
    .PARAMETER ComputerName
    Computer name in fqdn
    
    .PARAMETER inpath
    The path of the logs on the remote server
    
    .PARAMETER Regex
    The regex parameters you want to search for
            
    .EXAMPLE
    get-logs -ComputerName server1.contoso.com,server2.contoso.com,server3.contoso.com,server4.contoso.com -inpath c:\temp -regex [1-9]
    
    .NOTES
    2019-01-31 - Rui Duarte
    #>
    [cmdletbinding()]
    Param ( 
        [parameter(Mandatory = $true, HelpMessage = "Computer name in fqdn")]
        [string[]]$ComputerName,
        
        [parameter(Mandatory = $true, HelpMessage = "type the path where the script will look for logs on the remote server")]
        [string[]]$inpath,
        
        [parameter(Mandatory = $true, HelpMessage = "type the Regex string that you need to search in the logs")]
        [ValidateNotNullorEmpty()]
        [string]$regex
    )

    $DateStr = (Get-date).ToString("yyMMdd")
    $outfile = "c:\output_logs\logs$DateStr.txt"

    #creates Destination for logs in local disk if it doesn't exist
    try {
        Get-ChildItem $outfile -ErrorAction Stop
    }
    catch {
        Write-Host 'Creating Log repository'
        New-Item $outfile -Force
    }

    #Gets a list of files that are in the log path
    foreach ($computer in $ComputerName) {
        $session = New-PSSession -ComputerName $Computer
        $scriptblockinpath = "Get-ChildItem -Path $inpath"
        Get-job | Remove-Job     
        Invoke-Command -Session $session {param($inpath) Get-ChildItem -Path $inpath -ErrorAction SilentlyContinue } -ArgumentList $inpath -AsJob
        $logs = get-job | wait-job | Receive-Job -keep
        #Gets the content of the logs
        if ($Logs) {    
            Get-job | Remove-Job
            Invoke-Command -Session $session {param($logs, $regex, $computer) get-content -Path $logs.FullName -ErrorAction SilentlyContinue | Select-String -Pattern $regex | ForEach-Object {"$computer " + $_ } }-ArgumentList $logs, $regex, $computer -AsJob #| Out-File -filepath $outfile -Force -Append 
            get-job | wait-job | Receive-Job -keep | Out-File -filepath $outfile -Force -Append
            $session | Remove-PSSession
        }
    }
}