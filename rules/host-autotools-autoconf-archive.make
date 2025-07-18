# -*-makefile-*-
#
# Copyright (C) 2017 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_AUTOTOOLS_AUTOCONF_ARCHIVE) += host-autotools-autoconf-archive

#
# Paths and names
#
HOST_AUTOTOOLS_AUTOCONF_ARCHIVE_VERSION	:= 2024.10.16
HOST_AUTOTOOLS_AUTOCONF_ARCHIVE_MD5	:= 6b39e10f2d67b19c01632021a71fb378
HOST_AUTOTOOLS_AUTOCONF_ARCHIVE		:= autoconf-archive-$(HOST_AUTOTOOLS_AUTOCONF_ARCHIVE_VERSION)
HOST_AUTOTOOLS_AUTOCONF_ARCHIVE_SUFFIX	:= tar.xz
HOST_AUTOTOOLS_AUTOCONF_ARCHIVE_URL	:= $(call ptx/mirror, GNU, autoconf-archive/$(HOST_AUTOTOOLS_AUTOCONF_ARCHIVE).$(HOST_AUTOTOOLS_AUTOCONF_ARCHIVE_SUFFIX))
HOST_AUTOTOOLS_AUTOCONF_ARCHIVE_SOURCE	:= $(SRCDIR)/$(HOST_AUTOTOOLS_AUTOCONF_ARCHIVE).$(HOST_AUTOTOOLS_AUTOCONF_ARCHIVE_SUFFIX)
HOST_AUTOTOOLS_AUTOCONF_ARCHIVE_DIR	:= $(HOST_BUILDDIR)/$(HOST_AUTOTOOLS_AUTOCONF_ARCHIVE)
HOST_AUTOTOOLS_AUTOCONF_ARCHIVE_LICENSE	:= GPL-3.0-or-later WITH Autoconf-exception-3.0
HOST_AUTOTOOLS_AUTOCONF_ARCHIVE_LICENSE_FILES := \
	file://COPYING;md5=11cc2d3ee574f9d6b7ee797bdce4d423 \
	file://COPYING.EXCEPTION;md5=fdef168ebff3bc2f13664c365a5fb515 \
	file://README;startline=51;endline=67;md5=3f11cfe44d65b72a29f05d8638b6c356

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_AUTOTOOLS_AUTOCONF_ARCHIVE_CONF_TOOL	:= autoconf

# vim: syntax=make
