# -*-makefile-*-
#
# Copyright (C) 2025 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION) += host-system-python3-license-expression

#
# Paths and names
#
HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION_VERSION		:= 30.4.1
HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION_MD5		:= 0a66ff031cd5e4d33567776f4a72bc97
HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION			:= license_expression-$(HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION_VERSION)
HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION_SUFFIX		:= tar.gz
HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION_URL		:= $(call ptx/mirror-pypi, license-expression, $(HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION).$(HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION_SUFFIX))
HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION_SOURCE		:= $(SRCDIR)/$(HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION).$(HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION_SUFFIX)
HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION_DIR		:= $(HOST_BUILDDIR)/system-$(HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION)
HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION_LICENSE		:= Apache-2.0
HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION_LICENSE_FILES	:= file://apache-2.0.LICENSE;md5=86d3f3a95c324c9479bd8986968f4327

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

HOST_SYSTEM_PYTHON3_LICENSE_EXPRESSION_CONF_TOOL	:= python3

# vim: syntax=make
