# -*-makefile-*-
# $Id: glibc.make,v 1.10 2003/10/23 15:01:19 mkl Exp $
#
# Copyright (C) 2003 by Auerswald GmbH & Co. KG, Schandelah, Germany
# Copyright (C) 2002 by Pengutronix e.K., Hildesheim, Germany
# See CREDITS for details about who has contributed to this project. 
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
ifdef PTXCONF_GLIBC
ifdef PTXCONF_BUILD_CROSSCHAIN
PACKAGES	+= glibc
endif
DYNAMIC_LINKER	=  /lib/ld-linux.so.2
endif


#
# Paths and names 
#
GLIBC			= glibc-$(GLIBC_VERSION)
GLIBC_URL		= ftp://ftp.gnu.org/gnu/glibc/$(GLIBC).tar.gz
GLIBC_SOURCE		= $(SRCDIR)/$(GLIBC).tar.gz
GLIBC_DIR		= $(BUILDDIR)/$(GLIBC)

GLIBC_THREADS		= glibc-linuxthreads-$(GLIBC_VERSION)
GLIBC_THREADS_URL	= ftp://ftp.gnu.org/gnu/glibc/$(GLIBC_THREADS).tar.gz
GLIBC_THREADS_SOURCE	= $(SRCDIR)/$(GLIBC_THREADS).tar.gz
GLIBC_THREADS_DIR	= $(GLIBC_DIR)

GLIBC_BUILDDIR		= $(BUILDDIR)/$(GLIBC)-build

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

glibc_get:		$(STATEDIR)/glibc.get

glibc_get_deps = \
	$(GLIBC_SOURCE) \
	$(STATEDIR)/glibc-patches.get

ifdef PTXCONF_GLIBC_PTHREADS
glibc_get_deps += \
	$(GLIBC_THREADS_SOURCE) \
	$(STATEDIR)/glibc-threads-patches.get
endif

$(STATEDIR)/glibc.get: $(glibc_get_deps)
	@$(call targetinfo, $@)
	touch $@

$(STATEDIR)/glibc-patches.get:
	@$(call targetinfo, $@)
	@$(call get_patches, $(GLIBC))
	touch $@

$(STATEDIR)/glibc-threads-patches.get:
	@$(call targetinfo, $@)
	@$(call get_patches, $(GLIBC_THREADS))
	touch $@

$(GLIBC_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(GLIBC_URL))

$(GLIBC_THREADS_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, $(GLIBC_THREADS_URL))

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

glibc_extract: $(STATEDIR)/glibc.extract

glibc_extract_deps =  $(STATEDIR)/glibc-base.extract
ifdef PTXCONF_GLIBC_PTHREADS
glibc_extract_deps += $(STATEDIR)/glibc-threads.extract
endif

$(STATEDIR)/glibc.extract: $(glibc_extract_deps)
	@$(call targetinfo, $@)
	touch $@

$(STATEDIR)/glibc-base.extract: $(STATEDIR)/glibc.get
	@$(call targetinfo, $@)
	@$(call clean, $(GLIBC_DIR))
	@$(call extract, $(GLIBC_SOURCE))
	@$(call patchin, $(GLIBC))
	touch $@

$(STATEDIR)/glibc-threads.extract: $(STATEDIR)/glibc.get
	@$(call targetinfo, $@)
	@$(call extract, $(GLIBC_THREADS_SOURCE), $(GLIBC_DIR))
	@$(call patchin, $(GLIBC_THREADS), $(GLIBC_DIR))
	touch $@

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

glibc_prepare:		$(STATEDIR)/glibc.prepare

# 
# arcitecture dependend configuration
#
GLIBC_AUTOCONF	= \
	--build=$(GNU_HOST) \
	--host=$(PTXCONF_GNU_TARGET) \
	--with-headers=$(CROSS_LIB_DIR)/include \
	--enable-clocale=gnu \
	--without-tls \
	--without-cvs \
	--without-gd \
	--prefix=/usr \
	--libexecdir=/usr/bin

ifdef GLIBC_OPTKERNEL
GLIBC_AUTOCONF += --enable-kernel=$(KERNEL_VERSION)
endif

ifeq ($(GLIBC_VERSION_MAJOR).$(GLIBC_VERSION_MINOR),2.2)
GLIBC_PATH	=  PATH=$(PTXCONF_PREFIX)/$(AUTOCONF213)/bin:$(CROSS_PATH)
else
#FIXME: wich autoconf version wants the glibc?
GLIBC_PATH	=  PATH=$(CROSS_PATH)
endif

GLIBC_ENV	=  $(CROSS_ENV) BUILD_CC=$(HOSTCC)

#
# features
#
ifdef PTXCONF_GLIBC_LIBIO
GLIBC_AUTOCONF	+= --enable-libio
endif

ifdef PTXCONF_GLIBC_SHARED
GLIBC_AUTOCONF	+= --enable-shared
else
GLIBC_AUTOCONF	+= --enable-shared=no
endif

ifdef PTXCONF_GLIBC_PROFILED
GLIBC_AUTOCONF	+= --enable-profile=yes
else
GLIBC_AUTOCONF	+= --enable-profile=no
endif

ifdef PTXCONF_GLIBC_OMITFP
GLIBC_AUTOCONF	+= --enable-omitfp
endif

ifdef PTXCONF_GLIBC_PTHREADS
GLIBC_AUTOCONF	+= --enable-add-ons=linuxthreads
endif

GLIBC_AUTOCONF	+= $(GLIBC_EXTRA_CONFIG)

#
# dependencies
#
glibc_prepare_deps = \
	$(STATEDIR)/autoconf213.install \
	$(STATEDIR)/xchain-gccstage1.install \
	$(STATEDIR)/glibc.extract

$(STATEDIR)/glibc.prepare: $(glibc_prepare_deps)
	@$(call targetinfo, $@)
	mkdir -p $(GLIBC_BUILDDIR)
	cd $(GLIBC_BUILDDIR) &&	\
	        $(GLIBC_PATH) $(GLIBC_ENV) \
		$(GLIBC_DIR)/configure $(PTXCONF_GNU_TARGET) \
			$(GLIBC_AUTOCONF)
#
# don't compile programs
#
# 	echo "build-programs=no" >> $(XCHAIN_GLIBC_BUILDDIR)/configparms

	touch $@

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

glibc_compile:		$(STATEDIR)/glibc.compile

$(STATEDIR)/glibc.compile: $(STATEDIR)/glibc.prepare 
	@$(call targetinfo, $@)
	$(GLIBC_PATH) make -C $(GLIBC_BUILDDIR)
#
# fake files which are installed by make install although
# compiling binaries was switched of (tested with 2.2.5)
#
# 	touch $(XCHAIN_GLIBC_BUILDDIR)/iconv/iconv_prog
# 	touch $(XCHAIN_GLIBC_BUILDDIR)/login/pt_chown
	touch $@

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

glibc_install:		$(STATEDIR)/glibc.install

$(STATEDIR)/glibc.install: $(STATEDIR)/glibc.compile
	@$(call targetinfo, $@)
	$(GLIBC_PATH) make -C $(GLIBC_BUILDDIR) \
		install_root=$(CROSS_LIB_DIR) prefix="" install
#
# Dan Kegel writes:
#
# Fix problems in linker scripts.
# 
# 1. Remove absolute paths
# Any file in a list of known suspects that isn't a symlink is assumed to be a linker script.
# FIXME: test -h is not portable
# FIXME: probably need to check more files than just these three...
# Need to use sed instead of just assuming we know what's in libc.so because otherwise alpha breaks
#
# 2. Remove lines containing BUG per http://sources.redhat.com/ml/bug-glibc/2003-05/msg00055.html,
# needed to fix gcc-3.2.3/glibc-2.3.2 targeting arm
#
	for file in libc.so libpthread.so libgcc_s.so; do								\
		if [ -f $(CROSS_LIB_DIR)/lib/$$file -a ! -h $(CROSS_LIB_DIR)/lib/$$file ]; then				\
			echo $$file;											\
			if [ ! -f $(CROSS_LIB_DIR)/lib/$$file.orig ]; then						\
				mv $(CROSS_LIB_DIR)/lib/$$file $(CROSS_LIB_DIR)/lib/$$file.orig;			\
			fi;												\
			sed 's,/lib/,,g;/BUG in libc.scripts.output-format.sed/d' < $(CROSS_LIB_DIR)/lib/$$file.orig	\
				> $(CROSS_LIB_DIR)/lib/$$file;								\
		fi;													\
	done
	touch $@

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

glibc_targetinstall:		$(STATEDIR)/glibc.targetinstall

ifdef PTXCONF_BUILD_CROSSCHAIN
glibc_targetinstall_deps = $(STATEDIR)/glibc.install
endif

ifdef PTXCONF_GLIBC_DEBUG
GLIBC_STRIP	= true
else
GLIBC_STRIP	= $(CROSSSTRIP) -S -R .note -R .comment
endif

ifeq ($(GLIBC_VERSION_MAJOR).$(GLIBC_VERSION_MINOR),2.2)
GLIBC_PTHREAD_VERSION	= 0.9
else
GLIBC_PTHREAD_VERSION	= 0.10
endif

$(STATEDIR)/glibc.targetinstall: $(glibc_targetinstall_deps)
	@$(call targetinfo, $@)
#
# CAREFUL: don't never ever make install!!!
# but we never ever run ptxdist as root, do we? :)
#
	mkdir -p $(ROOTDIR)/lib

	install $(CROSS_LIB_DIR)/lib/ld-$(GLIBC_VERSION).so $(ROOTDIR)/lib/ld-$(GLIBC_VERSION).so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/ld-$(GLIBC_VERSION).so
	ln -sf ld-$(GLIBC_VERSION).so $(ROOTDIR)/lib/ld.so.1
	ln -sf ld-$(GLIBC_VERSION).so $(ROOTDIR)/lib/ld-linux.so.2

	install $(CROSS_LIB_DIR)/lib/libc-$(GLIBC_VERSION).so $(ROOTDIR)/lib/libc-$(GLIBC_VERSION).so.6
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libc-$(GLIBC_VERSION).so.6
	ln -sf libc-$(GLIBC_VERSION).so.6 $(ROOTDIR)/lib/libc.so.6

ifdef PTXCONF_GLIBC_PTHREADS
	install $(CROSS_LIB_DIR)/lib/libpthread-$(GLIBC_PTHREAD_VERSION).so $(ROOTDIR)/lib/libpthread-$(GLIBC_PTHREAD_VERSION).so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libpthread-$(GLIBC_PTHREAD_VERSION).so
	ln -sf libpthread-$(GLIBC_PTHREAD_VERSION).so $(ROOTDIR)/lib/libpthread.so.0
endif

ifdef PTXCONF_GLIBC_THREAD_DB
	install $(CROSS_LIB_DIR)/lib/libthread_db.so $(ROOTDIR)/lib/libthread_db-1.0.so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libthread_db-1.0.so
	ln -sf libthread_db-1.0.so $(ROOTDIR)/lib/libthread_db.so.1
endif

ifdef PTXCONF_GLIBC_DL
	install $(CROSS_LIB_DIR)/lib/libdl.so $(ROOTDIR)/lib/libdl-$(GLIBC_VERSION).so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libdl-$(GLIBC_VERSION).so
	ln -sf libdl-$(GLIBC_VERSION).so $(ROOTDIR)/lib/libdl.so.2
endif

ifdef PTXCONF_GLIBC_CRYPT
	install $(CROSS_LIB_DIR)/lib/libcrypt.so $(ROOTDIR)/lib/libcrypt-$(GLIBC_VERSION).so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libcrypt-$(GLIBC_VERSION).so
	ln -sf libcrypt-$(GLIBC_VERSION).so $(ROOTDIR)/lib/libcrypt.so.1
endif

ifdef PTXCONF_GLIBC_UTIL
	install $(CROSS_LIB_DIR)/lib/libutil.so $(ROOTDIR)/lib/libutil-$(GLIBC_VERSION).so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libutil-$(GLIBC_VERSION).so
	ln -sf libutil-$(GLIBC_VERSION).so $(ROOTDIR)/lib/libutil.so.1
endif

ifdef PTXCONF_GLIBC_LIBM
	install $(CROSS_LIB_DIR)/lib/libm.so $(ROOTDIR)/lib/libm-$(GLIBC_VERSION).so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libm-$(GLIBC_VERSION).so
	ln -sf libm-$(GLIBC_VERSION).so $(ROOTDIR)/lib/libm.so.6
endif

ifdef PTXCONF_GLIBC_NSS_DNS
	install $(CROSS_LIB_DIR)/lib/libnss_dns.so.2 $(ROOTDIR)/lib/libnss_dns-$(GLIBC_VERSION).so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libnss_dns-$(GLIBC_VERSION).so
	ln -sf libnss_dns-$(GLIBC_VERSION).so $(ROOTDIR)/lib/libnss_dns.so.2
endif

ifdef PTXCONF_GLIBC_NSS_FILES
	install $(CROSS_LIB_DIR)/lib/libnss_files.so.2 $(ROOTDIR)/lib/libnss_files-$(GLIBC_VERSION).so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libnss_files-$(GLIBC_VERSION).so
	ln -sf libnss_files-$(GLIBC_VERSION).so $(ROOTDIR)/lib/libnss_files.so.2
endif

ifdef PTXCONF_GLIBC_NSS_HESIOD
	install $(CROSS_LIB_DIR)/lib/libnss_hesiod.so.2 $(ROOTDIR)/lib/libnss_hesiod-$(GLIBC_VERSION).so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libnss_hesiod-$(GLIBC_VERSION).so
	ln -sf libnss_hesiod-$(GLIBC_VERSION).so $(ROOTDIR)/lib/libnss_hesiod.so.2
endif

ifdef PTXCONF_GLIBC_NSS_NIS
	install $(CROSS_LIB_DIR)/lib/libnss_nis.so.2 $(ROOTDIR)/lib/libnss_nis-$(GLIBC_VERSION).so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libnss_nis-$(GLIBC_VERSION).so
	ln -sf libnss_nis-$(GLIBC_VERSION).so $(ROOTDIR)/lib/libnss_nis.so.2
endif

ifdef PTXCONF_GLIBC_NSS_NISPLUS
	install $(CROSS_LIB_DIR)/lib/libnss_nisplus.so.2 $(ROOTDIR)/lib/libnss_nisplus-$(GLIBC_VERSION).so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libnss_nisplus-$(GLIBC_VERSION).so
	ln -sf libnss_nisplus-$(GLIBC_VERSION).so $(ROOTDIR)/lib/libnss_nisplus.so.2
endif

ifdef PTXCONF_GLIBC_NSS_COMPAT
	install $(CROSS_LIB_DIR)/lib/libnss_compat.so.2 $(ROOTDIR)/lib/libnss_compat-$(GLIBC_VERSION).so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libnss_compat-$(GLIBC_VERSION).so
	ln -sf libnss_compat-$(GLIBC_VERSION).so $(ROOTDIR)/lib/libnss_compat.so.2
endif

ifdef PTXCONF_GLIBC_RESOLV
	install $(CROSS_LIB_DIR)/lib/libresolv.so $(ROOTDIR)/lib/libresolv-$(GLIBC_VERSION).so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libresolv-$(GLIBC_VERSION).so
	ln -sf libresolv-$(GLIBC_VERSION).so $(ROOTDIR)/lib/libresolv.so.2
endif

ifdef PTXCONF_GLIBC_NSL
	install $(CROSS_LIB_DIR)/lib/libnsl.so $(ROOTDIR)/lib/libnsl-$(GLIBC_VERSION).so
	$(GLIBC_STRIP) $(ROOTDIR)/lib/libnsl-$(GLIBC_VERSION).so
	ln -sf libnsl-$(GLIBC_VERSION).so $(ROOTDIR)/lib/libnsl.so.1
endif

	touch $@

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

glibc_clean: 
	-rm -rf $(STATEDIR)/glibc*
	-rm -rf $(GLIBC_DIR)
	-rm -rf $(GLIBC_BUILDDIR)
: syntax=make
