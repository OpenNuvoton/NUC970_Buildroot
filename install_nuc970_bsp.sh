#!/bin/bash
# Copyright (c) Nuvoton Tech. Corp. All rights reserved.
# Description:  Nuvoton Linux platform toolchain install script
# Version:      2017-01-18      first release version

BR2_CONFIG="./.config"
BASE_DIR="./output"
BUILD_DIR=$BASE_DIR/build
HOST_DIR=$BASE_DIR/host
BINARIES_DIR=$BASE_DIR/images
TARGET_DIR=$BASE_DIR/target
APPLICATION_CONFIG="./package/applications/applications.mk"

if [ $BR2_CONFIG ]; then
	export $(grep "BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION=" $BR2_CONFIG | sed 's/\"//g')
	export $(grep "BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION=" $BR2_CONFIG | sed 's/\"//g')
	export $(grep "BR2_APPLICATION_CUSTOM_REPO_VERSION=" $BR2_CONFIG | sed 's/\"//g')
fi

if [ $APPLICATION_CONFIG ]; then
	export $(grep "APPLICATIONS_VERSION=" $APPLICATION_CONFIG | sed 's/\"//g')
fi


KERNEL_VER=linux-$BR2_LINUX_KERNEL_CUSTOM_REPO_VERSION
APPLICATION_VER=applications-$APPLICATIONS_VERSION
UBOOT_VER=uboot-$BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION


ROOT_UID=0
if [ "$UID" -ne "$ROOT_UID" ] ;then
    echo 'Sorry, you are not root !!'
    exit 1
fi

#chown -R $USER:$USER ${BUILD_DIR};

ARM_TOOL_ROOT="/usr/local"
ARM_TOOL_SUBDIR="usr"
ARM_TOOL_NANE="arm_linux_4.8"
#if grep -q "BR2_GCC_VERSION_4_9_X=y" $BR2_CONFIG; then  \
#	ARM_TOOL_NANE="arm_linux_4.9" \
#fi
ARM_TOOL_PATH="$ARM_TOOL_ROOT/$ARM_TOOL_NANE/$ARM_TOOL_SUBDIR"

NO_TOOL=0
if [ -d $ARM_TOOL_PATH ]; then
        echo "The folder \"$ARM_TOOL_PATH\" is already existed, continue the tool chain installation?(Y/N)"
        INSTALL=1
        while [ $INSTALL == 1 ]
        do
                read install
                case "$install" in
                [yY]|[yY][eE][sS] )
                        INSTALL=0
                        ;;
                [nN]|[nN][oO] )
                        echo "Skip toolchain installation"
                        INSTALL=2
                        NO_TOOL=1
                        ;;
                * )
                        echo "Please type yes or no!"
                        ;;
                esac
        done
        if [ $NO_TOOL == 0 ]; then
                echo "Do you want to remove this folder first?(Y/N)"
                REMOVE=1
                while [ $REMOVE == 1 ]
                do
                        read remove
                        case "$remove" in
                        [yY]|[yY][eE][sS] )
                                echo "Now deleteing the folder \"$ARM_TOOL_PATH\"..."
                                rm -rf $ARM_TOOL_PATH
                                REMOVE=0
                                ;;
                        [nN]|[nN][oO] )
                                echo "This installation will overwirte folder \"$ARM_TOOL_PATH\"!"
                                REMOVE=0
                                ;;
                        * )
                                echo "Please type yes or no!"
                                ;;
                        esac
                done
        fi
fi

if [ $NO_TOOL == 0 ]; then
	echo "Now installing $ARM_TOOL_NANE toolchain to $ARM_TOOL_ROOT"
	echo 'Please wait for a while... '
	mkdir -p $ARM_TOOL_PATH
	cp $HOST_DIR/usr $ARM_TOOL_ROOT/$ARM_TOOL_NANE -r &
	pid=`echo $!`
	str="| / - \\"
	count=1
	while [ -d /proc/$pid ]
	do
		if [ $count == 5 ]; then
			count=1
		fi
		echo -e -n "\r"`echo $str | awk '{print $'$count'}'`
		count=`expr $count + 1`
		sleep 1
	done
	chown root:root -R $ARM_TOOL_PATH
	echo -e -n '\r'
fi

echo "Now setting toolchain environment"
PROFILE=/etc/profile
NVTFILE=/etc/profile.d/nvt_arm_linux.sh
#TMPFILE=`mktemp -q /tmp/$0.XXXXXX`
TMPFILE=`mktemp -q /tmp/install.sh.XXXXXX`
if [ $? -ne 0 ]; then
	echo "$0: Can't create temp file, exiting..."
	exit 1
fi

# Check toolchain environment setting in PROFILE
REC=$(cat $PROFILE|tr -d '\r'|tr -t '\n' '\r'|sed '1,$s/\\//g' |tr -t '\r' '\n'|grep "PATH="|sed '1,$s/PATH=//g'|tr -t '\n' ':')
NUM=$(echo $REC|awk -F: 'END {print NF}')
i=1
RES=0
while (test $i -le $NUM)
do
	TMP=$(echo $REC | awk -F: "{print \$$i}") 	
	if [ "$TMP" = "$ARM_TOOL_PATH/bin" ]; then
		RES=1
	elif [ "$TMP" = "$ARM_TOOL_PATH/bin/" ]; then
		RES=1
	fi
	i=`expr $i + 1`
done

# Check toolchain environment setting in NVTFILE
if [ -f $NVTFILE ]; then
	rm $NVTFILE
fi
echo '## Nuvoton toolchain environment export' >> $NVTFILE
echo 'export PATH='$ARM_TOOL_PATH'/bin:$PATH' >> $NVTFILE
chmod +x $NVTFILE

echo "Installing $ARM_TOOL_NANE toolchain successfully"

echo "Install rootfs, $APPLICATION_VER, $UBOOT_VER and $KERNEL_VER"
echo 'Please enter absolute path for installing(eg:/home/<user name>) :'
read letter

if [ -d $letter ] ;then
        echo ''$letter' has existed';
else
        echo 'Create '$letter' ';
        mkdir $letter;
        if [ -z $SUDO_USER ];then
                chown -R $USER:$USER $letter;
        else
                chown $SUDO_USER:$SUDO_USER $letter;
        fi
fi

if [ -d $letter/nuc970bsp ];then
        echo ''$letter'/nuc970bsp/ existed, (o)verwite, (r)emove or (a)bort?[y/n]';
        read remove;
        case "$remove" in
        [oO] )
                echo "Overwrite $letter/nuc970bsp folder"
                ;;
        [rR] )
                echo "Remove $letter/nuc970bsp folder"
                rm -rf $letter/nuc970bsp/*;
                ;;
        [aA] )
                echo 'Abort installation process';
		exit 1;
                ;;
        * )
                echo 'Abort installation process';
                ;;
        esac
else
        mkdir $letter/nuc970bsp;
fi

echo 'Please wait for a while, it will take some time';
mkdir -p $letter/nuc970bsp/rootfs
tar -x -f ${BINARIES_DIR}/rootfs.tar --directory=$letter/nuc970bsp/rootfs
if grep -q "BR2_PACKAGE_APPLICATIONS=y" $BR2_CONFIG; then  \
	cp ${BUILD_DIR}/$APPLICATION_VER $letter/nuc970bsp/application -r & \
fi
if grep -q "BR2_TARGET_UBOOT=y" $BR2_CONFIG; then  \
	cp ${BUILD_DIR}/$UBOOT_VER $letter/nuc970bsp/uboot -r & \
fi
pid=`echo $!`
str="| / - \\"
count=1
while [ $? == 0 ]
do
        if [ $count == 4 ]; then
                count=1
        fi
        echo -e -n '\r'`echo $str|awk '{print $'$count'}'`
        count=`expr $count + 1`
        sleep 1
        ps aux|awk '$2=='$pid' {print $0}'|grep $pid > /dev/null
done

mkdir -p $letter/nuc970bsp/image
cp ${BUILD_DIR}/image/* $letter/nuc970bsp/image/ -a
cp ${BINARIES_DIR}/* $letter/nuc970bsp/image/ -a
if grep -q "BR2_LINUX_KERNEL=y" $BR2_CONFIG; then  \
	cp ${BUILD_DIR}/$KERNEL_VER $letter/nuc970bsp/linux-3.10.x -r &
fi
pid=`echo $!`
str="| / - \\"
count=1
while [ $? == 0 ]
do
        if [ $count == 4 ]; then
                count=1
        fi
        echo -e -n '\r'`echo $str|awk '{print $'$count'}'`
        count=`expr $count + 1`
        sleep 1
        ps aux|awk '$2=='$pid' {print $0}'|grep $pid > /dev/null
done

find $letter/nuc970bsp -type d|xargs chmod 755
if [ -z $SUDO_USER ];then
        chown -R $USER:$USER $letter/nuc970bsp;
else
        chown -R $SUDO_USER:$SUDO_USER $letter/nuc970bsp;
fi
echo -e '\rNUC970 BSP installation complete'
