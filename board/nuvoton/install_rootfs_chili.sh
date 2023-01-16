#!/bin/sh

ENABLE_ALLXON_SERVICE="false"

CleanAllxonService() {
	rm output/target/bin/agent-core
	rm output/target/bin/bdmplugin
	rm output/target/bin/dmidecode
	rm output/target/bin/oobconf
	rm output/target/bin/oobwatchdog
	rm output/target/bin/ntpclient
	rm output/target/sbin/getconf.sh
	rm output/target/sbin/init.sh
	rm output/target/sbin/led.sh
	rm output/target/sbin/setconf.sh
	rm output/target/sbin/set_dns.sh
	rm output/target/lib/libargon2.so.1
	rm output/target/lib/libboost*
	rm output/target/lib/libdmsagentcore.so
	rm output/target/lib/libdmsvpl.so
	rm output/target/lib/libaws*
	rm output/target/lib/libs2n.so
	rm -rf output/opt/allxon
	rm -rf output/config
	rm -rf output/usr

	rm board/nuvoton/rootfs-chili/bin/agent-core
        rm board/nuvoton/rootfs-chili/bin/bdmplugin
        rm board/nuvoton/rootfs-chili/bin/dmidecode
        rm board/nuvoton/rootfs-chili/bin/oobconf
        rm board/nuvoton/rootfs-chili/bin/oobwatchdog
        rm board/nuvoton/rootfs-chili/bin/ntpclient
        rm board/nuvoton/rootfs-chili/sbin/getconf.sh
        rm board/nuvoton/rootfs-chili/sbin/init.sh
        rm board/nuvoton/rootfs-chili/sbin/led.sh
        rm board/nuvoton/rootfs-chili/sbin/setconf.sh
        rm board/nuvoton/rootfs-chili/sbin/set_dns.sh
        rm board/nuvoton/rootfs-chili/lib/libargon2.so.1
        rm board/nuvoton/rootfs-chili/lib/libboost*
        rm board/nuvoton/rootfs-chili/lib/libdmsagentcore.so
        rm board/nuvoton/rootfs-chili/lib/libdmsvpl.so
        rm board/nuvoton/rootfs-chili/lib/libaws*
        rm board/nuvoton/rootfs-chili/lib/libs2n.so
	rm -rf board/nuvoton/opt/allxon
	rm -rf board/nuvoton/config
	rm -rf board/nuvoton/usr

	rm ./tarballmd5
}

InstallAllxonService() {
	if [ -f "./tarballmd5" ]; then
		TS=$(grep -e "timestamp" ./tarballmd5 | cut -d "=" -f 2)
        	CACHEMD5=$(grep -e "md5" ./tarballmd5 | cut -d "=" -f 2)
	else
		TS=0
        	CACHEMD5="0"
	fi
	CURRENTTS=$(date +%s)
	DIFFTS=$(expr $CURRENTTS - $TS)
	if [ "$DIFFTS" -gt "86400" ]; then
		wget -q https://get.allxon.net/oob/nuvoton/md5
		MD5=$(cat ./md5)
		if [ "$MD5" = "$CACHEMD5" ] && [ -f "./board/nuvoton/rootfs-chili/bin/agent-core" ]; then
			echo "The Allxon service is installed, skip installing"
			if [ -f "./tarball.md5" ]; then
				rm ./tarballmd5
			fi
			echo "timestamp=$(date +%s)" > ./tarballmd5
			echo "md5=$MD5" >> ./tarballmd5
		else
			IHV_INFO=$(grep -e "NUC980_APPLICATIONS_BUILD_ALLXON_IHV_INFO" ./.config | cut -d "=" -f 2 | sed "s/\"//g" | sed "s/\"//g")
			echo "Starting install the Allxon service"
			wget -qO - https://get.allxon.net/oob/nuvoton/install_allxon_service | bash -s -- -m $IHV_INFO
			echo "Installing the Allxon service is completed."
		fi
		rm ./md5
	fi
}

if grep -q NUC980_APPLICATIONS_BUILD_ALLXON=y ./.config;
then
	ENABLE_ALLXON_SERVICE="true"
fi

if [ "$ENABLE_ALLXON_SERVICE" = "true" ];
then
	InstallAllxonService
else
	CleanAllxonService
fi

rm output/target/etc/resolv.conf
cp -af board/nuvoton/rootfs-chili/* output/target/

