<#The script will auto-set ip in host for Hyver-V#>

$tempPath='D:\Helper\Hyper-V\ToolKit\temp.txt';
<#the name must match you vm#>
$myVmName = ubuntu-server-20;

get-vm -Name $myVmName | Select -ExpandProperty Networkadapters | Select -Property  IPAddresses|Out-File -FilePath $tempPath;

$inet4=(Get-Content -Path $tempPath| Select-String -Pattern '{' ).ToString();
<#the host name in Hyper-V#>
$newHostName='ubuntu';
$newHost=$inet4.Substring(1,$inet4. IndexOf(',') - 1) + ' '+ $newHostName;

if($newHost.Length -lt 12) {
    return;
}

$hostFilePath='C:\Windows\System32\drivers\etc\hosts';
<# consider backup it in other place#>
$hostBackupFilePath='C:\Windows\System32\drivers\etc\hosts.bak';


$oldhosts=(Get-Content -Path $hostFilePath);
$oldhosts|Out-File -FilePath $hostBackupFilePath;

$rewritehosts='';
foreach($oldhost in $oldhosts) {
    if(!$oldhost.Contains($newHostName)) {
        $rewritehosts += $oldhost + "`r`n";
    }
}
<#rewrite to hosts#>
$rewritehosts + $newHost | Out-File -FilePath $hostFilePath;

