#!/bin/bash
# zImage gen script for
# 			Gemini	(Xiaomi Mi 5)
# 			Jason	(Xiaomi Mi Note 3)
#			Lithium (Xiaomi Mi Mix)

set -o errexit

function jStuff {
	cat arch/arm64/boot/dts/qcom/jason-sdm660.dtb > arch/arm/boot/dts/qcom/Jason.dtb
	cat arch/arm64/boot/Image.gz-dtb arch/arm/boot/dts/qcom/Jason.dtb  > zImage
}

function zImageReport {
	if [ ! -f zImage ]; then
		printf "zImage wasn't generated successfully, aborting...\n"
		exit 1
	else
		printf "zImage generated.\n"
	fi
	cleanup
}


function cleanup {	
	if [ -e ak2/zImage ]; then
		printf "Deleting alredy present zImage...\n"
		rm -rf ${HOME}/kernel/ak2/zImage
	fi

	if [ -e ak2/*.zip ]; then
		printf "Deleting alredy present zip...\n"
		rm -rf ${HOME}/kernel/ak2/*.zip
	fi
	generateAK2
}

function generateAK2 {

	mv zImage ${HOME}/kernel/ak2/zImage
	cd ${HOME}/kernel/ak2
	zip -r "${kernelName}".zip *
	if [ -e "${kernelName}".zip ]; then 
		printf "ZIP file generated successfully!\n"
		cd ..
		copyAndSetPerms
	else
		printf "ZIP file NOT generated!\n"
		exit 1
	fi
}

function copyAndSetPerms {
	if [ -e ../*.zip ]; then
		rm ../*.zip
	fi
	cp ${HOME}/kernel/ak2/"${kernelName}".zip ../
	chmod 0777 ../"${kernelName}".zip
}
export ARCH=arm64
export CROSS_COMPILE=/home/dusan/kernel/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export HOME=/home/dusan
make lineageos_jason_defconfig
make
jStuff
deviceName="Jason"

date="$(date '+%d%m%Y_%H%M')"
printf "Date ${date}\n"
kernelName="Kangeroo-Kernel-${deviceName}-${date}-LOS";
printf "Name ${kernelName}\n";
zImageReport


