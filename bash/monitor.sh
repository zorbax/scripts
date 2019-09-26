#! /bin/bash

clear

unset tecreset os architecture kernelrelease internalip externalip nameserver loadaverage

while getopts iv name
do
	case $name in
  	i)iopt=1;;
    v)vopt=1;;
    *)echo "Invalid arg";;
  esac
done

if [[ ! -z $iopt ]]; then
{
	wd=$(pwd)
	basename "$(test -L "$0" && readlink "$0" || echo "$0")" > /tmp/scriptname
	scriptname=$(echo -e -n $wd/ && cat /tmp/scriptname)
	su -c "cp $scriptname /usr/bin/monitor" root && echo "Congratulations! Script Installed, now run monitor Command" || echo "Installation failed"
}
fi

if [[ ! -z $vopt ]]; then
{
	echo -e "tecmint_monitor version 0.1\nDesigned by Tecmint.com\nReleased Under Apache 2.0 License"
}
fi

if [[ $# -eq 0 ]]; then
{
	tecreset=$(tput sgr0)
	ping -c 1 google.com &> /dev/null && echo -e '\E[32m'"Internet: $tecreset Connected" || echo -e '\E[32m'"Internet: $tecreset Disconnected"

	os=$(uname -o)
	echo -e '\E[32m'"Operating System Type :" $tecreset $os

	cat /etc/os-release | grep 'NAME\|VERSION' | grep -v 'VERSION_ID' | grep -v 'PRETTY_NAME' > /tmp/osrelease
	echo -n -e '\E[32m'"OS Name :" $tecreset  && cat /tmp/osrelease | grep -v "VERSION" | grep -v CPE_NAME | cut -f2 -d\"
	echo -n -e '\E[32m'"OS Version :" $tecreset && cat /tmp/osrelease | grep -v "NAME" | grep -v CT_VERSION | cut -f2 -d\"

	architecture=$(uname -m)
	echo -e '\E[32m'"Architecture :" $tecreset $architecture

	kernelrelease=$(uname -r)
	echo -e '\E[32m'"Kernel Release :" $tecreset $kernelrelease

	echo -e '\E[32m'"Hostname :" $tecreset $HOSTNAME

	internalip=$(hostname -I)
	echo -e '\E[32m'"Internal IP :" $tecreset $internalip

	externalip=$(curl -s ipecho.net/plain;echo)
	echo -e '\E[32m'"External IP : $tecreset "$externalip

	nameservers=$(cat /etc/resolv.conf | sed '1 d' | awk '{print $2}')
	echo -e '\E[32m'"Name Servers :" $tecreset $nameservers 

	who>/tmp/who
	echo -e '\E[32m'"Logged In users :" $tecreset && cat /tmp/who 

	free -h | grep -v + > /tmp/ramcache
	echo -e '\E[32m'"Ram Usages :" $tecreset
	cat /tmp/ramcache | grep -v "Swap"
	echo -e '\E[32m'"Swap Usages :" $tecreset
	cat /tmp/ramcache | grep -v "Mem"

	df -h| grep 'Filesystem\|/dev/nvme*' > /tmp/diskusage
	echo -e '\E[32m'"Disk Usages :" $tecreset 
	cat /tmp/diskusage

	loadaverage=$(top -n 1 -b | grep "load average:" | awk '{print $10 $11 $12}')
	echo -e '\E[32m'"Load Average :" $tecreset $loadaverage

	tecuptime=$(uptime | awk '{print $3,$4}' | cut -f1 -d,)
	echo -e '\E[32m'"System Uptime Days/(HH:MM) :" $tecreset $tecuptime

	unset tecreset os architecture kernelrelease internalip externalip nameserver loadaverage

	rm /tmp/osrelease /tmp/who /tmp/ramcache /tmp/diskusage
}
fi

shift $(($OPTIND -1))
