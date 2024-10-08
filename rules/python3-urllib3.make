# -*-makefile-*-
#
# Copyright (C) 2020 by Lars Pedersen <lapeddk@gmail.com>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_PYTHON3_URLLIB3) += python3-urllib3

#
# Paths and names
#
PYTHON3_URLLIB3_VERSION	:= 2.2.2
PYTHON3_URLLIB3_MD5	:= efb79cfdef7b811687afe02ccaf67433
PYTHON3_URLLIB3		:= urllib3-$(PYTHON3_URLLIB3_VERSION)
PYTHON3_URLLIB3_SUFFIX	:= tar.gz
PYTHON3_URLLIB3_URL	:= $(call ptx/mirror-pypi, urllib3, $(PYTHON3_URLLIB3).$(PYTHON3_URLLIB3_SUFFIX))
PYTHON3_URLLIB3_SOURCE	:= $(SRCDIR)/$(PYTHON3_URLLIB3).$(PYTHON3_URLLIB3_SUFFIX)
PYTHON3_URLLIB3_DIR	:= $(BUILDDIR)/$(PYTHON3_URLLIB3)
PYTHON3_URLLIB3_LICENSE	:= MIT
PYTHON3_URLLIB3_LICENSE_FILES := \
	file://LICENSE.txt;md5=52d273a3054ced561275d4d15260ecda \

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

PYTHON3_URLLIB3_CONF_TOOL	:= python3

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/python3-urllib3.targetinstall:
	@$(call targetinfo)

	@$(call install_init, python3-urllib3)
	@$(call install_fixup, python3-urllib3,PRIORITY,optional)
	@$(call install_fixup, python3-urllib3,SECTION,base)
	@$(call install_fixup, python3-urllib3,AUTHOR,"Lars Pedersen <lapeddk@gmail.com>")
	@$(call install_fixup, python3-urllib3,DESCRIPTION,missing)

	@$(call install_glob, python3-urllib3, 0, 0, -, \
		$(PYTHON3_SITEPACKAGES),, *.py)

	@$(call install_finish, python3-urllib3)

	@$(call touch)

# vim: syntax=make
