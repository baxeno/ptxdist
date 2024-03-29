AC_PREREQ(2.69)

# TODO add useful information about this package
AC_INIT([@name@], 0.0.0, [bugs@yourdomain.to], [@name@], [http://www.yourdomain.to/])
AC_CONFIG_SRCDIR([@name@.c])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])
AC_CANONICAL_BUILD
AC_CANONICAL_HOST

# default is less output while building the package
AM_SILENT_RULES([yes])

# TODO If you don't want the default installation path to be '/usr/local' change it here
# AC_PREFIX_DEFAULT(<new prefix>)

# If possible, enable extensions to Posix
AC_USE_SYSTEM_EXTENSIONS

# support LFS
AC_SYS_LARGEFILE

AM_MAINTAINER_MODE
AM_INIT_AUTOMAKE([foreign no-exeext dist-xz silent-rules subdir-objects])

#
# Checks for programs.
#
AC_PROG_CC_C99

#
# Using additional preprocessor, compiler or linker flags:
# - add them to AM_CPPFLAGS, AM_CFLAGS or AM_LDFLAGS if they should be used
#   by all source files
# - give the user a chance to setup her/his own flags with the CPPFLAGS, CFLAGS
#   and LDFLAGS
# - if some flags are specific to a file add the flags via the substitute macro
#   into the Makefile
#
# Don't add the "-g" to the CFLAGS variable. It will be done automatically if
# autoconf detects a GNU compiler.
#

#
# Please note: 'configure' defaults the CFLAGS to "-O2 -g" if it detects a
# GCC. If the user overwrites the CFLAGS externally, there will be no default!
# Keep the user informed about this behaviour.

#
# TODO Check here for mandatory external libraries
#
# Rule of thumb: when your library needs an external library, add it
# to the 'LIBS' variable. Do _not_ add it manually into the Makefile.am files.
# These libraries _must_ be listed in the *.pc file.
#
# Don't add libraries without a check. Even if you know the 'sqrt()' requires
# 'libm' on most systems, check for its real need with 'AC_SEARCH_LIBS(sqrt, m)'.
# Doing it in this way will ensure an embedded developer knows exactly what
# dependencies your library has (because it gets listed in the *.pc file).
#
# Another way for checking libraries is the PKG_CHECK_MODULES macro. But please
# honor if a user switches off a feature you also switch of the test for a
# external component via PKG_CHECK_MODULES when it is no longer required!
# PKG_CHECK_MODULES returns *_CFLAGS and *_LIBS. Again, add the *_LIBS to the
# global 'LIBS', but for the CFLAGS you can decide if you add them to the
# CFLAGS, AM_CFLAGS or as substitution variables in the Makefile.am.

#REQUIRES_LIBSOMETHING="libsomething >= 20090402-1"
#AC_SUBST(REQUIRES_LIBSOMETHING)
#PKG_CHECK_MODULES(libsomething, $REQUIRES_LIBSOMETHING)

#
# TODO Check for functions and header files. First write your code and then run
# the 'autoscan' tool to get an idea what is still missing in your 'configure.ac'
#

PTX_COMMON_CHECKS
PTX_APPLICATION_CHECKS

# ---------------------------------------------------------------------------

# TODO Checking if this CPU has a hardware floating point unit

#AX_HARDWARE_FP([target_hardware_fp=yes], [target_hardware_fp=no])

# When a hardware floating point unit seems available, then use it.
# This will end in bad code on badly configured compilers which generates
# floating point instructions even if the CPU has not hardware FP unit
#
#AS_IF([test x${target_hardware_fp} = "xyes"],
#	[AC_MSG_NOTICE([FPU available])],
#	[AC_MSG_NOTICE([FPU not available])])

# ---------------------------------------------------------------------------

# TODO discover on demand the special architecture this compiler builds code
# for. This can be useful if the package provides some optimized code for
# specific architectures.

#AS_IF([test x${host_cpu} = "xarm"],
#	[AX_DETECT_ARMV5([enable_arm5=yes], [enable_arm5=no])
#	AX_DETECT_ARMV6([enable_arm6=yes], [enable_arm6=no])
#	AX_DETECT_ARMV7([enable_arm7=yes], [enable_arm7=no])
#	AX_DETECT_ARMV8([enable_arm8=yes], [enable_arm8=no])
#
#	AS_IF([test x${enable_arm4} = "xyes"], [AC_MSG_NOTICE([ARMv4 target])])
#	AS_IF([test x${enable_arm5} = "xyes"], [AC_MSG_NOTICE([ARMv5 target])])
#	AS_IF([test x${enable_arm6} = "xyes"], [AC_MSG_NOTICE([ARMv6 target])])
#	AS_IF([test x${enable_arm7} = "xyes"], [AC_MSG_NOTICE([ARMv7 target])])
#	AS_IF([test x${enable_arm8} = "xyes"], [AC_MSG_NOTICE([ARMv8 target])])])

# -------------------------- use all the settings ----------------------------

# substitute the settings valid for all source files
AC_SUBST(AM_CFLAGS)
AC_SUBST(AM_CPPFLAGS)
AC_SUBST(AM_LDFLAGS)

# add private libs to the pkg-config file
# 'private libs' are those required to link this library
# its used later on if someone wants to link this library statically
AC_SUBST(LIBS)

# add required lib information to the pkg-config file (on demand)
AC_SUBST(REQUIRES)

# add lib information which may conflict with this libarry
AC_SUBST(CONFLICTS)

# add special compile flags on demand
AC_SUBST(PRIVATE_CFLAGS)

# be very silent on request
AM_CONDITIONAL(BUILD_SILENTLY, test "x$AM_DEFAULT_VERBOSITY" = x0)

AC_CONFIG_FILES([
	Makefile
])
AC_OUTPUT

AC_MSG_RESULT([
	------------------------------------------------------
	Configure results for: ${PACKAGE}
	------------------------------------------------------

	Release State:
	------------------------------------------------------
	 Package release:	${VERSION}

	General:
	------------------------------------------------------
	 Cross compiling:	${cross_compiling}
	 Compiler:		${CC}
	 Target CPU:		${host_cpu}
	 Target OS:		${host_os}

	User options:
	------------------------------------------------------
	 CFLAGS:		${CFLAGS}
	 CPPFLAGS:		${CPPFLAGS}
	 LDFLAGS:		${LDFLAGS}

	Detected options:
	------------------------------------------------------
	 Debug:			${enable_debug}
	 Coverage:		${enable_code_coverage}
		CPPFLAGS:	${CODE_COVERAGE_CPPFLAGS}
		CFLAGS:		${CODE_COVERAGE_CFLAGS}
		LDFLAGS:	${CODE_COVERAGE_LDFLAGS}
	 Profiling:		${enable_profile}
	 Optimisation goal:	${with_goal}
	 Private libs:		${LIBS}
	 Use abort():		${enable_abort}

	Install options:
	------------------------------------------------------
	 prefix:		${prefix}
	 sysconfdir:		${sysconfdir}
	 libdir:		${libdir}
	 includedir:		${includedir}
	 bindir:		${bindir}
])
