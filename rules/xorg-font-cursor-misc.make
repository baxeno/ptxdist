# -*-makefile-*-
#
# Copyright (C) 2006 by Erwin Rol
#           (C) 2010 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_XORG_FONT_CURSOR_MISC) += xorg-font-cursor-misc

#
# Paths and names
#
XORG_FONT_CURSOR_MISC_VERSION	:= 1.0.3
XORG_FONT_CURSOR_MISC_MD5	:= 3e0069d4f178a399cffe56daa95c2b63
XORG_FONT_CURSOR_MISC		:= font-cursor-misc-$(XORG_FONT_CURSOR_MISC_VERSION)
XORG_FONT_CURSOR_MISC_SUFFIX	:= tar.bz2
XORG_FONT_CURSOR_MISC_URL	:= $(call ptx/mirror, XORG, individual/font/$(XORG_FONT_CURSOR_MISC).$(XORG_FONT_CURSOR_MISC_SUFFIX))
XORG_FONT_CURSOR_MISC_SOURCE	:= $(SRCDIR)/$(XORG_FONT_CURSOR_MISC).$(XORG_FONT_CURSOR_MISC_SUFFIX)
XORG_FONT_CURSOR_MISC_DIR	:= $(BUILDDIR)/$(XORG_FONT_CURSOR_MISC)

ifdef PTXCONF_XORG_FONT_CURSOR_MISC
$(STATEDIR)/xorg-fonts.targetinstall.post: $(STATEDIR)/xorg-font-cursor-misc.targetinstall
endif

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
XORG_FONT_CURSOR_MISC_CONF_TOOL	:= autoconf
XORG_FONT_CURSOR_MISC_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--with-fontdir=$(XORG_FONTDIR)/misc

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xorg-font-cursor-misc.install:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xorg-font-cursor-misc.targetinstall:
	@$(call targetinfo)

	@mkdir -p $(XORG_FONTS_DIR_INSTALL)/misc

	@find $(XORG_FONT_CURSOR_MISC_DIR) \
		-name "*.pcf.gz" \
		| \
		while read file; do \
		install -m 644 $${file} $(XORG_FONTS_DIR_INSTALL)/misc; \
	done

	@$(call touch)

# vim: syntax=make
