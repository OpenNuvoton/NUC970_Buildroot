#!/bin/sh

rm output/target/etc/resolv.conf
cp -af board/nuvoton/rootfs-chili/* output/target/

