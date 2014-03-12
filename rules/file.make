# -*-makefile-*-
#
# Copyright (C) 2011 by Alexander Dahl <post@lespocky.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_FILE) += file

#
# Paths and names
#
FILE_VERSION	:= 5.17
FILE_MD5	:= e19c47e069ced7b01ccb4db402cc01d3
FILE		:= file-$(FILE_VERSION)
FILE_SUFFIX	:= tar.gz
FILE_URL	:= ftp://ftp.astron.com/pub/file/$(FILE).$(FILE_SUFFIX)
FILE_SOURCE	:= $(SRCDIR)/$(FILE).$(FILE_SUFFIX)
FILE_DIR	:= $(BUILDDIR)/$(FILE)
FILE_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

FILE_PATH	:= PATH=$(PTXDIST_SYSROOT_HOST)/bin/file:$(CROSS_PATH)
FILE_CONF_TOOL	:= autoconf

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/file.targetinstall:
	@$(call targetinfo)

	@$(call install_init, file)
	@$(call install_fixup, file,PRIORITY,optional)
	@$(call install_fixup, file,SECTION,base)
	@$(call install_fixup, file,AUTHOR,"Alexander Dahl <post@lespocky.de>")
	@$(call install_fixup, file,DESCRIPTION,missing)

	@$(call install_lib, file, 0, 0, 0644, libmagic)
	@$(call install_copy, file, 0, 0, 0755, -, /usr/bin/file)
	@$(call install_copy, file, 0, 0, 0644, -, /usr/share/misc/magic.mgc)

	@$(call install_finish, file)

	@$(call touch)

# vim: syntax=make
