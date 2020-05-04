#!/bin/sh
APP_PATH=output/build/applications-1.0.0

rm output/target/etc/resolv.conf
cp -a board/nuvoton/rootfs-eth2uart/* output/target/
if [ -d $APP_PATH ]; then
	cp $APP_PATH/demos/eth2uart/eth2uart output/target/usr/bin/
fi
