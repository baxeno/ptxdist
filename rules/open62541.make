# -*-makefile-*-
#
# Copyright (C) 2018 by Robert Schwebel <r.schwebel@pengutronix.de>
# Copyright (C) 2019 by Bjoern Esser <b.esser@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_OPEN62541) += open62541

#
# Paths and names
#
OPEN62541_VERSION		:= 1.3.4
OPEN62541_MD5			:= a3871da1723b0d436564d643e169879e
OPEN62541			:= open62541-$(OPEN62541_VERSION)
OPEN62541_SUFFIX		:= tar.gz
OPEN62541_URL			:= https://github.com/open62541/open62541/archive/v$(OPEN62541_VERSION)/$(OPEN62541).$(OPEN62541_SUFFIX)
OPEN62541_SOURCE		:= $(SRCDIR)/$(OPEN62541).$(OPEN62541_SUFFIX)
OPEN62541_DIR			:= $(BUILDDIR)/$(OPEN62541)
OPEN62541_LICENSE		:= MPL-2.0
OPEN62541_LICENSE_FILES		:= file://LICENSE;md5=815ca599c9df247a0c7f619bab123dad

# use tarballs instead of git submodules
# see https://github.com/open62541/open62541/tree/v$(version)/deps
OPEN62541_MDNSD_VERSION		:= 3151afe5899dba5125dffa9f4cf3ae1fe2edc0f0
OPEN62541_MDNSD_MD5		:= 75c45c7913b33f92a7be460bce593991
OPEN62541_MDNSD			:= open62541-mdnsd-$(OPEN62541_MDNSD_VERSION)
OPEN62541_MDNSD_SUFFIX		:= tar.gz
OPEN62541_MDNSD_URL		:= https://github.com/Pro/mdnsd/archive/$(OPEN62541_MDNSD_VERSION)/$(OPEN62541_MDNSD).$(OPEN62541_MDNSD_SUFFIX)
OPEN62541_MDNSD_SOURCE		:= $(SRCDIR)/$(OPEN62541_MDNSD).$(OPEN62541_MDNSD_SUFFIX)
$(OPEN62541_MDNSD_SOURCE)	:= OPEN62541_MDNSD
OPEN62541_MDNSD_DIR		:= $(OPEN62541_DIR)/deps/mdnsd
OPEN62541_MDNSD_LICENSE		:= BSD-3-Clause
OPEN62541_MDNSD_LICENSE_FILES	:= file://LICENSE;md5=3bb4047dc4095cd7336de3e2a9be94f0

OPEN62541_DEVPKG		:= NO

OPEN62541_SOURCES		:= $(OPEN62541_SOURCE) $(OPEN62541_MDNSD_SOURCE)


# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/open62541.extract:
	@$(call targetinfo)
	@$(call clean, $(OPEN62541_DIR))
	@$(call extract, OPEN62541)
	@$(call extract, OPEN62541_MDNSD)
	@$(call patchin, OPEN62541)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

OPEN62541_LOGLEVEL	:= 300

OPEN62541_CONF_TOOL	:= cmake
OPEN62541_CONF_OPT	:= \
	$(CROSS_CMAKE_USR) \
	-DBUILD_SHARED_LIBS=ON \
	-DCLANG_FORMAT_EXE=$(PTXDIST_WORKSPACE)/selected_toolchain/clang-format \
	-DMDNSD_LOGLEVEL=$(OPEN62541_LOGLEVEL) \
	-DOPEN62541_VERSION="v$(OPEN62541_VERSION)" \
	-DUA_ARCHITECTURE=posix \
	-DUA_BUILD_EXAMPLES=OFF \
	-DUA_BUILD_FUZZING=OFF \
	-DUA_BUILD_FUZZING_CORPUS=OFF \
	-DUA_BUILD_OSS_FUZZ=OFF \
	-DUA_BUILD_TOOLS=ON \
	-DUA_BUILD_UNIT_TESTS=OFF \
	-DUA_DEBUG=OFF \
	-DUA_DEBUG_DUMP_PKGS=OFF \
	-DUA_ENABLE_AMALGAMATION=OFF \
	-DUA_ENABLE_COVERAGE=OFF \
	-DUA_ENABLE_DA=ON \
	-DUA_ENABLE_DETERMINISTIC_RNG=OFF \
	-DUA_ENABLE_DIAGNOSTICS=OFF \
	-DUA_ENABLE_DISCOVERY=ON \
	-DUA_ENABLE_DISCOVERY_MULTICAST=ON \
	-DUA_ENABLE_DISCOVERY_SEMAPHORE=ON \
	-DUA_ENABLE_ENCRYPTION=ON \
	-DUA_ENABLE_EXPERIMENTAL_HISTORIZING=OFF \
	-DUA_ENABLE_HARDENING=ON \
	-DUA_ENABLE_ENCRYPTION_TPM2=OFF \
	-DUA_ENABLE_HISTORIZING=ON \
	-DUA_ENABLE_IMMUTABLE_NODES=ON \
	-DUA_ENABLE_JSON_ENCODING=OFF \
	-DUA_ENABLE_MALLOC_SINGLETON=OFF \
	-DUA_ENABLE_METHODCALLS=ON \
	-DUA_ENABLE_NODEMANAGEMENT=ON \
	-DUA_ENABLE_NODESET_COMPILER_DESCRIPTIONS=ON \
	-DUA_ENABLE_PUBSUB=ON \
	-DUA_ENABLE_PUBSUB_DELTAFRAMES=ON \
	-DUA_ENABLE_PUBSUB_ETH_UADP=ON \
	-DUA_ENABLE_PUBSUB_DELTAFRAMES=ON \
	-DUA_ENABLE_PUBSUB_INFORMATIONMODEL=ON \
	-DUA_ENABLE_PUBSUB_INFORMATIONMODEL_METHODS=ON \
	-DUA_ENABLE_QUERY=ON \
	-DUA_ENABLE_STATIC_ANALYZER=OFF \
	-DUA_ENABLE_STATUSCODE_DESCRIPTIONS=ON \
	-DUA_ENABLE_SUBSCRIPTIONS=ON \
	-DUA_ENABLE_SUBSCRIPTIONS_EVENTS=ON \
	-DUA_ENABLE_UNIT_TEST_FAILURE_HOOKS=OFF \
	-DUA_ENABLE_UNIT_TESTS_MEMCHECK=OFF \
	-DUA_ENABLE_VALGRIND_INTERACTIVE=OFF \
	-DUA_FILE_NS0="" \
	-DUA_FORCE_WERROR=OFF \
	-DUA_LOGLEVEL=$(OPEN62541_LOGLEVEL) \
	-DUA_MSVC_FORCE_STATIC_CRT=OFF \
	-DUA_MULTITHREADING=200 \
	-DUA_NAMESPACE_ZERO=FULL \
	-DUA_NODESET_DIR="$(PTXDIST_SYSROOT_HOST)/usr/share/ua-nodeset" \
	-DUA_PACK_DEBIAN=OFF
	-DUA_LOGLEVEL=$(OPEN62541_LOGLEVEL) \
	-DUA_MSVC_FORCE_STATIC_CRT=OFF \
	-DUA_NAMESPACE_ZERO=FULL \
	-DUA_NODESET_DIR="$(PTXDIST_SYSROOT_HOST)/usr/share/ua-nodeset" \
	-DUA_PACK_DEBIAN=OFF

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/open62541.targetinstall:
	@$(call targetinfo)

	@$(call install_init, open62541)
	@$(call install_fixup, open62541,PRIORITY,optional)
	@$(call install_fixup, open62541,SECTION,base)
	@$(call install_fixup, open62541,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, open62541,DESCRIPTION,missing)

	@$(call install_lib, open62541, 0, 0, 0644, libopen62541)

	@$(call install_finish, open62541)
	@$(call touch)

# vim: syntax=make
