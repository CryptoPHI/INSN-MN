# Deploy an INSN Master Node

#### NOTE: 

 + "MNx" is an alias for your MN, you can name them what you want. we are using x to denote MN1, MN2, MN3.... as masternode aliases
+ Configuration files locations by default are: 
   * Linux: `~/.INSN/` 
   * Windows: `%appdata%\INSN\` 
   ![Image of Windows_Roamin_folder](/images/Roaming_Folder.png)
   * OSX: `~/Library/Application Support/INSN/`
+ Take note of the outputs of all commands you run in steps 1-3 as you will need them later
 
## Step 1: Prepare for your REMOTE MasterNode
On your master wallet, You will need to generate/prepare a Masternode Key/s by following these steps:

For every Masternode you want to create: 
1. In your wallet Debug Console
   1. Generate an address to hold your MN collateral using : <br> ` getaccountaddress MN1 `
       ![Image of getaccountaddress_in](/images/Generate_MN_PubKey_I.png "Input")
       ![Image of getaccountaddress_out](/images/Generate_MN_PubKey_O.png "Output")
       >**sample output:** iEZzKiAcit8MCULTexkeZZZZZ7aevL6xv
       
   2. Generate a Masternode KEY for the above MN:            <br> ` masternode genkey `
       ![Image of masternode_genkey_in](/images/Generate_MN_Key_I.png "Input")
       ![Image of masternode_genkey_out](/images/Generate_MN_Key_O.png "Output")
       >**sample output:** 2rBZzZzZzZC3zZzZzZzZUgrqWsYJPFDmmaGrsWzZ
       
2. Using your QT wallet interface
   1.  Send - In a single Transaction - 50K INSN to the address generated in step 1.i - requires *15 confirmations*
       ![Image of send_payment](/images/MN_Collateral.png "Send Payment")
       
3. In your wallet Debug Console
   1.  Run the following command and save its output:<br> `masternode outputs` 
        ![Image of masternode_output_in](/images/Masternode_Outputs_I.png "Input")
        ![Image of masternode_output_out](/images/Masternode_Outputs_O.png "Output")
        >**sample output:** { "d1197905eaffd2fbfcd35f681adba92b25e32c62de6d0f7a5487926c01a70897":"0" }
        
4. On your desktop, edit the file named `masternode.conf` located in your INSN wallet folder; add a **SINGLE SPACED SINGLE LINE** for each of your Masternodes based on the following template : 
   >*MN_ALIAS REMOTE_MN_IP:10255 MASTERNODE_PRIVKEY TRANSACTION_HASH INDEX*
   
   **Example:** the second line is not to be included in the config file and is to assist in pointing out the source of the information
   ><pre><code>MN1 123.123.123.123:10255 2rBZzZzZzZC3zZzZzZzZUgrqWsYJPFDmmaGrsWzZ d1197905eaffd2fbfcd35f681adba92b25e32c62de6d0f7a5487926c01a70897 0<br>
   >1.i 123.123.123.123:10255 ^^^^^^ 1.ii ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ^^^^^^^^^  3.i  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ^</code></pre>
   
   [Sample masternode.conf](https://github.com/CryptoPHI/INSN-MN/blob/master/masternode.conf)
## Step 2: Deploy to VPS
The procedure has been tested on Ubuntu +16.04
1. Access your VPS and issue the following command to proceed as root: <br>`sudo -i`
2. Fetch the script and execute it: <br> `cd /opt && wget https://github.com/CryptoPHI/INSN-MN/blob/master/INSN_deploy_mn.sh  && chmod +x INSN_deploy_mn.sh && ./INSN_deploy_mn.sh`

## To report issues or for support : <br> [InsaneCoin Slack #masternodesupport](https://insanecointeam.slack.com/messages/C5A3DT42J)
