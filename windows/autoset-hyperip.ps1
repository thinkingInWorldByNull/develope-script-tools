<#The script will auto-set ip in host for Hyver-V#>

$tempvar='D:\Helper\Hyper-V\ToolKit\temp.txt';
get-vm -Name ubuntu-server-20 | Select -ExpandProperty Networkadapters | Select -Property  IPAddresses|Out-File -FilePath $tempvar;

$inet4=(Get-Content -Path $tempvar| Select-String -Pattern '{' ).ToString();
<#the host name in Hyper-V#>
$newhostname='ubuntu';
$newvmhost=$inet4.Substring(1,$inet4. IndexOf(',') - 1) + ' '+ $newhostname;

if($newvmhost.Length -lt 12) {
    return;
}

$hostpath='C:\Windows\System32\drivers\etc\hosts';
<# consider backup it in other place#>
$hostbackpath='C:\Windows\System32\drivers\etc\hosts.bak';


$oldhosts=(Get-Content -Path $hostpath);
$oldhosts|Out-File -FilePath $hostbackpath;

$rewritehosts='';
foreach($oldhost in $oldhosts) {
    if(!$oldhost.Contains($newhostname)) {
        $rewritehosts += $oldhost + "`r`n";
    }
}
<#rewrite to hosts#>
$rewritehosts + $newvmhost | Out-File -FilePath $hostpath;

