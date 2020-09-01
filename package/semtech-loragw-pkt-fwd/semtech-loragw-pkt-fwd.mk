################################################################################
#
# SEMTECH_LORAGW_PKT_FWD
#
################################################################################

SEMTECH_LORAGW_PKT_FWD_VERSION = d0226eae6e7b6bbaec6117d0d2372bf17819c438
SEMTECH_LORAGW_PKT_FWD_SITE = https://github.com/Lora-net/packet_forwarder.git
SEMTECH_LORAGW_PKT_FWD_SITE_METHOD = git
SEMTECH_LORAGW_PKT_FWD_LICENSE_FILES = LICENSE
SEMTECH_LORAGW_PKT_FWD_INSTALL_STAGING = NO
SEMTECH_LORAGW_PKT_FWD_INSTALL_TARGET = YES

SEMTECH_LIBLORAGW_PATH=$(@D)/../semtech-libloragw*/libloragw
define SEMTECH_LORAGW_PKT_FWD_BUILD_CMDS
        $(TARGET_MAKE_ENV) $(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" LGW_PATH="$(SEMTECH_LIBLORAGW_PATH)" -C $(@D)/lora_pkt_fwd
endef

define SEMTECH_LORAGW_PKT_FWD_INSTALL_TARGET_CMDS
        $(INSTALL) -m 0755 -D $(@D)/lora_pkt_fwd/lora_pkt_fwd		-t $(TARGET_DIR)/opt/lora-net/
        $(INSTALL) -m 0755 -D package/semtech-loragw-pkt-fwd/*.sh	-t $(TARGET_DIR)/opt/lora-net/
	$(INSTALL) -m 0644 -D package/semtech-loragw-pkt-fwd/*.json	-t $(TARGET_DIR)/opt/lora-net/
endef

$(eval $(generic-package))

