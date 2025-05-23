# -*-makefile-*-
#
# Copyright (C) 2002      by Pengutronix e.K., Hildesheim, Germany
#               2003      by Auerswald GmbH & Co. KG, Schandelah, Germany
#               2005-2009 by Marc Kleine-Budde <mkl@pengutronix.de>, Pengutronix e.K., Hildesheim, Germany
#           (C) 2010 by Michael Olbrich <m.olbrich@pengutronix.de>
#           (C) 2016 by Clemens Gruber <clemens.gruber@pqgruber.com>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_GLIBC) += glibc

#
# Paths and names
#
GLIBC_VERSION	:= $(call ptx/config-version, PTXCONF_GLIBC)
# for license information
-include $(PTXDIST_PLATFORMDIR)/selected_toolchain/../share/compliance/glibc.make

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

GLIBC_INSTALL_MVEC :=
ifdef PTXCONF_ARCH_X86_64
GLIBC_INSTALL_MVEC := $(PTXCONF_GLIBC_MVEC)
endif
ifdef PTXCONF_ARCH_ARM64
# libmvec support has been added to AArch64 with glibc version 2.38
ifdef PTXCONF_GLIBC_2_38
GLIBC_INSTALL_MVEC := $(PTXCONF_GLIBC_MVEC)
endif
endif

$(STATEDIR)/glibc.prepare:
	@$(call targetinfo)
ifdef PTXCONF_GLIBC_Y2038
	@echo Checking Y2038 support...
	@echo 'static_assert(sizeof(time_t) == 8, "y2038");' | \
		$(CROSS_CC) -c -x c -fsyntax-only -include sys/types.h -include assert.h - &>/dev/null || \
		ptxd_bailout "PTXCONF_GLIBC_Y2038 is enabled but the toolchain has no Y2038 support!"
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/glibc.targetinstall:
	@$(call targetinfo)

	@$(call install_init, glibc)
	@$(call install_fixup, glibc,PRIORITY,optional)
	@$(call install_fixup, glibc,SECTION,base)
	@$(call install_fixup, glibc,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, glibc,DESCRIPTION,missing)

ifdef PTXCONF_GLIBC_LD
ifneq ($(CROSS_LINKER_LIB_DIR),lib)
	@$(call install_link, glibc, lib, /$(CROSS_LINKER_LIB_DIR))
endif
	@$(call install_copy_toolchain_dl, glibc)
endif

ifdef PTXCONF_GLIBC_C
	@$(call install_copy_toolchain_lib, glibc, libc.so.6)
endif

ifdef PTXCONF_GLIBC_PTHREAD
	@$(call install_copy_toolchain_lib, glibc, libpthread.so.0)
endif

ifdef PTXCONF_GLIBC_THREAD_DB
	@$(call install_copy_toolchain_lib, glibc, libthread_db.so)
endif

ifdef PTXCONF_GLIBC_RT
	@$(call install_copy_toolchain_lib, glibc, librt.so.1)
endif

ifdef PTXCONF_GLIBC_DL
	@$(call install_copy_toolchain_lib, glibc, libdl.so.2)
endif

ifdef PTXCONF_GLIBC_CRYPT
	@$(call install_copy_toolchain_lib, glibc, libcrypt.so.1)
endif

ifdef PTXCONF_GLIBC_UTIL
	@$(call install_copy_toolchain_lib, glibc, libutil.so.1)
endif

ifdef PTXCONF_GLIBC_M
	@$(call install_copy_toolchain_lib, glibc, libm.so.6)
endif

ifdef GLIBC_INSTALL_MVEC
	@$(call install_copy_toolchain_lib, glibc, libmvec.so.1)
endif

ifdef PTXCONF_GLIBC_NSS_DNS
	@$(call install_copy_toolchain_lib, glibc, libnss_dns.so.2)
endif

ifdef PTXCONF_GLIBC_NSS_FILES
	@$(call install_copy_toolchain_lib, glibc, libnss_files.so.2)
endif

ifdef PTXCONF_GLIBC_NSS_HESIOD
	@$(call install_copy_toolchain_lib, glibc, libnss_hesiod.so)
endif

ifdef PTXCONF_GLIBC_ANL
	@$(call install_copy_toolchain_lib, glibc, libanl.so.1)
endif

ifdef PTXCONF_GLIBC_NSS_NIS
	@$(call install_copy_toolchain_lib, glibc, libnss_nis.so)
endif

ifdef PTXCONF_GLIBC_NSS_NISPLUS
	@$(call install_copy_toolchain_lib, glibc, libnss_nisplus.so)
endif

ifdef PTXCONF_GLIBC_NSS_COMPAT
	@$(call install_copy_toolchain_lib, glibc, libnss_compat.so)
endif

ifdef PTXCONF_GLIBC_RESOLV
	@$(call install_copy_toolchain_lib, glibc, libresolv.so.2)
endif

ifdef PTXCONF_GLIBC_NSL
	@$(call install_copy_toolchain_lib, glibc, libnsl.so.1)
endif

ifdef PTXCONF_GLIBC_GCONV_BASE
	@$(call install_copy_toolchain_lib, glibc, gconv/gconv-modules,, n)
endif

ifdef PTXCONF_GLIBC_GCONV_DEF
	@$(call install_copy_toolchain_lib, glibc, gconv/ISO8859-1.so)
	@$(call install_copy_toolchain_lib, glibc, gconv/ISO8859-15.so)
endif

ifdef PTXCONF_GLIBC_GCONV_UTF
	@$(call install_copy_toolchain_lib, glibc, gconv/UNICODE.so)
	@$(call install_copy_toolchain_lib, glibc, gconv/UTF-16.so)
	@$(call install_copy_toolchain_lib, glibc, gconv/UTF-32.so)
	@$(call install_copy_toolchain_lib, glibc, gconv/UTF-7.so)
endif

ifdef PTXCONF_GLIBC_GCONV_ZH
	@$(call install_copy_toolchain_lib, glibc, gconv/GBBIG5.so)
	@$(call install_copy_toolchain_lib, glibc, gconv/GB18030.so)
endif

ifdef PTXCONF_GLIBC_GETENT
	@$(call install_copy_toolchain_usr, glibc, bin/getent)
endif

ifdef PTXCONF_GLIBC_LDCONFIG
	@$(call install_copy, glibc, 0, 0, 0755, \
	    $(PTXDIST_SYSROOT_TOOLCHAIN)/sbin/ldconfig, /usr/sbin/ldconfig)
	@$(call install_alternative, glibc, 0, 0, 0644, /etc/ld.so.conf)
	@$(call install_copy, glibc, 0, 0, 0755, /etc/ld.so.conf.d)
endif

ifdef PTXCONF_GLIBC_LDCONFIG_RC_ONCE
	@$(call install_alternative, glibc, 0, 0, 0755, \
	    /etc/rc.once.d/ldconfig)
endif

ifdef PTXCONF_GLIBC_I18N_BIN_LOCALE
	@$(call install_copy_toolchain_usr, glibc, bin/locale)
endif

ifdef PTXCONF_GLIBC_I18N_BIN_LOCALEDEF
	@$(call install_copy_toolchain_usr, glibc, bin/localedef)
endif

ifdef PTXCONF_GLIBC_I18N_RAWDATA
	@$(call install_copy_toolchain_usr, glibc, share/i18n/charmaps/*)
	@$(call install_copy_toolchain_usr, glibc, share/i18n/locales/*)
	@$(call install_copy_toolchain_usr, glibc, share/locale/locale.alias)
endif

ifdef PTXCONF_LOCALES
	@$(call install_copy_toolchain_usr, glibc, share/locale/locale.alias)
endif

# Zonefiles are BROKEN
# 	@$(call install_copy, glibc, 0, 0, 0755, /usr/share/zoneinfo)
# 	@for target in $(GLIBC_ZONEFILES-y); do \
# 		$(call install_copy, glibc, 0, 0, 0644, \
# 		$(GLIBC_ZONEDIR)/zoneinfo/$$target, \
# 		/usr/share/zoneinfo/$$target) \
# 	done;
	@$(call install_finish, glibc)

	@$(call touch)


# vim: syntax=make
