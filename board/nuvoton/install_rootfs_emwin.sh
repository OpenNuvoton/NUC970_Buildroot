#!/bin/sh
rm output/target/etc/resolv.conf
chmod 777 board/nuvoton/rootfs-emwin/etc/init.d/rcS
cp -a board/nuvoton/rootfs-emwin/* output/target/
cp -a output/build/applications-1.0.0/emWin/Sample/SimpleDemo/SimpleDemo output/target/usr/bin
cp -a output/build/applications-1.0.0/emWin/Sample/GUIDemo/GUIDemo output/target/usr/bin
