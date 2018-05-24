Write-Host "TDX Hyper-V Virtual Machine Creation Script"

"="*50

#Parameters

$VMName = Read-Host "Give Me a VM Name"
$RAM = 4GB
$CPUCores = Read-Host "Enter Number of Cores"
$OSVHDSize = 5GB
$DataVHDSize = 5GB
$VHDLocation = "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks"
$VMLocation = "C:\ProgramData\Microsoft\Windows\Hyper-V"
$VlanID = Read-Host "Enter Vlan ID"

#Copy Template VHD

#Start-BitsTransfer -Source C:\clientsourcedir\*.txt `-Destination c:\clientdir\ -TransferType Download



#BuildVM

New-VM -Name $VMName -MemoryStartupBytes $RAM -NewVHDPath $VHDLocation\$VMName`_System.vhdx -Path $VMLocation -NewVHDSizeBytes $OSVHDSize -Generation 2 -Switch "Private Network"
Set-VM -Name $VMName -ProcessorCount $CPUCores -StaticMemory:$true
Set-VMNetworkAdapterVlan -VMName $VMName -Access -VlanId $VlanID
New-VHD -Path "$VHDLocation\$VMName`_Data.vhdx" -Fixed -SizeBytes $DataVHDSize
Add-VMHardDiskDrive -VMName $VMName -Path "$VHDLocation\$VMName`_Data.vhdx"

Pause