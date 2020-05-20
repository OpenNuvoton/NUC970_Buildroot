#!/bin/sh

rm output/target/etc/resolv.conf
cp -a board/nuvoton/rootfs-lorag/* output/target/
