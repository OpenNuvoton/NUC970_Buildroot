################################################################################
#
# mbed-edge
#
################################################################################

MBED_EDGE_VERSION = 45aae544a82bb489cdaba9efd2cdd117c8f3f3ab
MBED_EDGE_SITE = https://github.com/ARMmbed/mbed-edge.git
MBED_EDGE_SITE_METHOD = git
MBED_EDGE_GIT_SUBMODULES = YES
MBED_EDGE_LICENSE = Apache-2.0
MBED_EDGE_LICENSE_FILES = LICENSE
MBED_EDGE_INSTALL_STAGING = YES
MBED_EDGE_INSTALL_TARGET = YES
MBED_EDGE_CONF_OPTS += -DDEVELOPER_MODE=ON 
MBED_EDGE_CONF_OPTS += -DFIRMWARE_UPDATE=OFF
MBED_EDGE_CONF_OPTS += -DFACTORY_MODE=OFF
MBED_EDGE_CONF_OPTS += -DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -std=gnu99 -pthread -DMBED_CONF_APP_DEVELOPER_MODE=1 -DPAL_DTLS_PEER_MIN_TIMEOUT=5000 -DPAL_SUPPORT_IP_V6=false -DPAL_NET_DNS_IP_SUPPORT=2 -DPAL_USE_SSL_SESSION_RESUM=0"
HOST_MBED_EDGE_DEPENDENCIES += host-automake host-cmake

define MBED_EDGE_INSTALL_TARGET_CMDS
        $(INSTALL) -D -m 0755 $(@D)/bin/edge-core -t $(TARGET_DIR)/opt/mbed-edge/bin/
        find $(@D) -name *.so | xargs $(INSTALL) -D -m 0755 -t $(TARGET_DIR)/opt/mbed-edge/lib
endef

$(eval $(cmake-package))
