$ComputerName = 'server1'
$inpath = 'C:\test'
$DateStr = (Get-date).ToString("yyMMdd")
$outfile = "c:\output_logs\logs$DateStr.txt"
$regex = "."

#creates Destination for logs if it doesn't exist
try {
    Get-ChildItem $outfile -ErrorAction Stop
}
catch{
    Write-Host 'Creating Log repository'
    New-Item $outfile -Force
}
#Gets a list of files that are in the log path


    try {
        $logs = Get-ChildItem -Path $inpath -ErrorAction Stop
    }
    Catch {
        Write-Output 'No Log file found, nothing to do here...'
    }

#Exports content of logs to a logfile
foreach ($log in $logs){
try {
    get-content -Path $log.FullName -ErrorAction Continue | Select-String -Pattern $regex | ForEach-Object {"$computername" + $_ } | Out-File -filepath $outfile -Force -Append
}
    Catch {Write-Output $_.exception.message.tostring()
    }
}

foreach ($log in $logs){
    try {
        get-content -Path $log.FullName | Select-String -Pattern $regex | ForEach-Object {"$computername" + $_ } | Out-File -filepath $outfile -Force
    }
        Catch {Write-Output $_.exception.message.tostring()
        }
}

$reader = New-Object System.IO.StreamReader($log)
$content = $reader.ReadToEnd()
$reader.Close()



