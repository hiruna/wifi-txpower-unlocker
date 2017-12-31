#!/bin/bash

#title: kali-linux-region-BO-wifi-txpower-unlocker.sh
#description: Unlocks the wifi txpower of the 2.4Ghz band of the BO region 
#author: Hiruna Wijesinghe https://github.com/hiruna/wifi-txpower-unlocker/
#date: 13/05/2017

#change the value to the tx power (dBm) you like
txpower=25 #I set it to 33 as 33dBm ~ 2W

set -e #Exit if any line fails

#Update and updrade
apt-get --yes update
apt-get --yes upgrade

#Download dependencies
apt-get --yes install pkg-config libnl-3-dev libgcrypt11-dev libnl-genl-3-dev build-essential

#Download latest CRDA and Wireless Regulatory DB
latestCRDA=$(curl 'https://www.kernel.org/pub/software/network/crda/' |     grep -oP 'href="crda-\K[0-9]+\.[0-9]+' |     sort -t. -rn -k1,1 -k2,2 -k3,3 | head -1)
latestWRDB=$(curl 'https://www.kernel.org/pub/software/network/wireless-regdb/' |     grep -oP 'href="wireless-regdb-\K[0-9]+\.[0-9]+\.[0-9]+' |     sort -t. -rn -k1,1 -k2,2 -k3,3 | head -1)

wget "https://www.kernel.org/pub/software/network/crda/crda-${latestCRDA}.tar.xz"
wget "https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-${latestWRDB}.tar.xz"

#Unzip the downloaded files
tar xvJf crda-${latestCRDA}.tar.xz
tar xvJf wireless-regdb-${latestWRDB}.tar.xz

#inset txpower in db.txt

sed -i -e 's/(5250 - 5350 @ 80), (30)/(5250 - 5350 @ 80), ('$txpower')/g' db.txt
sed -i -e 's/(5470 - 5725 @ 160), (30)/(5470 - 5725 @ 160), ('$txpower')/g' db.txt
sed -i -e 's/(5725 - 5875 @ 80), (30)/(5725 - 5875 @ 80), ('$txpower')/g' db.txt
sed -i -e 's/(2402 - 2482 @ 40), (30)/(2402 - 2482 @ 40), ('$txpower')/g' db.txt
sed -i -e 's/(5170 - 5250 @ 80), (30)/(5170 - 5250 @ 80), ('$txpower')/g' db.txt
sed -i -e 's/(5250 - 5330 @ 80), (30)/(5250 - 5330 @ 80), ('$txpower')/g' db.txt
sed -i -e 's/(5490 - 5710 @ 160), (30)/(5490 - 5710 @ 160), ('$txpower')/g' db.txt
sed -i -e 's/(5170 - 5250 @ 80), (30)/(5170 - 5250 @ 80), ('$txpower')/g' db.txt
sed -i -e 's/(5250 - 5330 @ 80), (30)/(5250 - 5330 @ 80), ('$txpower')/g' db.txt
sed -i -e 's/(5490 - 5730 @ 160), (30)/(5490 - 5730 @ 160), ('$txpower')/g' db.txt
sed -i -e 's/(2400 - 2494 @ 40), (30)/(2400 - 2494 @ 40), ('$txpower')/g' db.txt
sed -i -e 's/(4910 - 5835 @ 40), (30)/(4910 - 5835 @ 40), ('$txpower')/g' db.txt

#copy modified db.txt  
cp db.txt wireless-regdb-${latestWRDB}/db.txt

#compile regulatory.db
make -C wireless-regdb-${latestWRDB}

#backup the old regulatory.bin and move the new file into /lib/crda
mv /lib/crda/regulatory.bin /lib/crda/regulatory.bin.old
mv wireless-regdb-${latestWRDB}/regulatory.bin /lib/crda

#copy pubkeys
cp wireless-regdb-${latestWRDB}/*.pem crda-${latestCRDA}/pubkeys
#if the extra pubkeys exist, copy them too
if [ -e /lib/crda/pubkeys/benh\@debian.org.key.pub.pem ] ; then
cp /lib/crda/pubkeys/benh\@debian.org.key.pub.pem crda-${latestCRDA}/pubkeys
fi
if [ -e /lib/crda/pubkeys/linville.key.pub.pem ] ; then
cp /lib/crda/pubkeys/linville.key.pub.pem crda-${latestCRDA}/pubkeys
fi

#change regulatory.bin path in the Makefile
sed -i "/REG_BIN?=\/usr\/lib\/crda\/regulatory.bin/!b;cREG_BIN?=\/lib\/crda\/regulatory.bin" crda-${latestCRDA}/Makefile
#remove -Werror option when compiling
sed -i "/CFLAGS += -std=gnu99 -Wall -Werror -pedantic/!b;cCFLAGS += -std=gnu99 -Wall -pedantic" crda-${latestCRDA}/Makefile

#compile
make clean -C crda-${latestCRDA}
make -C crda-${latestCRDA}
make install -C crda-${latestCRDA}

#reboot
printf "A system reboot is required to apply changes. Do you want to reboot now ? [Yes,No,Y,N]:"
read -r reboot
if [ ${reboot,,} == "y" ] || [ ${reboot,,} == "yes" ] ; then
echo "Rebooting..."
reboot
elif [ ${reboot,,} == "n" ] || [ ${reboot,,} == "no" ] ; then
echo "You chose not to reboot. Please reboot the system manually."
else
echo "Invalid option. Please reboot the system manually."
fi
