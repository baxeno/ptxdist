# -*-makefile-*-
# $Id: libnet.make,v 1.7 2003/10/23 15:01:19 mkl Exp $
#
# Copyright (C) 2003 by Marc Kleine-Budde <kleine-budde.de>
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
ifdef PTXCONF_LIBNET
PACKAGES += libnet
endif

#
# Paths and names
#
LIBNET_VERSION	= 1.1.0
LIBNET		= libnet-$(LIBNET_VERSION)
LIBNET_SUFFIX	= tar.gz
LIBNET_URL	= http://www.packetfactory.net/libnet/dist/$(LIBNET).$(LIBNET_SUFFIX)
LIBNET_SOURCE	= $(SRCDIR)/$(LIBNET).$(LIBNET_SUFFIX)
LIBNET_DIR	= $(BUILDDIR)/Libnet-latest

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

libnet_get: $(STATEDIR)/libnet.get

libnet_get_deps	=  $(LIBNET_SOURCE)

$(STATEDIR)/libnet.get: $(libnet_get_deps)
	@$(call targetinfo, $@)
	@$(call get_patches, $(LIBNET))
	touch $@

$(LIBNET_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(LIBNET_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

libnet_extract: $(STATEDIR)/libnet.extract

libnet_extract_deps = \
	$(STATEDIR)/automake15.install \
	$(STATEDIR)/autoconf257.install \
	$(STATEDIR)/libnet.get

$(STATEDIR)/libnet.extract: $(libnet_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBNET_DIR))
	@$(call extract, $(LIBNET_SOURCE))
	@$(call patchin, $(LIBNET), $(LIBNET_DIR))
	cd $(LIBNET_DIR) && \
		$(PTXCONF_PREFIX)/$(AUTOMAKE15)/bin/aclocal && \
		$(PTXCONF_PREFIX)/$(AUTOMAKE15)/bin/automake && \
		$(PTXCONF_PREFIX)/$(AUTOCONF257)/bin/autoconf
	touch $@

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

libnet_prepare: $(STATEDIR)/libnet.prepare

#
# dependencies
#
libnet_prepare_deps =  \
	$(STATEDIR)/libnet.extract \
	$(STATEDIR)/virtual-xchain.install

LIBNET_PATH	=  PATH=$(CROSS_PATH)
LIBNET_ENV 	=  $(CROSS_ENV)
LIBNET_ENV 	+= ac_libnet_have_packet_socket=yes

#
# autoconf
#
LIBNET_AUTOCONF	=  --prefix=$(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)
LIBNET_AUTOCONF	+= --build=$(GNU_HOST)
LIBNET_AUTOCONF	+= --host=$(PTXCONF_GNU_TARGET)
LIBNET_AUTOCONF	+= --with-pf_packet=yes

$(STATEDIR)/libnet.prepare: $(libnet_prepare_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(LIBNET_BUILDDIR))
	cd $(LIBNET_DIR) && \
		$(LIBNET_PATH) $(LIBNET_ENV) \
		./configure $(LIBNET_AUTOCONF)
	touch $@

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

libnet_compile: $(STATEDIR)/libnet.compile

libnet_compile_deps =  $(STATEDIR)/libnet.prepare

$(STATEDIR)/libnet.compile: $(libnet_compile_deps)
	@$(call targetinfo, $@)
	$(LIBNET_PATH) $(LIBNET_ENV) make -C $(LIBNET_DIR)
	touch $@

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

libnet_install: $(STATEDIR)/libnet.install

$(STATEDIR)/libnet.install: $(STATEDIR)/libnet.compile
	@$(call targetinfo, $@)
	$(LIBNET_PATH) $(LIBNET_ENV) make -C $(LIBNET_DIR) install
	touch $@

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

libnet_targetinstall: $(STATEDIR)/libnet.targetinstall

libnet_targetinstall_deps	=  $(STATEDIR)/libnet.install

$(STATEDIR)/libnet.targetinstall: $(libnet_targetinstall_deps)
	@$(call targetinfo, $@)
	touch $@

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

libnet_clean:
	rm -rf $(STATEDIR)/libnet.*
	rm -rf $(LIBNET_DIR)

# vim: syntax=make
