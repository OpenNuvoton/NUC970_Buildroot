################################################################################
#
# SEMTECH_LIBLORAGW
#
################################################################################

SEMTECH_LIBLORAGW_VERSION = a955619271b5d0a46d32e08150acfbc1eed183b7
SEMTECH_LIBLORAGW_SITE = https://github.com/Lora-net/lora_gateway.git
SEMTECH_LIBLORAGW_SITE_METHOD = git
SEMTECH_LIBLORAGW_LICENSE_FILES = LICENSE
SEMTECH_LIBLORAGW_INSTALL_STAGING = YES
LIBLORAGW_SPIDEV_PATH = $(call qstrip,$(BR2_PACKAGE_LIBLORAGW_SPIDEV_PATH))

define SEMTECH_LIBLORAGW_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" -C $(@D)/libloragw \
		CFLAGS=' -DSPI_DEV_PATH=\"$(LIBLORAGW_SPIDEV_PATH)\" -O2 -Wall -Wextra -std=c99 -Iinc -I.'
endef

define SEMTECH_LIBLORAGW_INSTALL_STAGING_CMDS
	$(INSTALL) -m 0755 -D $(@D)/libloragw/libloragw.a  $(STAGING_DIR)/usr/lib
        $(INSTALL) -m 0644 -D $(@D)/libloragw/inc/loragw_hal.h  $(STAGING_DIR)/usr/include/loragw_hal.h
        $(INSTALL) -m 0644 -D $(@D)/libloragw/inc/loragw_aux.h  $(STAGING_DIR)/usr/include/loragw_aux.h
        $(INSTALL) -m 0644 -D $(@D)/libloragw/inc/loragw_reg.h  $(STAGING_DIR)/usr/include/loragw_reg.h
        $(INSTALL) -m 0644 -D $(@D)/libloragw/inc/loragw_gps.h  $(STAGING_DIR)/usr/include/loragw_gps.h
        $(INSTALL) -m 0644 -D $(@D)/libloragw/inc/config.h  $(STAGING_DIR)/usr/include/config.h
endef

$(eval $(generic-package))

