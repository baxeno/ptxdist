# -*-makefile-*-
#
# Copyright (C) 2025 by Bruno Thomsen <bruno.thomsen@gmail.com>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

PHONY += ptxdist-repology

ptx/repology = \
	$(call ptx/env) \
	ptx_dgen_rulesfiles_make="$(PTX_DGEN_RULESFILES_MAKE)" \
	ptxd_make_world_repology

ptxdist-repology:
	@$(call targetinfo)
	@$(call ptx/repology)

# vim: syntax=make
