#!/bin/bash
#
# Copyright (C) 2019 Sascha Hauer <s.hauer@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

ptxd_make_image_fit_its() {
    local compatible

    cat << EOF
/dts-v1/;
/ {
	description = "Kernel Image";
	#address-cells = <1>;

	images {
		kernel {
			description = "kernel";
			data = /incbin/("${image_kernel}");
			arch = "$(ptxd_get_ptxconf PTXCONF_ARCH_STRING)";
			os = "linux";
			compression = "none";
EOF
    if [ -n "$(ptxd_get_ptxconf PTXCONF_KERNEL_FIT_NOLOAD)" ]; then
        cat << EOF
			type = "kernel_noload";
			load = <0x00000000>;
			entry = <0x00000000>;
EOF
    else
        cat << EOF
			type = "kernel";
EOF
        if [ -n "$(ptxd_get_ptxconf PTXCONF_KERNEL_FIT_LOAD)" ]; then
            cat << EOF
			load = <$(ptxd_get_ptxconf PTXCONF_KERNEL_FIT_LOAD)>;
EOF
        fi
        if [ -n "$(ptxd_get_ptxconf PTXCONF_KERNEL_FIT_ENTRY)" ]; then
            cat << EOF
			entry = <$(ptxd_get_ptxconf PTXCONF_KERNEL_FIT_ENTRY)>;
EOF
        fi
    fi
    cat << EOF
			hash-1 {
				algo = "sha256";
			};
		};
EOF
    if [ -n "${image_initramfs}" ]; then
    cat << EOF
		initramfs {
			description = "initramfs";
			data = /incbin/("${image_initramfs}");
			type = "ramdisk";
			os = "linux";
			compression = "none";
			hash-1 {
				algo = "sha256";
			};
		};
EOF
    fi
    for i in ${image_dtb}; do
	compatible=$(set -- $(fdtget "${i}" / compatible); echo ${1})
	cat << EOF
		fdt-${compatible} {
			data = /incbin/("${i}");
			compression = "none";
			type = "flat_dt";
			arch = "$(ptxd_get_ptxconf PTXCONF_ARCH_STRING)";
			hash-1 {
				algo = "sha256";
			};
		};
EOF
    done
    cat << EOF
	};
	configurations {
EOF
    for i in ${image_dtb}; do
	compatible=$(set -- $(fdtget "${i}" / compatible); echo ${1})
	cat << EOF
		conf-${compatible} {
			compatible = "${compatible}";
			kernel = "kernel";
EOF
	if [ -n "${image_initramfs}" ]; then
	cat << EOF
			ramdisk = "initramfs";
EOF
	fi
	cat << EOF
			fdt = "fdt-${compatible}";
EOF
	if [ -n "${image_sign_role}" ]; then
	    cat << EOF
			signature-1 {
				algo = "sha256,rsa4096";
				key-name-hint = "${image_key_name_hint}";
				sign-images = "fdt", "kernel"${image_initramfs:+$(printf %s ', "ramdisk"')};
			};
EOF
	fi
	cat << EOF
		};
EOF
    done
    cat << EOF
	};
};
EOF
}
export -f ptxd_make_image_fit_its

ptxd_make_image_fit() {
    local pkcs11_uri
    local its=$(mktemp ${PTXDIST_TEMPDIR}/fitimage.XXXXXXXX)
    local -a sign_args

    ptxd_make_image_init || return

    if [ -n "${image_sign_role}" ]; then
	pkcs11_uri=$(cs_get_uri "${image_sign_role}")
	sign_args=( -k "${pkcs11_uri}" )
    fi

    if [ -z "${image_image}" ]; then
	ptxd_bailout "ptxd_make_image_fit: image_image not given"
    fi

    if [ -z "${image_kernel}" ]; then
	ptxd_bailout "ptxd_make_image_fit: image_kernel not given"
    fi

    ptxd_make_image_fit_its > "${its}" &&
    if [ "${PTXDIST_VERBOSE}" == "1" ]; then
	echo "Generated device-tree for the fit image:"
	cat "${its}"
    fi &&
    ptxd_exec mkimage -N pkcs11 -f "${its}" "${image_image}" -r "${sign_args[@]}"
}
export -f ptxd_make_image_fit
