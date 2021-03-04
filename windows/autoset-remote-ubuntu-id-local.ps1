<#This script will auto set host for remote computer, forexample if the remote hostname is easonwang-ubuntu#>

<#this is very important , the name must be correct#>
$local_ubuntu_ip_info=(nslookup easonwang-ubuntu)

$local_ubuntu_ip_local;

foreach($local_ubuntu_ip in $local_ubuntu_ip_info) {
    if(!$local_ubuntu_ip.Contains('.')) {
        continue;
    }
    $local_ubuntu_ip_local=$local_ubuntu_ip.Substring(10);
}

if($local_ubuntu_ip_local.Length -lt 10) {
    return;
}

$hostpath='C:\Windows\System32\drivers\etc\hosts';
<# consider backup it in other place#>
$hostbackpath='C:\Windows\System32\drivers\etc\hosts.bak';


$oldhosts=(Get-Content -Path $hostpath);
$oldhosts|Out-File -FilePath $hostbackpath;

<#The result is  ubunt 192.XXX, You can rename it as you like #>
$newhostname='ubuntu';
$rewritehosts='';

foreach($oldhost in $oldhosts) {
    if(!$oldhost.Contains($newhostname)) {
        $rewritehosts += $oldhost + "`r`n";
    }
}
$rewritehosts + $local_ubuntu_ip_local + ' ' + $newhostname| Out-File -FilePath $hostpath;

