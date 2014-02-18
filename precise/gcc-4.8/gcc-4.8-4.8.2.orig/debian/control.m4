divert(-1)

define(`checkdef',`ifdef($1, , `errprint(`error: undefined macro $1
')m4exit(1)')')
define(`errexit',`errprint(`error: undefined macro `$1'
')m4exit(1)')

dnl The following macros must be defined, when called:
dnl ifdef(`SRCNAME',	, errexit(`SRCNAME'))
dnl ifdef(`PV',		, errexit(`PV'))
dnl ifdef(`ARCH',		, errexit(`ARCH'))

dnl The architecture will also be defined (-D__i386__, -D__powerpc__, etc.)

define(`PN', `$1')
ifdef(`PRI', `', `
    define(`PRI', `$1')
')
define(`MAINTAINER', `Debian GCC Maintainers <debian-gcc@lists.debian.org>')

define(`depifenabled', `ifelse(index(enabled_languages, `$1'), -1, `', `$2')')
define(`ifenabled', `ifelse(index(enabled_languages, `$1'), -1, `dnl', `$2')')

define(`CROSS_ARCH', ifdef(`CROSS_ARCH', CROSS_ARCH, `all'))
define(`libdep', `lib$2$1`'LS`'AQ (ifelse(`$3',`',`>=',`$3') ifelse(`$4',`',`${gcc:Version}',`$4'))')
define(`libdevdep', `lib$2$1`'LS`'AQ (ifelse(`$3',`',`=',`$3') ifelse(`$4',`',`${gcc:Version}',`$4'))')
define(`libdbgdep', `lib$2$1`'LS`'AQ (ifelse(`$3',`',`>=',`$3') ifelse(`$4',`',`${gcc:Version}',`$4'))')

define(`BUILT_USING', ifelse(add_built_using,yes,`Built-Using: ${Built-Using}
'))

divert`'dnl
dnl --------------------------------------------------------------------------
Source: SRCNAME
Section: devel
Priority: PRI(optional)
Maintainer: ABE Hiroki (hATrayflood) <h.rayflood@gmail.com>
Standards-Version: 3.9.4
ifdef(`TARGET',`dnl cross
Build-Depends: debhelper (>= 5.0.62),
  LIBC_BUILD_DEP, LIBC_BIARCH_BUILD_DEP
  LIBUNWIND_BUILD_DEP LIBATOMIC_OPS_BUILD_DEP AUTOGEN_BUILD_DEP AUTO_BUILD_DEP
  SOURCE_BUILD_DEP CROSS_BUILD_DEP
  CLOOG_BUILD_DEP MPC_BUILD_DEP MPFR_BUILD_DEP GMP_BUILD_DEP,
  zlib1g-dev, gawk, lzma, xz-utils, patchutils,
  bison (>= 1:2.3), flex, realpath (>= 1.9.12), lsb-release, quilt
',`dnl native
Build-Depends: debhelper (>= 5.0.62), GCC_MULTILIB_BUILD_DEP
  LIBC_BUILD_DEP, LIBC_BIARCH_BUILD_DEP LIBC_DBG_DEP
  kfreebsd-kernel-headers (>= 0.84) [kfreebsd-any],
  AUTO_BUILD_DEP AUTOGEN_BUILD_DEP
  libunwind7-dev (>= 0.98.5-6) [ia64], libatomic-ops-dev [ia64],
  zlib1g-dev, gawk, lzma, xz-utils, patchutils,
  BINUTILS_BUILD_DEP, binutils-hppa64 (>= BINUTILSBDV) [hppa],
  gperf (>= 3.0.1), bison (>= 1:2.3), flex, gettext,
  texinfo (>= 4.3), locales, sharutils,
  procps, FORTRAN_BUILD_DEP JAVA_BUILD_DEP GNAT_BUILD_DEP GO_BUILD_DEP GDC_BUILD_DEP
  CLOOG_BUILD_DEP MPC_BUILD_DEP MPFR_BUILD_DEP GMP_BUILD_DEP
  CHECK_BUILD_DEP realpath (>= 1.9.12), chrpath, lsb-release, quilt
Build-Depends-Indep: LIBSTDCXX_BUILD_INDEP JAVA_BUILD_INDEP
')dnl
Homepage: https://launchpad.net/~h-rayflood/+archive/gcc-upper
XS-Vcs-Browser: https://github.com/hATrayflood/gcc-ppa

ifelse(regexp(SRCNAME, `gcc-snapshot'),0,`dnl
Package: gcc-snapshot`'TS
Architecture: any
Section: devel
Priority: extra
Depends: binutils`'TS (>= ${binutils:Version}), ${dep:libcbiarchdev}, ${dep:libcdev}, ${dep:libunwinddev}, ${snap:depends}, ${shlibs:Depends}, ${dep:ecj}, python, ${misc:Depends}
Recommends: ${snap:recommends}
Suggests: ${dep:gold}
Provides: c++-compiler`'TS`'ifdef(`TARGET',`',`, c++abi2-dev')
BUILT_USING`'dnl
Description: A SNAPSHOT of the GNU Compiler Collection
 This package contains a recent development SNAPSHOT of all files
 contained in the GNU Compiler Collection (GCC).
 .
 The source code for this package has been exported from SVN trunk.
 .
 DO NOT USE THIS SNAPSHOT FOR BUILDING DEBIAN PACKAGES!
 .
 This package will NEVER hit the testing distribution. It is used for
 tracking gcc bugs submitted to the Debian BTS in recent development
 versions of gcc.
',`dnl gcc-X.Y

dnl default base package dependencies
define(`BASETARGET', `')
define(`BASEDEP', `gcc`'PV-base (= ${gcc:Version})')
define(`SOFTBASEDEP', `gcc`'PV-base (>= ${gcc:SoftVersion})')

dnl base, when building libgcc out of the gcj source; needed if new symbols
dnl in libgcc are used in libgcj.
ifelse(index(SRCNAME, `gcj'), 0, `
define(`BASEDEP', `gcj`'PV-base (= ${gcj:Version})')
define(`SOFTBASEDEP', `gcj`'PV-base (>= ${gcj:SoftVersion})')
')

ifelse(index(SRCNAME, `gnat'), 0, `
define(`BASEDEP', `gnat`'PV-base (= ${gnat:Version})')
define(`SOFTBASEDEP', `gnat`'PV-base (>= ${gnat:SoftVersion})')
')

ifdef(`TARGET', `', `
ifenabled(`gccbase',`

Package: gcc`'PV-base
Architecture: any
ifdef(`MULTIARCH', `Multi-Arch: same
')`'dnl
Section: libs
Priority: PRI(required)
Depends: ${misc:Depends}
Replaces: ${base:Replaces}
Breaks: gcc-4.4-base (<< 4.4.7), gcj-4.4-base (<< 4.4.6-9~), gnat-4.4-base (<< 4.4.6-3~), gcj-4.6-base (<< 4.6.1-4~), gnat-4.6 (<< 4.6.1-5~), gcc-4.7-base (<< 4.7.3), dehydra (<= 0.9.hg20110609-2)
BUILT_USING`'dnl
Description: GCC, the GNU Compiler Collection (base package)
 This package contains files common to all languages and libraries
 contained in the GNU Compiler Collection (GCC).
ifdef(`BASE_ONLY', `dnl
 .
 This version of GCC is not yet available for this architecture.
 Please use the compilers from the gcc-snapshot package for testing.
')`'dnl
')`'dnl
')`'dnl native

ifenabled(`gccxbase',`
dnl override default base package dependencies to cross version
dnl This creates a toolchain that doesnt depend on the system -base packages
define(`BASETARGET', `PV`'TS')
define(`BASEDEP', `gcc`'BASETARGET-base (= ${gcc:Version})')
define(`SOFTBASEDEP', `gcc`'BASETARGET-base (>= ${gcc:SoftVersion})')

Package: gcc`'BASETARGET-base
Architecture: any
Section: devel
Priority: PRI(extra)
Depends: ${misc:Depends}
BUILT_USING`'dnl
Description: GCC, the GNU Compiler Collection (base package)
 This package contains files common to all languages and libraries
 contained in the GNU Compiler Collection (GCC).
')`'dnl

ifenabled(`java',`
ifdef(`TARGET', `', `
ifenabled(`gcjbase',`
Package: gcj`'PV-base
Architecture: any
ifdef(`MULTIARCH', `Multi-Arch: same
')`'dnl
Section: libs
Priority: PRI(optional)
Depends: ${misc:Depends}
BUILT_USING`'dnl
Description: GCC, the GNU Compiler Collection (gcj base package)
 This package contains files common to all java related packages
 built from the GNU Compiler Collection (GCC).
')`'dnl gccbase
')`'dnl native

ifenabled(`gcjxbase',`
dnl override default base package dependencies to cross version
dnl This creates a toolchain that doesnt depend on the system -base packages
define(`BASETARGET', `PV`'TS')
define(`BASEDEP', `gcj`'BASETARGET-base (= ${gcc:Version})')
define(`SOFTBASEDEP', `gcj`'BASETARGET-base (>= ${gcc:SoftVersion})')

Package: gcj`'BASETARGET-base
Architecture: any
Section: devel
Priority: PRI(extra)
Depends: ${misc:Depends}
BUILT_USING`'dnl
Description: GCC, the GNU Compiler Collection (gcj base package)
 This package contains files common to all java related packages
 built from the GNU Compiler Collection (GCC).
')`'dnl
')`'dnl java

ifenabled(`ada',`
Package: gnat`'PV-base`'TS
Architecture: any
Section: libs
Priority: PRI(optional)
Depends: ${misc:Depends}
Breaks: gcc-4.6 (<< 4.6.1-8~)
BUILT_USING`'dnl
Description: GNU Ada compiler (common files)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 This package contains files common to all GNAT related packages.
')`'dnl ada

ifenabled(`libgcc',`
Package: libgcc1`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',required)
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libgcc1-TARGET-dcv1',
ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
Breaks: ${multiarch:breaks}
')`Provides: libgcc1-armel [armel], libgcc1-armhf [armhf]')
BUILT_USING`'dnl
Description: GCC support library`'ifdef(`TARGET)',` (TARGET)', `')
 Shared version of the support library, a library of internal subroutines
 that GCC uses to overcome shortcomings of particular machines, or
 special needs for some languages.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libgcc1-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gcc1,,=,${gcc:EpochVersion}), ${misc:Depends}
ifdef(`TARGET',`',`dnl
ifdef(`MULTIARCH',`Multi-Arch: same
')dnl
Provides: libgcc1-dbg-armel [armel], libgcc1-dbg-armhf [armhf]
')dnl
BUILT_USING`'dnl
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libgcc2`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`m68k')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',required)
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libgcc2-TARGET-dcv1
',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
Breaks: ${multiarch:breaks}
'))`'dnl
BUILT_USING`'dnl
Description: GCC support library`'ifdef(`TARGET)',` (TARGET)', `')
 Shared version of the support library, a library of internal subroutines
 that GCC uses to overcome shortcomings of particular machines, or
 special needs for some languages.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libgcc2-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`m68k')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gcc2,,=,${gcc:Version}), ${misc:Depends}
ifdef(`TARGET',`',ifdef(`MULTIARCH', `Multi-Arch: same
'))`'dnl
BUILT_USING`'dnl
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libgcc

ifenabled(`cdev',`
Package: libgcc`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Section: libdevel
Priority: optional
Recommends: ${dep:libcdev}
Depends: BASEDEP, ${dep:libgcc}, ${dep:libssp}, ${dep:libgomp}, ${dep:libitm}, ${dep:libatomic}, ${dep:libbtrace}, ${dep:libasan}, ${dep:libtsan}, ${dep:libqmath}, ${dep:libunwinddev}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`',ifdef(`MULTIARCH', `Multi-Arch: same
'))`'dnl
BUILT_USING`'dnl
Description: GCC support library (development files)
 This package contains the headers and static library files necessary for
 building C programs which use libgcc, libgomp, libquadmath, libssp or libitm.
')`'dnl libgcc

ifenabled(`lib4gcc',`
Package: libgcc4`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`hppa')
ifdef(`TARGET',`',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
Breaks: ${multiarch:breaks}
'))`'dnl
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',required)
Depends: ifdef(`STANDALONEJAVA',`gcj`'PV-base (>= ${gcj:Version})',`BASEDEP'), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC support library`'ifdef(`TARGET)',` (TARGET)', `')
 Shared version of the support library, a library of internal subroutines
 that GCC uses to overcome shortcomings of particular machines, or
 special needs for some languages.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libgcc4-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`hppa')
ifdef(`TARGET',`',ifdef(`MULTIARCH', `Multi-Arch: same
'))`'dnl
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gcc4,,=,${gcc:Version}), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl lib4gcc

ifenabled(`lib64gcc',`
Package: lib64gcc1`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${misc:Depends}
ifdef(`TARGET',`Provides: lib64gcc1-TARGET-dcv1
',`')`'dnl
Conflicts: libdep(gcc`'GCC_SO,,<=,1:3.3-0pre9)
BUILT_USING`'dnl
Description: GCC support library`'ifdef(`TARGET)',` (TARGET)', `') (64bit)
 Shared version of the support library, a library of internal subroutines
 that GCC uses to overcome shortcomings of particular machines, or
 special needs for some languages.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: lib64gcc1-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gcc1,64,=,${gcc:EpochVersion}), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl lib64gcc

ifenabled(`cdev',`
Package: lib64gcc`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: libdevel
Priority: optional
Recommends: ${dep:libcdev}
Depends: BASEDEP, ${dep:libgccbiarch}, ${dep:libsspbiarch}, ${dep:libgompbiarch}, ${dep:libitmbiarch}, ${dep:libatomicbiarch}, ${dep:libbtracebiarch}, ${dep:libasanbiarch}, ${dep:libtsanbiarch}, ${dep:libqmathbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC support library (64bit development files)
 This package contains the headers and static library files necessary for
 building C programs which use libgcc, libgomp, libquadmath, libssp or libitm.
')`'dnl cdev

ifenabled(`lib32gcc',`
Package: lib32gcc1`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: extra
Depends: BASEDEP, ${dep:libcbiarch}, ${misc:Depends}
Conflicts: ${confl:lib32}
ifdef(`TARGET',`Provides: lib32gcc1-TARGET-dcv1
',`')`'dnl
BUILT_USING`'dnl
Description: GCC support library (32 bit Version)
 Shared version of the support library, a library of internal subroutines
 that GCC uses to overcome shortcomings of particular machines, or
 special needs for some languages.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: lib32gcc1-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gcc1,32,=,${gcc:EpochVersion}), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl lib32gcc1

ifenabled(`cdev',`
Package: lib32gcc`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: libdevel
Priority: optional
Recommends: ${dep:libcdev}
Depends: BASEDEP, ${dep:libgccbiarch}, ${dep:libsspbiarch}, ${dep:libgompbiarch}, ${dep:libitmbiarch}, ${dep:libatomicbiarch}, ${dep:libbtracebiarch}, ${dep:libasanbiarch}, ${dep:libtsanbiarch}, ${dep:libqmathbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC support library (32 bit development files)
 This package contains the headers and static library files necessary for
 building C programs which use libgcc, libgomp, libquadmath, libssp or libitm.
')`'dnl cdev

ifenabled(`libneongcc',`
Package: libgcc1-neon`'LS
Architecture: NEON_ARCHS
Section: libs
Priority: extra
Depends: BASEDEP, libc6-neon`'LS, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC support library [neon optimized]
 Shared version of the support library, a library of internal subroutines
 that GCC uses to overcome shortcomings of particular machines, or
 special needs for some languages.
 .
 This set of libraries is optimized to use a NEON coprocessor, and will
 be selected instead when running under systems which have one.
')`'dnl libneongcc1

ifenabled(`libhfgcc',`
Package: libhfgcc1`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${misc:Depends}
ifdef(`TARGET',`Provides: libhfgcc1-TARGET-dcv1
',`Conflicts: libgcc1-armhf [biarchhf_archs]
')`'dnl
BUILT_USING`'dnl
Description: GCC support library`'ifdef(`TARGET)',` (TARGET)', `') (hard float ABI)
 Shared version of the support library, a library of internal subroutines
 that GCC uses to overcome shortcomings of particular machines, or
 special needs for some languages.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libhfgcc1-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gcc1,hf,=,${gcc:EpochVersion}), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgcc1-dbg-armhf [biarchhf_archs]')
BUILT_USING`'dnl
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libhfgcc

ifenabled(`cdev',`
ifenabled(`armml',`
Package: libhfgcc`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: libdevel
Priority: optional
Recommends: ${dep:libcdev}
Depends: BASEDEP, ${dep:libgccbiarch}, ${dep:libsspbiarch}, ${dep:libgompbiarch}, ${dep:libitmbiarch}, ${dep:libatomicbiarch}, ${dep:libbtracebiarch}, ${dep:libasanbiarch}, ${dep:libtsanbiarch}, ${dep:libqmathbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC support library (hard float ABI development files)
 This package contains the headers and static library files necessary for
 building C programs which use libgcc, libgomp, libquadmath, libssp or libitm.
')`'dnl armml
')`'dnl cdev

ifenabled(`libsfgcc',`
Package: libsfgcc1`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${misc:Depends}
ifdef(`TARGET',`Provides: libsfgcc1-TARGET-dcv1
',`Conflicts: libgcc1-armel [biarchsf_archs]
')`'dnl
BUILT_USING`'dnl
Description: GCC support library`'ifdef(`TARGET)',` (TARGET)', `') (soft float ABI)
 Shared version of the support library, a library of internal subroutines
 that GCC uses to overcome shortcomings of particular machines, or
 special needs for some languages.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libsfgcc1-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gcc1,sf,=,${gcc:EpochVersion}), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgcc1-dbg-armel [biarchsf_archs]')
BUILT_USING`'dnl
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libsfgcc

ifenabled(`cdev',`
ifenabled(`armml',`
Package: libsfgcc`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: libdevel
Priority: optional
Recommends: ${dep:libcdev}
Depends: BASEDEP, ${dep:libgccbiarch}, ${dep:libsspbiarch}, ${dep:libgompbiarch}, ${dep:libitmbiarch}, ${dep:libatomicbiarch}, ${dep:libbtracebiarch}, ${dep:libasanbiarch}, ${dep:libtsanbiarch}, ${dep:libqmathbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC support library (soft float ABI development files)
 This package contains the headers and static library files necessary for
 building C programs which use libgcc, libgomp, libquadmath, libssp or libitm.
')`'dnl armml
')`'dnl cdev

ifenabled(`libn32gcc',`
Package: libn32gcc1`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${misc:Depends}
Conflicts: libdep(gcc`'GCC_SO,,<=,1:3.3-0pre9)
ifdef(`TARGET',`Provides: libn32gcc1-TARGET-dcv1
',`')`'dnl
BUILT_USING`'dnl
Description: GCC support library`'ifdef(`TARGET)',` (TARGET)', `') (n32)
 Shared version of the support library, a library of internal subroutines
 that GCC uses to overcome shortcomings of particular machines, or
 special needs for some languages.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libn32gcc1-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gcc1,n32,=,${gcc:EpochVersion}), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libn32gcc

ifenabled(`cdev',`
Package: libn32gcc`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: libdevel
Priority: optional
Recommends: ${dep:libcdev}
Depends: BASEDEP, ${dep:libgccbiarch}, ${dep:libsspbiarch}, ${dep:libgompbiarch}, ${dep:libitmbiarch}, ${dep:libatomicbiarch}, ${dep:libbtracebiarch}, ${dep:libasanbiarch}, ${dep:libtsanbiarch}, ${dep:libqmathbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC support library (n32 development files)
 This package contains the headers and static library files necessary for
 building C programs which use libgcc, libgomp, libquadmath, libssp or libitm.
')`'dnl cdev

ifenabled(`libx32gcc',`
Package: libx32gcc1`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${misc:Depends}
ifdef(`TARGET',`Provides: libx32gcc1-TARGET-dcv1
',`')`'dnl
BUILT_USING`'dnl
Description: GCC support library`'ifdef(`TARGET)',` (TARGET)', `') (x32)
 Shared version of the support library, a library of internal subroutines
 that GCC uses to overcome shortcomings of particular machines, or
 special needs for some languages.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libx32gcc1-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gcc1,x32,=,${gcc:EpochVersion}), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libx32gcc

ifenabled(`cdev',`
ifenabled(`x32dev',`
Package: libx32gcc`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: libdevel
Priority: optional
Recommends: ${dep:libcdev}
Depends: BASEDEP, ${dep:libgccbiarch}, ${dep:libsspbiarch}, ${dep:libgompbiarch}, ${dep:libitmbiarch}, ${dep:libatomicbiarch}, ${dep:libbtracebiarch}, ${dep:libasanbiarch}, ${dep:libtsanbiarch}, ${dep:libqmathbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC support library (x32 development files)
 This package contains the headers and static library files necessary for
 building C programs which use libgcc, libgomp, libquadmath, libssp or libitm.
')`'dnl x32dev
')`'dnl cdev

ifdef(`TARGET', `', `
ifenabled(`libgmath',`
Package: libgccmath`'GCCMATH_SO`'LS
Architecture: i386
ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
')`'dnl
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC math support library
 Support library for GCC.

Package: lib32gccmath`'GCCMATH_SO`'LS
Architecture: amd64
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC math support library (32bit)
 Support library for GCC.

Package: lib64gccmath`'GCCMATH_SO`'LS
Architecture: i386
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC math support library (64bit)
 Support library for GCC.
')`'dnl
')`'dnl native

ifenabled(`cdev',`
Package: gcc`'PV`'TS
Architecture: any
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: cpp`'PV`'TS (= ${gcc:Version}),ifenabled(`gccbase',` BASEDEP,')
  binutils`'TS (>= ${binutils:Version}),
  depifenabled(`libgcc',`libdevdep(gcc`'PV-dev`',), ')${shlibs:Depends}, ${misc:Depends}
Recommends: ${dep:libcdev}
Suggests: ${gcc:multilib}, gcc`'PV-doc (>= ${gcc:SoftVersion}), gcc`'PV-locales (>= ${gcc:SoftVersion}), libdbgdep(gcc`'GCC_SO-dbg,,>=,${libgcc:Version}), libdbgdep(gomp`'GOMP_SO-dbg,), libdbgdep(itm`'ITM_SO-dbg,), libdbgdep(atomic`'ATOMIC_SO-dbg,), libdbgdep(asan`'ASAN_SO-dbg,), libdbgdep(tsan`'TSAN_SO-dbg,), libdbgdep(backtrace`'BTRACE_SO-dbg,), libdbgdep(quadmath`'QMATH_SO-dbg,), ${dep:libcloog}, ${dep:gold}
Provides: c-compiler`'TS
ifdef(`TARGET',`Conflicts: gcc-multilib
')`'dnl
BUILT_USING`'dnl
Description: GNU C compiler`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU C compiler, a fairly portable optimizing compiler for C.
ifdef(`TARGET', `dnl
 .
 This package contains C cross-compiler for TARGET architecture.
')`'dnl

ifenabled(`multilib',`
Package: gcc`'PV-multilib`'TS
Architecture: ifdef(`TARGET',`any',MULTILIB_ARCHS)
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gcc`'PV`'TS (= ${gcc:Version}), ${dep:libcbiarchdev}, ${dep:libgccbiarchdev}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GNU C compiler (multilib files)`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU C compiler, a fairly portable optimizing compiler for C.
 .
 On architectures with multilib support, the package contains files
 and dependencies for the non-default multilib architecture(s).
')`'dnl multilib

ifenabled(`plugindev',`
Package: gcc`'PV-plugin-dev`'TS
Architecture: any
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gcc`'PV`'TS (= ${gcc:Version}), GMP_BUILD_DEP ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Files for GNU GCC plugin development.
 This package contains (header) files for GNU GCC plugin development. It
 is only used for the development of GCC plugins, but not needed to run
 plugins.
')`'dnl plugindev
')`'dnl cdev

ifenabled(`cdev',`
Package: gcc`'PV-hppa64
Architecture: ifdef(`TARGET',`any',hppa)
Section: devel
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
Conflicts: gcc-3.3-hppa64 (<= 1:3.3.4-5), gcc-3.4-hppa64 (<= 3.4.1-3)
BUILT_USING`'dnl
Description: GNU C compiler (cross compiler for hppa64)
 This is the GNU C compiler, a fairly portable optimizing compiler for C.
')`'dnl cdev

ifenabled(`cdev',`
Package: cpp`'PV`'TS
Architecture: any
Section: ifdef(`TARGET',`devel',`interpreters')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
Suggests: gcc`'PV-locales (>= ${gcc:SoftVersion})
Replaces: gcc-4.6 (<< 4.6.1-9)
BUILT_USING`'dnl
Description: GNU C preprocessor
 A macro processor that is used automatically by the GNU C compiler
 to transform programs before actual compilation.
 .
 This package has been separated from gcc for the benefit of those who
 require the preprocessor but not the compiler.
ifdef(`TARGET', `dnl
 .
 This package contains preprocessor configured for TARGET architecture.
')`'dnl

ifdef(`TARGET', `', `
ifenabled(`gfdldoc',`
Package: cpp`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: gcc`'PV-base (>= ${gcc:SoftVersion}), dpkg (>= 1.15.4) | install-info, ${misc:Depends}
Description: Documentation for the GNU C preprocessor (cpp)
 Documentation for the GNU C preprocessor in info `format'.
')`'dnl gfdldoc
')`'dnl native

ifdef(`TARGET', `', `
Package: gcc`'PV-locales
Architecture: all
Section: devel
Priority: PRI(optional)
Depends: SOFTBASEDEP, cpp`'PV (>= ${gcc:SoftVersion}), ${misc:Depends}
Recommends: gcc`'PV (>= ${gcc:SoftVersion})
Description: GCC, the GNU compiler collection (native language support files)
 Native language support for GCC. Lets GCC speak your language,
 if translations are available.
 .
 Please do NOT submit bug reports in other languages than "C".
 Always reset your language settings to use the "C" locales.
')`'dnl native
')`'dnl cdev

ifenabled(`c++',`
ifenabled(`c++dev',`
Package: g++`'PV`'TS
Architecture: any
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gcc`'PV`'TS (= ${gcc:Version}), libdevdep(stdc++`'PV-dev,,=), ${shlibs:Depends}, ${misc:Depends}
Provides: c++-compiler`'TS`'ifdef(`TARGET)',`',`, c++abi2-dev')
Suggests: ${gxx:multilib}, gcc`'PV-doc (>= ${gcc:SoftVersion}), libdbgdep(stdc++CXX_SO`'PV-dbg,)
BUILT_USING`'dnl
Description: GNU C++ compiler`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU C++ compiler, a fairly portable optimizing compiler for C++.
ifdef(`TARGET', `dnl
 .
 This package contains C++ cross-compiler for TARGET architecture.
')`'dnl

ifenabled(`multilib',`
Package: g++`'PV-multilib`'TS
Architecture: ifdef(`TARGET',`any',MULTILIB_ARCHS)
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, g++`'PV`'TS (= ${gcc:Version}), gcc`'PV-multilib`'TS (= ${gcc:Version}), ${dep:libcxxbiarchdev}, ${shlibs:Depends}, ${misc:Depends}
Suggests: ${dep:libcxxbiarchdbg}
BUILT_USING`'dnl
Description: GNU C++ compiler (multilib files)`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU C++ compiler, a fairly portable optimizing compiler for C++.
 .
 On architectures with multilib support, the package contains files
 and dependencies for the non-default multilib architecture(s).
')`'dnl multilib
')`'dnl c++dev
')`'dnl c++

ifdef(`TARGET', `', `
ifenabled(`ssp',`
Package: libssp`'SSP_SO`'LS
Architecture: any
ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
')`'dnl
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC stack smashing protection library
 GCC can now emit code for protecting applications from stack-smashing attacks.
 The protection is realized by buffer overflow detection and reordering of
 stack variables to avoid pointer corruption.

Package: lib32ssp`'SSP_SO`'LS
Architecture: biarch32_archs
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Replaces: libssp0 (<< 4.1)
Conflicts: ${confl:lib32}
BUILT_USING`'dnl
Description: GCC stack smashing protection library (32bit)
 GCC can now emit code for protecting applications from stack-smashing attacks.
 The protection is realized by buffer overflow detection and reordering of
 stack variables to avoid pointer corruption.

Package: lib64ssp`'SSP_SO`'LS
Architecture: biarch64_archs
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Replaces: libssp0 (<< 4.1)
BUILT_USING`'dnl
Description: GCC stack smashing protection library (64bit)
 GCC can now emit code for protecting applications from stack-smashing attacks.
 The protection is realized by buffer overflow detection and reordering of
 stack variables to avoid pointer corruption.

Package: libn32ssp`'SSP_SO`'LS
Architecture: biarchn32_archs
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Replaces: libssp0 (<< 4.1)
BUILT_USING`'dnl
Description: GCC stack smashing protection library (n32)
 GCC can now emit code for protecting applications from stack-smashing attacks.
 The protection is realized by buffer overflow detection and reordering of
 stack variables to avoid pointer corruption.

Package: libx32ssp`'SSP_SO`'LS
Architecture: biarchx32_archs
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Replaces: libssp0 (<< 4.1)
BUILT_USING`'dnl
Description: GCC stack smashing protection library (x32)
 GCC can now emit code for protecting applications from stack-smashing attacks.
 The protection is realized by buffer overflow detection and reordering of
 stack variables to avoid pointer corruption.

Package: libhfssp`'SSP_SO`'LS
Architecture: biarchhf_archs
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC stack smashing protection library (hard float ABI)
 GCC can now emit code for protecting applications from stack-smashing attacks.
 The protection is realized by buffer overflow detection and reordering of
 stack variables to avoid pointer corruption.

Package: libsfssp`'SSP_SO`'LS
Architecture: biarchsf_archs
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC stack smashing protection library (soft float ABI)
 GCC can now emit code for protecting applications from stack-smashing attacks.
 The protection is realized by buffer overflow detection and reordering of
 stack variables to avoid pointer corruption.
')`'dnl
')`'dnl native

ifenabled(`libgomp',`
Package: libgomp`'GOMP_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
Breaks: ${multiarch:breaks}
')`Provides: libgomp'GOMP_SO`-armel [armel], libgomp'GOMP_SO`-armhf [armhf]')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: libgomp`'GOMP_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gomp`'GOMP_SO,,=), ${misc:Depends}
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
')`Provides: libgomp'GOMP_SO`-dbg-armel [armel], libgomp'GOMP_SO`-dbg-armhf [armhf]')
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library (debug symbols)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: lib32gomp`'GOMP_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library (32bit)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: lib32gomp`'GOMP_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gomp`'GOMP_SO,32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library (32 bit debug symbols)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: lib64gomp`'GOMP_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library (64bit)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: lib64gomp`'GOMP_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gomp`'GOMP_SO,64,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library (64bit debug symbols)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: libn32gomp`'GOMP_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library (n32)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: libn32gomp`'GOMP_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gomp`'GOMP_SO,n32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library (n32 debug symbols)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers

ifenabled(`libx32gomp',`
Package: libx32gomp`'GOMP_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library (x32)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: libx32gomp`'GOMP_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gomp`'GOMP_SO,x32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library (x32 debug symbols)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
')`'dnl libx32gomp

ifenabled(`libhfgomp',`
Package: libhfgomp`'GOMP_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgomp'GOMP_SO`-armhf [biarchhf_archs]')
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library (hard float ABI)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: libhfgomp`'GOMP_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gomp`'GOMP_SO,hf,=), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgomp'GOMP_SO`-dbg-armhf [biarchhf_archs]')
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library (hard float ABI debug symbols)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
')`'dnl libhfgomp

ifenabled(`libsfgomp',`
Package: libsfgomp`'GOMP_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgomp'GOMP_SO`-armel [biarchsf_archs]')
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library (soft float ABI)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: libsfgomp`'GOMP_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(gomp`'GOMP_SO,sf,=), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgomp'GOMP_SO`-dbg-armel [biarchsf_archs]')
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library (soft float ABI debug symbols)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
')`'dnl libsfgomp

ifenabled(`libneongomp',`
Package: libgomp`'GOMP_SO-neon`'LS
Architecture: NEON_ARCHS
Section: libs
Priority: extra
Depends: BASEDEP, libc6-neon`'LS, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC OpenMP (GOMP) support library [neon optimized]
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.
 .
 This set of libraries is optimized to use a NEON coprocessor, and will
 be selected instead when running under systems which have one.
')`'dnl libneongomp
')`'dnl libgomp

ifenabled(`libitm',`
Package: libitm`'ITM_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
')`Provides: libitm'ITM_SO`-armel [armel], libitm'ITM_SO`-armhf [armhf]')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Transactional Memory Library
 GNU Transactional Memory Library (libitm) provides transaction support for
 accesses to the memory of a process, enabling easy-to-use synchronization of
 accesses to shared memory by several threads.

Package: libitm`'ITM_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(itm`'ITM_SO,,=), ${misc:Depends}
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
')`Provides: libitm'ITM_SO`-dbg-armel [armel], libitm'ITM_SO`-dbg-armhf [armhf]')
BUILT_USING`'dnl
Description: GNU Transactional Memory Library (debug symbols)
 GNU Transactional Memory Library (libitm) provides transaction support for
 accesses to the memory of a process, enabling easy-to-use synchronization of
 accesses to shared memory by several threads.

Package: lib32itm`'ITM_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
BUILT_USING`'dnl
Description: GNU Transactional Memory Library (32bit)
 GNU Transactional Memory Library (libitm) provides transaction support for
 accesses to the memory of a process, enabling easy-to-use synchronization of
 accesses to shared memory by several threads.

Package: lib32itm`'ITM_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(itm`'ITM_SO,32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Transactional Memory Library (32 bit debug symbols)
 GNU Transactional Memory Library (libitm) provides transaction support for
 accesses to the memory of a process, enabling easy-to-use synchronization of
 accesses to shared memory by several threads.

Package: lib64itm`'ITM_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Transactional Memory Library (64bit)
 GNU Transactional Memory Library (libitm) provides transaction support for
 accesses to the memory of a process, enabling easy-to-use synchronization of
 accesses to shared memory by several threads.

Package: lib64itm`'ITM_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(itm`'ITM_SO,64,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Transactional Memory Library (64bit debug symbols)
 GNU Transactional Memory Library (libitm) provides transaction support for
 accesses to the memory of a process, enabling easy-to-use synchronization of
 accesses to shared memory by several threads.

Package: libn32itm`'ITM_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Transactional Memory Library (n32)
 GNU Transactional Memory Library (libitm) provides transaction support for
 accesses to the memory of a process, enabling easy-to-use synchronization of
 accesses to shared memory by several threads.

Package: libn32itm`'ITM_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(itm`'ITM_SO,n32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Transactional Memory Library (n32 debug symbols)
 GNU Transactional Memory Library (libitm) provides transaction support for
 accesses to the memory of a process, enabling easy-to-use synchronization of
 accesses to shared memory by several threads.

ifenabled(`libx32itm',`
Package: libx32itm`'ITM_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Transactional Memory Library (x32)
 This manual documents the usage and internals of libitm. It provides
 transaction support for accesses to the memory of a process, enabling
 easy-to-use synchronization of accesses to shared memory by several threads.

Package: libx32itm`'ITM_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(itm`'ITM_SO,x32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Transactional Memory Library (x32 debug symbols)
 This manual documents the usage and internals of libitm. It provides
 transaction support for accesses to the memory of a process, enabling
 easy-to-use synchronization of accesses to shared memory by several threads.
')`'dnl libx32itm

ifenabled(`libhfitm',`
Package: libhfitm`'ITM_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libitm'ITM_SO`-armhf [biarchhf_archs]')
BUILT_USING`'dnl
Description: GNU Transactional Memory Library (hard float ABI)
 GNU Transactional Memory Library (libitm) provides transaction support for
 accesses to the memory of a process, enabling easy-to-use synchronization of
 accesses to shared memory by several threads.

Package: libhfitm`'ITM_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(itm`'ITM_SO,hf,=), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libitm'ITM_SO`-armel [biarchsf_archs]')
BUILT_USING`'dnl
Description: GNU Transactional Memory Library (hard float ABI debug symbols)
 GNU Transactional Memory Library (libitm) provides transaction support for
 accesses to the memory of a process, enabling easy-to-use synchronization of
 accesses to shared memory by several threads.
')`'dnl libhfitm

ifenabled(`libsfitm',`
Package: libsfitm`'ITM_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Transactional Memory Library (soft float ABI)
 GNU Transactional Memory Library (libitm) provides transaction support for
 accesses to the memory of a process, enabling easy-to-use synchronization of
 accesses to shared memory by several threads.

Package: libsfitm`'ITM_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(itm`'ITM_SO,sf,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Transactional Memory Library (soft float ABI debug symbols)
 GNU Transactional Memory Library (libitm) provides transaction support for
 accesses to the memory of a process, enabling easy-to-use synchronization of
 accesses to shared memory by several threads.
')`'dnl libsfitm

ifenabled(`libneonitm',`
Package: libitm`'ITM_SO-neon`'LS
Architecture: NEON_ARCHS
Section: libs
Priority: extra
Depends: BASEDEP, libc6-neon`'LS, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Transactional Memory Library [neon optimized]
 GNU Transactional Memory Library (libitm) provides transaction support for
 accesses to the memory of a process, enabling easy-to-use synchronization of
 accesses to shared memory by several threads.
 .
 This set of libraries is optimized to use a NEON coprocessor, and will
 be selected instead when running under systems which have one.
')`'dnl libneonitm
')`'dnl libitm

ifenabled(`libatomic',`
Package: libatomic`'ATOMIC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
')`Provides: libatomic'ATOMIC_SO`-armel [armel], libatomic'ATOMIC_SO`-armhf [armhf]')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.

Package: libatomic`'ATOMIC_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(atomic`'ATOMIC_SO,,=), ${misc:Depends}
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
')`Provides: libatomic'ATOMIC_SO`-dbg-armel [armel], libatomic'ATOMIC_SO`-dbg-armhf [armhf]')
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions (debug symbols)
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.

Package: lib32atomic`'ATOMIC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions (32bit)
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.

Package: lib32atomic`'ATOMIC_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(atomic`'ATOMIC_SO,32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions (32 bit debug symbols)
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.

Package: lib64atomic`'ATOMIC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions (64bit)
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.

Package: lib64atomic`'ATOMIC_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(atomic`'ATOMIC_SO,64,=), ${misc:Depends}
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions (64bit debug symbols)
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.

Package: libn32atomic`'ATOMIC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions (n32)
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.

Package: libn32atomic`'ATOMIC_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(atomic`'ATOMIC_SO,n32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions (n32 debug symbols)
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.

ifenabled(`libx32atomic',`
Package: libx32atomic`'ATOMIC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions (x32)
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.

Package: libx32atomic`'ATOMIC_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(atomic`'ATOMIC_SO,x32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions (x32 debug symbols)
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.
')`'dnl libx32atomic

ifenabled(`libhfatomic',`
Package: libhfatomic`'ATOMIC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libatomic'ATOMIC_SO`-armhf [biarchhf_archs]')
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions (hard float ABI)
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.

Package: libhfatomic`'ATOMIC_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(atomic`'ATOMIC_SO,hf,=), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libatomic'ATOMIC_SO`-armel [biarchsf_archs]')
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions (hard float ABI debug symbols)
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.
')`'dnl libhfatomic

ifenabled(`libsfatomic',`
Package: libsfatomic`'ATOMIC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions (soft float ABI)
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.

Package: libsfatomic`'ATOMIC_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(atomic`'ATOMIC_SO,sf,=), ${misc:Depends}
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions (soft float ABI debug symbols)
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.
')`'dnl libsfatomic

ifenabled(`libneonatomic',`
Package: libatomic`'ATOMIC_SO-neon`'LS
Architecture: NEON_ARCHS
Section: libs
Priority: extra
Depends: BASEDEP, libc6-neon`'LS, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: support library providing __atomic built-in functions [neon optimized]
 library providing __atomic built-in functions. When an atomic call cannot
 be turned into lock-free instructions, GCC will make calls into this library.
 .
 This set of libraries is optimized to use a NEON coprocessor, and will
 be selected instead when running under systems which have one.
')`'dnl libneonatomic
')`'dnl libatomic

ifenabled(`libasan',`
Package: libasan`'ASAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
')`Provides: libasan'ASAN_SO`-armel [armel], libasan'ASAN_SO`-armhf [armhf]')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.

Package: libasan`'ASAN_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(asan`'ASAN_SO,,=), ${misc:Depends}
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
')`Provides: libasan'ASAN_SO`-dbg-armel [armel], libasan'ASAN_SO`-dbg-armhf [armhf]')
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector (debug symbols)
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.

Package: lib32asan`'ASAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector (32bit)
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.

Package: lib32asan`'ASAN_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(asan`'ASAN_SO,32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector (32 bit debug symbols)
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.

Package: lib64asan`'ASAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector (64bit)
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.

Package: lib64asan`'ASAN_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(asan`'ASAN_SO,64,=), ${misc:Depends}
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector (64bit debug symbols)
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.

Package: libn32asan`'ASAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(extra)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector (n32)
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.

Package: libn32asan`'ASAN_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(asan`'ASAN_SO,n32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector (n32 debug symbols)
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.

ifenabled(`libx32asan',`
Package: libx32asan`'ASAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector (x32)
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.

Package: libx32asan`'ASAN_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(asan`'ASAN_SO,x32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector (x32 debug symbols)
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.
')`'dnl libx32asan

ifenabled(`libhfasan',`
Package: libhfasan`'ASAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(extra)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libasan'ASAN_SO`-armhf [biarchhf_archs]')
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector (hard float ABI)
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.

Package: libhfasan`'ASAN_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(asan`'ASAN_SO,hf,=), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libasan'ASAN_SO`-armel [biarchsf_archs]')
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector (hard float ABI debug symbols)
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.
')`'dnl libhfasan

ifenabled(`libsfasan',`
Package: libsfasan`'ASAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(extra)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector (soft float ABI)
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.

Package: libsfasan`'ASAN_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(asan`'ASAN_SO,sf,=), ${misc:Depends}
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector (soft float ABI debug symbols)
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.
')`'dnl libsfasan

ifenabled(`libneonasan',`
Package: libasan`'ASAN_SO-neon`'LS
Architecture: NEON_ARCHS
Section: libs
Priority: extra
Depends: BASEDEP, libc6-neon`'LS, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: AddressSanitizer -- a fast memory error detector [neon optimized]
 AddressSanitizer (ASan) is a fast memory error detector.  It finds
 use-after-free and {heap,stack,global}-buffer overflow bugs in C/C++ programs.
 .
 This set of libraries is optimized to use a NEON coprocessor, and will
 be selected instead when running under systems which have one.
')`'dnl libneonasan
')`'dnl libasan

ifenabled(`libtsan',`
Package: libtsan`'TSAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
')`Provides: libtsan'TSAN_SO`-armel [armel], libtsan'TSAN_SO`-armhf [armhf]')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races (runtime)
 ThreadSanitizer (Tsan) is a data race detector for C/C++ programs. 
 The Linux and Mac versions are based on Valgrind. 

Package: libtsan`'TSAN_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(tsan`'TSAN_SO,,=), ${misc:Depends}
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
')`Provides: libtsan'TSAN_SO`-dbg-armel [armel], libtsan'TSAN_SO`-dbg-armhf [armhf]')
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races (debug symbols)
 ThreadSanitizer (Tsan) is a data race detector for C/C++ programs. 
 The Linux and Mac versions are based on Valgrind. 

ifenabled(`lib32tsan',`
Package: lib32tsan`'TSAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races (32bit)
 ThreadSanitizer (Tsan) is a data race detector for C/C++ programs. 
 The Linux and Mac versions are based on Valgrind. 

Package: lib32tsan`'TSAN_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(tsan`'TSAN_SO,32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races (32 bit debug symbols)
 ThreadSanitizer (Tsan) is a data race detector for C/C++ programs. 
 The Linux and Mac versions are based on Valgrind. 
')`'dnl lib32tsan

ifenabled(`lib64tsan',`
Package: lib64tsan`'TSAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races (64bit)
 ThreadSanitizer (Tsan) is a data race detector for C/C++ programs. 
 The Linux and Mac versions are based on Valgrind. 

Package: lib64tsan`'TSAN_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(tsan`'TSAN_SO,64,=), ${misc:Depends}
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races (64bit debug symbols)
 ThreadSanitizer (Tsan) is a data race detector for C/C++ programs. 
 The Linux and Mac versions are based on Valgrind. 
')`'dnl lib64tsan

ifenabled(`libn32tsan',`
Package: libn32tsan`'TSAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races (n32)
 ThreadSanitizer (Tsan) is a data race detector for C/C++ programs. 
 The Linux and Mac versions are based on Valgrind. 

Package: libn32tsan`'TSAN_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(tsan`'TSAN_SO,n32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races (n32 debug symbols)
 ThreadSanitizer (Tsan) is a data race detector for C/C++ programs. 
 The Linux and Mac versions are based on Valgrind. 
')`'dnl libn32tsan

ifenabled(`libx32tsan',`
Package: libx32tsan`'TSAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races (x32)
 ThreadSanitizer (Tsan) is a data race detector for C/C++ programs. 
 The Linux and Mac versions are based on Valgrind. 

Package: libx32tsan`'TSAN_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(tsan`'TSAN_SO,x32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races (x32 debug symbols)
 ThreadSanitizer (Tsan) is a data race detector for C/C++ programs. 
 The Linux and Mac versions are based on Valgrind. 
')`'dnl libx32tsan

ifenabled(`libhftsan',`
Package: libhftsan`'TSAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libtsan'TSAN_SO`-armhf [biarchhf_archs]')
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races (hard float ABI)
 ThreadSanitizer (Tsan) is a data race detector for C/C++ programs. 
 The Linux and Mac versions are based on Valgrind. 

Package: libhftsan`'TSAN_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(tsan`'TSAN_SO,hf,=), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libtsan'TSAN_SO`-armel [biarchsf_archs]')
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races (hard float ABI debug symbols)
')`'dnl libhftsan

ifenabled(`libsftsan',`
Package: libsftsan`'TSAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races (soft float ABI)
 ThreadSanitizer (Tsan) is a data race detector for C/C++ programs. 
 The Linux and Mac versions are based on Valgrind. 

Package: libsftsan`'TSAN_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(tsan`'TSAN_SO,sf,=), ${misc:Depends}
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races (soft float ABI debug symbols)
 ThreadSanitizer (Tsan) is a data race detector for C/C++ programs. 
 The Linux and Mac versions are based on Valgrind. 
')`'dnl libsftsan

ifenabled(`libneontsan',`
Package: libtsan`'TSAN_SO-neon`'LS
Architecture: NEON_ARCHS
Section: libs
Priority: extra
Depends: BASEDEP, libc6-neon`'LS, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: ThreadSanitizer -- a Valgrind-based detector of data races [neon optimized]
 ThreadSanitizer (Tsan) is a data race detector for C/C++ programs. 
 The Linux and Mac versions are based on Valgrind. 
 .
 This set of libraries is optimized to use a NEON coprocessor, and will
 be selected instead when running under systems which have one.
')`'dnl libneontsan
')`'dnl libtsan

ifenabled(`libbacktrace',`
Package: libbacktrace`'BTRACE_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
')`Provides: libbacktrace'BTRACE_SO`-armel [armel], libbacktrace'BTRACE_SO`-armhf [armhf]')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: stack backtrace library
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.

Package: libbacktrace`'BTRACE_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(backtrace`'BTRACE_SO,,=), ${misc:Depends}
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
')`Provides: libbacktrace'BTRACE_SO`-dbg-armel [armel], libbacktrace'BTRACE_SO`-dbg-armhf [armhf]')
BUILT_USING`'dnl
Description: stack backtrace library (debug symbols)
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.

Package: lib32backtrace`'BTRACE_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
BUILT_USING`'dnl
Description: stack backtrace library (32bit)
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.

Package: lib32backtrace`'BTRACE_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(backtrace`'BTRACE_SO,32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: stack backtrace library (32 bit debug symbols)
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.

Package: lib64backtrace`'BTRACE_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: stack backtrace library (64bit)
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.

Package: lib64backtrace`'BTRACE_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(backtrace`'BTRACE_SO,64,=), ${misc:Depends}
BUILT_USING`'dnl
Description: stack backtrace library (64bit debug symbols)
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.

Package: libn32backtrace`'BTRACE_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: stack backtrace library (n32)
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.

Package: libn32backtrace`'BTRACE_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(backtrace`'BTRACE_SO,n32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: stack backtrace library (n32 debug symbols)
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.

ifenabled(`libx32backtrace',`
Package: libx32backtrace`'BTRACE_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: stack backtrace library (x32)
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.

Package: libx32backtrace`'BTRACE_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(backtrace`'BTRACE_SO,x32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: stack backtrace library (x32 debug symbols)
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.
')`'dnl libx32backtrace

ifenabled(`libhfbacktrace',`
Package: libhfbacktrace`'BTRACE_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libbacktrace'BTRACE_SO`-armhf [biarchhf_archs]')
BUILT_USING`'dnl
Description: stack backtrace library (hard float ABI)
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.

Package: libhfbacktrace`'BTRACE_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(backtrace`'BTRACE_SO,hf,=), ${misc:Depends}
wifdef(`TARGET',`dnl',`Conflicts: libbacktrace'BTRACE_SO`-armel [biarchsf_archs]')
BUILT_USING`'dnl
Description: stack backtrace library (hard float ABI debug symbols)
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.
')`'dnl libhfbacktrace

ifenabled(`libsfbacktrace',`
Package: libsfbacktrace`'BTRACE_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: stack backtrace library (soft float ABI)
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.

Package: libsfbacktrace`'BTRACE_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(backtrace`'BTRACE_SO,sf,=), ${misc:Depends}
BUILT_USING`'dnl
Description: stack backtrace library (soft float ABI debug symbols)
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.
')`'dnl libsfbacktrace

ifenabled(`libneonbacktrace',`
Package: libbacktrace`'BTRACE_SO-neon`'LS
Architecture: NEON_ARCHS
Section: libs
Priority: extra
Depends: BASEDEP, libc6-neon`'LS, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: stack backtrace library [neon optimized]
 libbacktrace uses the GCC unwind interface to collect a stack trace,
 and parses DWARF debug info to get file/line/function information.
 .
 This set of libraries is optimized to use a NEON coprocessor, and will
 be selected instead when running under systems which have one.
')`'dnl libneonbacktrace
')`'dnl libbacktrace


ifenabled(`libqmath',`
Package: libquadmath`'QMATH_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
'))`'dnl
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC Quad-Precision Math Library
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype. The library is used to provide on such
 targets the REAL(16) type in the GNU Fortran compiler.

Package: libquadmath`'QMATH_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(quadmath`'QMATH_SO,,=), ${misc:Depends}
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
'))`'dnl
BUILT_USING`'dnl
Description: GCC Quad-Precision Math Library (debug symbols)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype.

Package: lib32quadmath`'QMATH_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
BUILT_USING`'dnl
Description: GCC Quad-Precision Math Library (32bit)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype. The library is used to provide on such
 targets the REAL(16) type in the GNU Fortran compiler.

Package: lib32quadmath`'QMATH_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(quadmath`'QMATH_SO,32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC Quad-Precision Math Library (32 bit debug symbols)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype.

Package: lib64quadmath`'QMATH_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC Quad-Precision Math Library  (64bit)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype. The library is used to provide on such
 targets the REAL(16) type in the GNU Fortran compiler.

Package: lib64quadmath`'QMATH_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(quadmath`'QMATH_SO,64,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC Quad-Precision Math Library  (64bit debug symbols)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype.

Package: libn32quadmath`'QMATH_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC Quad-Precision Math Library (n32)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype. The library is used to provide on such
 targets the REAL(16) type in the GNU Fortran compiler.

Package: libn32quadmath`'QMATH_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(quadmath`'QMATH_SO,n32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC Quad-Precision Math Library (n32 debug symbols)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype.

ifenabled(`libx32qmath',`
Package: libx32quadmath`'QMATH_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC Quad-Precision Math Library (x32)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype. The library is used to provide on such
 targets the REAL(16) type in the GNU Fortran compiler.

Package: libx32quadmath`'QMATH_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(quadmath`'QMATH_SO,x32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC Quad-Precision Math Library (x32 debug symbols)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype.
')`'dnl libx32qmath

ifenabled(`libhfqmath',`
Package: libhfquadmath`'QMATH_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC Quad-Precision Math Library (hard float ABI)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype. The library is used to provide on such
 targets the REAL(16) type in the GNU Fortran compiler.

Package: libhfquadmath`'QMATH_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(quadmath`'QMATH_SO,hf,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC Quad-Precision Math Library (hard float ABI debug symbols)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype.
')`'dnl libhfqmath

ifenabled(`libsfqmath',`
Package: libsfquadmath`'QMATH_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GCC Quad-Precision Math Library (soft float ABI)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype. The library is used to provide on such
 targets the REAL(16) type in the GNU Fortran compiler.

Package: libsfquadmath`'QMATH_SO-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(quadmath`'QMATH_SO,sf,=), ${misc:Depends}
BUILT_USING`'dnl
Description: GCC Quad-Precision Math Library (hard float ABI debug symbols)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype.
')`'dnl libsfqmath
')`'dnl libqmath

ifenabled(`objpp',`
ifenabled(`objppdev',`
Package: gobjc++`'PV`'TS
Architecture: any
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gobjc`'PV`'TS (= ${gcc:Version}), g++`'PV`'TS (= ${gcc:Version}), ${shlibs:Depends}, libdevdep(objc`'PV-dev,,=), ${misc:Depends}
Suggests: ${gobjcxx:multilib}, gcc`'PV-doc (>= ${gcc:SoftVersion})
Provides: objc++-compiler`'TS
BUILT_USING`'dnl
Description: GNU Objective-C++ compiler
 This is the GNU Objective-C++ compiler, which compiles
 Objective-C++ on platforms supported by the gcc compiler. It uses the
 gcc backend to generate optimized code.
')`'dnl obcppdev

ifenabled(`multilib',`
Package: gobjc++`'PV-multilib`'TS
Architecture: ifdef(`TARGET',`any',MULTILIB_ARCHS)
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gobjc++`'PV`'TS (= ${gcc:Version}), g++`'PV-multilib`'TS (= ${gcc:Version}), gobjc`'PV-multilib`'TS (= ${gcc:Version}), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Objective-C++ compiler (multilib files)
 This is the GNU Objective-C++ compiler, which compiles Objective-C++ on
 platforms supported by the gcc compiler.
 .
 On architectures with multilib support, the package contains files
 and dependencies for the non-default multilib architecture(s).
')`'dnl multilib
')`'dnl obcpp

ifenabled(`objc',`
ifenabled(`objcdev',`
Package: gobjc`'PV`'TS
Architecture: any
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gcc`'PV`'TS (= ${gcc:Version}), ${dep:libcdev}, ${shlibs:Depends}, libdevdep(objc`'PV-dev,,=), ${misc:Depends}
Suggests: ${gobjc:multilib}, gcc`'PV-doc (>= ${gcc:SoftVersion}), libdbgdep(objc`'OBJC_SO-dbg,)
Provides: objc-compiler`'TS
ifdef(`__sparc__',`Conflicts: gcc`'PV-sparc64', `dnl')
BUILT_USING`'dnl
Description: GNU Objective-C compiler
 This is the GNU Objective-C compiler, which compiles
 Objective-C on platforms supported by the gcc compiler. It uses the
 gcc backend to generate optimized code.

ifenabled(`multilib',`
Package: gobjc`'PV-multilib`'TS
Architecture: ifdef(`TARGET',`any',MULTILIB_ARCHS)
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gobjc`'PV`'TS (= ${gcc:Version}), gcc`'PV-multilib`'TS (= ${gcc:Version}), ${dep:libobjcbiarchdev}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Objective-C compiler (multilib files)`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU Objective-C compiler, which compiles Objective-C on platforms
 supported by the gcc compiler.
 .
 On architectures with multilib support, the package contains files
 and dependencies for the non-default multilib architecture(s).
')`'dnl multilib

Package: libobjc`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Section: libdevel
Priority: optional
Depends: BASEDEP, libdevdep(gcc`'PV-dev,), libdep(objc`'OBJC_SO,), ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`',ifdef(`MULTIARCH', `Multi-Arch: same
'))`'dnl
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (development files)
 This package contains the headers and static library files needed to build
 GNU ObjC applications.

Package: lib64objc`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: libdevel
Priority: optional
Depends: BASEDEP, libdevdep(gcc`'PV-dev,64), libdep(objc`'OBJC_SO,64), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (64bit development files)
 This package contains the headers and static library files needed to build
 GNU ObjC applications.

Package: lib32objc`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: libdevel
Priority: optional
Depends: BASEDEP, libdevdep(gcc`'PV-dev,32), libdep(objc`'OBJC_SO,32), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (32bit development files)
 This package contains the headers and static library files needed to build
 GNU ObjC applications.

Package: libn32objc`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: libdevel
Priority: optional
Depends: BASEDEP, libdevdep(gcc`'PV-dev,n32), libdep(objc`'OBJC_SO,n32), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (n32 development files)
 This package contains the headers and static library files needed to build
 GNU ObjC applications.

ifenabled(`x32dev',`
Package: libx32objc`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: libdevel
Priority: optional
Depends: BASEDEP, libdevdep(gcc`'PV-dev,x32), libdep(objc`'OBJC_SO,x32), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (x32 development files)
 This package contains the headers and static library files needed to build
 GNU ObjC applications.
')`'dnl libx32objc

ifenabled(`armml',`
Package: libhfobjc`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: libdevel
Priority: optional
Depends: BASEDEP, libdevdep(gcc`'PV-dev,hf), libdep(objc`'OBJC_SO,hf), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (hard float ABI development files)
 This package contains the headers and static library files needed to build
 GNU ObjC applications.
')`'dnl armml

ifenabled(`armml',`
Package: libsfobjc`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: libdevel
Priority: optional
Depends: BASEDEP, libdevdep(gcc`'PV-dev,sf), libdep(objc`'OBJC_SO,sf), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (soft float development files)
 This package contains the headers and static library files needed to build
 GNU ObjC applications.
')`'dnl armml
')`'dnl objcdev

ifenabled(`libobjc',`
Package: libobjc`'OBJC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
ifelse(OBJC_SO,`2',`Breaks: ${multiarch:breaks}
',`')')`Provides: libobjc'OBJC_SO`-armel [armel], libobjc'OBJC_SO`-armhf [armhf]')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications
 Library needed for GNU ObjC applications linked against the shared library.

Package: libobjc`'OBJC_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
')`Provides: libobjc'OBJC_SO`-dbg-armel [armel], libobjc'OBJC_SO`-dbg-armhf [armhf]')
Priority: extra
Depends: BASEDEP, libdep(objc`'OBJC_SO,,=), libdbgdep(gcc`'GCC_SO-dbg,,>=,${libgcc:Version}), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (debug symbols)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl libobjc

ifenabled(`lib64objc',`
Package: lib64objc`'OBJC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (64bit)
 Library needed for GNU ObjC applications linked against the shared library.

Package: lib64objc`'OBJC_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Priority: extra
Depends: BASEDEP, libdep(objc`'OBJC_SO,64,=), libdbgdep(gcc`'GCC_SO-dbg,64,>=,${gcc:EpochVersion}), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (64 bit debug symbols)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl lib64objc

ifenabled(`lib32objc',`
Package: lib32objc`'OBJC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (32bit)
 Library needed for GNU ObjC applications linked against the shared library.

Package: lib32objc`'OBJC_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Priority: extra
Depends: BASEDEP, libdep(objc`'OBJC_SO,32,=), libdbgdep(gcc`'GCC_SO-dbg,32,>=,${gcc:EpochVersion}), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (32 bit debug symbols)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl lib32objc

ifenabled(`libn32objc',`
Package: libn32objc`'OBJC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (n32)
 Library needed for GNU ObjC applications linked against the shared library.

Package: libn32objc`'OBJC_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Priority: extra
Depends: BASEDEP, libdep(objc`'OBJC_SO,n32,=), libdbgdep(gcc`'GCC_SO-dbg,n32,>=,${gcc:EpochVersion}), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (n32 debug symbols)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl libn32objc

ifenabled(`libx32objc',`
Package: libx32objc`'OBJC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (x32)
 Library needed for GNU ObjC applications linked against the shared library.

Package: libx32objc`'OBJC_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Priority: extra
Depends: BASEDEP, libdep(objc`'OBJC_SO,x32,=), libdbgdep(gcc`'GCC_SO-dbg,x32,>=,${gcc:EpochVersion}), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (x32 debug symbols)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl libx32objc

ifenabled(`libhfobjc',`
Package: libhfobjc`'OBJC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libobjc'OBJC_SO`-armhf [biarchhf_archs]')
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (hard float ABI)
 Library needed for GNU ObjC applications linked against the shared library.

Package: libhfobjc`'OBJC_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Priority: extra
Depends: BASEDEP, libdep(objc`'OBJC_SO,hf,=), libdbgdep(gcc`'GCC_SO-dbg,hf,>=,${gcc:EpochVersion}), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libobjc'OBJC_SO`-dbg-armhf [biarchhf_archs]')
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (hard float ABI debug symbols)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl libhfobjc

ifenabled(`libsfobjc',`
Package: libsfobjc`'OBJC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libobjc'OBJC_SO`-armel [biarchsf_archs]')
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (soft float ABI)
 Library needed for GNU ObjC applications linked against the shared library.

Package: libsfobjc`'OBJC_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Priority: extra
Depends: BASEDEP, libdep(objc`'OBJC_SO,sf,=), libdbgdep(gcc`'GCC_SO-dbg,sf,>=,${gcc:EpochVersion}), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libobjc'OBJC_SO`-dbg-armel [biarchsf_archs]')
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications (soft float ABI debug symbols)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl libsfobjc

ifenabled(`libneonobjc',`
Package: libobjc`'OBJC_SO-neon`'LS
Section: libs
Architecture: NEON_ARCHS
Priority: PRI(optional)
Depends: BASEDEP, libc6-neon`'LS, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Objective-C applications  [NEON version]
 Library needed for GNU ObjC applications linked against the shared library.
 .
 This set of libraries is optimized to use a NEON coprocessor, and will
 be selected instead when running under systems which have one.
')`'dnl libneonobjc
')`'dnl objc

ifenabled(`fortran',`
ifenabled(`fdev',`
Package: gfortran`'PV`'TS
Architecture: any
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gcc`'PV`'TS (= ${gcc:Version}), libdevdep(gfortran`'PV-dev,,=), ${dep:libcdev}, ${shlibs:Depends}, ${misc:Depends}
Provides: fortran95-compiler, ${fortran:mod-version}
Suggests: ${gfortran:multilib}, gfortran`'PV-doc, libdbgdep(gfortran`'FORTRAN_SO-dbg,)
BUILT_USING`'dnl
Description: GNU Fortran compiler
 This is the GNU Fortran compiler, which compiles
 Fortran on platforms supported by the gcc compiler. It uses the
 gcc backend to generate optimized code.

ifenabled(`multilib',`
Package: gfortran`'PV-multilib`'TS
Architecture: ifdef(`TARGET',`any',MULTILIB_ARCHS)
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gfortran`'PV`'TS (= ${gcc:Version}), gcc`'PV-multilib`'TS (= ${gcc:Version}), ${dep:libgfortranbiarchdev}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Fortran compiler (multilib files)`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU Fortran compiler, which compiles Fortran on platforms
 supported by the gcc compiler.
 .
 On architectures with multilib support, the package contains files
 and dependencies for the non-default multilib architecture(s).
')`'dnl multilib

ifenabled(`gfdldoc',`
Package: gfortran`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: gcc`'PV-base (>= ${gcc:SoftVersion}), dpkg (>= 1.15.4) | install-info, ${misc:Depends}
Description: Documentation for the GNU Fortran compiler (gfortran)
 Documentation for the GNU Fortran compiler in info `format'.
')`'dnl gfdldoc

Package: libgfortran`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: optional
Depends: BASEDEP, libdevdep(gcc`'PV-dev`',), libdep(gfortran`'FORTRAN_SO,), ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`',ifdef(`MULTIARCH', `Multi-Arch: same
'))`'dnl
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (development files)
 This package contains the headers and static library files needed to build
 GNU Fortran applications.

Package: lib64gfortran`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: libdevel
Priority: optional
Depends: BASEDEP, libdevdep(gcc`'PV-dev`',64), libdep(gfortran`'FORTRAN_SO,64), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (64bit development files)
 This package contains the headers and static library files needed to build
 GNU Fortran applications.

Package: lib32gfortran`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: libdevel
Priority: optional
Depends: BASEDEP, libdevdep(gcc`'PV-dev`',32), libdep(gfortran`'FORTRAN_SO,32), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (32bit development files)
 This package contains the headers and static library files needed to build
 GNU Fortran applications.

Package: libn32gfortran`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: libdevel
Priority: optional
Depends: BASEDEP, libdevdep(gcc`'PV-dev`',n32), libdep(gfortran`'FORTRAN_SO,n32), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (n32 development files)
 This package contains the headers and static library files needed to build
 GNU Fortran applications.

ifenabled(`x32dev',`
Package: libx32gfortran`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: libdevel
Priority: optional
Depends: BASEDEP, libdevdep(gcc`'PV-dev`',x32), libdep(gfortran`'FORTRAN_SO,x32), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (x32 development files)
 This package contains the headers and static library files needed to build
 GNU Fortran applications.
')`'dnl libx32gfortran

ifenabled(`armml',`
Package: libhfgfortran`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: libdevel
Priority: optional
Depends: BASEDEP, libdevdep(gcc`'PV-dev`',hf), libdep(gfortran`'FORTRAN_SO,hf), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (hard float ABI development files)
 This package contains the headers and static library files needed to build
 GNU Fortran applications.
')`'dnl armml

ifenabled(`armml',`
Package: libsfgfortran`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: libdevel
Priority: optional
Depends: BASEDEP, libdevdep(gcc`'PV-dev`',sf), libdep(gfortran`'FORTRAN_SO,sf), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (soft float ABI development files)
 This package contains the headers and static library files needed to build
 GNU Fortran applications.
')`'dnl armml
')`'dnl fdev

ifenabled(`libgfortran',`
Package: libgfortran`'FORTRAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
Breaks: ${multiarch:breaks}
')`Provides: libgfortran'FORTRAN_SO`-armel [armel], libgfortran'FORTRAN_SO`-armhf [armhf]')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications
 Library needed for GNU Fortran applications linked against the
 shared library.

Package: libgfortran`'FORTRAN_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
')`Provides: libgfortran'FORTRAN_SO`-dbg-armel [armel], libgfortran'FORTRAN_SO`-dbg-armhf [armhf]')
Priority: extra
Depends: BASEDEP, libdep(gfortran`'FORTRAN_SO,,=), libdbgdep(gcc`'GCC_SO-dbg,,>=,${libgcc:Version}), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (debug symbols)
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl libgfortran

ifenabled(`lib64gfortran',`
Package: lib64gfortran`'FORTRAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (64bit)
 Library needed for GNU Fortran applications linked against the
 shared library.

Package: lib64gfortran`'FORTRAN_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Priority: extra
Depends: BASEDEP, libdep(gfortran`'FORTRAN_SO,64,=), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (64bit debug symbols)
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl lib64gfortran

ifenabled(`lib32gfortran',`
Package: lib32gfortran`'FORTRAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (32bit)
 Library needed for GNU Fortran applications linked against the
 shared library.

Package: lib32gfortran`'FORTRAN_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Priority: extra
Depends: BASEDEP, libdep(gfortran`'FORTRAN_SO,32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (32 bit debug symbols)
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl lib32gfortran

ifenabled(`libn32gfortran',`
Package: libn32gfortran`'FORTRAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (n32)
 Library needed for GNU Fortran applications linked against the
 shared library.

Package: libn32gfortran`'FORTRAN_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Priority: extra
Depends: BASEDEP, libdep(gfortran`'FORTRAN_SO,n32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (n32 debug symbols)
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl libn32gfortran

ifenabled(`libx32gfortran',`
Package: libx32gfortran`'FORTRAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (x32)
 Library needed for GNU Fortran applications linked against the
 shared library.

Package: libx32gfortran`'FORTRAN_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Priority: extra
Depends: BASEDEP, libdep(gfortran`'FORTRAN_SO,x32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (x32 debug symbols)
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl libx32gfortran

ifenabled(`libhfgfortran',`
Package: libhfgfortran`'FORTRAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgfortran'FORTRAN_SO`-armhf [biarchhf_archs]')
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (hard float ABI)
 Library needed for GNU Fortran applications linked against the
 shared library.

Package: libhfgfortran`'FORTRAN_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Priority: extra
Depends: BASEDEP, libdep(gfortran`'FORTRAN_SO,hf,=), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgfortran'FORTRAN_SO`-dbg-armhf [biarchhf_archs]')
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (hard float ABI debug symbols)
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl libhfgfortran

ifenabled(`libsfgfortran',`
Package: libsfgfortran`'FORTRAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgfortran'FORTRAN_SO`-armel [biarchsf_archs]')
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (soft float ABI)
 Library needed for GNU Fortran applications linked against the
 shared library.

Package: libsfgfortran`'FORTRAN_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Priority: extra
Depends: BASEDEP, libdep(gfortran`'FORTRAN_SO,sf,=), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgfortran'FORTRAN_SO`-dbg-armel [biarchsf_archs]')
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications (hard float ABI debug symbols)
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl libsfgfortran

ifenabled(`libneongfortran',`
Package: libgfortran`'FORTRAN_SO-neon`'LS
Section: libs
Architecture: NEON_ARCHS
ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
Breaks: ${multiarch:breaks}
')`'dnl
Priority: extra
Depends: BASEDEP, libgcc1-neon`'LS, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Fortran applications [NEON version]
 Library needed for GNU Fortran applications linked against the
 shared library.
 .
 This set of libraries is optimized to use a NEON coprocessor, and will
 be selected instead when running under systems which have one.
')`'dnl libneongfortran
')`'dnl fortran

ifenabled(`ggo',`
ifenabled(`godev',`
Package: gccgo`'PV`'TS
Architecture: any
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ifdef(`STANDALONEGO',,`gcc`'PV`'TS (= ${gcc:Version}), ')libdep(go`'GO_SO,), ${dep:libcdev}, ${shlibs:Depends}, ${misc:Depends}
Provides: go-compiler
Suggests: ${go:multilib}, gccgo`'PV-doc, libdbgdep(go`'GO_SO-dbg,)
BUILT_USING`'dnl
Description: GNU Go compiler
 This is the GNU Go compiler, which compiles Go on platforms supported
 by the gcc compiler. It uses the gcc backend to generate optimized code.

ifenabled(`multilib',`
Package: gccgo`'PV-multilib`'TS
Architecture: ifdef(`TARGET',`any',MULTILIB_ARCHS)
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gccgo`'PV`'TS (= ${gcc:Version}), ifdef(`STANDALONEGO',,`gcc`'PV-multilib`'TS (= ${gcc:Version}), ')${dep:libgobiarch}, ${shlibs:Depends}, ${misc:Depends}
Suggests: ${dep:libgobiarchdbg}
BUILT_USING`'dnl
Description: GNU Go compiler (multilib files)`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU Go compiler, which compiles Go on platforms supported
 by the gcc compiler.
 .
 On architectures with multilib support, the package contains files
 and dependencies for the non-default multilib architecture(s).
')`'dnl multilib

ifenabled(`gfdldoc',`
Package: gccgo`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: gcc`'PV-base (>= ${gcc:SoftVersion}), dpkg (>= 1.15.4) | install-info, ${misc:Depends}
BUILT_USING`'dnl
Description: Documentation for the GNU Go compiler (gccgo)
 Documentation for the GNU Go compiler in info `format'.
')`'dnl gfdldoc
')`'dnl fdev

ifenabled(`libggo',`
Package: libgo`'GO_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
')`Provides: libgo'GO_SO`-armel [armel], libgo'GO_SO`-armhf [armhf]')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
Replaces: libgo3`'LS
BUILT_USING`'dnl
Description: Runtime library for GNU Go applications
 Library needed for GNU Go applications linked against the
 shared library.

Package: libgo`'GO_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
')`Provides: libgo'GO_SO`-dbg-armel [armel], libgo'GO_SO`-dbg-armhf [armhf]')
Priority: extra
Depends: BASEDEP, libdep(go`'GO_SO,,=), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Go applications (debug symbols)
 Library needed for GNU Go applications linked against the
 shared library.
')`'dnl libgo

ifenabled(`lib64ggo',`
Package: lib64go`'GO_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Replaces: lib64go3`'LS
BUILT_USING`'dnl
Description: Runtime library for GNU Go applications (64bit)
 Library needed for GNU Go applications linked against the
 shared library.

Package: lib64go`'GO_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Priority: extra
Depends: BASEDEP, libdep(go`'GO_SO,64,=), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Go applications (64bit debug symbols)
 Library needed for GNU Go applications linked against the
 shared library.
')`'dnl lib64go

ifenabled(`lib32ggo',`
Package: lib32go`'GO_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
Replaces: lib32go3`'LS
BUILT_USING`'dnl
Description: Runtime library for GNU Go applications (32bit)
 Library needed for GNU Go applications linked against the
 shared library.

Package: lib32go`'GO_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Priority: extra
Depends: BASEDEP, libdep(go`'GO_SO,32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Go applications (32 bit debug symbols)
 Library needed for GNU Go applications linked against the
 shared library.
')`'dnl lib32go

ifenabled(`libn32ggo',`
Package: libn32go`'GO_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Replaces: libn32go3`'LS
BUILT_USING`'dnl
Description: Runtime library for GNU Go applications (n32)
 Library needed for GNU Go applications linked against the
 shared library.

Package: libn32go`'GO_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Priority: extra
Depends: BASEDEP, libdep(go`'GO_SO,n32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Go applications (n32 debug symbols)
 Library needed for GNU Go applications linked against the
 shared library.
')`'dnl libn32go

ifenabled(`libx32ggo',`
Package: libx32go`'GO_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Replaces: libx32go3`'LS
BUILT_USING`'dnl
Description: Runtime library for GNU Go applications (x32)
 Library needed for GNU Go applications linked against the
 shared library.

Package: libx32go`'GO_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Priority: extra
Depends: BASEDEP, libdep(go`'GO_SO,x32,=), ${misc:Depends}
BUILT_USING`'dnl
Description: Runtime library for GNU Go applications (x32 debug symbols)
 Library needed for GNU Go applications linked against the
 shared library.
')`'dnl libx32go
')`'dnl ggo

ifenabled(`java',`
ifenabled(`gcj',`
Package: gcj`'PV`'TS
Section: java
Architecture: any
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:gcj}, ${dep:gcjcross}, ${dep:libcdev}, ${dep:ecj}, ${shlibs:Depends}, dpkg (>= 1.15.4) | install-info, ${misc:Depends}
Recommends: libecj-java-gcj
Conflicts: gcj-4.4, cpp-4.1 (<< 4.1.1), gcc-4.1 (<< 4.1.1)
Replaces: libgcj11 (<< 4.5-20100101-1), gcj`'PV-jdk`'TS (<< 4.8.1-4)
BUILT_USING`'dnl
Description: GCJ byte code and native compiler for Java(TM)
 GCJ is a front end to the GCC compiler which can natively compile both
 Java(tm) source and bytecode files. The compiler can also generate class
 files.
')`'dnl gcj

ifenabled(`libgcj',`
ifenabled(`libgcjcommon',`
Package: libgcj-common
Section: java
Architecture: all
Priority: PRI(optional)
Depends: BASEDEP, ${misc:Depends}
Conflicts: classpath (<= 0.04-4)
Replaces: java-gcj-compat (<< 1.0.65-3), java-gcj-compat-dev (<< 1.0.65-3)
BUILT_USING`'dnl
Description: Java runtime library (common files)
 This package contains files shared by Classpath and libgcj libraries.
')`'dnl libgcjcommon


Package: gcj`'PV-jdk`'TS
Section: java
Architecture: any
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:gcj}, ${dep:libcdev}, gcj`'PV`'TS (= ${gcj:Version}), gcj`'PV-jre`'TS (= ${gcj:Version}), libdevdep(gcj`'GCJ_SO-dev,,=,${gcj:Version}), fastjar, libgcj-bc`'LS, java-common, libantlr-java, ${shlibs:Depends}, dpkg (>= 1.15.4) | install-info, ${misc:Depends}
Recommends: libecj-java-gcj
Suggests: gcj`'PV-source (>= ${gcj:SoftVersion}), libdbgdep(gcj`'GCJ_SO-dbg,)
Provides: java-compiler, java-sdk, java2-sdk, java5-sdk
Conflicts: gcj-4.4, cpp-4.1 (<< 4.1.1), gcc-4.1 (<< 4.1.1)
Replaces: libgcj11 (<< 4.5-20100101-1)
BUILT_USING`'dnl
Description: GCJ and Classpath development tools for Java(TM)
 GCJ is a front end to the GCC compiler which can natively compile both
 Java(tm) source and bytecode files. The compiler can also generate class
 files. Other java development tools from classpath are included in this
 package.
 .
 The package contains as well a collection of wrapper scripts and symlinks.
 It is meant to provide a Java-SDK-like interface to the GCJ tool set.

Package: gcj`'PV-jre-headless`'TS
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Section: java
Architecture: any
Depends: BASEDEP, gcj`'PV-jre-lib`'TS (>= ${gcj:SoftVersion}), libdep(gcj`'LIBGCJ_EXT,,=,${gcj:Version}), ${dep:prctl}, ${shlibs:Depends}, ${misc:Depends}
Suggests: fastjar, gcj`'PV-jdk`'TS (= ${gcj:Version}), libdep(gcj`'LIBGCJ_EXT-awt,,=,${gcj:Version})
Conflicts: gij-4.4, java-gcj-compat (<< 1.0.76-4)
Replaces: gcj-4.8-jre-lib`'TS (<< 4.8-20121219-0)
Provides: java5-runtime-headless, java2-runtime-headless, java1-runtime-headless, java-runtime-headless
BUILT_USING`'dnl
Description: Java runtime environment using GIJ/Classpath (headless version)
 GIJ is a Java bytecode interpreter, not limited to interpreting bytecode.
 It includes a class loader which can dynamically load shared objects, so
 it is possible to give it the name of a class which has been compiled and
 put into a shared library on the class path.
 .
 The package contains as well a collection of wrapper scripts and symlinks.
 It is meant to provide a Java-RTE-like interface to the GIJ/GCJ tool set,
 limited to the headless tools and libraries.

Package: gcj`'PV-jre`'TS
Section: java
Architecture: any
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gcj`'PV-jre-headless`'TS (= ${gcj:Version}), libdep(gcj`'LIBGCJ_EXT-awt,,=,${gcj:Version}), ${shlibs:Depends}, ${misc:Depends}
Provides: java5-runtime, java2-runtime, java1-runtime, java-runtime
Replaces: gcj-4.8-jre-headless`'TS (<< 4.8.2-2)
BUILT_USING`'dnl
Description: Java runtime environment using GIJ/Classpath
 GIJ is a Java bytecode interpreter, not limited to interpreting bytecode.
 It includes a class loader which can dynamically load shared objects, so
 it is possible to give it the name of a class which has been compiled and
 put into a shared library on the class path.
 .
 The package contains as well a collection of wrapper scripts and symlinks.
 It is meant to provide a Java-RTE-like interface to the GIJ/GCJ tool set.

Package: libgcj`'LIBGCJ_EXT`'LS
Section: libs
Architecture: any
Priority: PRI(optional)
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
Multi-Arch: same
')`'dnl
Depends: SOFTBASEDEP, libgcj-common (>= 1:4.1.1-21), ${shlibs:Depends}, ${misc:Depends}
Recommends: gcj`'PV-jre-lib`'TS (>= ${gcj:SoftVersion})
Suggests: libdbgdep(gcj`'GCJ_SO-dbg,), libdep(gcj`'LIBGCJ_EXT-awt,,=,${gcj:Version})
Replaces: gij-4.4 (<< 4.4.0-1), gcj-4.8-jre-headless`'TS (<< 4.8.2-5)
BUILT_USING`'dnl
Description: Java runtime library for use with gcj
 This is the runtime that goes along with the gcj front end to
 gcc. libgcj includes parts of the Java Class Libraries, plus glue to
 connect the libraries to the compiler and the underlying OS.
 .
 To show file names and line numbers in stack traces, the packages
 libgcj`'GCJ_SO-dbg and binutils are required.

Package: gcj`'PV-jre-lib`'TS
Section: java
Architecture: all
Priority: PRI(optional)
Depends: SOFTBASEDEP, libdep(gcj`'LIBGCJ_EXT,,>=,${gcj:SoftVersion}), ${misc:Depends}
BUILT_USING`'dnl
Description: Java runtime library for use with gcj (jar files)
 This is the jar file that goes along with the gcj front end to gcc.

ifenabled(`gcjbc',`
Package: libgcj-bc
Section: java
Architecture: any
Priority: PRI(optional)
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
Multi-Arch: same
')`'dnl
Depends: BASEDEP, libdep(gcj`'LIBGCJ_EXT,,>=,${gcj:Version}), ${misc:Depends}
BUILT_USING`'dnl
Description: Link time only library for use with gcj
 A fake library that is used at link time only.  It ensures that
 binaries built with the BC-ABI link against a constant SONAME.
 This way, BC-ABI binaries continue to work if the SONAME underlying
 libgcj.so changes.
')`'dnl gcjbc

Package: libgcj`'LIBGCJ_EXT-awt`'LS
Section: libs
Architecture: any
Priority: PRI(optional)
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
Multi-Arch: same
')`'dnl
Depends: SOFTBASEDEP, libdep(gcj`'LIBGCJ_EXT,,=,${gcj:Version}), ${shlibs:Depends}, ${misc:Depends}
Suggests: ${pkg:gcjqt}
BUILT_USING`'dnl
Description: AWT peer runtime libraries for use with gcj
 These are runtime libraries holding the AWT peer implementations
 for libgcj (currently the GTK+ based peer library is required, the
 QT bases library is not built).

ifenabled(`gtkpeer',`
Package: libgcj`'GCJ_SO-awt-gtk`'LS
Section: libs
Architecture: any
Priority: PRI(optional)
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
Multi-Arch: same
')`'dnl
Depends: SOFTBASEDEP, libgcj`'LIBGCJ_EXT-awt`'LS (= ${gcj:Version}), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: AWT GTK+ peer runtime library for use with libgcj
 This is the runtime library holding the GTK+ based AWT peer
 implementation for libgcj.
')`'dnl gtkpeer

ifenabled(`qtpeer',`
Package: libgcj`'GCJ_SO-awt-qt`'LS
Section: libs
Architecture: any
Priority: PRI(optional)
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
Multi-Arch: same
')`'dnl
Depends: SOFTBASEDEP, libdep(gcj`'LIBGCJ_EXT-awt,,=,${gcj:Version}), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: AWT QT peer runtime library for use with libgcj
 This is the runtime library holding the QT based AWT peer
 implementation for libgcj.
')`'dnl qtpeer
')`'dnl libgcj

ifenabled(`libgcjdev',`
Package: libgcj`'GCJ_SO-dev`'LS
Section: libdevel
Architecture: any
ifdef(`MULTIARCH', `Multi-Arch: same
')`'dnl
Priority: PRI(optional)
Depends: BASEDEP, libdep(gcj`'LIBGCJ_EXT-awt,,=,${gcj:Version}), libgcj-bc`'LS, ${pkg:gcjgtk}, ${pkg:gcjqt}, zlib1g-dev, ${shlibs:Depends}, ${misc:Depends}
Suggests: libgcj-doc
BUILT_USING`'dnl
Description: Java development headers for use with gcj
 These are the development headers that go along with the gcj front end
 to gcc. libgcj includes parts of the Java Class Libraries, plus glue
 to connect the libraries to the compiler and the underlying OS.

Package: libgcj`'GCJ_SO-dbg`'LS
Section: debug
Architecture: any
Priority: extra
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
Multi-Arch: same
')`'dnl
Depends: BASEDEP, libdep(gcj`'LIBGCJ_EXT,,=,${gcj:Version}), ${misc:Depends}
Recommends: binutils, libc6-dbg | libc-dbg
BUILT_USING`'dnl
Description: Debugging symbols for libraries provided in libgcj`'GCJ_SO-dev
 The package provides debugging symbols for the libraries provided
 in libgcj`'GCJ_SO-dev.
 .
 binutils is required to show file names and line numbers in stack traces.

ifenabled(`gcjsrc',`
Package: gcj`'PV-source
Section: java
Architecture: all
Priority: PRI(optional)
Depends: SOFTBASEDEP, gcj`'PV-jdk (>= ${gcj:SoftVersion}), ${misc:Depends}
BUILT_USING`'dnl
Description: GCJ java sources for use in IDEs like eclipse and netbeans
 These are the java source files packaged as a zip file for use in development
 environments like eclipse and netbeans.
')`'dnl

ifenabled(`gcjdoc',`
Package: libgcj-doc
Section: doc
Architecture: all
Priority: PRI(optional)
Depends: SOFTBASEDEP, ${misc:Depends}
Enhances: libgcj`'GCJ_SO-dev
Provides: classpath-doc
BUILT_USING`'dnl
Description: libgcj API documentation and example programs
 Autogenerated documentation describing the API of the libgcj library.
 Sources and precompiled example programs from the Classpath library.
')`'dnl gcjdoc
')`'dnl libgcjdev
')`'dnl java

ifenabled(`c++',`
ifenabled(`libcxx',`
Package: libstdc++CXX_SO`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(important))
Depends: BASEDEP, ${dep:libc}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libstdc++CXX_SO-TARGET-dcv1',
ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
Breaks: ${multiarch:breaks}
')`Provides: libstdc++'CXX_SO`-armel [armel], libstdc++'CXX_SO`-armhf [armhf]')
Conflicts: scim (<< 1.4.2-1)
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains an additional runtime library for C++ programs
 built with the GNU compiler.
 .
 libstdc++-v3 is a complete rewrite from the previous libstdc++-v2, which
 was included up to g++-2.95. The first version of libstdc++-v3 appeared
 in g++-3.0.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libcxx

ifenabled(`lib32cxx',`
Package: lib32stdc++CXX_SO`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: extra
Depends: BASEDEP, libdep(gcc1,32), ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
ifdef(`TARGET',`Provides: lib32stdc++CXX_SO-TARGET-dcv1
',`')`'dnl
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (32 bit Version)
 This package contains an additional runtime library for C++ programs
 built with the GNU compiler.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl lib32cxx

ifenabled(`lib64cxx',`
Package: lib64stdc++CXX_SO`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, libdep(gcc1,64), ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: lib64stdc++CXX_SO-TARGET-dcv1
',`')`'dnl
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3`'ifdef(`TARGET)',` (TARGET)', `') (64bit)
 This package contains an additional runtime library for C++ programs
 built with the GNU compiler.
 .
 libstdc++-v3 is a complete rewrite from the previous libstdc++-v2, which
 was included up to g++-2.95. The first version of libstdc++-v3 appeared
 in g++-3.0.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl lib64cxx

ifenabled(`libn32cxx',`
Package: libn32stdc++CXX_SO`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, libdep(gcc1,n32), ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libn32stdc++CXX_SO-TARGET-dcv1
',`')`'dnl
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3`'ifdef(`TARGET)',` (TARGET)', `') (n32)
 This package contains an additional runtime library for C++ programs
 built with the GNU compiler.
 .
 libstdc++-v3 is a complete rewrite from the previous libstdc++-v2, which
 was included up to g++-2.95. The first version of libstdc++-v3 appeared
 in g++-3.0.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libn32cxx

ifenabled(`libx32cxx',`
Package: libx32stdc++CXX_SO`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, libdep(gcc1,x32), ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libx32stdc++CXX_SO-TARGET-dcv1
',`')`'dnl
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3`'ifdef(`TARGET)',` (TARGET)', `') (x32)
 This package contains an additional runtime library for C++ programs
 built with the GNU compiler.
 .
 libstdc++-v3 is a complete rewrite from the previous libstdc++-v2, which
 was included up to g++-2.95. The first version of libstdc++-v3 appeared
 in g++-3.0.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libx32cxx

ifenabled(`libhfcxx',`
Package: libhfstdc++CXX_SO`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, libdep(gcc1,hf), ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libhfstdc++CXX_SO-TARGET-dcv1
',`')`'dnl
ifdef(`TARGET',`dnl',`Conflicts: libstdc++'CXX_SO`-armhf [biarchhf_archs]')
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3`'ifdef(`TARGET)',` (TARGET)', `') (hard float ABI)
 This package contains an additional runtime library for C++ programs
 built with the GNU compiler.
 .
 libstdc++-v3 is a complete rewrite from the previous libstdc++-v2, which
 was included up to g++-2.95. The first version of libstdc++-v3 appeared
 in g++-3.0.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libhfcxx

ifenabled(`libsfcxx',`
Package: libsfstdc++CXX_SO`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, libdep(gcc1,sf), ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libsfstdc++CXX_SO-TARGET-dcv1
',`')`'dnl
ifdef(`TARGET',`dnl',`Conflicts: libstdc++'CXX_SO`-armel [biarchsf_archs]')
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3`'ifdef(`TARGET)',` (TARGET)', `') (soft float ABI)
 This package contains an additional runtime library for C++ programs
 built with the GNU compiler.
 .
 libstdc++-v3 is a complete rewrite from the previous libstdc++-v2, which
 was included up to g++-2.95. The first version of libstdc++-v3 appeared
 in g++-3.0.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libsfcxx

ifenabled(`libneoncxx',`
Package: libstdc++CXX_SO-neon`'LS
Architecture: NEON_ARCHS
Section: libs
Priority: extra
Depends: BASEDEP, libc6-neon`'LS, libgcc1-neon`'LS, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 [NEON version]
 This package contains an additional runtime library for C++ programs
 built with the GNU compiler.
 .
 This set of libraries is optimized to use a NEON coprocessor, and will
 be selected instead when running under systems which have one.
')`'dnl

ifenabled(`c++dev',`
Package: libstdc++`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`',ifdef(`MULTIARCH', `Multi-Arch: same
'))`'dnl
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, libdevdep(gcc`'PV-dev,,=), libdep(stdc++CXX_SO,,>=), ${dep:libcdev}, ${misc:Depends}
ifdef(`TARGET',`',`dnl native
Conflicts: libg++27-dev, libg++272-dev (<< 2.7.2.8-1), libstdc++2.8-dev, libg++2.8-dev, libstdc++2.9-dev, libstdc++2.9-glibc2.1-dev, libstdc++2.10-dev (<< 1:2.95.3-2), libstdc++3.0-dev
Suggests: libstdc++`'PV-doc
')`'dnl native
Provides: libstdc++-dev`'LS`'ifdef(`TARGET',`, libstdc++-dev-TARGET-dcv1')
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (development files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the headers and static library files necessary for
 building C++ programs which use libstdc++.
 .
 libstdc++-v3 is a complete rewrite from the previous libstdc++-v2, which
 was included up to g++-2.95. The first version of libstdc++-v3 appeared
 in g++-3.0.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libstdc++`'PV-pic`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`',ifdef(`MULTIARCH', `Multi-Arch: same
'))`'dnl
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: extra
Depends: BASEDEP, libdep(stdc++CXX_SO,), libdevdep(stdc++`'PV-dev,), ${misc:Depends}
ifdef(`TARGET',`Provides: libstdc++-pic-TARGET-dcv1
',`')`'dnl
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (shared library subset kit)`'ifdef(`TARGET)',` (TARGET)', `')
 This is used to develop subsets of the libstdc++ shared libraries for
 use on custom installation floppies and in embedded systems.
 .
 Unless you are making one of those, you will not need this package.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libstdc++CXX_SO`'PV-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(stdc++CXX_SO,), libdbgdep(gcc`'GCC_SO-dbg,,>=,${libgcc:Version}), ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libstdc++CXX_SO-dbg-TARGET-dcv1',`dnl
ifdef(`MULTIARCH', `Multi-Arch: same',`dnl')
Provides: libstdc++'CXX_SO`'PV`-dbg-armel [armel], libstdc++'CXX_SO`'PV`-dbg-armhf [armhf]dnl
')
Recommends: libdevdep(stdc++`'PV-dev,)
Conflicts: libstdc++5-dbg`'LS, libstdc++5-3.3-dbg`'LS, libstdc++6-dbg`'LS, libstdc++6-4.0-dbg`'LS, libstdc++6-4.1-dbg`'LS, libstdc++6-4.2-dbg`'LS, libstdc++6-4.3-dbg`'LS, libstdc++6-4.4-dbg`'LS, libstdc++6-4.5-dbg`'LS, libstdc++6-4.6-dbg`'LS, libstdc++6-4.7-dbg`'LS
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the shared library of libstdc++ compiled with
 debugging symbols.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: lib32stdc++`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, libdevdep(gcc`'PV-dev,32), libdep(stdc++CXX_SO,32), libdevdep(stdc++`'PV-dev,), ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (development files)`'ifdef(`TARGET',` (TARGET)', `')
 This package contains the headers and static library files necessary for
 building C++ programs which use libstdc++.
 .
 libstdc++-v3 is a complete rewrite from the previous libstdc++-v2, which
 was included up to g++-2.95. The first version of libstdc++-v3 appeared
 in g++-3.0.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: lib32stdc++CXX_SO`'PV-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(stdc++CXX_SO,32), libdevdep(stdc++`'PV-dev,), libdbgdep(gcc`'GCC_SO-dbg,32,>=,${gcc:EpochVersion}), ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: lib32stdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
Conflicts: lib32stdc++6-dbg`'LS, lib32stdc++6-4.0-dbg`'LS, lib32stdc++6-4.1-dbg`'LS, lib32stdc++6-4.2-dbg`'LS, lib32stdc++6-4.3-dbg`'LS, lib32stdc++6-4.4-dbg`'LS, lib32stdc++6-4.5-dbg`'LS, lib32stdc++6-4.6-dbg`'LS, lib32stdc++6-4.7-dbg`'LS,
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the shared library of libstdc++ compiled with
 debugging symbols.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: lib64stdc++`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, libdevdep(gcc`'PV-dev,64), libdep(stdc++CXX_SO,64), libdevdep(stdc++`'PV-dev,), ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (development files)`'ifdef(`TARGET',` (TARGET)', `')
 This package contains the headers and static library files necessary for
 building C++ programs which use libstdc++.
 .
 libstdc++-v3 is a complete rewrite from the previous libstdc++-v2, which
 was included up to g++-2.95. The first version of libstdc++-v3 appeared
 in g++-3.0.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: lib64stdc++CXX_SO`'PV-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarch64_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(stdc++CXX_SO,64), libdevdep(stdc++`'PV-dev,), libdbgdep(gcc`'GCC_SO-dbg,64,>=,${gcc:EpochVersion}), ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: lib64stdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
Conflicts: lib64stdc++6-dbg`'LS, lib64stdc++6-4.0-dbg`'LS, lib64stdc++6-4.1-dbg`'LS, lib64stdc++6-4.2-dbg`'LS, lib64stdc++6-4.3-dbg`'LS, lib64stdc++6-4.4-dbg`'LS, lib64stdc++6-4.5-dbg`'LS, lib64stdc++6-4.6-dbg`'LS, lib64stdc++6-4.7-dbg`'LS
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the shared library of libstdc++ compiled with
 debugging symbols.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libn32stdc++`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, libdevdep(gcc`'PV-dev,n32), libdep(stdc++CXX_SO,n32), libdevdep(stdc++`'PV-dev,), ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (development files)`'ifdef(`TARGET',` (TARGET)', `')
 This package contains the headers and static library files necessary for
 building C++ programs which use libstdc++.
 .
 libstdc++-v3 is a complete rewrite from the previous libstdc++-v2, which
 was included up to g++-2.95. The first version of libstdc++-v3 appeared
 in g++-3.0.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libn32stdc++CXX_SO`'PV-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchn32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(stdc++CXX_SO,n32), libdevdep(stdc++`'PV-dev,), libdbgdep(gcc`'GCC_SO-dbg,n32,>=,${gcc:EpochVersion}), ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libn32stdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
Conflicts: libn32stdc++6-dbg`'LS, libn32stdc++6-4.0-dbg`'LS, libn32stdc++6-4.1-dbg`'LS, libn32stdc++6-4.2-dbg`'LS, libn32stdc++6-4.3-dbg`'LS, libn32stdc++6-4.4-dbg`'LS, libn32stdc++6-4.5-dbg`'LS, libn32stdc++6-4.6-dbg`'LS, libn32stdc++6-4.7-dbg`'LS
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the shared library of libstdc++ compiled with
 debugging symbols.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

ifenabled(`x32dev',`
Package: libx32stdc++`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, libdevdep(gcc`'PV-dev,x32), libdep(stdc++CXX_SO,x32), libdevdep(stdc++`'PV-dev,), ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (development files)`'ifdef(`TARGET',` (TARGET)', `')
 This package contains the headers and static library files necessary for
 building C++ programs which use libstdc++.
 .
 libstdc++-v3 is a complete rewrite from the previous libstdc++-v2, which
 was included up to g++-2.95. The first version of libstdc++-v3 appeared
 in g++-3.0.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl x32dev

ifenabled(`libx32dbgcxx',`
Package: libx32stdc++CXX_SO`'PV-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchx32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(stdc++CXX_SO,x32), libdevdep(stdc++`'PV-dev,), libdbgdep(gcc`'GCC_SO-dbg,x32,>=,${gcc:EpochVersion}), ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libx32stdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
Conflicts: libx32stdc++6-dbg`'LS, libx32stdc++6-4.6-dbg`'LS, libx32stdc++6-4.7-dbg`'LS
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the shared library of libstdc++ compiled with
 debugging symbols.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libx32dbgcxx

ifenabled(`libhfdbgcxx',`
Package: libhfstdc++`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, libdevdep(gcc`'PV-dev,hf), libdep(stdc++CXX_SO,hf), libdevdep(stdc++`'PV-dev,), ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (development files)`'ifdef(`TARGET',` (TARGET)', `')
 This package contains the headers and static library files necessary for
 building C++ programs which use libstdc++.
 .
 libstdc++-v3 is a complete rewrite from the previous libstdc++-v2, which
 was included up to g++-2.95. The first version of libstdc++-v3 appeared
 in g++-3.0.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libhfstdc++CXX_SO`'PV-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchhf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(stdc++CXX_SO,hf), libdevdep(stdc++`'PV-dev,), libdbgdep(gcc`'GCC_SO-dbg,hf,>=,${gcc:EpochVersion}), ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libhfstdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
ifdef(`TARGET',`dnl',`Conflicts: libhfstdc++6-dbg`'LS, libhfstdc++6-4.3-dbg`'LS, libhfstdc++6-4.4-dbg`'LS, libhfstdc++6-4.5-dbg`'LS, libhfstdc++6-4.6-dbg`'LS, libhfstdc++6-4.7-dbg`'LS, libstdc++'CXX_SO`-armhf [biarchhf_archs]')
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the shared library of libstdc++ compiled with
 debugging symbols.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libhfdbgcxx

ifenabled(`libsfdbgcxx',`
Package: libsfstdc++`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, libdevdep(gcc`'PV-dev,sf), libdep(stdc++CXX_SO,sf), libdevdep(stdc++`'PV-dev,), ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (development files)`'ifdef(`TARGET',` (TARGET)', `')
 This package contains the headers and static library files necessary for
 building C++ programs which use libstdc++.
 .
 libstdc++-v3 is a complete rewrite from the previous libstdc++-v2, which
 was included up to g++-2.95. The first version of libstdc++-v3 appeared
 in g++-3.0.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libsfstdc++CXX_SO`'PV-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`biarchsf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libdep(stdc++CXX_SO,sf), libdevdep(stdc++`'PV-dev,), libdbgdep(gcc`'GCC_SO-dbg,sf,>=,${gcc:EpochVersion}), ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libsfstdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
ifdef(`TARGET',`dnl',`Conflicts: libsfstdc++6-dbg`'LS, libsfstdc++6-4.3-dbg`'LS, libsfstdc++6-4.4-dbg`'LS, libsfstdc++6-4.5-dbg`'LS, libsfstdc++6-4.6-dbg`'LS, libsfstdc++6-4.7-dbg`'LS, libstdc++'CXX_SO`-armel [biarchsf_archs]')
BUILT_USING`'dnl
Description: GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the shared library of libstdc++ compiled with
 debugging symbols.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libsfdbgcxx

ifdef(`TARGET', `', `
Package: libstdc++`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: gcc`'PV-base (>= ${gcc:SoftVersion}), ${misc:Depends}, libjs-jquery
Conflicts: libstdc++5-doc, libstdc++5-3.3-doc, libstdc++6-doc, libstdc++6-4.0-doc, libstdc++6-4.1-doc, libstdc++6-4.2-doc, libstdc++6-4.3-doc, libstdc++6-4.4-doc, libstdc++6-4.5-doc, libstdc++6-4.6-doc, libstdc++6-4.7-doc
Description: GNU Standard C++ Library v3 (documentation files)
 This package contains documentation files for the GNU stdc++ library.
 .
 One set is the distribution documentation, the other set is the
 source documentation including a namespace list, class hierarchy,
 alphabetical list, compound list, file list, namespace members,
 compound members and file members.
')`'dnl native
')`'dnl c++dev
')`'dnl c++

ifenabled(`ada',`
Package: gnat`'-GNAT_V`'TS
Architecture: any
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
')`'dnl
Depends: BASEDEP, gcc`'PV`'TS (>= ${gcc:SoftVersion}), ${dep:libgnat}, ${dep:libcdev}, ${shlibs:Depends}, ${misc:Depends}
Suggests: gnat`'PV-doc, ada-reference-manual-html, ada-reference-manual-info, ada-reference-manual-pdf, ada-reference-manual-text, gnat`'-GNAT_V-sjlj
Conflicts: gnat (<< 4.1), gnat-3.1, gnat-3.2, gnat-3.3, gnat-3.4, gnat-3.5, gnat-4.0, gnat-4.1, gnat-4.2, gnat-4.3, gnat-4.4, gnat-4.6
BUILT_USING`'dnl
Description: GNU Ada compiler
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 This package provides the compiler, tools and runtime library that handles
 exceptions using the default zero-cost mechanism.

Package: gnat`'-GNAT_V-sjlj`'TS
Architecture: any
Priority: extra
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
')`'dnl
Depends: BASEDEP, gnat`'-GNAT_V`'TS (= ${gnat:Version}), ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Ada compiler (setjump/longjump runtime library)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 This package provides an alternative runtime library that handles
 exceptions using the setjump/longjump mechanism (as a static library
 only).  You can install it to supplement the normal compiler.

ifenabled(`libgnat',`
Package: libgnat`'-GNAT_V`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
'))`'dnl
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: runtime for applications compiled with GNAT (shared library)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 The libgnat library provides runtime components needed by most
 applications produced with GNAT.
 .
 This package contains the runtime shared library.

Package: libgnat`'-GNAT_V-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
'))`'dnl
Priority: extra
Depends: BASEDEP, libgnat`'-GNAT_V`'LS (= ${gnat:Version}), ${misc:Depends}
BUILT_USING`'dnl
Description: runtime for applications compiled with GNAT (debugging symbols)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 The libgnat library provides runtime components needed by most
 applications produced with GNAT.
 .
 This package contains the debugging symbols.

Package: libgnatvsn`'GNAT_V-dev`'LS
Section: libdevel
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Priority: extra
Depends: BASEDEP, gnat`'PV`'LS (= ${gnat:Version}),
 libgnatvsn`'GNAT_V`'LS (= ${gnat:Version}), ${misc:Depends}
Conflicts: libgnatvsn-dev (<< `'GNAT_V), libgnatvsn4.1-dev, libgnatvsn4.3-dev, libgnatvsn4.4-dev, libgnatvsn4.5-dev, libgnatvsn4.6-dev
BUILT_USING`'dnl
Description: GNU Ada compiler selected components (development files)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 The libgnatvsn library exports selected GNAT components for use in other
 packages, most notably ASIS tools. It is licensed under the GNAT-Modified
 GPL, allowing to link proprietary programs with it.
 .
 This package contains the development files and static library.

Package: libgnatvsn`'GNAT_V`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
'))`'dnl
Priority: PRI(optional)
Section: ifdef(`TARGET',`devel',`libs')
Depends: BASEDEP, libgnat`'-GNAT_V`'LS (= ${gnat:Version}), ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Ada compiler selected components (shared library)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 The libgnatvsn library exports selected GNAT components for use in other
 packages, most notably ASIS tools. It is licensed under the GNAT-Modified
 GPL, allowing to link proprietary programs with it.
 .
 This package contains the runtime shared library.

Package: libgnatvsn`'GNAT_V-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
'))`'dnl
Priority: extra
Section: debug
Depends: BASEDEP, libgnatvsn`'GNAT_V`'LS (= ${gnat:Version}), ${misc:Depends}
Suggests: gnat
BUILT_USING`'dnl
Description: GNU Ada compiler selected components (debugging symbols)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 The libgnatvsn library exports selected GNAT components for use in other
 packages, most notably ASIS tools. It is licensed under the GNAT-Modified
 GPL, allowing to link proprietary programs with it.
 .
 This package contains the debugging symbols.

Package: libgnatprj`'GNAT_V-dev`'LS
Section: libdevel
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
Priority: extra
Depends: BASEDEP, gnat`'PV`'TS (= ${gnat:Version}),
 libgnatprj`'GNAT_V`'LS (= ${gnat:Version}),
 libgnatvsn`'GNAT_V-dev`'LS (= ${gnat:Version}), ${misc:Depends}
Conflicts: libgnatprj-dev (<< `'GNAT_V), libgnatprj4.1-dev, libgnatprj4.3-dev, libgnatprj4.4-dev, libgnatprj4.5-dev, libgnatprj4.6-dev
BUILT_USING`'dnl
Description: GNU Ada compiler Project Manager (development files)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 GNAT uses project files to organise source and object files in large-scale
 development efforts. The libgnatprj library exports GNAT project files
 management for use in other packages, most notably ASIS tools (package
 asis-programs) and GNAT Programming Studio (package gnat-gps). It is
 licensed under the pure GPL; all programs that use it must also be
 distributed under the GPL, or not distributed at all.
 .
 This package contains the development files and static library.

Package: libgnatprj`'GNAT_V`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
'))`'dnl
Priority: PRI(optional)
Section: ifdef(`TARGET',`devel',`libs')
Depends: BASEDEP, libgnat`'-GNAT_V`'LS (= ${gnat:Version}), libgnatvsn`'GNAT_V`'LS (= ${gnat:Version}), ${misc:Depends}
BUILT_USING`'dnl
Description: GNU Ada compiler Project Manager (shared library)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 GNAT uses project files to organise source and object files in large-scale
 development efforts. The libgnatprj library exports GNAT project files
 management for use in other packages, most notably ASIS tools (package
 asis-programs) and GNAT Programming Studio (package gnat-gps). It is
 licensed under the pure GPL; all programs that use it must also be
 distributed under the GPL, or not distributed at all.
 .
 This package contains the runtime shared library.

Package: libgnatprj`'GNAT_V-dbg`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
'))`'dnl
Priority: extra
Section: debug
Depends: BASEDEP, libgnatprj`'GNAT_V`'LS (= ${gnat:Version}), ${misc:Depends}
Suggests: gnat
BUILT_USING`'dnl
Description: GNU Ada compiler Project Manager (debugging symbols)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 GNAT uses project files to organise source and object files in large-scale
 development efforts. The libgnatprj library exports GNAT project files
 management for use in other packages, most notably ASIS tools (package
 asis-programs) and GNAT Programming Studio (package gnat-gps). It is
 licensed under the pure GPL; all programs that use it must also be
 distributed under the GPL, or not distributed at all.
 .
 This package contains the debugging symbols.
')`'dnl libgnat

ifenabled(`lib64gnat',`
Package: lib64gnat`'-GNAT_V
Section: libs
Architecture: biarch64_archs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: runtime for applications compiled with GNAT (64 bits shared library)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 The libgnat library provides runtime components needed by most
 applications produced with GNAT.
 .
 This package contains the runtime shared library for 64 bits architectures.
')`'dnl libgnat

ifenabled(`gfdldoc',`
Package: gnat`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: dpkg (>= 1.15.4) | install-info, ${misc:Depends}
Suggests: gnat`'PV
Conflicts: gnat-4.1-doc, gnat-4.2-doc, gnat-4.3-doc, gnat-4.4-doc, gnat-4.6-doc
BUILT_USING`'dnl
Description: GNU Ada compiler (documentation)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 The libgnat library provides runtime components needed by most
 applications produced with GNAT.
 .
 This package contains the documentation in info `format'.
')`'dnl gfdldoc
')`'dnl ada

ifenabled(`d ',`
Package: gdc`'PV`'TS
Architecture: any
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: SOFTBASEDEP, g++`'PV`'TS (>= ${gcc:SoftVersion}), ${dep:gdccross}, ${dep:phobosdev}, ${shlibs:Depends}, ${misc:Depends}
Provides: gdc, d-compiler, d-v2-compiler
Replaces: gdc (<< 4.4.6-5)
BUILT_USING`'dnl
Description: GNU D compiler (version 2), based on the GCC backend
 This is the GNU D compiler, which compiles D on platforms supported by gcc.
 It uses the gcc backend to generate optimised code.
 .
 This compiler supports D language version 2.

ifenabled(`libphobos',`
Package: libphobos`'PV-dev`'LS
Architecture: ifdef(`TARGET',`CROSS_ARCH',`libphobos_archs')
Section: libdevel
Priority: PRI(optional)
Depends: BASEDEP, zlib1g-dev, ${shlibs:Depends}, ${misc:Depends}
Provides: libphobos-dev
BUILT_USING`'dnl
Description: Phobos D standard library
 This is the Phobos standard library that comes with the D2 compiler.
 .
 For more information check http://www.dlang.org/phobos/

Package: libphobos`'PHOBOS_V`'PV`'TS-dbg
Section: debug
Architecture: ifdef(`TARGET',`CROSS_ARCH',`libphobos_archs')
Priority: extra
Depends: BASEDEP, libphobos`'PHOBOS_V`'PV-dev (= ${gdc:Version}), ${misc:Depends}
Provides: libphobos`'PHOBOS_V`'TS-dbg
BUILT_USING`'dnl
Description: The Phobos D standard library (debug symbols)
 This is the Phobos standard library that comes with the D2 compiler.
 .
 For more information check http://www.dlang.org/phobos/
')`'dnl libphobos
')`'dnl d

ifdef(`TARGET',`',`dnl
ifenabled(`libs',`
Package: gcc`'PV-soft-float
Architecture: arm armel armhf
Priority: PRI(optional)
Depends: BASEDEP, depifenabled(`cdev',`gcc`'PV (= ${gcc:Version}),') ${shlibs:Depends}, ${misc:Depends}
Conflicts: gcc-4.4-soft-float, gcc-4.5-soft-float, gcc-4.6-soft-float
BUILT_USING`'dnl
Description: GCC soft-floating-point gcc libraries (ARM)
 These are versions of basic static libraries such as libgcc.a compiled
 with the -msoft-float option, for CPUs without a floating-point unit.
')`'dnl commonlibs
')`'dnl

ifenabled(`fixincl',`
Package: fixincludes
Architecture: any
Priority: PRI(optional)
Depends: BASEDEP, gcc`'PV (= ${gcc:Version}), ${shlibs:Depends}, ${misc:Depends}
BUILT_USING`'dnl
Description: Fix non-ANSI header files
 FixIncludes was created to fix non-ANSI system header files. Many
 system manufacturers supply proprietary headers that are not ANSI compliant.
 The GNU compilers cannot compile non-ANSI headers. Consequently, the
 FixIncludes shell script was written to fix the header files.
 .
 Not all packages with header files are installed on the system, when the
 package is built, so we make fixincludes available at build time of other
 packages, such that checking tools like lintian can make use of it.
')`'dnl fixincl

ifenabled(`cdev',`
ifdef(`TARGET', `', `
ifenabled(`gfdldoc',`
Package: gcc`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: gcc`'PV-base (>= ${gcc:SoftVersion}), dpkg (>= 1.15.4) | install-info, ${misc:Depends}
Conflicts: gcc-docs (<< 2.95.2)
Replaces: gcc (<=2.7.2.3-4.3), gcc-docs (<< 2.95.2)
Description: Documentation for the GNU compilers (gcc, gobjc, g++)
 Documentation for the GNU compilers in info `format'.
')`'dnl gfdldoc
')`'dnl native
')`'dnl cdev

ifdef(`TARGET',`',`dnl
ifenabled(`libnof',`
Package: gcc`'PV-nof
Architecture: powerpc
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}ifenabled(`cdev',`, gcc`'PV (= ${gcc:Version})'), ${misc:Depends}
Conflicts: gcc-3.2-nof
BUILT_USING`'dnl
Description: GCC no-floating-point gcc libraries (powerpc)
 These are versions of basic static libraries such as libgcc.a compiled
 with the -msoft-float option, for CPUs without a floating-point unit.
')`'dnl libnof
')`'dnl

ifenabled(`source',`
Package: gcc`'PV-source
Architecture: all
Priority: PRI(optional)
Depends: make (>= 3.81), autoconf2.64, quilt, patchutils, gawk, ${misc:Depends}
Description: Source of the GNU Compiler Collection
 This package contains the sources and patches which are needed to
 build the GNU Compiler Collection (GCC).
')`'dnl source
dnl
')`'dnl gcc-X.Y
dnl last line in file
