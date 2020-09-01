################################################################################
#
# ali LoRaGW-SDK
#
################################################################################

ALI_LORAGW_SDK_VERSION = 7f0377ee81356c820469f1aabbe3bb8a08209958
ALI_LORAGW_SDK_SITE = https://code.aliyun.com/LinkWAN/LoRaGW-SDK.git
ALI_LORAGW_SDK_SITE_METHOD = git
ALI_LORAGW_SDK_LICENSE = Apache-2.0
ALI_LORAGW_SDK_LICENSE_FILES = LICENSE
ALI_LORAGW_SDK_DEPENDENCIES += host-automake host-autoconf host-libtool

define ALI_LORAGW_SDK_BUILD_CMDS
	export PATH=$(PWD)/output/host/usr/bin:$(PATH) && \
	export MAKEFLAGS="--no-print-directory" && \
	export product_key=${BR2_PACKAGE_ALI_LORAGW_SDK_PRODUCT_KEY} && \
	export device_name=${BR2_PACKAGE_ALI_LORAGW_SDK_DEVICE_NAME} && \
	export device_secret=${BR2_PACKAGE_ALI_LORAGW_SDK_DEVICE_SECRET} && \
	cd $(@D) && ./build.sh all
endef

define ALI_LORAGW_SDK_INSTALL_TARGET_CMDS
        $(INSTALL) -m 755 -D $(@D)/build/bin/*     -t $(TARGET_DIR)/opt/ali_loragw/bin/
        $(INSTALL) -m 755 -D $(@D)/build/lib/*.so* -t $(TARGET_DIR)/opt/ali_loragw/lib/
endef

$(eval $(generic-package))

