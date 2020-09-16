################################################################################
#
# mbed-edge-examples
#
################################################################################

MBED_EDGE_EXAMPLES_VERSION = cd505d1486a4a98800adb99c610706feabd60b11
MBED_EDGE_EXAMPLES_SITE = https://github.com/ARMmbed/mbed-edge-examples.git
MBED_EDGE_EXAMPLES_SITE_METHOD = git
MBED_EDGE_EXAMPLES_GIT_SUBMODULES = YES
MBED_EDGE_EXAMPLES_LICENSE = Apache-2.0
MBED_EDGE_EXAMPLES_LICENSE_FILES = LICENSE
MBED_EDGE_EXAMPLES_INSTALL_STAGING = YES
MBED_EDGE_EXAMPLES_INSTALL_TARGET = YES
MBED_EDGE_EXAMPLES_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
MBED_EDGE_EXAMPLES_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF
HOST_MBED_EDGE_EXAMPLES_DEPENDENCIES += host-automake host-cmake
MBED_EDGE_EXAMPLES_DEPENDENCIES += mbed-edge mosquitto

define MBED_EDGE_EXAMPLES_INSTALL_TARGET_CMDS
        $(INSTALL) -D -m 0755 $(@D)/bin/* -t $(TARGET_DIR)/opt/mbed-edge/bin/
endef

$(eval $(cmake-package))
