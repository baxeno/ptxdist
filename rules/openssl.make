# -*-makefile-*-
#
# Copyright (C) 2002 by Jochen Striepe for Pengutronix e.K., Hildesheim, Germany
#               2003-2008 by Pengutronix e.K., Hildesheim, Germany
#		2009 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_OPENSSL) += openssl

#
# Paths and names
#
OPENSSL_VERSION		:= 3.5.1
OPENSSL_MD5		:= 562a4e8d14ee5272f677a754b9c1ca5c
OPENSSL			:= openssl-$(OPENSSL_VERSION)
OPENSSL_SUFFIX		:= tar.gz
OPENSSL_URL		:= \
	https://github.com/openssl/openssl/releases/download/$(OPENSSL)/$(OPENSSL).$(OPENSSL_SUFFIX) \
	https://www.openssl.org/source/$(OPENSSL).$(OPENSSL_SUFFIX) \
	https://www.openssl.org/source/old/$(basename $(OPENSSL_VERSION))/$(OPENSSL).$(OPENSSL_SUFFIX)
OPENSSL_SOURCE		:= $(SRCDIR)/$(OPENSSL).$(OPENSSL_SUFFIX)
OPENSSL_DIR		:= $(BUILDDIR)/$(OPENSSL)
OPENSSL_LICENSE		:= Apache-2.0
OPENSSL_LICENSE_FILES	:= \
	file://LICENSE.txt;md5=c75985e733726beaba57bc5253e96d04

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

OPENSSL_CONF_ENV	:= $(CROSS_ENV)

OPENSSL_ARCH-$(PTXCONF_ARCH_X86)	:= debian-i386
OPENSSL_ARCH-$(PTXCONF_ARCH_X86_64)	:= debian-amd64
OPENSSL_ARCH-$(PTXCONF_ARCH_M68K)	:= debian-m68k
OPENSSL_ARCH-$(PTXCONF_ARCH_PPC)	:= debian-powerpc
OPENSSL_ARCH-$(PTXCONF_ARCH_SPARC)	:= debian-sparc
OPENSSL_ARCH-$(PTXCONF_ARCH_ARM64)	:= debian-arm64

ifdef PTXCONF_ENDIAN_LITTLE
OPENSSL_ARCH-$(PTXCONF_ARCH_ARM)	:= debian-armel
OPENSSL_ARCH-$(PTXCONF_ARCH_MIPS)	:= debian-$(call ptx/ifdef,PTXCONF_ARCH_LP64,mips64el,mipsel)
OPENSSL_ARCH-$(PTXCONF_ARCH_SH_SH3)	:= debian-sh3
OPENSSL_ARCH-$(PTXCONF_ARCH_SH_SH4)	:= debian-sh4
else
OPENSSL_ARCH-$(PTXCONF_ARCH_MIPS)	:= debian-$(call ptx/ifdef,PTXCONF_ARCH_LP64,mips64,mips)
OPENSSL_ARCH-$(PTXCONF_ARCH_SH_SH3)	:= debian-sh3eb
OPENSSL_ARCH-$(PTXCONF_ARCH_SH_SH4)	:= debian-sh4eb
endif

ifdef PTXCONF_OPENSSL
ifndef OPENSSL_ARCH-y
$(call ptx/error, Sorry unsupported ARCH in openssl.make)
endif
endif


#
# autoconf
#
OPENSSL_CONF_OPT := \
	--prefix=/usr \
	--libdir=/usr/lib \
	--openssldir=/usr/lib/ssl \
	shared \
	$(call ptx/ifdef, PTXCONF_OPENSSL_CRYPTODEV, enable-devcryptoeng, no-devcryptoeng) \
	$(call ptx/ifdef, PTXCONF_OPENSSL_KTLS, enable-ktls, no-ktls) \
	no-idea \
	no-mdc2 \
	no-rc5 \
	no-zlib \
	no-ssl3 \
	no-ssl3-method

OPENSSL_INSTALL_OPT := \
	install_sw \
	install_ssldirs

$(STATEDIR)/openssl.prepare:
	@$(call targetinfo)
	cd $(OPENSSL_DIR) && \
		$(OPENSSL_PATH) $(OPENSSL_CONF_ENV) \
		./Configure $(OPENSSL_ARCH-y) $(OPENSSL_CONF_OPT)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/openssl.targetinstall:
	@$(call targetinfo)

	@$(call install_init, openssl)
	@$(call install_fixup, openssl,PRIORITY,optional)
	@$(call install_fixup, openssl,SECTION,base)
	@$(call install_fixup, openssl,AUTHOR,"Marc Kleine-Budde <mkl@pengutronix.de>")
	@$(call install_fixup, openssl,DESCRIPTION,missing)

ifdef PTXCONF_OPENSSL_BIN
	@$(call install_copy, openssl, 0, 0, 0755, -, \
		/usr/bin/openssl)
endif

	@$(call install_alternative, openssl, 0, 0, 0644, \
		/usr/lib/ssl/openssl.cnf)
ifdef PTXCONF_OPENSSL_LEGACY
	@$(call install_alternative, openssl, 0, 0, 0644, \
		/usr/lib/ossl-modules/legacy.so)
endif

	@$(call install_lib, openssl, 0, 0, 0644, libssl)
	@$(call install_lib, openssl, 0, 0, 0644, libcrypto)

	@$(call install_finish, openssl)

	@$(call touch)

# vim: syntax=make
