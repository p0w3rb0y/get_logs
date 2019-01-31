$path = 'C:\temp'

$logs = New-Object -TypeName psobject

try {
    $logs = Get-ChildItem -Path $obj -Recurse -ErrorAction Continue | Add-Member -MemberType NoteProperty -Name
}
Catch {
    Write-Output $_.exception.message.tostring()
}


$logs

foreach ($obj in $path){
try {
    get-content -Path $path -ErrorAction Continue}
    Catch {Write-Output $_.exception.message.tostring()
     }
}