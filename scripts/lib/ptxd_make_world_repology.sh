#!/bin/bash
#
# Copyright (C) 2025 by Bruno Thomsen <bruno.thomsen@gmail.com>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

ptxd_make_world_repology() {
	local filefd file
	local first
	ptxd_make_world_init

	echo "Locating all target packages ..."

	first=1
	exec {filefd}< <(ptxd_make_world_lint_makefiles)
	while read file <&${filefd}; do
	filename="${file##*/}"

	case "${filename}" in
		host-system-*|host-*|cross-*|image-*)
		continue
		;;
		*)
		;;
	esac
	case "${file}" in
		*/rules/post/*|*/rules/pre/*)
			continue
			;;
		*)
			;;
	esac
	grep -q '^[^ 	]*_VERSION[ 	:]*=' "${file}" || continue

	pkg_name=$(grep -m1 '^PACKAGES-$(PTXCONF_' "${file}" | cut -d '=' -f 2 | xargs)
	pkg_version=$(grep -m1 '^[^ 	]*_VERSION[ 	:]*=' "${file}" | cut -d '=' -f 2 | xargs)
	pkg_license=$(grep '^[^ 	]*_LICENSE[ 	:]*=' "${file}" | cut -d '=' -f 2 | xargs)

	[[ "$pkg_license" == *"call remove_quotes"* ]] && continue
	[[ "$pkg_license" == "ignore" ]] && continue
	[[ "$pkg_license" == '$('* ]] && continue
	[[ "$pkg_version" == '$('* ]] && continue
	[[ "$pkg_version" == *"call ptx/"* ]] && continue

	if [ $first -eq 1 ]; then
		first=0
		echo "["
	else
		echo ","
	fi
	echo "{\"name\": \"${pkg_name}\", \"version\": \"${pkg_version}\", \"license\": \"${pkg_license}\"}"
	done
	echo "]"
}
export -f ptxd_make_world_repology
