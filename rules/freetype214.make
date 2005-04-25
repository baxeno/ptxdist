# -*-makefile-*-
# $Id$
#
# Copyright (C) 2003 by Robert Schwebel <r.schwebel@pengutronix.de>
#             Pengutronix <info@pengutronix.de>, Germany
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
ifdef PTXCONF_FREETYPE
PACKAGES += freetype
endif

#
# Paths and names
#
FREETYPE_VERSION	= 2.1.9
FREETYPE		= freetype-$(FREETYPE_VERSION)
FREETYPE_SUFFIX		= tar.gz
FREETYPE_URL		= ftp://gd.tuwien.ac.at/publishing/freetype/freetype2/$(FREETYPE).$(FREETYPE_SUFFIX)
FREETYPE_SOURCE		= $(SRCDIR)/$(FREETYPE).$(FREETYPE_SUFFIX)
FREETYPE_DIR		= $(BUILDDIR)/$(FREETYPE)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

freetype_get: $(STATEDIR)/freetype.get

freetype_get_deps	=  $(FREETYPE_SOURCE)

$(STATEDIR)/freetype.get: $(freetype_get_deps)
	@$(call targetinfo, $@)
	touch $@

$(FREETYPE_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(FREETYPE_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

freetype_extract: $(STATEDIR)/freetype.extract

freetype_extract_deps	=  $(STATEDIR)/freetype.get

$(STATEDIR)/freetype.extract: $(freetype_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(FREETYPE_DIR))
	@$(call extract, $(FREETYPE_SOURCE))
	touch $@

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

freetype_prepare: $(STATEDIR)/freetype.prepare

#
# dependencies
#
freetype_prepare_deps =  \
	$(STATEDIR)/freetype.extract \
	$(STATEDIR)/virtual-xchain.install

	# FIXME: these dependencies have been there for penguzilla;
	# check if they are still needed [RSC]	
	# $(STATEDIR)/glib22.install \
	# $(STATEDIR)/expat.install \

FREETYPE_PATH	=  PATH=$(CROSS_PATH)
FREETYPE_ENV 	=  $(CROSS_ENV)
FREETYPE_ENV		+= PKG_CONFIG_PATH=$(CROSS_LIB_DIR)/lib/pkgconfig/

#
# autoconf
#
FREETYPE_AUTOCONF	=  $(CROSS_AUTOCONF)
FREETYPE_AUTOCONF	+= --prefix=$(CROSS_LIB_DIR)

$(STATEDIR)/freetype.prepare: $(freetype_prepare_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(FREETYPE_BUILDDIR))
	cd $(FREETYPE_DIR) && \
		$(FREETYPE_PATH) $(FREETYPE_ENV) \
		./configure $(FREETYPE_AUTOCONF)
	touch $@

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

freetype_compile: $(STATEDIR)/freetype.compile

freetype_compile_deps =  $(STATEDIR)/freetype.prepare

$(STATEDIR)/freetype.compile: $(freetype_compile_deps)
	@$(call targetinfo, $@)
	cd $(FREETYPE_DIR) $(FREETYPE_PATH) make
	chmod a+x $(FREETYPE_DIR)/builds/unix/freetype-config
	touch $@

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

freetype_install: $(STATEDIR)/freetype.install

$(STATEDIR)/freetype.install: $(STATEDIR)/freetype.compile
	@$(call targetinfo, $@)
	cd $(FREETYPE_DIR) && $(FREETYPE_PATH) make install
	touch $@

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

freetype_targetinstall: $(STATEDIR)/freetype.targetinstall

freetype_targetinstall_deps	=  $(STATEDIR)/freetype.compile
freetype_targetinstall_deps	+= $(STATEDIR)/glib22.targetinstall
freetype_targetinstall_deps	+= $(STATEDIR)/expat.targetinstall

$(STATEDIR)/freetype.targetinstall: $(freetype_targetinstall_deps)
	@$(call targetinfo, $@)
	install -d $(ROOTDIR)
	rm -f $(ROOTDIR)/lib/libfreetype.so*
	install $(FREETYPE_DIR)/objs/.libs/libfreetype.so.6.3.5 $(ROOTDIR)/lib/
	ln -sf libfreetype.so.6.3.5 $(ROOTDIR)/lib/libfreetype.so.6
	ln -sf libfreetype.so.6.3.5 $(ROOTDIR)/lib/libfreetype.so
	touch $@

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

freetype_clean:
	rm -rf $(STATEDIR)/freetype.*
	rm -rf $(FREETYPE_DIR)

# vim: syntax=make
