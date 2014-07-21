#!/usr/bin/perl

open FH, '<', '/etc/udev/rules.d/70-persistent-net.rules';
my $mac;
my $netface;
while(<FH>){
    # SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="08:00:27:94:6f:09", ATTR{type}=="1", KERNEL=="eth*", NAME="eth1"
    if($_ =~ /^SUBSYSTEM=="net", ACTION=="add", DRIVERS=="\?\*", ATTR{address}=="(.*)", ATTR{type}=="1", KERNEL=="eth\*", NAME="(.*)"/){
        $mac = $1;
        $netface = $2;
        open ET, '>', "/etc/sysconfig/network-scripts/ifcfg-$netface";
        print ET "DEVICE=$netface\nHWADDR=$mac\nTYPE=Ethernet\nONBOOT=yes\nNM_CONTROLLED=yes\nBOOTPROTO=dhcp\n";
        close ET;
    }
}
close FH;

my $restartInfo = `service network restart`;
print $restartInfo;
my $ifconfig  = `ifconfig`;
print $ifconfig;
