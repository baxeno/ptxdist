# -*-makefile-*-
# $Id: template 3079 2005-09-02 18:09:51Z rsc $
#
# Copyright (C) 2005 by BSP
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_PNET) += pnet

#
# Paths and names
#
PNET_VERSION	= 0.7.2
PNET		= pnet-$(PNET_VERSION)
PNET_SUFFIX	= tar.gz
PNET_URL	= http://www.southern-storm.com.au/download/$(PNET).$(PNET_SUFFIX)
PNET_SOURCE	= $(SRCDIR)/$(PNET).$(PNET_SUFFIX)
PNET_DIR	= $(BUILDDIR)/$(PNET)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

pnet_get: $(STATEDIR)/pnet.get

pnet_get_deps = $(PNET_SOURCE)

$(STATEDIR)/pnet.get: $(pnet_get_deps)
	@$(call targetinfo, $@)
	@$(call get_patches, $(PNET))
	$(call touch, $@)

$(PNET_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(PNET_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

pnet_extract: $(STATEDIR)/pnet.extract

pnet_extract_deps = $(STATEDIR)/pnet.get

$(STATEDIR)/pnet.extract: $(pnet_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(PNET_DIR))
	@$(call extract, $(PNET_SOURCE))
	@$(call patchin, $(PNET))
	$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

pnet_prepare: $(STATEDIR)/pnet.prepare

#
# dependencies
#
pnet_prepare_deps = \
	$(STATEDIR)/pnet.extract \
	$(STATEDIR)/treecc.install \
	$(STATEDIR)/virtual-xchain.install

PNET_PATH	=  PATH=$(CROSS_PATH)
PNET_ENV 	=  $(CROSS_ENV)
PNET_ENV	+= PKG_CONFIG_PATH=$(CROSS_LIB_DIR)/lib/pkgconfig

#
# autoconf
#
PNET_AUTOCONF =  $(CROSS_AUTOCONF)
PNET_AUTOCONF += --prefix=$(CROSS_LIB_DIR)

$(STATEDIR)/pnet.prepare: $(pnet_prepare_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(PNET_DIR)/config.cache)
	cd $(PNET_DIR) && \
		$(PNET_PATH) $(PNET_ENV) \
		./configure $(PNET_AUTOCONF)
	$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

pnet_compile: $(STATEDIR)/pnet.compile

pnet_compile_deps = $(STATEDIR)/pnet.prepare

$(STATEDIR)/pnet.compile: $(pnet_compile_deps)
	@$(call targetinfo, $@)
	cd $(PNET_DIR) && $(PNET_ENV) $(PNET_PATH) make
	$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

pnet_install: $(STATEDIR)/pnet.install

$(STATEDIR)/pnet.install: $(STATEDIR)/pnet.compile
	@$(call targetinfo, $@)
	cd $(PNET_DIR) && $(PNET_ENV) $(PNET_PATH) make install
	$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

pnet_targetinstall: $(STATEDIR)/pnet.targetinstall
pnet_targetinstall_deps = $(STATEDIR)/pnet.compile

$(STATEDIR)/pnet.targetinstall: $(pnet_targetinstall_deps)
	@$(call targetinfo, $@)

	@$(call install_init,default)
	@$(call install_fixup,PACKAGE,pnet)
	@$(call install_fixup,PRIORITY,optional)
	@$(call install_fixup,VERSION,$(PNET_VERSION))
	@$(call install_fixup,SECTION,base)
	@$(call install_fixup,AUTHOR,"Benedikt Spranger <b.spranger\@linutronix.de>")
	@$(call install_fixup,DEPENDS,)
	@$(call install_fixup,DESCRIPTION,missing)

	@$(call install_copy, 0, 0, 0755, $(PNET_DIR)/engine/ilrun, /usr/bin/ilrun)
	@$(call install_copy, 0, 0, 0755, $(PNET_DIR)/engine/ilverify, /usr/bin/ilverify)
		
	@$(call install_finish)

	$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

pnet_clean:
	rm -rf $(STATEDIR)/pnet.*
	rm -rf $(IMAGEDIR)/pnet_*
	rm -rf $(PNET_DIR)

# vim: syntax=make
