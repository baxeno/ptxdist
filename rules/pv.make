# -*-makefile-*-
#
# Copyright (C) 2009 by Wolfram Sang
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_PV) += pv

#
# Paths and names
#
PV_VERSION	:= 1.4.12
PV_MD5		:= 605adc0f369496bca92b0656cf86b25e
PV		:= pv-$(PV_VERSION)
PV_SUFFIX	:= tar.bz2
PV_URL		:= http://www.ivarch.com/programs/sources/$(PV).$(PV_SUFFIX)
PV_SOURCE	:= $(SRCDIR)/$(PV).$(PV_SUFFIX)
PV_DIR		:= $(BUILDDIR)/$(PV)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

PV_MAKE_OPT	:= $(CROSS_ENV_LD)

#
# autoconf
#
PV_CONF_TOOL	:= autoconf
PV_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-nls \
	--disable-splice \
	--disable-ipc \
	--$(call ptx/endis, PTXCONF_GLOBAL_LARGE_FILE)-lfs \
	--enable-debugging

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/pv.targetinstall:
	@$(call targetinfo)

	@$(call install_init, pv)
	@$(call install_fixup, pv,PRIORITY,optional)
	@$(call install_fixup, pv,SECTION,base)
	@$(call install_fixup, pv,AUTHOR,"Wolfram Sang <w.sang@pengutronix.de>")
	@$(call install_fixup, pv,DESCRIPTION,missing)

	@$(call install_copy, pv, 0, 0, 0755, -, /usr/bin/pv)

	@$(call install_finish, pv)

	@$(call touch)

# vim: syntax=make
