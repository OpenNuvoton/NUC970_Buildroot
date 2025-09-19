################################################################################
#
# bison
#
################################################################################

BISON_VERSION = 3.8.2
BISON_SOURCE = bison-$(BISON_VERSION).tar.xz
BISON_SITE = $(BR2_GNU_MIRROR)/bison
BISON_LICENSE = GPLv3+
BISON_LICENSE_FILES = COPYING
HOST_BISON_DEPENDENCIES = host-m4

$(eval $(host-autotools-package))
