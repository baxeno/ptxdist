# -*-makefile-*-
#
# Copyright (C) 2015 by Michael Olbrich <m.olbrich@pengutronix.de>
#           (C) 2018 by Florian Bäuerle <florian.baeuerle@allegion.com>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_XORG_FONT_TTF_NOTO) += xorg-font-ttf-noto

#
# Paths and names
#
XORG_FONT_TTF_NOTO_VERSION	:= 20151129-g69424ef5945c
XORG_FONT_TTF_NOTO_MD5		:= a359e6671d5f41fd7616d52dc87ccbf2
XORG_FONT_TTF_NOTO		:= noto-fonts-$(XORG_FONT_TTF_NOTO_VERSION)
XORG_FONT_TTF_NOTO_SUFFIX	:= tar.gz
XORG_FONT_TTF_NOTO_URL		:= https://github.com/notofonts/noto-fonts/archive/$(XORG_FONT_TTF_NOTO).$(XORG_FONT_TTF_NOTO_SUFFIX)
XORG_FONT_TTF_NOTO_SOURCE	:= $(SRCDIR)/$(XORG_FONT_TTF_NOTO).$(XORG_FONT_TTF_NOTO_SUFFIX)
XORG_FONT_TTF_NOTO_DIR		:= $(BUILDDIR)/$(XORG_FONT_TTF_NOTO)
XORG_FONT_TTF_NOTO_LICENSE	:= OFL-1.1

XORG_FONT_TTF_NOTO_CONF_TOOL	:= NO
XORG_FONT_TTF_NOTO_FONTDIR	:= $(XORG_FONTDIR)/truetype/noto

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/xorg-font-ttf-noto.compile:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xorg-font-ttf-noto.install:
	@$(call targetinfo)
	@$(call world/install-fonts,XORG_FONT_TTF_NOTO,*.ttf)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xorg-font-ttf-noto.targetinstall:
	@$(call targetinfo)
	@$(call install_init, xorg-font-ttf-noto)
	@$(call install_fixup, xorg-font-ttf-noto,PRIORITY,optional)
	@$(call install_fixup, xorg-font-ttf-noto,SECTION,base)
	@$(call install_fixup, xorg-font-ttf-noto,AUTHOR,"Florian Bäuerle <florian.baeuerle@allegion.com>")
	@$(call install_fixup, xorg-font-ttf-noto,DESCRIPTION,missing)

	@$(call install_tree, xorg-font-ttf-noto, 0, 0, -, /usr)

	@$(call install_finish, xorg-font-ttf-noto)
	@$(call touch)

# vim: syntax=make
