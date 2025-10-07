# -*-makefile-*-
#
# Copyright (C) 2025 by Bruno Thomsen <bruno.thomsen@gmail.com>
#               2025 by Ladislav Michl <ladis@triops.cz>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

PTX_PACKAGES_IGNORE	:= \
	cross-llvm \
	nodejs_packages

PHONY += ptxdist-repology

ptx_packages_reported:=$(sort $(filter-out host-system-%,$(filter-out host-%,$(filter-out image-%,$(PTX_PACKAGES_ALL)))))
ptx_packages_reported:=$(filter-out $(PTX_PACKAGES_IGNORE),$(ptx_packages_reported))
ptx_package_last:=$(lastword $(ptx_packages_reported))
ptx_packages_reported:=$(filter-out $(ptx_package_last),$(ptx_packages_reported))

ptx/repology-print = \
	$(info $(space)   "name": "$(1)"$(comma)) \
	$(info $(space)   "version": "$($(PTX_MAP_TO_PACKAGE_$(1))_VERSION)"$(comma)) \
	$(info $(space)   "upstream_urls": "$($(PTX_MAP_TO_PACKAGE_$(1))_URL)"$(comma)) \
	$(info $(space)   "license": "$($(PTX_MAP_TO_PACKAGE_$(1))_LICENSE)")

ptx/repology-item = \
	$(info $(space) {) \
	$(call ptx/repology-print,$(1)) \
	$(info $(space) }$(comma))

ptx/repology-lastitem = \
	$(info $(space) {) \
	$(call ptx/repology-print,$(1)) \
	$(info $(space) })

ptx/repology = \
	$(info [) \
	$(foreach pkg,$(ptx_packages_reported), \
		$(if $(subst undefined,,$($(PTX_MAP_TO_PACKAGE_$(pkg))_VERSION)), \
			$(if $($(PTX_MAP_TO_PACKAGE_$(pkg))_URL), \
				$(call ptx/repology-item,$(pkg))$(ptx/nl),),)) \
	$(call ptx/repology-lastitem,$(ptx_package_last)) \
	$(info ])

ptxdist-repology:
	@$(call ptx/repology)
	@touch $(PTXDIST_TEMPDIR)/repology.done

# vim: syntax=make
