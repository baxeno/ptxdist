# -*-makefile-*-
# $Id: atk124.make,v 1.3 2003/10/23 15:01:19 mkl Exp $
#
# Copyright (C) 2003 by Robert Schwebel <r.schwebel@pengutronix.de>
#                       Pengutronix <info@pengutronix.de>, Germany
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
ifdef PTXCONF_ATK124
PACKAGES += atk124
endif

#
# Paths and names
#
ATK124_VERSION		= 1.2.4
ATK124			= atk-$(ATK124_VERSION)
ATK124_SUFFIX		= tar.gz
ATK124_URL		= ftp://ftp.gtk.org/pub/gtk/v2.2/$(ATK124).$(ATK124_SUFFIX)
ATK124_SOURCE		= $(SRCDIR)/$(ATK124).$(ATK124_SUFFIX)
ATK124_DIR		= $(BUILDDIR)/$(ATK124)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

atk124_get: $(STATEDIR)/atk124.get

atk124_get_deps	=  $(ATK124_SOURCE)

$(STATEDIR)/atk124.get: $(atk124_get_deps)
	@$(call targetinfo, $@)
	touch $@

$(ATK124_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(ATK124_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

atk124_extract: $(STATEDIR)/atk124.extract

atk124_extract_deps	=  $(STATEDIR)/atk124.get

$(STATEDIR)/atk124.extract: $(atk124_extract_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(ATK124_DIR))
	@$(call extract, $(ATK124_SOURCE))
	touch $@

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

atk124_prepare: $(STATEDIR)/atk124.prepare

#
# dependencies
#
atk124_prepare_deps =  \
	$(STATEDIR)/atk124.extract \
	$(STATEDIR)/pango12.install \
	$(STATEDIR)/virtual-xchain.install

ATK124_PATH	=  PATH=$(CROSS_PATH)
ATK124_ENV 	=  $(CROSS_ENV)
ATK124_ENV	+= PKG_CONFIG_PATH=../$(GLIB22):../$(ATK124):../$(PANGO12):../$(GTK22)

#
# autoconf
#
ATK124_AUTOCONF	=  --prefix=/usr
ATK124_AUTOCONF	+= --build=$(GNU_HOST)
ATK124_AUTOCONF	+= --host=$(PTXCONF_GNU_TARGET)

ifdef PTXCONF_ATK124_FOO
ATK124_AUTOCONF	+= --enable-foo
endif

$(STATEDIR)/atk124.prepare: $(atk124_prepare_deps)
	@$(call targetinfo, $@)
	@$(call clean, $(ATK124_BUILDDIR))
	cd $(ATK124_DIR) && \
		$(ATK124_PATH) $(ATK124_ENV) \
		./configure $(ATK124_AUTOCONF)
	touch $@

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

atk124_compile: $(STATEDIR)/atk124.compile

atk124_compile_deps =  $(STATEDIR)/atk124.prepare

$(STATEDIR)/atk124.compile: $(atk124_compile_deps)
	@$(call targetinfo, $@)
	$(ATK124_PATH) make -C $(ATK124_DIR) 

# FIXME: this is somehow not done by the packet; file bug report
	ln -sf libatk-1.0.la $(ATK124_DIR)/atk/libatk.la

	touch $@

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

atk124_install: $(STATEDIR)/atk124.install

$(STATEDIR)/atk124.install: $(STATEDIR)/atk124.compile
	@$(call targetinfo, $@)

	install -d $(PTXCONF_PREFIX)
	rm -f $(PTXCONF_PREFIX)/lib/libatk-1.0.so*
	install $(ATK124_DIR)/atk/.libs/libatk-1.0.so.0.200.4 $(PTXCONF_PREFIX)/lib/
	ln -s libatk-1.0.so.0.200.4 $(PTXCONF_PREFIX)/lib/libatk-1.0.so.0
	ln -s libatk-1.0.so.0.200.4 $(PTXCONF_PREFIX)/lib/libatk-1.0.so

	rm -f $(PTXCONF_PREFIX)/include/atk*.h
	install $(ATK124_DIR)/atk/atk*.h $(PTXCONF_PREFIX)/include

	touch $@

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

atk124_targetinstall: $(STATEDIR)/atk124.targetinstall

atk124_targetinstall_deps	=  $(STATEDIR)/atk124.compile

$(STATEDIR)/atk124.targetinstall: $(atk124_targetinstall_deps)
	@$(call targetinfo, $@)

	install -d $(ROOTDIR)
	rm -f $(ROOTDIR)/lib/libatk-1.0.so*
	install $(ATK124_DIR)/atk/.libs/libatk-1.0.so.0.200.4 $(ROOTDIR)/lib/
	ln -s libatk-1.0.so.0.200.4 $(ROOTDIR)/lib/libatk-1.0.so.0
	ln -s libatk-1.0.so.0.200.4 $(ROOTDIR)/lib/libatk-1.0.so

	touch $@

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

atk124_clean:
	rm -rf $(STATEDIR)/atk124.*
	rm -rf $(ATK124_DIR)
	rm -f $(PTXCONF_PREFIX)/$(PTXCONF_GNU_TARGET)/share/pkg-config/atk*.pc

# vim: syntax=make
