# -*-makefile-*-
#
# Copyright (C) 2006 by Robert Schwebel
#           (C) 2010 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#

#
HOST_PACKAGES-$(PTXCONF_HOST_PELTS) += host-pelts

#
# Paths and names
#
HOST_PELTS_VERSION	:= 1.0.12
HOST_PELTS_MD5		:= d3543b296a8ce36603e84cfb47897c1f
HOST_PELTS		:= pelts-$(HOST_PELTS_VERSION)
HOST_PELTS_SUFFIX	:= tar.bz2
HOST_PELTS_URL		:= http://www.pengutronix.de/software/pelts/download/v1/$(HOST_PELTS).$(HOST_PELTS_SUFFIX)
HOST_PELTS_SOURCE	:= $(SRCDIR)/$(HOST_PELTS).$(HOST_PELTS_SUFFIX)
HOST_PELTS_DIR		:= $(HOST_BUILDDIR)/$(HOST_PELTS)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_PELTS_CONF_TOOL	:= autoconf

# vim: syntax=make
