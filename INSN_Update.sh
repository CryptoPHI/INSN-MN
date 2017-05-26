#!/bin/bash
# https://github.com/CryptoPHI/INSN-MN for updates
# UPDATE a built INSN node from https://github.com/CryptoCoderz/INSN Repository on to Ubuntu +16.04 VPS
# Tested on a minimal VPS configuration of: 1vCPU 1GB RAM 16GB Storage
#########################################################################################################
# PLEASE REVIEW IT BEFORE YOUR RUN 
#########################################################################################################
clear

echo "Updating the VM and applying OS patches"
apt update && apt -y upgrade 
echo "Updating INSN"
INSaNed stop
cd /opt/INSN && git pull && cd INSN/src && chmod +x leveldb/build_detect_platform && chmod +x secp256k1/autogen.sh && make -f makefile.unix && strip INSaNed && cp INSaNed /usr/local/bin && echo "Cleaning up" && make -f makefile.unix clean && cd && INSaNed

echo "Switching to node monitor mode. Press ctl-c to exit."
watch INSaNed getinfo
echo "Get INSANE!!" 
