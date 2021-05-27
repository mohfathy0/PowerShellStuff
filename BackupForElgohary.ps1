<#

Please run this script as admin so it can change the execution policy on your machine

#>

#SourcePath replace it with the directory you want to copy from 
$SourcePath="M:\Backup\backup"
#BackupDirectory Replace it with the target path where you want to copy the backup files
$BackupDirectory="C:\BackupPath"
#FileNamePattern represent the pattern of the file or in other word it should start with whatever string you will add below
$FileNamePattern="MINFORDB.DB2.DBPART"
#The script should create the backup folder defined in $BackupDirectory if it does not exist

$ExecutionPolicy = Get-ExecutionPolicy -Verbose
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force -Verbose
if(Test-Path $SourcePath){
    Write-Host "**********************" -ForegroundColor Red
    Write-Host "* Wrong source path! *" -ForegroundColor Red
    Write-Host "* Copy Backup field! *" -ForegroundColor Red
    Write-Host "**********************" -ForegroundColor Red
    Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy -Force
    break
}
$LatestBackupFileName =Get-ChildItem -Path $SourcePath -Name "$($FileNamePattern)*" | 
Sort-Object {$PSItem.LastWriteTime}|
Select-Object -First 1
Get-ChildItem -Path $LatestBackupFileName 
if($Null -eq $LatestBackupFileName )
{

    Write-Host "**************************" -ForegroundColor Red
    Write-Host "* Backup file NOT FOUND! *" -ForegroundColor Red
    Write-Host "* Copy Backup field!     *" -ForegroundColor Red
    Write-Host "**************************" -ForegroundColor Red
    Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy -Force
    break
} else
{
    if(!(Test-Path $BackupDirectory))
    {
        Write-Warning "Backup Directory not found!"
        new-item -ItemType "directory" -Force -Path $BackupDirectory  -Verbose|Out-Null
    }

    Copy-Item $LatestBackupFileName $BackupDirectory -Verbose
    Write-host "Testing backup"
    if(Test-Path $("$BackupDirectory/$LatestBackupFileName"))
    {
        Write-Host "Copy backup Complete!"
    } else
    {
        Write-Warning "Something went wrong. Please check manually"
    }
}
Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy -Force -Verbose


