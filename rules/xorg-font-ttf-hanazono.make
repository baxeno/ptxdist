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
PACKAGES-$(PTXCONF_XORG_FONT_TTF_HANAZONO) += xorg-font-ttf-hanazono

#
# Paths and names
#
XORG_FONT_TTF_HANAZONO_VERSION		:= 20170904
XORG_FONT_TTF_HANAZONO_MD5		:= 3614983d1a899dc212ed377c4b5c99eb
XORG_FONT_TTF_HANAZONO			:= hanazono-$(XORG_FONT_TTF_HANAZONO_VERSION)
XORG_FONT_TTF_HANAZONO_SUFFIX		:= zip
XORG_FONT_TTF_HANAZONO_URL		:= https://glyphwiki.org/hanazono/$(XORG_FONT_TTF_HANAZONO).$(XORG_FONT_TTF_HANAZONO_SUFFIX)
XORG_FONT_TTF_HANAZONO_SOURCE		:= $(SRCDIR)/$(XORG_FONT_TTF_HANAZONO).$(XORG_FONT_TTF_HANAZONO_SUFFIX)
XORG_FONT_TTF_HANAZONO_DIR		:= $(BUILDDIR)/$(XORG_FONT_TTF_HANAZONO)
XORG_FONT_TTF_HANAZONO_STRIP_LEVEL	:= 0
XORG_FONT_TTF_HANAZONO_LICENSE		:= OFL-1.1
XORG_FONT_TTF_HANAZONO_LICENSE_FILES	:= file://LICENSE.txt;md5=aaede1ca24363a103976ba88f5905f40

XORG_FONT_TTF_HANAZONO_CONF_TOOL	:= NO
XORG_FONT_TTF_HANAZONO_FONTDIR		:= $(XORG_FONTDIR)/truetype/hanazono

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/xorg-font-ttf-hanazono.compile:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xorg-font-ttf-hanazono.install:
	@$(call targetinfo)
	@$(call world/install-fonts,XORG_FONT_TTF_HANAZONO,*.ttf)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/xorg-font-ttf-hanazono.targetinstall:
	@$(call targetinfo)
	@$(call install_init, xorg-font-ttf-hanazono)
	@$(call install_fixup, xorg-font-ttf-hanazono,PRIORITY,optional)
	@$(call install_fixup, xorg-font-ttf-hanazono,SECTION,base)
	@$(call install_fixup, xorg-font-ttf-hanazono,AUTHOR,"Florian Bäuerle <florian.baeuerle@allegion.com>")
	@$(call install_fixup, xorg-font-ttf-hanazono,DESCRIPTION,missing)

	@$(call install_tree, xorg-font-ttf-hanazono, 0, 0, -, /usr)

	@$(call install_finish, xorg-font-ttf-hanazono)
	@$(call touch)

# vim: syntax=make
