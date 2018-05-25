Write-Host "TDX Hyper-V Virtual Machine Creation Script"

"="*50

#Parameters

$VMName = Read-Host "Enter VM Name"
$RAM = 4GB
$CPUCores = Read-Host "Enter Number of Cores"
$OSVHDSize = 5GB
$DataVHDSize = 5GB
$ImageLocation = "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks"
$VHDLocation = "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks"
$VMLocation = "C:\ProgramData\Microsoft\Windows\Hyper-V"
$VlanID = Read-Host "Enter Vlan ID"

#Copy Template VHD

New-Item -Type Directory -Path "$VHDLocation\$VMNAME"
Start-BitsTransfer -Source "$ImageLocation\Sysprep.vhdx" -Destination "$VHDLocation\$VMNAME" -TransferType Download
Rename-Item -Path "$VHDLocation\$VMNAME\Sysprep.vhdx" -NewName "$VMNAME`_SYSTEM.vhdx"
##Start-Sleep -Seconds 10

"="*50

Write-Host "Template VM Copied Successfully" -ForegroundColor Green

"="*50

#BuildVM

New-VM -Name $VMName -MemoryStartupBytes $RAM -VHDPath $VHDLocation\$VMName\$VMName`_System.vhdx -Path $VMLocation -Generation 2 -Switch "Private Network"
Set-VM -Name $VMName -ProcessorCount $CPUCores -StaticMemory:$true
Set-VMNetworkAdapterVlan -VMName $VMName -Access -VlanId $VlanID
New-VHD -Path "$VHDLocation\$VMName\$VMName`_Data.vhdx" -Fixed -SizeBytes $DataVHDSize
Add-VMHardDiskDrive -VMName $VMName -Path "$VHDLocation\$VMName\$VMName`_Data.vhdx"

"="*50

Write-Host "VM $VMName Successfully Created" -ForegroundColor Green

"="*50

Start-VM -Name $VMName

"="*50

Write-Host "VM $VMName Successfully Started" -ForegroundColor Green

"="*50

Pause