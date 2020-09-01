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
HOST_MBED_EDGE_EXAMPLES_DEPENDENCIES += host-automake host-cmake
MBED_EDGE_EXAMPLES_DEPENDENCIES += mbed-edge mosquitto

define MBED_EDGE_EXAMPLES_INSTALL_TARGET_CMDS
        $(INSTALL) -D -m 0755 $(@D)/bin/* -t $(TARGET_DIR)/opt/mbed-edge/bin/
	find $(@D) -name *.so | xargs $(INSTALL) -D -m 0755 -t $(TARGET_DIR)/opt/mbed-edge/lib
endef

$(eval $(cmake-package))
