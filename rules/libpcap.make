# -*-makefile-*-
# $Id: libpcap.make,v 1.1 2003/09/09 00:12:42 mkl Exp $
#
# (c) 2003 by Marc Kleine-Budde
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXDIST project and license conditions
# see the README file.
#

#
# We provide this package
#
ifdef PTXCONF_LIBPCAP
PACKAGES += libpcap
endif

#
# Paths and names
#
LIBPCAP_VERSION	= 0.7.2
LIBPCAP		= libpcap-$(LIBPCAP_VERSION)
LIBPCAP_SUFFIX	= tar.gz
LIBPCAP_URL	= http://www.tcpdump.org/release/$(LIBPCAP).$(LIBPCAP_SUFFIX)
LIBPCAP_SOURCE	= $(SRCDIR)/$(LIBPCAP).$(LIBPCAP_SUFFIX)
LIBPCAP_DIR	= $(BUILDDIR)/$(LIBPCAP)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

libpcap_get: $(STATEDIR)/libpcap.get

libpcap_get_deps	=  $(LIBPCAP_SOURCE)

$(STATEDIR)/libpcap.get: $(libpcap_get_deps)
	@$(call targetinfo, libpcap.get)
	touch $@

$(LIBPCAP_SOURCE):
	@$(call targetinfo, $(LIBPCAP_SOURCE))
	@$(call get, $(LIBPCAP_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

libpcap_extract: $(STATEDIR)/libpcap.extract

libpcap_extract_deps	=  $(STATEDIR)/libpcap.get

$(STATEDIR)/libpcap.extract: $(libpcap_extract_deps)
	@$(call targetinfo, libpcap.extract)
	@$(call clean, $(LIBPCAP_DIR))
	@$(call extract, $(LIBPCAP_SOURCE))
	touch $@

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

libpcap_prepare: $(STATEDIR)/libpcap.prepare

#
# dependencies
#
libpcap_prepare_deps =  \
	$(STATEDIR)/libpcap.extract \
	$(STATEDIR)/virtual-xchain.install

LIBPCAP_PATH	=  PATH=$(CROSS_PATH)
LIBPCAP_ENV 	=  $(CROSS_ENV)
LIBPCAP_ENV	+= ac_cv_linux_vers=2


#
# autoconf
#
LIBPCAP_AUTOCONF	=  --prefix=$(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)
LIBPCAP_AUTOCONF	+= --build=$(GNU_HOST)
LIBPCAP_AUTOCONF	+= --host=$(PTXCONF_GNU_TARGET)
LIBPCAP_AUTOCONF	+= --with-pcap=linux

$(STATEDIR)/libpcap.prepare: $(libpcap_prepare_deps)
	@$(call targetinfo, libpcap.prepare)
	@$(call clean, $(LIBPCAP_BUILDDIR))
	cd $(LIBPCAP_DIR) && \
		$(LIBPCAP_PATH) $(LIBPCAP_ENV) \
		./configure $(LIBPCAP_AUTOCONF)
	touch $@

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

libpcap_compile: $(STATEDIR)/libpcap.compile

libpcap_compile_deps =  $(STATEDIR)/libpcap.prepare

$(STATEDIR)/libpcap.compile: $(libpcap_compile_deps)
	@$(call targetinfo, libpcap.compile)
	$(LIBPCAP_PATH) make -C $(LIBPCAP_DIR)
	touch $@

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

libpcap_install: $(STATEDIR)/libpcap.install

$(STATEDIR)/libpcap.install: $(STATEDIR)/libpcap.compile
	@$(call targetinfo, libpcap.install)
	$(LIBPCAP_PATH) make -C $(LIBPCAP_DIR) install
	touch $@

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

libpcap_targetinstall: $(STATEDIR)/libpcap.targetinstall

libpcap_targetinstall_deps	=

$(STATEDIR)/libpcap.targetinstall: $(libpcap_targetinstall_deps)
	@$(call targetinfo, libpcap.targetinstall)
	touch $@

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

libpcap_clean:
	rm -rf $(STATEDIR)/libpcap.*
	rm -rf $(LIBPCAP_DIR)

# vim: syntax=make
