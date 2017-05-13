# wifi-txpower-unlocker

A bash script that generates a modified regulatory.bin from [Central Regulatory Domain Agent](https://wireless.wiki.kernel.org/en/developers/regulatory/crda) and [Wireles Regulatory Database](https://wireless.wiki.kernel.org/en/developers/regulatory/wireless-regdb) sources and patches the kernel. This unlocks the maximum WiFi TX power (on 2.4 Ghz) of the region BO according to the dBm value you specify in the script. 

In the future I plan to modify the script to allow users to choose a specific region and a frequency range.

## kali-linux-region-BO-wifi-txpower-unlocker.sh
* Region BO
* 2.4 Ghz
* Customized for Kali Linux

## ubuntu-region-BO-wifi-txpower-unlocker.sh
* Same as kali-linux-region-BO-wifi-txpower-unlocker.sh but added dependencies for Ubuntu

## Tested Devices
* Raspberry Pi 3 running Kali Linux (with the kali-linux-full metapackage)
* Virtual Machine running Kali Linux 64 bit
* Ubuntu 16.04 LTS 64 bit

## Usage
#### Increase TX power
1. Login as root in Kali Linux
2. Download kali-...sh or ubuntu-...sh script (or clone the repo)
3. Open the script in a text editor and change change the value of the variable ```txpower``` to the desired value
* I set the ```txpower``` to ```33``` in the script
4. Grant execution permission using Terminal (use ubuntu-...sh script if using Ubuntu)
* ```chmod +x kali-linux-region-BO-wifi-txpower-unlocker.sh```
5. Execute the script (use ubuntu-...sh script if using Ubuntu)
* ```./kali-linux-region-BO-wifi-txpower-unlocker.sh```
6. When prompted to reboot type ```'Y'``` and press ```[Enter]```
7. After rebooting, login as root
#### Set the txpower of the interface
1. Run ```iwconfig``` or ```ifconfig``` to determine your wireless interface
* ```iwconfig``` or ```ifconfig```
* My wireless interface was ```wlan1``` so replace wlan1 with your interface name
2. Bring the interface down
* ```ifconfig wlan1 down```
3. Set region to BO
* ```iw reg set BO```
4. Change the txpower of the interface (again, I chose 33). If you specified ```xx``` in the script before executing, ```xx``` will be the highest txpower you can set the interface to. 
* ```iwconfig wlan1 txpower 33```
5. Bring the interface up
* ```ifconfig wlan1 up```
6. Use ```iwconfig``` to make sure that the txpower is set to what you desired
* ```iwconfig wlan1```

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D


