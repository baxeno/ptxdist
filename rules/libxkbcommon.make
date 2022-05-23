# -*-makefile-*-
#
# Copyright (C) 2013 by Philipp Zabel <p.zabel@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBXKBCOMMON) += libxkbcommon

#
# Paths and names
#
LIBXKBCOMMON_VERSION	:= 1.4.1
LIBXKBCOMMON_MD5	:= a871be5c9af2511f899e1bd6db8b429f
LIBXKBCOMMON		:= libxkbcommon-$(LIBXKBCOMMON_VERSION)
LIBXKBCOMMON_SUFFIX	:= tar.xz
LIBXKBCOMMON_URL	:= http://xkbcommon.org/download/$(LIBXKBCOMMON).$(LIBXKBCOMMON_SUFFIX)
LIBXKBCOMMON_SOURCE	:= $(SRCDIR)/$(LIBXKBCOMMON).$(LIBXKBCOMMON_SUFFIX)
LIBXKBCOMMON_DIR	:= $(BUILDDIR)/$(LIBXKBCOMMON)
LIBXKBCOMMON_LICENSE	:= MIT AND X11 AND HPND
LIBXKBCOMMON_LICENSE_FILES := file://LICENSE;md5=e525ed9809e1f8a07cf4bce8b09e8b87

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
LIBXKBCOMMON_CONF_TOOL	:= meson
LIBXKBCOMMON_CONF_OPT	:= \
	$(CROSS_MESON_USR) \
	-Ddefault-layout='us' \
	-Ddefault-model='pc105' \
	-Ddefault-options='' \
	-Ddefault-rules='evdev' \
	-Ddefault-variant='' \
	-Denable-docs=false \
	-Denable-tools=false \
	-Denable-wayland=false \
	-Denable-x11=$(call ptx/truefalse, PTXCONF_LIBXKBCOMMON_X11) \
	-Denable-xkbregistry=false \
	-Dx-locale-root=$(XORG_DATADIR)/X11/locale \
	-Dxkb-config-extra-path=/etc/xkb \
	-Dxkb-config-root=$(XORG_DATADIR)/X11/xkb \

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libxkbcommon.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libxkbcommon)
	@$(call install_fixup, libxkbcommon,PRIORITY,optional)
	@$(call install_fixup, libxkbcommon,SECTION,base)
	@$(call install_fixup, libxkbcommon,AUTHOR,"Philipp Zabel <p.zabel@pengutronix.de>")
	@$(call install_fixup, libxkbcommon,DESCRIPTION,missing)

	@$(call install_lib, libxkbcommon, 0, 0, 0644, libxkbcommon)
ifdef PTXCONF_LIBXKBCOMMON_X11
	@$(call install_lib, libxkbcommon, 0, 0, 0644, libxkbcommon-x11)
endif

	@$(call install_finish, libxkbcommon)

	@$(call touch)

# vim: syntax=make
