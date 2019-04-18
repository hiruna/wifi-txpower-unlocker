#!/bin/bash -e

#title: wifi_txpower_unlocker.sh
#description: Unlocks the wifi txpower of the 2.4Ghz band of the BO region 
#author: Hiruna Wijesinghe https://github.com/hiruna/wifi-txpower-unlocker/
#date: 19/04/2019

# Input the desired transmit power (dBm) (I used 33dBm for 2W)
txpower="$1"

if [ -z $txpower ]; then
	echo "TX power not specified. Exitting..." 1>&2
	exit 1
fi

if ! [[ "$txpower" =~ ^[0-9]+$ ]]; then
    echo "TX power input must be an integer. Exitting..."
	exit 1
fi

# APT update & upgrade
echo "Update/Upgrade packages..." 1>&2
apt-get -y update && apt-get -y upgrade

# Install dependencies
echo "Installing dependencies..." 1>&2
apt-get -y install git python m2crypto libgcrypt* libnl* pkg-config build-essential python-dev python-pip curl
pip install setuptools future

echo "Fetching crda and wireless-regdb..." 1>&2
# Clone crda
git clone git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/crda.git

# Clone wireless-regdb
git clone git://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git

# Change region 'BO's TXpower in db.txt
echo "Setting the desired TX power in wireless-regdb/db.txt ..." 1>&2
sed -i '/country BO: DFS-JP/!b;n;c\\t(2402 - 2482 @ 40), ('"$txpower"')' wireless-regdb/db.txt

# Compile wireless-regdb (regulatory.bin)
echo "Compiling wireless-regdb (regulatory.bin)..." 1>&2
make -C wireless-regdb/

# Backup old regulatory.bin and copy the newly compiled file into /lib/crda/
echo "Backing up old regulatory.bin and copying the newly compiled file into /lib/crda/ ..." 1>&2
cp /lib/crda/regulatory.bin /lib/crda/regulatory.bin.old
cp wireless-regdb/regulatory.bin /lib/crda/

# Newly compiled regulatory.bin was signed by the current user, copy this key into crda
echo "Copying key signed by $(whoami) for the new regulatory.bin into crda..." 1>&2
cp wireless-regdb/$(whoami).key.pub.pem crda/pubkeys/
cp wireless-regdb/$(whoami).key.pub.pem /lib/crda/pubkeys/

# Change regulatory.bin path in the crda/Makefile to /lib/crda/regulatory.bin
echo "Changing regulatory.bin path in the crda/Makefile to /lib/crda/regulatory.bin ..." 1>&2
sed -i '/REG_BIN?=\/usr\/lib\/crda\/regulatory.bin/!b;cREG_BIN?=\/lib\/crda\/regulatory.bin' crda/Makefile

# Remove -Werror option when compiling
echo "Removing -Werror option when compiling..." 1>&2
sed -i '/CFLAGS += -std=gnu99 -Wall -Werror -pedantic/!b;cCFLAGS += -std=gnu99 -Wall -pedantic' crda/Makefile

# Clean and compile
echo "Clean and compile crda..." 1>&2
make clean -C crda/
make -C crda/
make install -C crda/

# Reboot to apply changes
printf 'A system reboot is required to apply the changes. Do you want to reboot now ? (y/n)' && read reboot_prompt && [[ "$reboot_prompt" == "y" ]] && reboot;