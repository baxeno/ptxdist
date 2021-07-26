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
PACKAGES-$(PTXCONF_PIPEWIRE) += pipewire

#
# Paths and names
#
PIPEWIRE_VERSION	:= 0.3.32
PIPEWIRE_MD5		:= c3f81ad2d0eedf87265cfae30f08c10b
PIPEWIRE		:= pipewire-$(PIPEWIRE_VERSION)
PIPEWIRE_SUFFIX		:= tar.bz2
PIPEWIRE_URL		:= https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/$(PIPEWIRE_VERSION)/$(PIPEWIRE).$(PIPEWIRE_SUFFIX)
PIPEWIRE_SOURCE		:= $(SRCDIR)/$(PIPEWIRE).$(PIPEWIRE_SUFFIX)
PIPEWIRE_DIR		:= $(BUILDDIR)/$(PIPEWIRE)
PIPEWIRE_LICENSE	:= MIT AND LGPL-2.1-or-later
PIPEWIRE_LICENSE_FILES := \
	file://LICENSE;md5=2158739e172e58dc9ab1bdd2d6ec9c72 \
	file://COPYING;md5=97be96ca4fab23e9657ffa590b931c1a

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

PIPEWIRE_CONF_ENV := \
	PTXDIST_PKG_CONFIG_VAR_NO_SYSROOT=systemduserunitdir

#
# meson
#
PIPEWIRE_CONF_TOOL	:= meson
PIPEWIRE_CONF_OPT	:= \
	$(CROSS_MESON_USR) \
	-Dalsa=enabled \
	-Daudioconvert=enabled \
	-Daudiomixer=enabled \
	-Daudiotestsrc=enabled \
	-Davahi=disabled \
	-Dbluez5=disabled \
	-Dbluez5-backend-hfp-native=disabled \
	-Dbluez5-backend-hsp-native=disabled \
	-Dbluez5-backend-hsphfpd=disabled \
	-Dbluez5-backend-ofono=disabled \
	-Dbluez5-codec-aac=disabled \
	-Dbluez5-codec-aptx=disabled \
	-Dbluez5-codec-ldac=disabled \
	-Dcontrol=enabled \
	-Ddefault-session-manager=media-session \
	-Ddocdir= \
	-Ddocs=disabled \
	-Decho-cancel-webrtc=disabled \
	-Devl=disabled \
	-Dexamples=enabled \
	-Dffmpeg=disabled \
	-Dgstreamer=$(call ptx/endis,PTXCONF_PIPEWIRE_GSTREAMER)d \
	-Dgstreamer-device-provider=$(call ptx/endis,PTXCONF_PIPEWIRE_GSTREAMER)d \
	-Dinstalled_tests=disabled \
	-Djack=disabled \
	-Djack-devel=disabled \
	-Dlibcamera=disabled \
	-Dlibjack-path= \
	-Dlibpulse=disabled \
	-Dlibusb=disabled \
	-Dman=disabled \
	-Dpipewire-alsa=enabled \
	-Dpipewire-jack=disabled \
	-Dpw-cat=enabled \
	-Droc=disabled \
	-Dsdl2=disabled \
	-Dsession-managers=media-session \
	-Dsndfile=enabled \
	-Dspa-plugins=enabled \
	-Dsupport=enabled \
	-Dsystemd=$(call ptx/endis,PTXCONF_PIPEWIRE_SYSTEMD)d \
	-Dsystemd-system-service=$(call ptx/endis,PTXCONF_PIPEWIRE_SYSTEMD_UNIT)d \
	-Dsystemd-user-service=$(call ptx/endis,PTXCONF_PIPEWIRE_SYSTEMD_UNIT_USER)d \
	-Dsystemd-user-unit-dir= \
	-Dtest=disabled \
	-Dtests=disabled \
	-Dudev=enabled \
	-Dudevrulesdir= \
	-Dv4l2=enabled \
	-Dvideoconvert=disabled \
	-Dvideotestsrc=enabled \
	-Dvolume=enabled \
	-Dvulkan=disabled

PIPEWIRE_CPPFLAGS = -isystem $(KERNEL_HEADERS_INCLUDE_DIR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

PIPEWIRE_MODULES := \
	access \
	adapter \
	client-device \
	client-node \
	echo-cancel \
	filter-chain \
	link-factory \
	loopback \
	metadata \
	portal \
	profiler \
	protocol-native \
	protocol-pulse \
	rt \
	rtkit \
	session-manager \
	spa-device \
	spa-device-factory \
	spa-node \
	spa-node-factory

PIPEWIRE_SPA_MODULES := \
	alsa/libspa-alsa \
	audiomixer/libspa-audiomixer \
	audiotestsrc/libspa-audiotestsrc \
	control/libspa-control \
	support/libspa-dbus \
	$(call ptx/ifdef,PTXCONF_PIPEWIRE_SYSTEMD,support/libspa-journal) \
	support/libspa-support \
	v4l2/libspa-v4l2 \
	videotestsrc/libspa-videotestsrc \
	volume/libspa-volume

$(STATEDIR)/pipewire.targetinstall:
	@$(call targetinfo)

	@$(call install_init, pipewire)
	@$(call install_fixup, pipewire,PRIORITY,optional)
	@$(call install_fixup, pipewire,SECTION,base)
	@$(call install_fixup, pipewire,AUTHOR,"Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, pipewire,DESCRIPTION,missing)

	@$(call install_lib, pipewire, 0, 0, 644, libpipewire-0.3)

	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/pipewire)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/pipewire-media-session)
ifdef PTXCONF_PIPEWIRE_PULSEAUDIO
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/pipewire-pulse)
endif
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/pw-cat)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/pw-cli)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/pw-dot)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/pw-dump)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/pw-link)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/pw-loopback)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/pw-metadata)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/pw-mididump)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/pw-mon)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/pw-profiler)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/pw-reserve)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/spa-acp-tool)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/spa-inspect)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/spa-json-dump)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/spa-monitor)
	@$(call install_copy, pipewire, 0, 0, 755, -, /usr/bin/spa-resample)

	@$(call install_link, pipewire, pw-cat, /usr/bin/pw-midiplay)
	@$(call install_link, pipewire, pw-cat, /usr/bin/pw-midirecord)
	@$(call install_link, pipewire, pw-cat, /usr/bin/pw-play)
	@$(call install_link, pipewire, pw-cat, /usr/bin/pw-record)

	@$(foreach module, $(PIPEWIRE_MODULES), \
		$(call install_lib, pipewire, 0, 0, 644, \
			pipewire-0.3/libpipewire-module-$(module))$(ptx/nl))

	@$(foreach module, $(PIPEWIRE_SPA_MODULES), \
		$(call install_lib, pipewire, 0, 0, 644, \
			spa-0.2/$(module))$(ptx/nl))

	@$(call install_alternative, pipewire, 0, 0, 644, /usr/share/pipewire/client.conf)
	@$(call install_alternative, pipewire, 0, 0, 644, /usr/share/pipewire/client-rt.conf)
	@$(call install_alternative, pipewire, 0, 0, 644, /usr/share/pipewire/filter-chain/demonic.conf)
	@$(call install_alternative, pipewire, 0, 0, 644, /usr/share/pipewire/filter-chain/sink-dolby-surround.conf)
	@$(call install_alternative, pipewire, 0, 0, 644, /usr/share/pipewire/filter-chain/sink-eq6.conf)
	@$(call install_alternative, pipewire, 0, 0, 644, /usr/share/pipewire/filter-chain/sink-matrix-spatialiser.conf)
	@$(call install_alternative, pipewire, 0, 0, 644, /usr/share/pipewire/filter-chain/source-rnnoise.conf)
	@$(call install_alternative, pipewire, 0, 0, 644, /usr/share/pipewire/pipewire.conf)
ifdef PTXCONF_PIPEWIRE_PULSEAUDIO
	@$(call install_alternative, pipewire, 0, 0, 644, /usr/share/pipewire/pipewire-pulse.conf)
endif
	@$(call install_alternative, pipewire, 0, 0, 644, /usr/share/pipewire/media-session.d/alsa-monitor.conf)
	@$(call install_alternative, pipewire, 0, 0, 644, /usr/share/pipewire/media-session.d/bluez-hardware.conf)
	@$(call install_alternative, pipewire, 0, 0, 644, /usr/share/pipewire/media-session.d/bluez-monitor.conf)
	@$(call install_alternative, pipewire, 0, 0, 644, /usr/share/pipewire/media-session.d/media-session.conf)
	@$(call install_alternative, pipewire, 0, 0, 644, /usr/share/pipewire/media-session.d/v4l2-monitor.conf)

ifdef PTXCONF_PIPEWIRE_GSTREAMER
	@$(call install_lib, pipewire, 0, 0, 644, gstreamer-1.0/libgstpipewire)
endif
ifdef PTXCONF_PIPEWIRE_SYSTEMD_UNIT_USER
	@$(call install_alternative, pipewire, 0, 0, 0644, \
		/usr/lib/systemd/user/pipewire.service)
	@$(call install_alternative, pipewire, 0, 0, 0644, \
		/usr/lib/systemd/user/pipewire-media-session.service)
	@$(call install_alternative, pipewire, 0, 0, 0644, \
		/usr/lib/systemd/user/pipewire.socket)
	@$(call install_link, pipewire, ../pipewire.socket, \
		/usr/lib/systemd/user/sockets.target.wants/pipewire.socket)
	@$(call install_link, pipewire, ../pipewire-media-session.service, \
		/usr/lib/systemd/user/pipewire.service.wants/pipewire-media-session.service)
ifdef PTXCONF_PIPEWIRE_PULSEAUDIO
	@$(call install_alternative, pipewire, 0, 0, 0644, \
		/usr/lib/systemd/user/pipewire-pulse.service)
	@$(call install_alternative, pipewire, 0, 0, 0644, \
		/usr/lib/systemd/user/pipewire-pulse.socket)
endif
endif
ifdef PTXCONF_PIPEWIRE_SYSTEMD_UNIT
	@$(call install_alternative, pipewire, 0, 0, 0644, \
		/usr/lib/systemd/system/pipewire.service)
	@$(call install_alternative, pipewire, 0, 0, 0644, \
		/usr/lib/systemd/system/pipewire-media-session.service)
	@$(call install_alternative, pipewire, 0, 0, 0644, \
		/usr/lib/systemd/system/pipewire.socket)
	@$(call install_link, pipewire, ../pipewire.socket, \
		/usr/lib/systemd/system/sockets.target.wants/pipewire.socket)
	@$(call install_link, pipewire, ../pipewire-media-session.service, \
		/usr/lib/systemd/system/pipewire.service.wants/pipewire-media-session.service)
endif

	@$(call install_finish, pipewire)

	@$(call touch)

# vim: syntax=make