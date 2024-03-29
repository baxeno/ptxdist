# -*-makefile-*-
#
# Copyright (C) 2017 by Markus Niebel <Markus.Niebel@tqs.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_GLMARK2) += glmark2

#
# Paths and names
#
GLMARK2_VERSION	:= 2023.01
GLMARK2_MD5	:= f6f20b4cb95aa40a446e8637115c7138
GLMARK2		:= glmark2-$(GLMARK2_VERSION)
GLMARK2_SUFFIX	:= tar.gz
GLMARK2_URL	:= https://github.com/glmark2/glmark2/archive/$(GLMARK2_VERSION).$(GLMARK2_SUFFIX)
GLMARK2_SOURCE	:= $(SRCDIR)/$(GLMARK2).$(GLMARK2_SUFFIX)
GLMARK2_DIR	:= $(BUILDDIR)/$(GLMARK2)
GLMARK2_LICENSE	:= GPL-3.0-only AND SGIv1
GLMARK2_LICENSE_FILES := \
	file://COPYING;md5=d32239bcb673463ab874e80d47fae504 \
	file://COPYING.SGI;md5=7125c8894bd29eddfd44ede5ce3ab1e4


# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

GLMARK2_FLAVORS-y :=
GLMARK2_FLAVORS-$(PTXCONF_GLMARK2_FLAVOR_X11_GL)	+= x11-gl
GLMARK2_FLAVORS-$(PTXCONF_GLMARK2_FLAVOR_X11_GLES2)	+= x11-glesv2
GLMARK2_FLAVORS-$(PTXCONF_GLMARK2_FLAVOR_DRM_GL)	+= drm-gl
GLMARK2_FLAVORS-$(PTXCONF_GLMARK2_FLAVOR_DRM_GLES2)	+= drm-glesv2
GLMARK2_FLAVORS-$(PTXCONF_GLMARK2_FLAVOR_WAYLAND_GL)	+= wayland-gl
GLMARK2_FLAVORS-$(PTXCONF_GLMARK2_FLAVOR_WAYLAND_GLES2)	+= wayland-glesv2

GLMARK2_FLAVORS := $(strip $(GLMARK2_FLAVORS-y))
GLMARK2_FLAVORS := $(subst $(ptx/def/space),$(ptx/def/comma),$(GLMARK2_FLAVORS))

GLMARK2_CONF_TOOL	:= meson
GLMARK2_CONF_OPT	:= \
	$(CROSS_MESON_USR) \
	-Ddata-path='' \
	-Dextras-path='' \
	-Dflavors=$(GLMARK2_FLAVORS) \
	-Dversion-suffix=''

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/glmark2.targetinstall:
	@$(call targetinfo)

	@$(call install_init, glmark2)
	@$(call install_fixup, glmark2, PRIORITY, optional)
	@$(call install_fixup, glmark2, SECTION, base)
	@$(call install_fixup, glmark2, AUTHOR, "Markus Niebel <Markus.Niebel@tqs.de>")
	@$(call install_fixup, glmark2, DESCRIPTION, missing)

	@$(call install_tree, glmark2, 0, 0, -, /usr/share/glmark2)
ifeq ($(PTXCONF_GLMARK2_FLAVOR_X11_GL),y)
	@$(call install_copy, glmark2, 0, 0, 0755, -, /usr/bin/glmark2)
endif
ifeq ($(PTXCONF_GLMARK2_FLAVOR_X11_GLES2),y)
	@$(call install_copy, glmark2, 0, 0, 0755, -, /usr/bin/glmark2-es2)
endif
ifeq ($(PTXCONF_GLMARK2_FLAVOR_DRM_GL),y)
	@$(call install_copy, glmark2, 0, 0, 0755, -, /usr/bin/glmark2-drm)
endif
ifeq ($(PTXCONF_GLMARK2_FLAVOR_DRM_GLES2),y)
	@$(call install_copy, glmark2, 0, 0, 0755, -, /usr/bin/glmark2-es2-drm)
endif
ifeq ($(PTXCONF_GLMARK2_FLAVOR_WAYLAND_GL),y)
	@$(call install_copy, glmark2, 0, 0, 0755, -, /usr/bin/glmark2-wayland)
endif
ifeq ($(PTXCONF_GLMARK2_FLAVOR_WAYLAND_GLES2),y)
	@$(call install_copy, glmark2, 0, 0, 0755, -, /usr/bin/glmark2-es2-wayland)
endif

	@$(call install_finish, glmark2)

	@$(call touch)

# vim: syntax=make
