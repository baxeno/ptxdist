# -*-makefile-*-
# $Id$
#
# Copyright (C) 2006 by Robert Schwebel
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_BINUTILS) += host-binutils

#
# Paths and names
#
HOST_BINUTILS_VERSION	= 2.16.1
HOST_BINUTILS		= binutils-$(HOST_BINUTILS_VERSION)
HOST_BINUTILS_SUFFIX	= tar.gz
HOST_BINUTILS_DIR	= $(HOST_BUILDDIR)/$(HOST_BINUTILS)

-include $(call package_depfile)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

host-binutils_get: $(STATEDIR)/host-binutils.get

$(STATEDIR)/host-binutils.get: $(BINUTILS_SOURCE)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

host-binutils_extract: $(STATEDIR)/host-binutils.extract

host-binutils_extract_deps = $(STATEDIR)/host-binutils.get

$(STATEDIR)/host-binutils.extract: $(host-binutils_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(HOST_BINUTILS_DIR))
	@$(call extract, $(BINUTILS_SOURCE), $(HOST_BUILDDIR))
	@$(call patchin, $(HOST_BINUTILS), $(HOST_BINUTILS_DIR))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

host-binutils_prepare: $(STATEDIR)/host-binutils.prepare

HOST_BINUTILS_PATH	=  PATH=$(HOST_PATH)
HOST_BINUTILS_ENV 	=  $(HOSTCC_ENV)

#
# autoconf
#
HOST_BINUTILS_AUTOCONF =  $(HOST_AUTOCONF)

$(STATEDIR)/host-binutils.prepare: $(host-binutils_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(HOST_BINUTILS_DIR)/config.cache)
	cd $(HOST_BINUTILS_DIR) && \
		$(HOST_BINUTILS_PATH) $(HOST_BINUTILS_ENV) \
		./configure $(HOST_BINUTILS_AUTOCONF)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

host-binutils_compile: $(STATEDIR)/host-binutils.compile

$(STATEDIR)/host-binutils.compile: $(host-binutils_compile_deps_default)
	@$(call targetinfo, $@)
	cd $(HOST_BINUTILS_DIR) && $(HOST_BINUTILS_ENV) $(HOST_BINUTILS_PATH) make
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

host-binutils_install: $(STATEDIR)/host-binutils.install

$(STATEDIR)/host-binutils.install: $(host-binutils_install_deps_default)
	@$(call targetinfo, $@)
ifdef PTXCONF_HOST_BINUTILS_LIBBFD
	@$(call install, HOST_BINUTILS,$(HOST_BINUTILS_DIR)/bfd,h)
endif
ifdef PTXCONF_HOST_BINUTILS_LIBIBERTY
	@$(call install, HOST_BINUTILS,$(HOST_BINUTILS_DIR)/libiberty,h)
endif
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

host-binutils_clean:
	rm -rf $(STATEDIR)/host-binutils.*
	rm -rf $(HOST_BINUTILS_DIR)

# vim: syntax=make
