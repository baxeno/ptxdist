# -*-makefile-*-
#
# Copyright (C) 2008 by Erwin Rol
#               2009 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_KEXEC_TOOLS) += kexec-tools

#
# Paths and names
#
KEXEC_TOOLS_VERSION	:= 2.0.30
KEXEC_TOOLS_MD5		:= 3495ca3f3f74e5e4412511d7ed88be86
KEXEC_TOOLS		:= kexec-tools-$(KEXEC_TOOLS_VERSION)
KEXEC_TOOLS_SUFFIX	:= tar.xz
KEXEC_TOOLS_URL		:= $(call ptx/mirror, KERNEL, utils/kernel/kexec/$(KEXEC_TOOLS).$(KEXEC_TOOLS_SUFFIX))
KEXEC_TOOLS_SOURCE	:= $(SRCDIR)/$(KEXEC_TOOLS).$(KEXEC_TOOLS_SUFFIX)
KEXEC_TOOLS_DIR		:= $(BUILDDIR)/$(KEXEC_TOOLS)
KEXEC_TOOLS_LICENSE	:= GPL-2.0-only
KEXEC_TOOLS_LICENSE_FILES	:= file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

ifdef PTXCONF_ARCH_ARM64
KEXEC_TOOLS_WRAPPER_BLACKLIST := \
	TARGET_HARDEN_PIE
endif

#
# autoconf
#
# Note: --without-gamecube is explicitly omitted. The option is broken.
KEXEC_TOOLS_CONF_TOOL := autoconf
KEXEC_TOOLS_CONF_OPT := \
	$(CROSS_AUTOCONF_USR) \
	--$(call ptx/wwo, PTXCONF_KEXEC_TOOLS_ZLIB)-zlib \
	--without-lzma \
	--$(call ptx/wwo, PTXCONF_KEXEC_TOOLS_XEN)-xen \
	--without-booke

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/kexec-tools.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  kexec-tools)
	@$(call install_fixup, kexec-tools,PRIORITY,optional)
	@$(call install_fixup, kexec-tools,SECTION,base)
	@$(call install_fixup, kexec-tools,AUTHOR,"Erwin Rol <erwin@erwinrol.com>")
	@$(call install_fixup, kexec-tools,DESCRIPTION,missing)

	@$(call install_copy, kexec-tools, 0, 0, 0755, -, /usr/sbin/kexec)

	@$(call install_finish, kexec-tools)

	@$(call touch)

# vim: syntax=make
