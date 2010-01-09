# -*-makefile-*-
#
# Copyright (C) 2007 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_LIBXCB) += host-libxcb

#
# Paths and names
#
HOST_LIBXCB_DIR	= $(HOST_BUILDDIR)/$(LIBXCB)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(STATEDIR)/host-libxcb.get: $(STATEDIR)/libxcb.get
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

HOST_LIBXCB_PATH	:= PATH=$(HOST_PATH)
HOST_LIBXCB_ENV 	:= $(HOST_ENV)

#
# autoconf
#
HOST_LIBXCB_AUTOCONF	:= \
	$(HOST_AUTOCONF) \
	--disable-build-docs

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

host-libxcb_clean:
	rm -rf $(STATEDIR)/host-libxcb.*
	rm -rf $(HOST_LIBXCB_DIR)

# vim: syntax=make
