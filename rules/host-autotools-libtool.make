# -*-makefile-*-
#
# Copyright (C) 2009 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
LAZY_PACKAGES-$(PTXCONF_HOST_AUTOTOOLS_LIBTOOL) += host-autotools-libtool

#
# Paths and names
#
HOST_AUTOTOOLS_LIBTOOL_VERSION	:= 2.5.3
HOST_AUTOTOOLS_LIBTOOL_MD5	:= 42abe5bed6cc8207f0868968d89d77cf
HOST_AUTOTOOLS_LIBTOOL		:= libtool-$(HOST_AUTOTOOLS_LIBTOOL_VERSION)
HOST_AUTOTOOLS_LIBTOOL_SUFFIX	:= tar.gz
HOST_AUTOTOOLS_LIBTOOL_URL	:= $(call ptx/mirror, GNU, libtool/$(HOST_AUTOTOOLS_LIBTOOL).$(HOST_AUTOTOOLS_LIBTOOL_SUFFIX))
HOST_AUTOTOOLS_LIBTOOL_SOURCE	:= $(SRCDIR)/$(HOST_AUTOTOOLS_LIBTOOL).$(HOST_AUTOTOOLS_LIBTOOL_SUFFIX)
HOST_AUTOTOOLS_LIBTOOL_DIR	:= $(HOST_BUILDDIR)/$(HOST_AUTOTOOLS_LIBTOOL)
HOST_AUTOTOOLS_LIBTOOL_DEVPKG	:= NO
HOST_AUTOTOOLS_LIBTOOL_LICENSE	:= GPL-2.0-or-later
HOST_AUTOTOOLS_LIBTOOL_LICENSE_FILES := \
	file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/host-autotools-libtool.extract.post:
	@$(call targetinfo)
	@cd $(HOST_AUTOTOOLS_LIBTOOL_DIR) && touch -r m4/ltdl.m4 m4/libtool.m4
	@$(call world/patchin/post, HOST_AUTOTOOLS_LIBTOOL)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

HOST_AUTOTOOLS_LIBTOOL_CONF_ENV		:= \
	$(HOST_ENV) \
	HELP2MAN=: \
	MAKEINFO=:

#
# autoconf
#
HOST_AUTOTOOLS_LIBTOOL_CONF_TOOL	:= autoconf
HOST_AUTOTOOLS_LIBTOOL_CONF_OPT		:= \
	$(HOST_AUTOCONF_SYSROOT) \
	--disable-static

# vim: syntax=make
