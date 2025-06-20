#!/bin/bash
#
# Copyright (C) 2004-2009 by the ptxdist project
#               2010 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# ptxd_make_world_patchin_apply_init -
# initialize variables used to apply the patches
#
# out:
#
# pkg_patch_series	path to series file
# pkg_patch_tool	tool used to apply the patch series
#
ptxd_make_world_patchin_apply_init()
{
    # look for series
    if [ -n "${pkg_patch_series}" ]; then
	# check if specified series file can be found
	pkg_patch_series="${pkg_patch_dir}/${pkg_patch_series}"
	if [ \! -e "${pkg_patch_series}" ]; then
	    echo "error: specified series '${pkg_patch_series}' not found"
	    return 1
	fi
    else
	# is there a "series" file
	pkg_patch_series="${pkg_patch_dir}/series"
    fi

    # decide which tool to use
    if [ "${PTXCONF_SETUP_PATCHIN_GIT}" ] && which git > /dev/null 2>&1; then
	pkg_patch_tool=git
    elif which quilt > /dev/null 2>&1; then
	pkg_patch_tool=quilt
    else
	pkg_patch_tool=patch
    fi
}
export -f ptxd_make_world_patchin_apply_init


#
# Wrapper that prevents running automatic repack during ptxdist runs to not
# loose more time on patch stacks that maybe are not modified anyhow.
#
__git()
{
	git -c gc.auto=0 "$@"
}
export -f __git


#
# initialize git database in $pkg_patchin_dir and do initial commit
#
ptxd_make_world_patchin_apply_git_init()
{
    local git_dir
    git_dir="$(git rev-parse --git-dir 2> /dev/null)" || true

    local git_ptx_patches
    ptxd_in_path PTXDIST_PATH_SCRIPTS git-ptx-patches
    git_ptx_patches="${ptxd_reply}"

    local git_ptx_refresh_tags_editor
    ptxd_in_path PTXDIST_PATH_SCRIPTS git-ptx-refresh-tags-editor
    git_ptx_refresh_tags_editor="${ptxd_reply}"

    # is already git repo?
    if [ "${git_dir}" != ".git" ]; then
	echo "patchin: git: initializing repository"
	__git init -q &&
	__git add -f . &&
	__git commit -q -m "initial commit" --author="ptxdist-${PTXDIST_VERSION_FULL} <ptxdist@pengutronix.de>" &&
	__git tag "${pkg_pkg//\~/-}" &&
	__git tag base &&
	__git config alias.ptx-patches "!${git_ptx_patches} \"\${@}\"" &&
	__git config sequence.editor "${git_ptx_refresh_tags_editor}" &&
	__git config diff.renames false &&
	__git config core.abbrev 12 &&
	__git config core.autocrlf false &&
	echo "patchin: git: done"
    fi
}
export -f ptxd_make_world_patchin_apply_git_init


#
# create a directory containing the patches and the selected series
# file. name that file "series".
#
# decompress "bz2", "gz" and "xz" patches on the fly
#
ptxd_make_world_patchin_apply_git_compat()
{
    mkdir "${pkg_patchin_dir}/.ptxdist/git-patches" || return

    local patch para
    while read patch para; do
	local cat
	local patch_file="${patch##*/}"

	case "${para}" in
	    ""|"#"*) para="-p1" ;;	# no para or comment
	    -p*) ;;
	esac

	case "${patch}" in
	    "#tag:"*)
		local tag="${patch##\#tag:}"
		if [ -f ${pkg_patchin_dir}/.ptxdist/git-patches/series ]; then
		    mv ${pkg_patchin_dir}/.ptxdist/git-patches/series{,.${tag}} &&
		    touch ${pkg_patchin_dir}/.ptxdist/git-patches/series
		else
		    touch ${pkg_patchin_dir}/.ptxdist/git-patches/series.${tag}
		fi
		continue
		;;
	    ""|"#"*) continue ;;	# skip empty lines and comments
	    *.gz)  cat="zcat" ;;
	    *.bz2) cat="bzcat" ;;
	    *.xz)  cat="xzcat" ;;
	    *)
		ln -s "../patches/${patch}" "${pkg_patchin_dir}/.ptxdist/git-patches/${patch_file}" &&
		echo "${patch_file}" "${para}" >> "${pkg_patchin_dir}/.ptxdist/git-patches/series" || return
		continue
		;;
	esac &&

	"${cat}" "${pkg_patchin_dir}/.ptxdist/patches/${patch}" > \
	    "${pkg_patchin_dir}/.ptxdist/git-patches/${patch_file%.*}"
	echo "${patch_file%.*}" "${para}" >> "${pkg_patchin_dir}/.ptxdist/git-patches/series" || return

    done < "${pkg_patchin_dir}/.ptxdist/series" &&
    touch "${pkg_patchin_dir}/.ptxdist/git-patches/series"
}
export -f ptxd_make_world_patchin_apply_git_compat


#
# apply patch series with git
#
ptxd_make_world_patchin_apply_git()
{
    #
    # git quiltimport has certain limitations, work around them
    #
    ptxd_make_world_patchin_apply_git_compat || return

    grep "\#tag:" "${pkg_patchin_dir}/.ptxdist/series" | while read tagline; do
	local tag="${tagline##\#tag:}"
	tag=$(echo ${tag}|cut -d' ' -f1)
	if [ -f "${pkg_patchin_dir}/.ptxdist/git-patches/series.${tag}" ]; then
	    mv ${pkg_patchin_dir}/.ptxdist/git-patches/series{,.1} || return
	    mv ${pkg_patchin_dir}/.ptxdist/git-patches/series{.${tag},} || return

	    __git quiltimport \
		--patches "${pkg_patchin_dir}/.ptxdist/git-patches" \
		--author "unknown author <unknown.author@example.com>" &&
	    echo "tagging -> ${tag}" &&
	    __git tag -f ${tag} &&
	    mv ${pkg_patchin_dir}/.ptxdist/git-patches/series{,.${tag}} || return
	    mv ${pkg_patchin_dir}/.ptxdist/git-patches/series{.1,} || return
	fi
    done

    __git quiltimport \
	--patches "${pkg_patchin_dir}/.ptxdist/git-patches" \
	--author "unknown author <unknown.author@example.com>" &&

    # skip patches generated by other tools with '# <tool>-end' as end marker
    if tail -n1 "${pkg_patchin_dir}/.ptxdist/series" | grep -q '# [^ ]*-end$'; then
	local last="$(sed -n 's/^0*\([1-9][0-9]*\)-.*/\1/p' "${pkg_patchin_dir}/.ptxdist/series" | tail -n1)"
	__git tag -f base || return
	local next=1000
	if [ -n "${last}" ]; then
		next="$[(1+${last}/1000)*1000]"
	fi
	echo "#tag:base --start-number ${next}" >> ${pkg_patchin_dir}/.ptxdist/series.append
    fi
}
export -f ptxd_make_world_patchin_apply_git


#
# apply patch series with quilt
#
ptxd_make_world_patchin_apply_quilt()
{
    QUILT_PATCHES="${pkg_patchin_dir}/.ptxdist/patches" quilt --quiltrc - push -a
}
export -f ptxd_make_world_patchin_apply_quilt


#
# apply patch series with patch
#
ptxd_make_world_patchin_apply_patch()
{
    local patch para junk

    while read patch para junk; do
	local cat

	case "${patch}" in
	    ""|"#"*) continue ;;	# skip empty lines and comments
	    *.gz)    cat=zcat ;;
	    *.bz2)   cat=bzcat ;;
	    *.xz)    cat=xzcat ;;
	    *)       cat=cat ;;
	esac

	case "${para}" in
	    ""|"#"*) para="-p1" ;;	# no para or comment
	    -p*) ;;
	esac

	echo "applying '${patch}'"
	patch="${pkg_patchin_dir}/.ptxdist/patches/${patch}"
	"${cat}" "${patch}" | patch "${para}" -N -d "${pkg_patchin_dir}" &&
	check_pipe_status || return

    done < "${pkg_patchin_dir}/.ptxdist/series" &&
    unset patch para junk
}
export -f ptxd_make_world_patchin_apply_patch


#
# generic apply patch series function
#
ptxd_make_world_patchin_apply()
{
    local \
	tmp_patch_series \
	pkg_patch_series \
	pkg_patch_tool

    if [[ "${pkg_url}" =~ ^file:// || "${pkg_url}" =~ ^lndir:// ]]; then
	local url="$(ptxd_file_url_path "${pkg_url}")"
	# local directories are not intended to be patched
	if [ -d "${url}" ]; then
	   echo "Local source directory detected, skipping patch-in step"
	   return
	fi
    fi

    ptxd_make_world_patchin_apply_init || return
    if [ -z "${pkg_patch_dir}" ]; then
	return
    fi &&

    if [ "${pkg_patch_tool}" = "git" ]; then
	ptxd_make_world_patchin_apply_git_init || return
    fi &&

    #
    # the primary reference is the ".ptxdist" folder in the pkg_patchin_dir:
    # these files might be existent:
    #
    # patches	link, pointing to the dir containing the pkg's patches
    # series	usually link, pointing to the used series file
    #		if no series file is supplied and the folder
    #		containing the patches is not writable, this will be a
    #		file
    #
    if [ -e "${pkg_patchin_dir}/.ptxdist" ]; then
	ptxd_bailout "pkg_patchin_dir '${pkg_patchin_dir}' already contains a '.ptxdist' folder"
    fi &&
    mkdir "${pkg_patchin_dir}/.ptxdist" &&

    #
    # create a ".ptxdist/patches" link pointing to the directory
    # containing the patches
    #
    ln -s "${pkg_patch_dir}" "${pkg_patchin_dir}/.ptxdist/patches" &&

    tmp_patch_series="${pkg_patchin_dir}/.ptxdist/series" &&

    # link series file - if not available create it
    if [ ! -e "${pkg_patch_series}" ]; then
	#
	# look for patches (and archives) and put into series file
	# (the "sed" removes "./" from find's output)
	#
	pushd "${pkg_patch_dir}/" >/dev/null &&
	find \
	    -name "*.diff" -o \
	    -name "*.patch" -o \
	    -name "*.xz" -o \
	    -name "*.bz2" -o \
	    -name "*.gz" | \
	    sed -e "s:^[.]/::" | sort > \
	    "${tmp_patch_series}" &&
	popd > /dev/null

	# no patches found
	if [ \! -s "${tmp_patch_series}" ]; then
	    rm -f "${tmp_patch_series}" &&
	    unset pkg_patch_series
	else
	    ptxd_pedantic "series file for '$(ptxd_print_path "${pkg_patch_dir}")' is missing" &&

	    # if writable, create series file next to the patches
	    if [ -w "${pkg_patch_dir}/" ]; then
		mv "${tmp_patch_series}" "${pkg_patch_series}" &&
		ln -s "${pkg_patch_series}" "${tmp_patch_series}"
	    fi
	fi
    else
	ln -s "${pkg_patch_series}" "${tmp_patch_series}"

	#
	# check for non existing patches
	#
	# Some tools like "git" skip non existing patches without an
	# error. In ptxdist we consider this a fatal error.
	#
	local patch para junk
	while read patch tmp; do
	    case "${patch}" in
		""|"#"*) continue ;;	# skip empty lines and comments
		*) ;;
	    esac

	    case "${para}" in
		""|"#"*) ;;		# no para or comment
		-p*) ;;
		*) ptxd_bailout "invalid parameter to patch '${patch}' in series file '${pkg_patch_series}'"
	    esac

	    if [ \! -f "${pkg_patchin_dir}/.ptxdist/patches/${patch}" ]; then
		ptxd_bailout "cannot find patch: '${patch}' specified in series file '${pkg_patch_series}'"
	    fi

	done < "${pkg_patchin_dir}/.ptxdist/series" &&
	unset patch para junk
    fi || return

    #
    # setup convenience links
    #
    # series
    if [ -e "${pkg_patchin_dir}/.ptxdist/series" ]; then
	if [ -e "${pkg_patchin_dir}/series" ]; then
	    ptxd_bailout "there's a 'series' file in the pkg_patchin_dir"
	fi
	ln -sf ".ptxdist/series" "${pkg_patchin_dir}/series"
    fi &&

    # patches
    if [ \! -e "${pkg_patchin_dir}/patches" ]; then
	ln -sf ".ptxdist/patches" "${pkg_patchin_dir}/patches"
    fi || return

    echo
    echo "pkg_patch_dir:     '$(ptxd_print_path "${pkg_patch_dir:-<none>}")'"
    echo "pkg_patch_series:  '$(ptxd_print_path "${pkg_patch_series:-<none>}")'"
    echo

    # apply patches if series file is available
    if [ -n "${pkg_patch_series}" ]; then
	echo    "patchin: ${pkg_patch_tool}: apply '$(ptxd_print_path ${pkg_patch_series})'"
	"ptxd_make_world_patchin_apply_${pkg_patch_tool}" || return
	echo -e "patchin: ${pkg_patch_tool}: done\n"
    fi
}
export -f ptxd_make_world_patchin_apply


#
#
#
ptxd_make_world_patchin_fixup()
{
    local file

    echo "patchin: fixup:"

    if [ "${pkg_conf_tool}" != "autoconf" -a "${pkg_conf_tool}" != "NO" ]; then
	echo -e "patchin: fixup: skipped\n"
	return
    fi

    find "${pkg_dir}/" -name "configure" -a -type f -a \! -path "*/.pc/*" | while read file; do
	ptxd_print_path "${file}"
	#
	# the first fixes a problem with libtool on blackfin:
	# - on blackfin they've got symbols with more "_" prefixes than on other platforms
	# - teach libtool to cope with it
	#
	# the second one suppresses the adding of "rpath"
	#
	sed -i \
	    -e "s=sed -e \"s/\\\\(\.\*\\\\)/\\\\1;/\"=sed -e \"s/\\\\(.*\\\\)/'\"\$ac_symprfx\"'\\\\1;/\"=" \
	    \
	    -e "s:^\(hardcode_into_libs\)=.*:\1=\"no\":" \
	    -e "s:^\(hardcode_libdir_flag_spec\)=.*:\1=\"\":" \
	    -e "s:^\(hardcode_libdir_flag_spec_ld\)=.*:\1=\"\":" \
	    -e "s:^\(enable_option_checking\)=.*:\1=fatal:" \
	    "${file}" || return
    done &&

    find "${pkg_dir}/" -name "ltmain.sh" -a \( -type f -o -type l \) -a \! -path "*/.pc/*" | while read file; do
	ptxd_print_path "${file}"
	#
	# this sed turns of the relinking during "make install" (it
	# might pick up libs from the host or break otherwise, we
	# don't need it on linux anyway)
	#
	sed -i \
	    -e "s:\(need_relink\)=yes:\1=\"no\":" \
	    "${file}" || return
    done &&

    ptxd_get_alternative scripts/autoconf config.sub
    local config_sub="${ptxd_reply}"
    find "${pkg_dir}/" \( -type f -o -type l \) -name "config.sub" ! -path "*/.pc/*" | while read file; do
	ptxd_print_path "${file}"
	cp -f "${config_sub}" "${file}" || return
    done &&

    echo -e "patchin: fixup: done\n"
}
export -f ptxd_make_world_patchin_fixup

#
#
#
ptxd_make_world_autogen() {
    # look for autogen.sh
    local pkg_patch_autogen="${pkg_patch_dir}/autogen.sh"
    if [ ! -x "${pkg_patch_autogen}" ]; then
	if [ -e "${pkg_patch_autogen}" -o -L "${pkg_patch_autogen}" ]; then
	    ptxd_bailout "'$(ptxd_print_path "${pkg_patch_autogen}")' is not executable or a broken link"
	fi
	unset pkg_patch_autogen
    fi

    echo "pkg_patch_autogen: '$(ptxd_print_path "${pkg_patch_autogen:-<none>}")'"
    echo

    # run autogen.sh if available
    if [ -n "${pkg_patch_autogen}" ]; then
	"${pkg_patch_autogen}" || return
	echo -e "patchin: autogen: done\n"
    fi
}
export -f ptxd_make_world_autogen


#
# ptxd_make_world_patchin_init -
# initialize variables used to apply the patches
#
# out:
#
# pkg_patchin_dir	where to apply the patches
# pkg_patch_dir		path to dir that contains the patches
#			empty if no patches should be applied
#
ptxd_make_world_patchin_init()
{
    ptxd_make_world_init || return

    if [ -z "${pkg_url}" -a -z "${pkg_src}" -a "${pkg_parts}" = "${pkg_PKG}" ]; then
	# no <PKG>_URL, no <PKG>_SOURCE and not other <PKG>_PARTS -> assume the package has nothing to patchin.
	return
    fi

    if [ -n "${pkg_deprecated_patchin_series}" ]; then
	ptxd_bailout "a 3rd parameter to patchin ('${pkg_deprecated_patchin_series}') is obsolete, please define <PKG>_SERIES instead"
    fi

    pkg_patchin_dir=${pkg_deprecated_patchin_dir:-${pkg_dir}}

    #
    # find patch_dir
    # fail if the legacy 'generic' location is found
    #
    if ptxd_in_path PTXDIST_PATH_PATCHES ${pkg_pkg}/generic; then
	ptxd_bailout "Legacy patch dir" \
	    "$(ptxd_print_path "${ptxd_reply}")" \
	    "is no longer supported. Move patches to" \
	    "$(ptxd_print_path "$(dirname "${ptxd_reply}")")"
    fi
    if [ -z "${pkg_patch_dir}" ]; then
	return
    fi
}
export -f ptxd_make_world_patchin_init

ptxd_make_world_patchin()
{
    ptxd_make_world_patchin_init || return

    if [ -n "${pkg_patch_dir}" ]; then (
	cd "${pkg_patchin_dir}" &&
	ptxd_make_world_patchin_apply
     ) else
	echo -e "patchin: no patches found"
    fi
}
export -f ptxd_make_world_patchin

ptxd_make_world_patchin_post() {
    ptxd_make_world_patchin_init || return

    if [ "${pkg_conf_tool}" = "cargo" -o -n "${pkg_cargo_lock}" ]; then
	{
	cat << EOF
[source.ptxdist]
directory = "${pkg_cargo_home}/source"

[source.crates-io]
replace-with = "ptxdist"
local-registry = "/nonexistant"

EOF

    sed -n 's;source = "\(git.*\)#.*;\1;p' "${pkg_dir}/${pkg_cargo_lock}" | sort -u | \
	sed -n 's;^git+\(.*://[^?]*\)?branch=\(.*\)$;[source."\1"]\ngit = "\1"\nbranch = "\2"\nreplace-with = "ptxdist"\n;p'
    sed -n 's;source = "\(git.*\)#.*;\1;p' "${pkg_dir}/${pkg_cargo_lock}" | sort -u | \
	sed -n 's;^git+\(.*://[^?]*\)?rev=\(.*\)$;[source."\1"]\ngit = "\1"\nrev = "\2"\nreplace-with = "ptxdist"\n;p'
    grep 'source = "git' "${pkg_dir}/${pkg_cargo_lock}" | sort -u | \
	sed -n 's;^source = "git+\(.*://[^?]*\)#.*";[source."\1"]\ngit = "\1"\nreplace-with = "ptxdist"\n;p'
    cat << EOF

[build]
target-dir = "${pkg_build_dir}/target"

[net]
offline = true
EOF
	} > ${pkg_cargo_home}/config.toml
    fi
    if [ -n "${pkg_patchin_dir}" ]; then (
	cd "${pkg_conf_dir_abs}" &&
	if [ -n "${pkg_patch_dir}" ]; then
	    ptxd_make_world_autogen
	fi
    ) fi &&
    if [ -e "${pkg_dir}" ]; then (
	cd "${pkg_dir}" &&
	if [ "${pkg_type}" = "target" ]; then
	    ptxd_make_world_patchin_fixup
	fi
    ) fi
}
export -f ptxd_make_world_patchin_post
