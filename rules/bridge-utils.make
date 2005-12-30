# -*-makefile-*-
# $Id: template 2224 2005-01-20 15:19:18Z rsc $
#
# Copyright (C) 2005 by Gary Thomas <gary@mlbassoc.com>
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

# FIXME: RSC: ipkgize

#
# We provide this package
#
PACKAGES-$(PTXCONF_BRIDGE_UTILS) += bridge-utils

#
# Paths and names
#
BRIDGE_UTILS_VERSION	= 1.0.4
BRIDGE_UTILS		= bridge-utils-$(BRIDGE_UTILS_VERSION)
BRIDGE_UTILS_SUFFIX	= tar.gz
BRIDGE_UTILS_URL	= $(PTXCONF_SETUP_SFMIRROR)/bridge/$(BRIDGE_UTILS).$(BRIDGE_UTILS_SUFFIX)
BRIDGE_UTILS_SOURCE	= $(SRCDIR)/$(BRIDGE_UTILS).$(BRIDGE_UTILS_SUFFIX)
BRIDGE_UTILS_DIR	= $(BUILDDIR)/$(BRIDGE_UTILS)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

bridge-utils_get: $(STATEDIR)/bridge-utils.get

bridge-utils_get_deps = $(BRIDGE_UTILS_SOURCE)

$(STATEDIR)/bridge-utils.get: $(bridge-utils_get_deps)
	@$(call targetinfo, $@)
	@$(call get_patches, $(BRIDGE_UTILS))
	@$(call touch, $@)

$(BRIDGE_UTILS_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(BRIDGE_UTILS_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

bridge-utils_extract: $(STATEDIR)/bridge-utils.extract

bridge-utils_extract_deps = $(STATEDIR)/bridge-utils.get

$(STATEDIR)/bridge-utils.extract: $(bridge-utils_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(BRIDGE_UTILS_DIR))
	@$(call extract, $(BRIDGE_UTILS_SOURCE))
	@$(call patchin, $(BRIDGE_UTILS))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

bridge-utils_prepare: $(STATEDIR)/bridge-utils.prepare

#
# dependencies
#
bridge-utils_prepare_deps = \
	$(STATEDIR)/bridge-utils.extract \
	$(STATEDIR)/virtual-xchain.install

BRIDGE_UTILS_PATH	=  PATH=$(CROSS_PATH)
BRIDGE_UTILS_ENV 	=  $(CROSS_ENV)

#
# autoconf
#
BRIDGE_UTILS_AUTOCONF =  $(CROSS_AUTOCONF_USR)

$(STATEDIR)/bridge-utils.prepare: $(bridge-utils_prepare_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(BRIDGE_UTILS_DIR)/config.cache)
	cd $(BRIDGE_UTILS_DIR) && \
		$(BRIDGE_UTILS_PATH) $(BRIDGE_UTILS_ENV) \
		./configure $(BRIDGE_UTILS_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

bridge-utils_compile: $(STATEDIR)/bridge-utils.compile

bridge-utils_compile_deps = $(STATEDIR)/bridge-utils.prepare

$(STATEDIR)/bridge-utils.compile: $(bridge-utils_compile_deps)
	@$(call targetinfo, $@)
	cd $(BRIDGE_UTILS_DIR) && $(BRIDGE_UTILS_ENV) $(BRIDGE_UTILS_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

bridge-utils_install: $(STATEDIR)/bridge-utils.install

$(STATEDIR)/bridge-utils.install: $(STATEDIR)/bridge-utils.compile
	@$(call targetinfo, $@)
	# FIXME
	#@$(call install, APACHE2)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

bridge-utils_targetinstall: $(STATEDIR)/bridge-utils.targetinstall

bridge-utils_targetinstall_deps = $(STATEDIR)/bridge-utils.compile

$(STATEDIR)/bridge-utils.targetinstall: $(bridge-utils_targetinstall_deps)
	@$(call targetinfo, $@)
	cd $(BRIDGE_UTILS_DIR) && $(BRIDGE_UTILS_ENV) $(BRIDGE_UTILS_PATH) make prefix=$(ROOTDIR) install
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

bridge-utils_clean:
	rm -rf $(STATEDIR)/bridge-utils.*
	rm -rf $(BRIDGE_UTILS_DIR)

# vim: syntax=make
