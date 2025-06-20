# -*-makefile-*-
#
# Copyright (C) 2008 by Daniel Schnell
#		2008, 2009, 2010 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBCURL) += libcurl

#
# Paths and names
#
LIBCURL_VERSION	:= 8.14.1
LIBCURL_MD5	:= cba9ea54bccefed639a529b1b5b17405
LIBCURL		:= curl-$(LIBCURL_VERSION)
LIBCURL_SUFFIX	:= tar.xz
LIBCURL_URL	:= https://curl.se/download/$(LIBCURL).$(LIBCURL_SUFFIX)
LIBCURL_SOURCE	:= $(SRCDIR)/$(LIBCURL).$(LIBCURL_SUFFIX)
LIBCURL_DIR	:= $(BUILDDIR)/$(LIBCURL)
LIBCURL_LICENSE	:= curl
LIBCURL_LICENSE_FILES := file://COPYING;md5=72f4e9890e99e68d77b7e40703d789b8

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
LIBCURL_CONF_TOOL	:= autoconf
LIBCURL_CONF_OPT	:= \
	$(CROSS_AUTOCONF_USR) \
	--disable-debug \
	--enable-optimize \
	--disable-warnings \
	--disable-werror \
	--disable-curldebug \
	--enable-symbol-hiding \
	--$(call ptx/endis, PTXCONF_LIBCURL_C_ARES)-ares \
	--enable-rt \
	--disable-httpsrr \
	--disable-ech \
	--disable-code-coverage \
	$(GLOBAL_LARGE_FILE_OPTION) \
	--disable-unity \
	--disable-test-bundles \
	--$(call ptx/endis, PTXCONF_LIBCURL_HTTP)-http \
	--$(call ptx/endis, PTXCONF_LIBCURL_FTP)-ftp \
	--$(call ptx/endis, PTXCONF_LIBCURL_FILE)-file \
	--disable-ipfs \
	--disable-ldap \
	--disable-ldaps \
	--$(call ptx/endis, PTXCONF_LIBCURL_RTSP)-rtsp \
	--enable-proxy \
	--disable-dict \
	--disable-telnet \
	--$(call ptx/endis, PTXCONF_LIBCURL_TFTP)-tftp \
	--disable-pop3 \
	--disable-imap \
	--disable-smb \
	--$(call ptx/endis, PTXCONF_LIBCURL_SMTP)-smtp \
	--disable-gopher \
	--disable-mqtt \
	--disable-manual \
	--disable-docs \
	--enable-libcurl-option \
	--disable-libgcc \
	$(GLOBAL_IPV6_OPTION) \
	--enable-openssl-auto-load-config \
	--disable-versioned-symbols \
	--disable-windows-unicode \
	--$(call ptx/disen, PTXCONF_LIBCURL_C_ARES)-threaded-resolver \
	--$(call ptx/endis, PTXCONF_LIBCURL_VERBOSE)-verbose \
	--disable-sspi \
	--enable-basic-auth \
	--$(call ptx/endis, PTXCONF_LIBCURL_CRYPTO_AUTH)-bearer-auth \
	--$(call ptx/endis, PTXCONF_LIBCURL_CRYPTO_AUTH)-digest-auth \
	--$(call ptx/endis, PTXCONF_LIBCURL_CRYPTO_AUTH)-kerberos-auth \
	--$(call ptx/endis, PTXCONF_LIBCURL_CRYPTO_AUTH)-negotiate-auth \
	--$(call ptx/endis, PTXCONF_LIBCURL_CRYPTO_AUTH)-aws \
	--$(call ptx/endis, PTXCONF_LIBCURL_CRYPTO_AUTH)-ntlm \
	--enable-tls-srp \
	--enable-unix-sockets \
	--$(call ptx/endis, PTXCONF_LIBCURL_COOKIES)-cookies \
	--enable-socketpair \
	--$(call ptx/endis, PTXCONF_LIBCURL_HTTP)-http-auth \
	--disable-doh \
	--$(call ptx/endis, PTXCONF_LIBCURL_MIME)-mime \
	--enable-bindlocal \
	--$(call ptx/endis, PTXCONF_LIBCURL_MIME)-form-api \
	--enable-dateparse \
	--enable-netrc \
	--enable-progress-meter \
	--enable-sha512-256 \
	--disable-dnsshuffle \
	--enable-get-easy-options \
	--disable-alt-svc \
	--disable-headers-api \
	--enable-hsts \
	--disable-websockets \
	--without-schannel \
	--without-secure-transport \
	--without-amissl \
	--$(call ptx/wwo,PTXCONF_LIBCURL_SSL)-ssl \
	--with-openssl=$(call ptx/ifdef, PTXCONF_LIBCURL_SSL_OPENSSL,$(SYSROOT)/usr,no) \
	--with-gnutls=$(call ptx/ifdef, PTXCONF_LIBCURL_SSL_GNUTLS,$(SYSROOT)/usr,no) \
	--without-mbedtls \
	--without-wolfssl \
	--without-bearssl \
	--without-rustls \
	--with-zlib=$(SYSROOT) \
	--without-brotli \
	--without-zstd \
	--without-gssapi \
	--with-default-ssl-backend=$(PTXCONF_LIBCURL_SSL_DEFAULT_BACKEND) \
	--with-ca-bundle=$(PTXCONF_LIBCURL_SSL_CABUNDLE_PATH) \
	--with-ca-path=$(PTXCONF_LIBCURL_SSL_CAPATH_PATH) \
	--without-ca-fallback \
	--without-libpsl \
	--without-libgsasl \
	--$(call ptx/wwo, PTXCONF_LIBCURL_LIBSSH2)-libssh2 \
	--without-libssh \
	--without-wolfssh \
	--without-librtmp \
	--without-winidn \
	--without-apple-idn \
	--without-libidn2 \
	--without-nghttp2 \
	--without-ngtcp2 \
	--without-openssl-quic \
	--without-nghttp3 \
	--without-quiche \
	--without-msh3 \
	--without-zsh-functions-dir \
	--without-fish-functions-dir

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libcurl.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libcurl)
	@$(call install_fixup, libcurl,PRIORITY,optional)
	@$(call install_fixup, libcurl,SECTION,base)
	@$(call install_fixup, libcurl,AUTHOR,"Daniel Schnell <daniel.schnell@marel.com>")
	@$(call install_fixup, libcurl,DESCRIPTION,missing)

ifdef PTXCONF_LIBCURL_CURL
	@$(call install_copy, libcurl, 0, 0, 0755, -, /usr/bin/curl)
endif
	@$(call install_lib, libcurl, 0, 0, 0644, libcurl)

	@$(call install_finish, libcurl)

	@$(call touch)

# vim: syntax=make
