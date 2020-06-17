################################################################################
#
# applications
#
################################################################################


export $(grep "BR2_PACKAGE_APPLICATIONS=" $(@D)/../../.config)
export $(grep "NUC970_APPLICATIONS=" $(@D)/../../.config)
export $(grep "NUC980_APPLICATIONS=" $(@D)/../../.config)

ifeq ($(NUC970_APPLICATIONS),y)
APPLICATIONS_VERSION=1.0.0
APPLICATIONS_SITE=$(call github,OpenNuvoton,NUC970_Linux_Applications,master)
APPLICATIONS_LICENSE=MIT
APPLICATIONS_LICENSE_FILES=LICENSE
APPLICATIONS_MAKE_ENV=
APPLICATIONS_MAKE_FLAGS=

SUBDIRS=	demos/ebi \
		demos/wwdt \
		demos/uart \
		demos/thread \
		demos/alsa_audio \
		demos/irda \
		demos/wdt \
		demos/crypto \
		demos/etimer \
		demos/gpio \
		demos/lcm \
		demos/cap \
		demos/keypad \
		demos/CAN \
		demos/rs485 \
		demos/sc \
		demos/eth2uart \
		demos/spi \
		demos/2d \
		demos/rtc

BENCHMARK_SUBDIRS=benchmark/netperf-2.6.0
YAFFS2_DIRS=yaffs2utils
PYTHON=Python-2.7.9
EMWIN=emWin

MINIGUI_LIB_SUBDIRS=minigui/libminigui-gpl-3.0.12
MINIGUI_RES_SUBDIRS=minigui/minigui-res-be-3.0.12
MINIGUI_APP_SUBDIRS=minigui/mg-samples-3.0.12

SETUPPATH=$(PWD)/$(MTD_DIRS)/install

PATH := $(PATH):$(HOST_DIR)/usr/bin

define APPLICATIONS_BUILD_CMDS
	@if grep -q "APPLICATIONS_BUILD_DEMOS=y" $(@D)/../../../.config; then \
		for subdir in $(SUBDIRS) ; do \
			( cd $(@D)/$$subdir && $(MAKE) $1) || exit 1; \
		done; \
	fi

	@if grep -q "APPLICATIONS_BUILD_PYTHON=y" $(@D)/../../../.config; then \
		for subdir in $(PYTHON) ; do \
			( cd $(@D)/$$subdir && ./make_python.sh ) || exit 1; \
		done; \
	fi

	@if grep -q "APPLICATIONS_BUILD_YAFFS2UTILS=y" $(@D)/../../../.config; then \
		for subdir in $(YAFFS2_DIRS) ; do \
			( cd $(@D)/$$subdir && $(MAKE) CROSS=arm-linux- ) || exit 1; \
		done; \
	fi

        @if grep -q "APPLICATIONS_BUILD_EMWIN=y" $(@D)/../../../.config; then \
		for subdir in $(EMWIN)/Sample/GUIDemo ; do \
			( cd $(@D)/$$subdir && $(MAKE) CROSS=arm-linux- LDFLAGS="-L../../Lib -lNUemWin -lm -L./tslib -lts -ldl -pthread" ) || exit 1; \
		done; \
		for subdir in $(EMWIN)/Sample/SimpleDemo ; do \
                        ( cd $(@D)/$$subdir && $(MAKE) CROSS=arm-linux- LDFLAGS="-L../../Lib -lNUemWin -lm -L./tslib -lts -ldl -pthread" ) || exit 1; \
                done; \
        fi

	@if grep -q "APPLICATIONS_BUILD_MINIGUI=y" $(@D)/../../../.config; then \
		for subdir in $(MINIGUI_LIB_SUBDIRS) ; do \
			( cd $(@D)/$(MINIGUI_LIB_SUBDIRS) && ./configure --prefix=$(@D)/_install/minigui/build CC=arm-linux-gcc --host=arm-linux --build=i386-linux --with-osname=linux --with-targetname=fbcon --disable-pcxvfb --enable-videonuc970 --enable-videofbcon --enable-autoial --disable-vbfsupport --disable-screensaver && make && make install && cd .. && cd ..; ) \
		done; \
		for subdir in $(MINIGUI_RES_SUBDIRS) ; do \
			cd $(@D)/$(MINIGUI_RES_SUBDIRS) && ./configure --prefix=$(@D)/_install/minigui/build && make install && cd .. && cd ..; \
		done; \
		for subdir in $(MINIGUI_APP_SUBDIRS) ; do \
			( cd $(@D)/$(MINIGUI_APP_SUBDIRS) && export PKG_CONFIG_PATH="$(@D)/_install/minigui/build/lib/pkgconfig" && ./configure --prefix=$(@D)/_install/minigui/build CC=arm-linux-gcc --host=arm-linux --build=i386-linux CFLAGS=-I$(@D)/_install/minigui/build/include && make && cd .. && cd .. ); \
		done; \
	fi
endef
define APPLICATIONS_INSTALL_TARGET_CMDS
	@if grep -q "APPLICATIONS_BUILD_PYTHON=y" $(@D)/../../../.config; then \
	for subdir in $(PYTHON) ; do \
		( rm -f $(TARGET_DIR)/usr/lib/libpython* && cp -a $(@D)/$$subdir/_install/* $(TARGET_DIR)/usr/ ) || exit 1; \
		( rm -f $(STAGING_DIR)/usr/lib/libpython* && cp -a $(@D)/$$subdir/_install/* $(STAGING_DIR)/usr/  ) || exit 1; \
	done; \
	fi
endef

endif

ifeq ($(NUC980_APPLICATIONS),y)
APPLICATIONS_VERSION=1.0.0
APPLICATIONS_SITE=$(call github,OpenNuvoton,NUC980_Linux_Applications,master)
APPLICATIONS_LICENSE=MIT
APPLICATIONS_LICENSE_FILES=LICENSE
APPLICATIONS_MAKE_ENV=
APPLICATIONS_MAKE_FLAGS=

NUC980_SUBDIRS=	demos/CAN \
                demos/alsa_audio \
                demos/cap \
                demos/crypto \
                demos/ebi \
                demos/etimer \
                demos/gpio \
                demos/irda \
                demos/rs485 \
                demos/rtc \
                demos/sc \
                demos/spi \
                demos/uart \
                demos/wdt \
                demos/eth2uart \
                demos/wwdt

NUC980_YAFFS2_DIRS=yaffs2utils

PATH := $(PATH):$(HOST_DIR)/usr/bin

define APPLICATIONS_BUILD_CMDS
        @if grep -q "NUC980_APPLICATIONS_BUILD_DEMOS=y" $(@D)/../../../.config; then \
                for subdir in $(NUC980_SUBDIRS) ; do \
                        ( cd $(@D)/$$subdir && $(MAKE) $1) || exit 1; \
                done; \
        fi

        @if grep -q "NUC980_APPLICATIONS_YAFFS2UTILS=y" $(@D)/../../../.config; then \
                for subdir in $(NUC980_YAFFS2_DIRS) ; do \
                        ( cd $(@D)/$$subdir && $(MAKE) CROSS=arm-linux- ) || exit 1; \
                done; \
        fi
endef

endif

$(eval $(generic-package))


