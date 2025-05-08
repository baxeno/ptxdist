# -*-makefile-*-
#
# Copyright (C) 2025 by Bruno Thomsen <bruno.thomsen@gmail.com>
#               2025 by Ladislav Michl <ladis@triops.cz>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

PHONY += ptxdist-repology

# Use '=' to delay $(shell ...) calls until this is needed
PTX_REPOLOGY_PY	 = $(call ptx/in-path, PTXDIST_PATH_SCRIPTS, report/repology.py)

ptx/repology = \
	@$(call world/execute, PTX_REPOLOGY, $(PTX_REPOLOGY_PY))

ptxdist-repology:
	@$(call ptx/repology)

# vim: syntax=make
