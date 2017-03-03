#! /bin/sh

# debugging message
#echo "MDEV=$1 : ACTION=$2 : SUBSYSTEM=$SUBSYSTEM : DEVPATH=$DEVPATH : DEVNAME=$DEVNAME" >> /dev/console

if [ "$1" == "" ]; then
	echo "parameter is none" > /tmp/error.txt
	exit 1
fi

MNT=$1
#if [ $(echo $1 | grep mmcblk) ]; then
#	if [ $(echo $1 | grep p[25]) ]; then
#		MNT=sdcard2
#	else
#		MNT=sdcard
#	fi
#elif [ $(echo $1 | grep sd) ]; then
#	if [ $(echo $1 | grep p[25]) ]; then
#		MNT=nandcard2
#	else
#		MNT=nandcard
#	fi
#fi

# there is no ACTION, it is for initial population
if [ "$2" = "X" ]; then
	mounted=`mount | grep $1 | wc -l`
	if [ $mounted -ge 1 ]; then
		# mounted, assume the ACTION is remove
		#ACT=Xremove
		# only set add for initial population
		ACT=Xadd
	else
		# not mounted, assume the ACTION is add
		ACT=Xadd
	fi
else
	ACT=$2
fi

if [ "$ACT" = "Xremove" ]; then
	# umount the device
	echo "$ACT /mnt/$1" >> /tmp/mdev.log
	if ! umount -l "/mnt/$1"; then
		exit 1
	else
		rm -f "/mnt/$MNT"
		echo "[Umount FS]: /dev/$1 -X-> /mnt/$MNT" > /dev/console
	fi

	if ! rmdir "/mnt/$1"; then
		exit 1
	fi
else
	# mount the device
	mounted=`mount | grep $1 | wc -l`
	#echo "par=$1,mounted=$mounted,MNT=$MNT" > /dev/console
	if [ $mounted -ge 1 ]; then
		#echo "device $1 is already mounted" > /dev/console
		exit 0
	fi

	if ! mkdir -p "/mnt/$1"; then
		exit 1
	fi

	if [ $(echo $1 | grep mtd) ]; then
		if mount -t jffs2 "/dev/$1" "/mnt/$1"; then
			echo "[Mount JFFS2]: /dev/$1 --> /mnt/$MNT" > /dev/console
			echo "$ACT /mnt/$1" >> /tmp/mdev.log
		elif mount -t yaffs2 -o"inband-tags" "/dev/$1" "/mnt/$1"; then
			echo "[Mount YAFFS2]: /dev/$1 --> /mnt/$MNT" > /dev/console
			echo "$ACT /mnt/$1" >> /tmp/mdev.log
		elif mount -t ubifs "/dev/$1" "/mnt/$1"; then
			echo "[Mount UBIFS]: /dev/$1 --> /mnt/$MNT" > /dev/console
			echo "$ACT /mnt/$1" >> /tmp/mdev.log
		else
			# failed to mount, clean up mountpoint
			if ! rmdir "/mnt/$1"; then
				exit 1
			fi
		fi
	else
		# try vfat only
		if mount -t vfat -o noatime,shortname=mixed,utf8 "/dev/$1" "/mnt/$1"; then
			ln -s /mnt/$1 /mnt/$MNT
			echo "[Mount VFAT]: /dev/$1 --> /mnt/$MNT" > /dev/console
			echo "$ACT /mnt/$1" >> /tmp/mdev.log		
        else
			# failed to mount, clean up mountpoint
			if ! rmdir "/mnt/$1"; then
				exit 1
			fi
			exit 1
		fi
	fi
fi

