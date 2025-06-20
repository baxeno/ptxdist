# -*-makefile-*-
#
# Copyright (C) 2006 by Erwin Rol
#               2010 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBDRM) += libdrm

#
# Paths and names
#
LIBDRM_VERSION	:= 2.4.125
LIBDRM_MD5	:= 3baec8e685510892b3355a7074baa874
LIBDRM		:= libdrm-$(LIBDRM_VERSION)
LIBDRM_SUFFIX	:= tar.xz
LIBDRM_URL	:= http://dri.freedesktop.org/libdrm/$(LIBDRM).$(LIBDRM_SUFFIX)
LIBDRM_SOURCE	:= $(SRCDIR)/$(LIBDRM).$(LIBDRM_SUFFIX)
LIBDRM_DIR	:= $(BUILDDIR)/$(LIBDRM)
LIBDRM_LICENSE	:= MIT
LIBDRM_LICENSE_FILES	:= \
	file://xf86drm.c;startline=10;endline=31;md5=30492a61897fb94bd0efd13b4f129d7a

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

ifdef PTXCONF_ARCH_X86
LIBDRM_BACKENDS-$(PTXCONF_LIBDRM_INTEL) += intel
else
LIBDRM_BACKENDS- += intel
endif
LIBDRM_BACKENDS-$(PTXCONF_LIBDRM_RADEON) += radeon
LIBDRM_BACKENDS-$(PTXCONF_LIBDRM_AMDGPU) += amdgpu
LIBDRM_BACKENDS-$(PTXCONF_LIBDRM_NOUVEAU) += nouveau
LIBDRM_BACKENDS-$(PTXCONF_LIBDRM_FREEDRENO) += freedreno
LIBDRM_BACKENDSC-$(PTXCONF_LIBDRM_VMWGFX) += vmwgfx
LIBDRM_BACKENDS-$(PTXCONF_LIBDRM_OMAP) += omap
LIBDRM_BACKENDS-$(PTXCONF_LIBDRM_EXYNOS) += exynos
LIBDRM_BACKENDS-$(PTXCONF_LIBDRM_TEGRA) += tegra
LIBDRM_BACKENDSC-$(PTXCONF_LIBDRM_VC4) += vc4
# vc4 is a headers only backend
LIBDRM_BACKENDS-$(PTXCONF_LIBDRM_ETNAVIV) += etnaviv

LIBDRM_BACKENDSC-y += $(LIBDRM_BACKENDS-y)
LIBDRM_BACKENDSC- += $(LIBDRM_BACKENDS-)
LIBDRM_BACKENDSL-y += $(LIBDRM_BACKENDS-y)

#
# meson
#
LIBDRM_CONF_TOOL := meson
LIBDRM_CONF_OPT := \
	$(CROSS_MESON_USR) \
	$(patsubst %,-D%=enabled,$(LIBDRM_BACKENDSC-y)) \
	$(patsubst %,-D%=disabled,$(LIBDRM_BACKENDSC-)) \
	-Dcairo-tests=disabled \
	-Dfreedreno-kgsl=false \
	-Dman-pages=disabled \
	-Dvalgrind=disabled \
	-Dinstall-test-programs=$(call ptx/truefalse, PTXCONF_LIBDRM_TESTS) \
	-Dtests=true \
	-Dudev=true


# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libdrm.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libdrm)
	@$(call install_fixup, libdrm,PRIORITY,optional)
	@$(call install_fixup, libdrm,SECTION,base)
	@$(call install_fixup, libdrm,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, libdrm,DESCRIPTION,missing)

	@$(call install_lib, libdrm, 0, 0, 0644, libdrm)

	@$(foreach backend,$(LIBDRM_BACKENDSL-y), \
		$(call install_lib, libdrm, 0, 0, 0644, \
			libdrm_$(backend))$(ptx/nl))

ifdef PTXCONF_LIBDRM_TESTS
	@$(call install_copy, libdrm, 0, 0, 0755, -, /usr/bin/modetest)
	@$(call install_copy, libdrm, 0, 0, 0755, -, /usr/bin/modeprint)
	@$(call install_copy, libdrm, 0, 0, 0755, -, /usr/bin/vbltest)
ifdef PTXCONF_LIBDRM_ETNAVIV
	@$(call install_copy, libdrm, 0, 0, 0755, -, /usr/bin/etnaviv_2d_test)
	@$(call install_copy, libdrm, 0, 0, 0755, -, /usr/bin/etnaviv_cmd_stream_test)
	@$(call install_copy, libdrm, 0, 0, 0755, -, /usr/bin/etnaviv_bo_cache_test)
endif
ifdef PTXCONF_LIBDRM_AMDGPU
	@$(call install_copy, libdrm, 0, 0, 0755, -, /usr/bin/amdgpu_stress)
endif
endif
ifdef PTXCONF_LIBDRM_AMDGPU
	@$(call install_copy, libdrm, 0, 0, 0644, -, /usr/share/libdrm/amdgpu.ids)
endif
	@$(call install_finish, libdrm)

	@$(call touch)

# vim: syntax=make
