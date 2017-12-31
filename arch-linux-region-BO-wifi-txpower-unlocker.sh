#!/bin/bash

#title: arch-linux-region-BO-wifi-txpower-unlocker.sh
#description: Unlocks BO with txpower and full channels @ 2,4, 5 and 60ghz 
#description: regions modded: DE, US, 00, GB & BO
#description: best use BO, others for testing or Region locked Wifi Firmwares
#author: Hiruna Wijesinghe https://github.com/hiruna/wifi-txpower-unlocker/
#contributions: Timo Sarawinski https://github.com/muhviehstah
#date: 31/12/2017

#change the value to the tx power (dBm) you like
txpower=33 #I set it to 33 as 33dBm ~ 2W

#Download and install the aur package and set txpower to selected value
cd /tmp
curl -JLO https://aur.archlinux.org/cgit/aur.git/snapshot/wireless-regdb-pentest.tar.gz
tar xf wireless-regdb-pentest.tar.gz
cd wireless-regdb-pentest
sed -i -e 's/(2402 - 2472 @ 40), (30)/(2402 - 2472 @ 40), ('$txpower')/g' db.txt.patch
sed -i -e 's/(2457 - 2482 @ 20), (30)/(2457 - 2482 @ 20), ('$txpower')/g' db.txt.patch
sed -i -e 's/(2474 - 2494 @ 20), (30)/(2474 - 2494 @ 20), ('$txpower')/g' db.txt.patch 
sed -i -e 's/(5170 - 5250 @ 80), (30)/(5170 - 5250 @ 80), ('$txpower')/g' db.txt.patch
sed -i -e 's/(5250 - 5330 @ 80), (30)/(5250 - 5330 @ 80), ('$txpower')/g' db.txt.patch
sed -i -e 's/(5490 - 5730 @ 160), (30)/(5490 - 5730 @ 160), ('$txpower')/g' db.txt.patch
sed -i -e 's/(5735 - 5835 @ 80), (30), NO-IR/(5735 - 5835 @ 80), ('$txpower'), NO-IR/g' db.txt.patch
sed -i -e 's/(2400 - 2483.5 @ 40), (30)/(2400 - 2483.5 @ 40), ('$txpower')/g' db.txt.patch
sed -i -e 's/(5150 - 5250 @ 80), (30)/(5150 - 5250 @ 80), ('$txpower')/g' db.txt.patch
sed -i -e 's/(5250 - 5350 @ 80), (30)/(5250 - 5350 @ 80), ('$txpower')/g' db.txt.patch
sed -i -e 's/(5470 - 5725 @ 160), (30)/(5470 - 5725 @ 160), ('$txpower')/g' db.txt.patch
sed -i -e 's/(5725 - 5875 @ 80), (30)/(5725 - 5875 @ 80), ('$txpower')/g' db.txt.patch
sed -i -e 's/(2402 - 2482 @ 40), (30)/(2402 - 2482 @ 40), ('$txpower')/g' db.txt.patch
sed -i -e 's/(5170 - 5250 @ 80), (30)/(5170 - 5250 @ 80), ('$txpower')/g' db.txt.patch
sed -i -e 's/(5250 - 5330 @ 80), (30)/(5250 - 5330 @ 80), ('$txpower')/g' db.txt.patch
sed -i -e 's/(5490 - 5710 @ 160), (30)/(5490 - 5710 @ 160), ('$txpower')/g' db.txt.patch
sed -i -e 's/(5170 - 5250 @ 80), (30)/(5170 - 5250 @ 80), ('$txpower')/g' db.txt.patch
sed -i -e 's/(5250 - 5330 @ 80), (30)/(5250 - 5330 @ 80), ('$txpower')/g' db.txt.patch
sed -i -e 's/(5490 - 5730 @ 160), (30)/(5490 - 5730 @ 160), ('$txpower')/g' db.txt.patch
sed -i -e 's/(2400 - 2494 @ 40), (30)/(2400 - 2494 @ 40), ('$txpower')/g' db.txt2.patch
sed -i -e 's/(4910 - 5835 @ 40), (30)/(4910 - 5835 @ 40), ('$txpower')/g' db.txt2.patch
makepkg --noconfirm -si --skipinteg
echo "Install done.. cleaning up"

#clean tmp dir
cd
rm -rf /tmp/wireless-regdb*
