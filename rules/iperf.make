# -*-makefile-*-
#
# Copyright (C) 2007 by Sascha Hauer
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_IPERF) += iperf

#
# Paths and names
#
IPERF_VERSION	:= 2.0.13
IPERF_MD5	:= 31ea1c6d5cbf80b16ff3abe4288dad5e
IPERF		:= iperf-$(IPERF_VERSION)
IPERF_SUFFIX	:= tar.gz
IPERF_URL	:= $(call ptx/mirror, SF, iperf2/$(IPERF).$(IPERF_SUFFIX))
IPERF_SOURCE	:= $(SRCDIR)/$(IPERF).$(IPERF_SUFFIX)
IPERF_DIR	:= $(BUILDDIR)/$(IPERF)
IPERF_LICENSE	:= BSD

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
IPERF_CONF_TOOL := autoconf
IPERF_CONF_OPT := \
	$(CROSS_AUTOCONF_USR) \
	$(GLOBAL_IPV6_OPTION) \
	--enable-multicast \
	--enable-threads \
	--disable-debuginfo \
	--disable-web100 \
	--enable-kalman \
	--enable-seqno64b \
	--enable-isochronous \
	--disable-fastsampling \
	--disable-checkprograms \
	--enable-af-packet

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/iperf.targetinstall:
	@$(call targetinfo)

	@$(call install_init, iperf)
	@$(call install_fixup, iperf,PRIORITY,optional)
	@$(call install_fixup, iperf,SECTION,base)
	@$(call install_fixup, iperf,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, iperf,DESCRIPTION,missing)

	@$(call install_copy, iperf, 0, 0, 0755, -, /usr/bin/iperf)

	@$(call install_finish, iperf)

	@$(call touch)

# vim: syntax=make
