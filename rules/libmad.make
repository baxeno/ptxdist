# -*-makefile-*-
#
# Copyright (C) 2008 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBMAD) += libmad

#
# Paths and names
#
LIBMAD_VERSION	:= 0.15.1b
LIBMAD_MD5	:= 1be543bc30c56fb6bea1d7bf6a64e66c
LIBMAD		:= libmad-$(LIBMAD_VERSION)
LIBMAD_SUFFIX	:= tar.gz
LIBMAD_URL	:=  $(call ptx/mirror, SF, mad/libmad/$(LIBMAD_VERSION)/$(LIBMAD).$(LIBMAD_SUFFIX))
LIBMAD_SOURCE	:= $(SRCDIR)/$(LIBMAD).$(LIBMAD_SUFFIX)
LIBMAD_DIR	:= $(BUILDDIR)/$(LIBMAD)
LIBMAD_LICENSE	:= GPL-2.0-or-later

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
LIBMAD_CONF_TOOL := autoconf
LIBMAD_CONF_OPT := \
	$(CROSS_AUTOCONF_USR) \
	--disable-debugging \
	--disable-profiling \
	--disable-experimental

ifdef PTXCONF_LIBMAD__OPT_SPEED
LIBMAD_CONF_OPT += --enable-speed
endif
ifdef PTXCONF_LIBMAD__OPT_ACCURACY
LIBMAD_CONF_OPT += --enable-accuracy
endif

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libmad.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libmad)
	@$(call install_fixup, libmad,PRIORITY,optional)
	@$(call install_fixup, libmad,SECTION,base)
	@$(call install_fixup, libmad,AUTHOR,"Marc Kleine-Budde <mkl@pengutronix.de>")
	@$(call install_fixup, libmad,DESCRIPTION,missing)

	@$(call install_lib, libmad, 0, 0, 0644, libmad)

	@$(call install_finish, libmad)

	@$(call touch)

# vim: syntax=make
