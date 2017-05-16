#!/bin/bash
# https://github.com/CryptoPHI/INSN-MN for updates
# To build a INSN node from https://github.com/CryptoCoderz/INSN Repository on to Ubuntu +16.04 VPS
# Tested on a minimal VPS configuration of: 1vCPU 1GB RAM 16GB Storage
#########################################################################################################
# PLEASE REVIEW IT BEFORE YOUR RUN 
#########################################################################################################
clear
uris=$(lsb_release -a | grep Release | cut -f 2)
meis=$(free -m | grep Mem | awk '{print $2}')
swis=$(free -m | grep Swap | awk '{print $2}')
uris=$(whoami)
iiis=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
ifis=$(route | grep default | awk '{print $8}')
echo "Generating a random user/password pair for your node RPC"
rpcu="$(whoami)$(date +%s | sha256sum | base64 | head -c 32 ; echo)"
sleep 3
rpcp="$(date +%s | sha256sum | base64 | head -c 32 ; echo)$(whoami)"
rpcp="$rpcp$(date +%s | sha256sum | base64 | head -c 32 ; echo)"

if [ "$swis" = 0 ]; then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo -e "/swapfile   none    swap    sw    0   0 \n" >> /etc/fstab
    swis=$(free -m | grep Swap | awk '{print $2}')
fi

echo "Running on Ubuntu $uris with $meis MB Ram and $swis MB swap"
echo "Updating the VM and installing dependencies"
apt update && apt -y upgrade && apt -y install build-essential libtool autotools-dev autoconf automake pkg-config libssl-dev libevent-dev libboost-all-dev libminiupnpc-dev libgmp-dev libcurl4-openssl-dev libdb-dev libdb++-dev git fail2ban
echo "Configuring fail2ban"
echo -e "[DEFAULT]\nbantime  = 864000\nfindtime  = 600\nmaxretry = 3\ndestemail = root@localhost\nsender = root@localhost\n\naction = %(action_mwl)s\n" >> /etc/fail2ban/jail.local
service fail2ban restart
echo "Building INSN... may take extended time on a low memory VPS"
cd /opt && rm -rf INSN && git clone https://github.com/CryptoCoderz/INSN.git && cd INSN/src && chmod +x leveldb/build_detect_platform && chmod +x secp256k1/autogen.sh && make -f makefile.unix && strip INSaNed && cp INSaNed /usr/local/bin && echo "Cleaning up" && make -f makefile.unix clean && cd && INSaNed

read -p "Please enter this MN Private Key and press [ENTER]:" yay
if [[ -z "$yay" ]]; then
   printf '%s\n' "No key entred, you have to edit ~/.INSN/INSaNe.conf your self and plug your Masternode Key"
   mnpkey="PLUG_YOUR_MN_KEY_HERE"
else
   shopt -s extglob
   yay="${yay##*( )}"
   yay="${yay%%*( )}"
   shopt -u extglob
   mnpkey=$yay
fi

echo "Building node config file"
echo -e "rpcuser=$rpcu\nrpcpassword=$rpcp\nrpcallowip=localhost\nrpcport=10257\nport=10255\\nexternalip=$iiis\nserver=1\nlisten=1\ndaemon=1\nlogtimestamps=1\ntxindex=1\nmaxconnections=500\nmnconflock=1\nmasternode=1\nmasternodeaddr=$iiis:10255\nmasternodeprivkey=$mnpkey\nstake=0\nstaking=0\nseednode=insn.cryptocoderz.com\n" > ~/.INSN/INSaNe.conf

sleep 10; INSaNed

echo "Setting INSaNed to auto-run on reboot"
echo -e "@reboot /usr/local/bin/INSaNed\n" >> /var/spool/cron/crontabs/$uris
echo "Switching to node monitor mode. Press ctl-c to exit."
watch INSaNed getinfo
echo "Get INSANE!!\nReboot the VPS and access it again to confirm all is in order" 
