# -*-makefile-*-
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LLVM) += llvm

#
# Paths and names
#
LLVM_VERSION		:= 17.0.1
LLVM_MD5		:= 78e1fbd14517f31f921b3224c0cd4e45
LLVM			:= llvm-$(LLVM_VERSION)
LLVM_SUFFIX		:= src.tar.xz
LLVM_URL		:= \
	https://github.com/llvm/llvm-project/releases/download/llvmorg-$(LLVM_VERSION)/$(LLVM).$(LLVM_SUFFIX)
LLVM_SOURCE		:= $(SRCDIR)/$(LLVM).$(LLVM_SUFFIX)
LLVM_DIR		:= $(BUILDDIR)/$(LLVM)
LLVM_SUBDIR		:= $(LLVM).src
LLVM_STRIP_LEVEL	:= 0
LLVM_LICENSE		:= Apache-2.0 WITH LLVM-exception AND NCSA
LLVM_LICENSE_FILES	:= file://$(LLVM_SUBDIR)/LICENSE.TXT;md5=8a15a0759ef07f2682d2ba4b893c9afe

LLVM_CMAKE_MD5		:= d24373e1c78f3f1275b6150a0b748c1c
LLVM_CMAKE_URL		:= \
	https://github.com/llvm/llvm-project/releases/download/llvmorg-$(LLVM_VERSION)/cmake-$(LLVM_VERSION).$(LLVM_SUFFIX)
LLVM_CMAKE_SOURCE	:= $(SRCDIR)/cmake-$(LLVM_VERSION).$(LLVM_SUFFIX)
LLVM_CMAKE_DIR		:= $(BUILDDIR)/$(LLVM)/cmake

LLVM_PARTS		+= LLVM_CMAKE

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LLVM_HOST_ARCH	:= X86

ifdef PTXCONF_ARCH_ARM
LLVM_TARGET_ARCH	:= ARM
endif
ifdef PTXCONF_ARCH_ARM64
LLVM_TARGET_ARCH	:= AArch64
endif
ifdef PTXCONF_ARCH_X86
LLVM_TARGET_ARCH	:= X86
endif
ifdef PTXCONF_ARCH_MIPS
LLVM_TARGET_ARCH	:= Mips
endif
ifdef PTXCONF_ARCH_PPC
LLVM_TARGET_ARCH	:= PowerPC
endif

ifdef PTXCONF_LLVM
ifndef LLVM_TARGET_ARCH
$(error Unsupported LLVM architecture $(PTXCONF_ARCH_STRING))
endif
endif

LLVM_TARGETS_TO_BUILD := \
	$(LLVM_TARGET_ARCH) \
	AMDGPU

LLVM_CONF_ENV	:= \
	$(HOST_ENV)

#
# cmake
#
LLVM_CONF_TOOL	:= cmake
LLVM_CONF_OPT	:= \
	$(CROSS_CMAKE_USR) \
	-G Ninja \
	-DBUILD_SHARED_LIBS=OFF \
	-DLLVM_ABI_BREAKING_CHECKS=WITH_ASSERTS \
	-DLLVM_ALLOW_PROBLEMATIC_CONFIGURATIONS=OFF \
	-DLLVM_APPEND_VC_REV=ON \
	-DLLVM_BINUTILS_INCDIR= \
	-DLLVM_BUILD_32_BITS=OFF \
	-DLLVM_BUILD_BENCHMARKS=OFF \
	-DLLVM_BUILD_DOCS=OFF \
	-DLLVM_BUILD_EXAMPLES=OFF \
	-DLLVM_BUILD_EXTERNAL_COMPILER_RT=OFF \
	-DLLVM_BUILD_LLVM_C_DYLIB=OFF \
	-DLLVM_BUILD_LLVM_DYLIB=ON \
	-DLLVM_BUILD_RUNTIME=ON \
	-DLLVM_BUILD_RUNTIMES=ON \
	-DLLVM_BUILD_TESTS=OFF \
	-DLLVM_BUILD_TOOLS=ON \
	-DLLVM_BUILD_UTILS=OFF \
	-DLLVM_CCACHE_BUILD=OFF \
	-DLLVM_CODESIGNING_IDENTITY= \
	-DLLVM_DEFAULT_TARGET_TRIPLE= \
	-DLLVM_DEPENDENCY_DEBUGGING=OFF \
	-DLLVM_ENABLE_ASSERTIONS=OFF \
	-DLLVM_ENABLE_BACKTRACES=ON \
	-DLLVM_ENABLE_BINDINGS=OFF \
	-DLLVM_ENABLE_CRASH_DUMPS=OFF \
	-DLLVM_ENABLE_CRASH_OVERRIDES=ON \
	-DLLVM_ENABLE_CURL=OFF \
	-DLLVM_ENABLE_DAGISEL_COV=OFF \
	-DLLVM_ENABLE_DOXYGEN=OFF \
	-DLLVM_ENABLE_DUMP=OFF \
	-DLLVM_ENABLE_EH=OFF \
	-DLLVM_ENABLE_EXPENSIVE_CHECKS=OFF \
	-DLLVM_ENABLE_FFI=OFF \
	-DLLVM_ENABLE_GISEL_COV=OFF \
	-DLLVM_ENABLE_HTTPLIB=OFF \
	-DLLVM_ENABLE_IDE=OFF \
	-DLLVM_ENABLE_LIBCXX=OFF \
	-DLLVM_ENABLE_LIBEDIT=OFF \
	-DLLVM_ENABLE_LIBPFM=OFF \
	-DLLVM_ENABLE_LIBXML2=OFF \
	-DLLVM_ENABLE_LLD=OFF \
	-DLLVM_ENABLE_LOCAL_SUBMODULE_VISIBILITY=ON \
	-DLLVM_ENABLE_LTO=OFF \
	-DLLVM_ENABLE_MODULES=OFF \
	-DLLVM_ENABLE_MODULE_DEBUGGING=OFF \
	-DLLVM_ENABLE_NEW_PASS_MANAGER=TRUE \
	-DLLVM_ENABLE_OCAMLDOC=OFF \
	-DLLVM_ENABLE_PEDANTIC=ON \
	-DLLVM_ENABLE_PIC=ON \
	-DLLVM_ENABLE_PLUGINS=ON \
	-DLLVM_ENABLE_PROJECTS=\
	-DLLVM_ENABLE_RTTI=ON \
	-DLLVM_ENABLE_RUNTIMES= \
	-DLLVM_ENABLE_SPHINX=OFF \
	-DLLVM_ENABLE_STRICT_FIXED_SIZE_VECTORS=OFF \
	-DLLVM_ENABLE_TERMINFO=OFF \
	-DLLVM_ENABLE_THREADS=ON \
	-DLLVM_ENABLE_UNWIND_TABLES=ON \
	-DLLVM_ENABLE_WARNINGS=ON \
	-DLLVM_ENABLE_WERROR=OFF \
	-DLLVM_ENABLE_Z3_SOLVER=OFF \
	-DLLVM_ENABLE_ZLIB=ON \
	-DLLVM_ENABLE_ZSTD=OFF \
	-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD= \
	-DLLVM_EXPORT_SYMBOLS_FOR_PLUGINS=OFF \
	-DLLVM_EXTERNALIZE_DEBUGINFO=OFF \
	-DLLVM_FORCE_ENABLE_STATS=OFF \
	-DLLVM_FORCE_USE_OLD_TOOLCHAIN=OFF \
	-DLLVM_HAVE_TFLITE= \
	-DLLVM_INCLUDE_BENCHMARKS=OFF \
	-DLLVM_INCLUDE_DOCS=OFF \
	-DLLVM_INCLUDE_EXAMPLES=OFF \
	-DLLVM_INCLUDE_RUNTIMES=ON \
	-DLLVM_INCLUDE_TESTS=OFF \
	-DLLVM_INCLUDE_TOOLS=ON \
	-DLLVM_INCLUDE_UTILS=OFF \
	-DLLVM_INSTALL_BINUTILS_SYMLINKS=OFF \
	-DLLVM_INSTALL_CCTOOLS_SYMLINKS=OFF \
	-DLLVM_INSTALL_GTEST=OFF \
	-DLLVM_INSTALL_MODULEMAPS=OFF \
	-DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF \
	-DLLVM_INSTALL_UTILS=OFF \
	-DLLVM_INTEGRATED_CRT_ALLOC= \
	-DLLVM_LIBDIR_SUFFIX= \
	-DLLVM_LIB_FUZZING_ENGINE= \
	-DLLVM_LINK_LLVM_DYLIB=ON \
	-DLLVM_LOCAL_RPATH= \
	-DLLVM_OMIT_DAGISEL_COMMENTS=ON \
	-DLLVM_OPTIMIZED_TABLEGEN=OFF \
	-DLLVM_OPTIMIZE_SANITIZED_BUILDS=ON \
	-DLLVM_PARALLEL_COMPILE_JOBS= \
	-DLLVM_PARALLEL_LINK_JOBS= \
	-DLLVM_PROFDATA_FILE= \
	-DLLVM_SOURCE_PREFIX= \
	-DLLVM_STATIC_LINK_CXX_STDLIB=OFF \
	-DLLVM_TABLEGEN=$(PTXDIST_SYSROOT_HOST)/bin/llvm-tblgen \
	-DLLVM_TARGETS_TO_BUILD="$(subst $(space),;,$(LLVM_TARGETS_TO_BUILD))" \
	-DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=OFF \
	-DLLVM_TOOL_BOLT_BUILD=OFF \
	-DLLVM_TOOL_CLANG_BUILD=OFF \
	-DLLVM_TOOL_COMPILER_RT_BUILD=OFF \
	-DLLVM_TOOL_DRAGONEGG_BUILD=OFF \
	-DLLVM_TOOL_FLANG_BUILD=OFF \
	-DLLVM_TOOL_LIBCXXABI_BUILD=OFF \
	-DLLVM_TOOL_LIBCXX_BUILD=OFF \
	-DLLVM_TOOL_LIBC_BUILD=OFF \
	-DLLVM_TOOL_LIBUNWIND_BUILD=OFF \
	-DLLVM_TOOL_LLDB_BUILD=OFF \
	-DLLVM_TOOL_LLD_BUILD=OFF \
	-DLLVM_TOOL_MLIR_BUILD=OFF \
	-DLLVM_TOOL_OPENMP_BUILD=OFF \
	-DLLVM_TOOL_POLLY_BUILD=OFF \
	-DLLVM_TOOL_PSTL_BUILD=OFF \
	-DLLVM_UNREACHABLE_OPTIMIZE=ON \
	-DLLVM_USE_FOLDERS=ON \
	-DLLVM_USE_INTEL_JITEVENTS=OFF \
	-DLLVM_USE_OPROFILE=OFF \
	-DLLVM_USE_PERF=ON \
	-DLLVM_USE_RELATIVE_PATHS_IN_DEBUG_INFO=OFF \
	-DLLVM_USE_RELATIVE_PATHS_IN_FILES=OFF \
	-DLLVM_USE_SANITIZER= \
	-DLLVM_USE_SPLIT_DWARF=OFF \
	-DLLVM_USE_STATIC_ZSTD=FALSE \
	-DLLVM_USE_SYMLINKS=ON \
	-DLLVM_VERSION_PRINTER_SHOW_HOST_TARGET_INFO=ON \
	-DLLVM_WINDOWS_PREFER_FORWARD_SLASH=OFF

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

CROSS_LLVM_CONFIG := $(PTXDIST_SYSROOT_CROSS)/usr/bin/llvm-config

$(STATEDIR)/llvm.install.post:
	@$(call targetinfo)
	@$(call world/install.post, LLVM)
#	# llvm-config must be in sysroot-target to generate the correct paths
	@cp $(PTXDIST_SYSROOT_HOST)/usr/bin/llvm-config $(PTXDIST_SYSROOT_TARGET)/usr/bin/llvm-config
	@echo '#!/bin/sh'						>  $(CROSS_LLVM_CONFIG)
	@echo 'exec $(PTXDIST_SYSROOT_TARGET)/usr/bin/llvm-config "$${@}"'	>> $(CROSS_LLVM_CONFIG)
	@chmod +x $(CROSS_LLVM_CONFIG)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/llvm.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  llvm)
	@$(call install_fixup, llvm,PACKAGE,llvm)
	@$(call install_fixup, llvm,PRIORITY,optional)
	@$(call install_fixup, llvm,SECTION,base)
	@$(call install_fixup, llvm,AUTHOR,"Marian Cichy <m.cichy@pengutronix.de>")
	@$(call install_fixup, llvm,DESCRIPTION,missing)

	@$(call install_lib, llvm, 0, 0, 0644, libLLVM-$(basename $(basename $(LLVM_VERSION))))

	@$(call install_finish, llvm)
	@$(call touch)

# vim: syntax=make
