Write-Host "What is the computer name?"
$NewName = Read-Host
Rename-Computer -NewName $newname -Confirm
Write-Host "What is the asset tag number?"
$AssetTagNumber = Read-Host
$NewDescription = "CTPF-" + $AssetTagNumber
$SystemInfo = Get-WmiObject Win32_OperatingSystem
$SystemInfo.Description = $NewDescription
$SystemInfo.Put()
Write-Host 'System description updated. Computer rename will take effect after restart.'
