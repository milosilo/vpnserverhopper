#!/bin/bash
#VPN Server Hopper
#changes vpn server from list created of available servers 


##### Functions

create_server_list()
#creates server list using ipvanish manager https://github.com/vduseev/ipvanish .
#Requirements: Python 3 and appdirs(Try: 'pip3 install appdirs').
#Setup: Download/git and place ipvanish manager files in a sub folder named 'ipvanish-master'.
#location modification: states is currently set at the location.  Refer to ipvanish manager
#project for additional settings.
{
	rm -f ipvanish-master/serverlistoutput.txt
	python3 ipvanish-master/ipvanish.py states > ipvanish-master/serverlistoutput.txt
	chmod 777 ipvanish-master/serverlistoutput.txt
	rm -f ipvanish-master/serverlist.txt
	cat ipvanish-master/serverlistoutput.txt | awk '{print $1}' | sed 1,2d > ipvanish-master/serverlist.txt

}	# end of create_server_list


vpn_connection_start()
#Selects random vpn server from list and connnects. 
#Configure:
#Setup ipvanish using this guide: https://www.ipvanish.com/vpn-setup/linux/#kalilinux-wrap
#IMPORTANT:ipvanish python script looks for files in the users home dirctory. you may need to modify user directories below
#Place config file in /root/ipvanish/vpn_config.txt. Not the greatest solution, but it works.
#Config file is 4 lines: Username, Password, Server and Connection Type(tcp or udp are the options)

{
	vpnserver=$(shuf -n 1 ipvanish-master/serverlist.txt)
	sed -i "3s/.*/$vpnserver/" /root/ipvanish/vpn_config.txt #check user directory
	echo Trying server: $vpnserver	
	cat /root/ipvanish/vpn_config.txt | source /root/ipvanish/ipvanish-vpn-linux start #check user directory
}

vpn_connection_stop()
#Parameters are 'start' or 'stop'
#Configure:
#Setup ipvanish using this guide: https://www.ipvanish.com/vpn-setup/linux/#kalilinux-wrap
#IMPORTANT:ipvanish python script looks for files in the users home dirctory. you may need to modify user directories below
#Place config file in /root/ipvanish/vpn_config.txt
#Config file is 4 lines: Username, Password, Server and Connection Type(tcp or udp are the options)

{
	source /root/ipvanish/ipvanish-vpn-linux stop #check user directory
}

#Test Commands:
#create_server_list
#vpn_connection_start
#vpn_connection_stop
#Run these to test!

#Usage Commands
#### Commands:
case "$1" in
  (create_server_list) 
    create_server_list
    exit 1
    ;;
  (vpn_connection_start)
    vpn_connection_start
    exit 0
    ;;
  (vpn_connection_stop)
    vpn_connection_stop
    exit 2
    ;;
esac

