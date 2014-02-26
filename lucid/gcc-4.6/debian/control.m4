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

define(`ifenabled', `ifelse(index(enabled_languages, `$1'), -1, `dnl', `$2')')

divert`'dnl
dnl --------------------------------------------------------------------------
Source: SRCNAME
Section: devel
Priority: PRI(optional)
ifelse(DIST,`Ubuntu',`dnl
ifelse(regexp(SRCNAME, `gnat\|gdc-'),0,`dnl
Maintainer: Ubuntu MOTU Developers <ubuntu-motu@lists.ubuntu.com>
', `dnl
Maintainer: Ubuntu Core developers <ubuntu-devel-discuss@lists.ubuntu.com>
')dnl SRCNAME
XSBC-Original-Maintainer: MAINTAINER
', `dnl
Maintainer: MAINTAINER
')dnl DIST
ifelse(regexp(SRCNAME, `gnat'),0,`dnl
Uploaders: Ludovic Brenta <lbrenta@debian.org>
', regexp(SRCNAME, `gdc'),0,`dnl
Uploaders: Iain Buclaw <ibuclaw@ubuntu.com>, Arthur Loiret <aloiret@debian.org>
', `dnl
Uploaders: Matthias Klose <doko@debian.org>, Arthur Loiret <aloiret@debian.org>
')dnl SRCNAME
Standards-Version: 3.9.3
ifdef(`TARGET',`dnl cross
Build-Depends: DPKG_BUILD_DEP debhelper (>= 5.0.62), LIBC_BUILD_DEP, LIBC_BIARCH_BUILD_DEP LIBUNWIND_BUILD_DEP LIBATOMIC_OPS_BUILD_DEP AUTOGEN_BUILD_DEP AUTO_BUILD_DEP SOURCE_BUILD_DEP CROSS_BUILD_DEP CLOOG_BUILD_DEP MPC_BUILD_DEP MPFR_BUILD_DEP GMP_BUILD_DEP ELF_BUILD_DEP, zlib1g-dev, gawk, lzma, xz-utils, patchutils, BINUTILS_BUILD_DEP, bison (>= 1:2.3), flex, realpath (>= 1.9.12), lsb-release, make (>= 3.81), quilt
',`dnl native
Build-Depends: DPKG_BUILD_DEP debhelper (>= 5.0.62), GCC_MULTILIB_BUILD_DEP LIBC_BUILD_DEP, LIBC_BIARCH_BUILD_DEP AUTO_BUILD_DEP AUTOGEN_BUILD_DEP libunwind7-dev (>= 0.98.5-6) [ia64], libatomic-ops-dev [ia64], zlib1g-dev, gawk, lzma, xz-utils, patchutils, BINUTILS_BUILD_DEP, binutils-hppa64 (>= BINUTILSV) [hppa], gperf (>= 3.0.1), bison (>= 1:2.3), flex, gettext, texinfo (>= 4.3), FORTRAN_BUILD_DEP locales [locale_no_archs], procps, sharutils, JAVA_BUILD_DEP GNAT_BUILD_DEP GDC_BUILD_DEP SPU_BUILD_DEP CLOOG_BUILD_DEP MPC_BUILD_DEP MPFR_BUILD_DEP GMP_BUILD_DEP ELF_BUILD_DEP CHECK_BUILD_DEP realpath (>= 1.9.12), chrpath, lsb-release, make (>= 3.81), quilt
Build-Depends-Indep: LIBSTDCXX_BUILD_INDEP JAVA_BUILD_INDEP
')dnl
Build-Conflicts: binutils-gold
ifelse(regexp(SRCNAME, `gnat'),0,`dnl
Homepage: http://gcc.gnu.org/
', regexp(SRCNAME, `gdc'),0,`dnl
Homepage: http://bitbucket.org/goshawk/gdc/
', `dnl
Homepage: http://gcc.gnu.org/
')dnl SRCNAME
XS-Vcs-Browser: http://svn.debian.org/viewsvn/gcccvs/branches/sid/gcc`'PV/
XS-Vcs-Svn: svn://svn.debian.org/svn/gcccvs/branches/sid/gcc`'PV

ifelse(regexp(SRCNAME, `gcc-snapshot'),0,`dnl
Package: gcc-snapshot`'TS
Architecture: any
Section: devel
Priority: extra
Depends: binutils`'TS (>= ${binutils:Version}), ${dep:libcbiarchdev}, ${dep:libcdev}, ${dep:libunwinddev}, ${snap:depends}, ${shlibs:Depends}, ${dep:ecj}, python, ${misc:Depends}
Recommends: ${snap:recommends}
Suggests: ${dep:gold}
Provides: c++-compiler`'TS`'ifdef(`TARGET)',`',`, c++abi2-dev')
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
Breaks: gcj-4.6-base (<< 4.6.1-4~), gnat-4.6 (<< 4.6.1-5~), dehydra (<= 0.9.hg20110609-2)
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
Description: GCC, the GNU Compiler Collection (base package)
 This package contains files common to all languages and libraries
 contained in the GNU Compiler Collection (GCC).
')`'dnl

ifenabled(`java',`
Package: gcj`'PV-base
Architecture: any
Section: libs
Priority: PRI(optional)
Depends: ${misc:Depends}
Description: GCC, the GNU Compiler Collection (gcj base package)
 This package contains files common to all java related packages
 built from the GNU Compiler Collection (GCC).
')`'dnl java

ifenabled(`ada',`
Package: gnat`'PV-base
Architecture: any
Section: libs
Priority: PRI(optional)
Depends: ${misc:Depends}
Breaks: gcc-4.6 (<< 4.6.1-8~)
Description: GNU Ada compiler (common files)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 This package contains files common to all GNAT related packages.
')`'dnl ada

ifenabled(`libgcc',`
Package: libgcc1`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',required)
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libgcc1-TARGET-dcv1',
ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
Breaks: ${multiarch:breaks}
')`Provides: libgcc1-armel [armel], libgcc1-armhf [armhf]')
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
Architecture: ifdef(`TARGET',`all',`any')
Section: debug
Priority: extra
Depends: BASEDEP, libgcc1`'LS (= ${gcc:EpochVersion}), ${misc:Depends}
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same'))
ifdef(`TARGET',`dnl',`Provides: libgcc1-dbg-armel [armel], libgcc1-dbg-armhf [armhf]')
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libgcc2`'LS
Architecture: ifdef(`TARGET',`all',`m68k')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',required)
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libgcc2-TARGET-dcv1
',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
Breaks: ${multiarch:breaks}
'))`'dnl
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
Architecture: ifdef(`TARGET',`all',`m68k')
Section: debug
Priority: extra
Depends: BASEDEP, libgcc2`'LS (= ${gcc:Version}), ${misc:Depends}
ifdef(`TARGET',`',ifdef(`MULTIARCH', `Multi-Arch: same
'))`'dnl
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libgcc

ifenabled(`lib4gcc',`
Package: libgcc4`'LS
Architecture: ifdef(`TARGET',`all',`hppa')
ifdef(`TARGET',`',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
Breaks: ${multiarch:breaks}
'))`'dnl
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',required)
Depends: ifdef(`STANDALONEJAVA',`gcj`'PV-base (>= ${gcj:Version})',`BASEDEP'), ${shlibs:Depends}, ${misc:Depends}
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
Architecture: ifdef(`TARGET',`all',`hppa')
ifdef(`TARGET',`',ifdef(`MULTIARCH', `Multi-Arch: same
'))`'dnl
Section: debug
Priority: extra
Depends: BASEDEP, libgcc4`'LS (= ${gcc:Version}), ${misc:Depends}
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
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${misc:Depends}
ifdef(`TARGET',`Provides: lib64gcc1-TARGET-dcv1
',`')`'dnl
Conflicts: libgcc`'GCC_SO`'LS (<= 1:3.3-0pre9)
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
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Section: debug
Priority: extra
Depends: BASEDEP, lib64gcc1`'LS (= ${gcc:EpochVersion}), ${misc:Depends}
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl lib64gcc

ifenabled(`lib32gcc',`
Package: lib32gcc1`'LS
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: extra
Depends: BASEDEP, ${dep:libcbiarch}, ${misc:Depends}
Conflicts: ${confl:lib32}
ifdef(`TARGET',`Provides: lib32gcc1-TARGET-dcv1
',`')`'dnl
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
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, lib32gcc1`'LS (= ${gcc:EpochVersion}), ${misc:Depends}
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl lib32gcc1

ifenabled(`libneongcc',`
Package: libgcc1-neon`'LS
Architecture: NEON_ARCHS
Section: libs
Priority: extra
Depends: BASEDEP, libc6-neon`'LS, ${shlibs:Depends}, ${misc:Depends}
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
Architecture: ifdef(`TARGET',`all',`biarchhf_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${misc:Depends}
ifdef(`TARGET',`Provides: libhfgcc1-TARGET-dcv1
',`Conflicts: libgcc1-armhf [biarchhf_archs]
')`'dnl
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
Architecture: ifdef(`TARGET',`all',`biarchhf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libhfgcc1`'LS (= ${gcc:EpochVersion}), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgcc1-dbg-armhf [biarchhf_archs]')
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libhfgcc

ifenabled(`libsfgcc',`
Package: libsfgcc1`'LS
Architecture: ifdef(`TARGET',`all',`biarchsf_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${misc:Depends}
ifdef(`TARGET',`Provides: libsfgcc1-TARGET-dcv1
',`Conflicts: libgcc1-armel [biarchsf_archs]
')`'dnl
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
Architecture: ifdef(`TARGET',`all',`biarchsf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libsfgcc1`'LS (= ${gcc:EpochVersion}), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgcc1-dbg-armel [biarchsf_archs]')
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libsfgcc

ifenabled(`libn32gcc',`
Package: libn32gcc1`'LS
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${misc:Depends}
ifdef(`TARGET',`Provides: libn32gcc1-TARGET-dcv1
',`')`'dnl
Conflicts: libgcc`'GCC_SO`'LS (<= 1:3.3-0pre9)
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
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libn32gcc1`'LS (= ${gcc:EpochVersion}), ${misc:Depends}
Description: GCC support library (debug symbols)`'ifdef(`TARGET)',` (TARGET)', `')
 Debug symbols for the GCC support library.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libn32gcc

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
Description: GCC math support library
 Support library for GCC.

Package: lib32gccmath`'GCCMATH_SO`'LS
Architecture: amd64
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
Description: GCC math support library (32bit)
 Support library for GCC.

Package: lib64gccmath`'GCCMATH_SO`'LS
Architecture: i386
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
Description: GCC math support library (64bit)
 Support library for GCC.
')`'dnl
')`'dnl native

ifenabled(`cdev',`
Package: gcc`'PV`'TS
Architecture: any
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, cpp`'PV`'TS (= ${gcc:Version}), binutils`'TS (>= ${binutils:Version}), ${dep:libgcc}, ${dep:libssp}, ${dep:libgomp}, ${dep:libqmath}, ${dep:libunwinddev}, ${shlibs:Depends}, ${misc:Depends}
Recommends: ${dep:libcdev}
Suggests: ${gcc:multilib}, libmudflap`'MF_SO`'PV-dev`'LS (>= ${gcc:Version}), gcc`'PV-doc (>= ${gcc:SoftVersion}), gcc`'PV-locales (>= ${gcc:SoftVersion}), libgcc`'GCC_SO-dbg`'LS, libgomp`'GOMP_SO-dbg`'LS, libquadmath`'QMATH_SO-dbg`'LS, libmudflap`'MF_SO-dbg`'LS, ${dep:libcloog}, ${dep:gold}
Provides: c-compiler`'TS
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
Depends: BASEDEP, gcc`'PV`'TS (= ${gcc:Version}), ${dep:libcbiarchdev}, ${dep:libgccbiarch}, ${dep:libsspbiarch}, ${dep:libgompbiarch}, ${dep:libqmathbiarch}, ${shlibs:Depends}, ${misc:Depends}
Suggests: ${dep:libmudflapbiarch}
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
Description: GNU C compiler (cross compiler for hppa64)
 This is the GNU C compiler, a fairly portable optimizing compiler for C.

ifdef(`TARGET', `', `
Package: gcc`'PV-spu
Architecture: powerpc ppc64
Section: devel
Priority: PRI(optional)
Depends: BASEDEP, binutils-spu (>= 2.18.1~cvs20080103-3), newlib-spu, ${shlibs:Depends}, ${misc:Depends}
Provides: spu-gcc
Description: SPU cross-compiler (preprocessor and C compiler)
 GNU Compiler Collection for the Cell Broadband Engine SPU (preprocessor
 and C compiler).

Package: g++`'PV-spu
Architecture: powerpc ppc64
Section: devel
Priority: PRI(optional)
Depends: BASEDEP, gcc`'PV-spu (= ${gcc:Version}), ${shlibs:Depends}, ${misc:Depends}
Provides: spu-g++
Description: SPU cross-compiler (C++ compiler)
 GNU Compiler Collection for the Cell Broadband Engine SPU (C++ compiler).

Package: gfortran`'PV-spu
Architecture: powerpc ppc64
Section: devel
Priority: PRI(optional)
Depends: BASEDEP, gcc`'PV-spu (= ${gcc:Version}), ${shlibs:Depends}, ${misc:Depends}
Provides: spu-gfortran
Description: SPU cross-compiler (Fortran compiler)
 GNU Compiler Collection for the Cell Broadband Engine SPU (Fortran compiler).

')`'dnl native
')`'dnl cdev

ifenabled(`cdev',`
Package: cpp`'PV`'TS
Architecture: any
Section: ifdef(`TARGET',`devel',`interpreters')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
Suggests: gcc`'PV-locales (>= ${gcc:SoftVersion})
Replaces: gcc-4.6 (<< 4.6.1-9)
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
Depends: BASEDEP, gcc`'PV`'TS (= ${gcc:Version}), libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version}), ${shlibs:Depends}, ${misc:Depends}
Provides: c++-compiler`'TS`'ifdef(`TARGET)',`',`, c++abi2-dev')
Suggests: ${gxx:multilib}, gcc`'PV-doc (>= ${gcc:SoftVersion}), libstdc++CXX_SO`'PV-dbg`'LS
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
Depends: BASEDEP, g++`'PV`'TS (= ${gcc:Version}), gcc`'PV-multilib`'TS (= ${gcc:Version}), ${dep:libcxxbiarch}, ${shlibs:Depends}, ${misc:Depends}
Suggests: ${dep:libcxxbiarchdbg}
Description: GNU C++ compiler (multilib files)`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU C++ compiler, a fairly portable optimizing compiler for C++.
 .
 On architectures with multilib support, the package contains files
 and dependencies for the non-default multilib architecture(s).
')`'dnl multilib
')`'dnl c++dev
')`'dnl c++

ifenabled(`mudflap',`
ifenabled(`libmudf',`
Package: libmudflap`'MF_SO`'LS
Architecture: ifdef(`TARGET',`all',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
Breaks: ${multiarch:breaks}
')`Provides: libmudflap'MF_SO`-armel [armel], libmudflap'MF_SO`-armhf [armhf]')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
Description: GCC mudflap shared support libraries
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.

Package: libmudflap`'MF_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
')`Provides: libmudflap'MF_SO`-dbg-armel [armel], libmudflap'MF_SO`-dbg-armhf [armhf]')
Section: debug
Priority: extra
Depends: BASEDEP, libmudflap`'MF_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: GCC mudflap shared support libraries (debug symbols)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.

Package: lib32mudflap`'MF_SO`'LS
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Replaces: libmudflap0 (<< 4.1)
Conflicts: ${confl:lib32}
Description: GCC mudflap shared support libraries (32bit)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.

Package: lib32mudflap`'MF_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, lib32mudflap`'MF_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: GCC mudflap shared support libraries (32 bit debug symbols)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.

Package: lib64mudflap`'MF_SO`'LS
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Replaces: libmudflap0 (<< 4.1)
Description: GCC mudflap shared support libraries (64bit)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.

Package: lib64mudflap`'MF_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Section: debug
Priority: extra
Depends: BASEDEP, lib64mudflap`'MF_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: GCC mudflap shared support libraries (64 bit debug symbols)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.

Package: libn32mudflap`'MF_SO`'LS
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Replaces: libmudflap0 (<< 4.1)
Description: GCC mudflap shared support libraries (n32)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.

Package: libn32mudflap`'MF_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libn32mudflap`'MF_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: GCC mudflap shared support libraries (n32 debug symbols)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.

ifenabled(`libhfmudflap',`
Package: libhfmudflap`'MF_SO`'LS
Architecture: ifdef(`TARGET',`all',`biarchhf_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
ifdef(`TARGET',`dnl',`Conflicts: libmudflap`'MF_SO`'-armhf [biarchhf_archs]')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: GCC mudflap shared support libraries (hard float)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.

Package: libhfmudflap`'MF_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarchhf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libhfmudflap`'MF_SO`'LS (= ${gcc:Version}), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libmudflap`'MF_SO`'-dbg-armhf [biarchhf_archs]')
Description: GCC mudflap shared support libraries (hard float debug symbols)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.
')`'dnl libhfmudflap

ifenabled(`libsfmudflap',`
Package: libsfmudflap`'MF_SO`'LS
Architecture: ifdef(`TARGET',`all',`biarchsf_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libmudflap`'MF_SO`'-armel [biarchsf_archs]')
Description: GCC mudflap shared support libraries (soft float)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.

Package: libsfmudflap`'MF_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarchsf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libsfmudflap`'MF_SO`'LS (= ${gcc:Version}), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libmudflap`'MF_SO`'-dbg-armel [biarchsf_archs]')
Description: GCC mudflap shared support libraries (soft float debug symbols)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.
')`'dnl libsfmudflap
')`'dnl libmudf

Package: libmudflap`'MF_SO`'PV-dev`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, libmudflap`'MF_SO`'LS (>= ${gcc:Version}), ${dep:libcdev}, ${shlibs:Depends}, ${misc:Depends}
Suggests: ${sug:libmudflapdev}
Conflicts: libmudflap0-dev
Description: GCC mudflap support libraries (development files)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.
 .
 This package contains the headers and the static libraries.
')`'dnl mudflap

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
Description: GCC stack smashing protection library (n32)
 GCC can now emit code for protecting applications from stack-smashing attacks.
 The protection is realized by buffer overflow detection and reordering of
 stack variables to avoid pointer corruption.

Package: libhfssp`'SSP_SO`'LS
Architecture: biarchhf_archs
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: GCC stack smashing protection library (hard float ABI)
 GCC can now emit code for protecting applications from stack-smashing attacks.
 The protection is realized by buffer overflow detection and reordering of
 stack variables to avoid pointer corruption.

Package: libsfssp`'SSP_SO`'LS
Architecture: biarchsf_archs
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: GCC stack smashing protection library (soft float ABI)
 GCC can now emit code for protecting applications from stack-smashing attacks.
 The protection is realized by buffer overflow detection and reordering of
 stack variables to avoid pointer corruption.
')`'dnl
')`'dnl native

ifenabled(`libgomp',`
Package: libgomp`'GOMP_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
Breaks: ${multiarch:breaks}
')`Provides: libgomp'GOMP_SO`-armel [armel], libgomp'GOMP_SO`-armhf [armhf]')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
Description: GCC OpenMP (GOMP) support library
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: libgomp`'GOMP_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: debug
Priority: extra
Depends: BASEDEP, libgomp`'GOMP_SO`'LS (= ${gcc:Version}), ${misc:Depends}
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
')`Provides: libgomp'GOMP_SO`-dbg-armel [armel], libgomp'GOMP_SO`-dbg-armhf [armhf]')
Description: GCC OpenMP (GOMP) support library (debug symbols)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: lib32gomp`'GOMP_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
Description: GCC OpenMP (GOMP) support library (32bit)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: lib32gomp`'GOMP_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, lib32gomp`'GOMP_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: GCC OpenMP (GOMP) support library (32 bit debug symbols)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: lib64gomp`'GOMP_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: GCC OpenMP (GOMP) support library (64bit)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: lib64gomp`'GOMP_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Section: debug
Priority: extra
Depends: BASEDEP, lib64gomp`'GOMP_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: GCC OpenMP (GOMP) support library (64bit debug symbols)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: libn32gomp`'GOMP_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: GCC OpenMP (GOMP) support library (n32)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: libn32gomp`'GOMP_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libn32gomp`'GOMP_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: GCC OpenMP (GOMP) support library (n32 debug symbols)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers

ifenabled(`libhfgomp',`
Package: libhfgomp`'GOMP_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarchhf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgomp'GOMP_SO`-armhf [biarchhf_archs]')
Description: GCC OpenMP (GOMP) support library (hard float ABI)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: libhfgomp`'GOMP_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarchhf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libhfgomp`'GOMP_SO`'LS (= ${gcc:Version}), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgomp'GOMP_SO`-dbg-armhf [biarchhf_archs]')
Description: GCC OpenMP (GOMP) support library (hard float ABI debug symbols)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
')`'dnl libhfgomp

ifenabled(`libsfgomp',`
Package: libsfgomp`'GOMP_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarchsf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgomp'GOMP_SO`-armel [biarchsf_archs]')
Description: GCC OpenMP (GOMP) support library (soft float ABI)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.

Package: libsfgomp`'GOMP_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarchsf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libsfgomp`'GOMP_SO`'LS (= ${gcc:Version}), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgomp'GOMP_SO`-dbg-armel [biarchsf_archs]')
Description: GCC OpenMP (GOMP) support library (soft float ABI debug symbols)
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
')`'dnl libsfgomp

ifenabled(`libneongomp',`
Package: libgomp`'GOMP_SO-neon`'LS
Architecture: NEON_ARCHS
Section: libs
Priority: extra
Depends: BASEDEP, libc6-neon`'LS, ${shlibs:Depends}, ${misc:Depends}
Description: GCC OpenMP (GOMP) support library [neon optimized]
 GOMP is an implementation of OpenMP for the C, C++, and Fortran compilers
 in the GNU Compiler Collection.
 .
 This set of libraries is optimized to use a NEON coprocessor, and will
 be selected instead when running under systems which have one.
')`'dnl libneongomp
')`'dnl libgomp

ifenabled(`libqmath',`
Package: libquadmath`'QMATH_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
'))`'dnl
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
Description: GCC Quad-Precision Math Library
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype. The library is used to provide on such
 targets the REAL(16) type in the GNU Fortran compiler.

Package: libquadmath`'QMATH_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: debug
Priority: extra
Depends: BASEDEP, libquadmath`'QMATH_SO`'LS (= ${gcc:Version}), ${misc:Depends}
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
'))`'dnl
Description: GCC Quad-Precision Math Library (debug symbols)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype.

Package: lib32quadmath`'QMATH_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
Description: GCC Quad-Precision Math Library (32bit)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype. The library is used to provide on such
 targets the REAL(16) type in the GNU Fortran compiler.

Package: lib32quadmath`'QMATH_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, lib32quadmath`'QMATH_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: GCC Quad-Precision Math Library (32 bit debug symbols)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype.

Package: lib64quadmath`'QMATH_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: GCC Quad-Precision Math Library  (64bit)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype. The library is used to provide on such
 targets the REAL(16) type in the GNU Fortran compiler.

Package: lib64quadmath`'QMATH_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Section: debug
Priority: extra
Depends: BASEDEP, lib64quadmath`'QMATH_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: GCC Quad-Precision Math Library  (64bit debug symbols)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype.

Package: libn32quadmath`'QMATH_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: GCC Quad-Precision Math Library (n32)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype. The library is used to provide on such
 targets the REAL(16) type in the GNU Fortran compiler.

Package: libn32quadmath`'QMATH_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libn32quadmath`'QMATH_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: GCC Quad-Precision Math Library (n32 debug symbols)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype.

ifenabled(`libhfqmath',`
Package: libhfquadmath`'QMATH_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarchhf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: GCC Quad-Precision Math Library (hard float ABI)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype. The library is used to provide on such
 targets the REAL(16) type in the GNU Fortran compiler.

Package: libhfquadmath`'QMATH_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarchhf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libhfquadmath`'QMATH_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: GCC Quad-Precision Math Library (hard float ABI debug symbols)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype.
')`'dnl libhfqmath

ifenabled(`libsfqmath',`
Package: libsfquadmath`'QMATH_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarchsf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: GCC Quad-Precision Math Library (soft float ABI)
 A library, which provides quad-precision mathematical functions on targets
 supporting the __float128 datatype. The library is used to provide on such
 targets the REAL(16) type in the GNU Fortran compiler.

Package: libsfquadmath`'QMATH_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarchsf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libsfquadmath`'QMATH_SO`'LS (= ${gcc:Version}), ${misc:Depends}
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
Depends: BASEDEP, gobjc`'PV`'TS (= ${gcc:Version}), g++`'PV`'TS (= ${gcc:Version}), ${shlibs:Depends}, libobjc`'OBJC_SO`'LS (>= ${gcc:Version}), ${misc:Depends}
Suggests: ${gobjcxx:multilib}, gcc`'PV-doc (>= ${gcc:SoftVersion})
Provides: objc++-compiler`'TS
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
Depends: BASEDEP, gcc`'PV`'TS (= ${gcc:Version}), ${dep:libcdev}, ${shlibs:Depends}, libobjc`'OBJC_SO`'LS (>= ${gcc:Version}), ${misc:Depends}
Suggests: ${gobjc:multilib}, gcc`'PV-doc (>= ${gcc:SoftVersion}), libobjc`'OBJC_SO-dbg`'LS
Provides: objc-compiler`'TS
ifdef(`__sparc__',`Conflicts: gcc`'PV-sparc64', `dnl')
Description: GNU Objective-C compiler
 This is the GNU Objective-C compiler, which compiles
 Objective-C on platforms supported by the gcc compiler. It uses the
 gcc backend to generate optimized code.

ifenabled(`multilib',`
Package: gobjc`'PV-multilib`'TS
Architecture: ifdef(`TARGET',`any',MULTILIB_ARCHS)
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gobjc`'PV`'TS (= ${gcc:Version}), gcc`'PV-multilib`'TS (= ${gcc:Version}), ${dep:libobjcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: GNU Objective-C compiler (multilib files)`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU Objective-C compiler, which compiles Objective-C on platforms
 supported by the gcc compiler.
 .
 On architectures with multilib support, the package contains files
 and dependencies for the non-default multilib architecture(s).
')`'dnl multilib
')`'dnl objcdev

ifenabled(`libobjc',`
Package: libobjc`'OBJC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
ifelse(OBJC_SO,`2',`Breaks: ${multiarch:breaks}
',`')')`Provides: libobjc'OBJC_SO`-armel [armel], libobjc'OBJC_SO`-armhf [armhf]')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
Description: Runtime library for GNU Objective-C applications
 Library needed for GNU ObjC applications linked against the shared library.

Package: libobjc`'OBJC_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
')`Provides: libobjc'OBJC_SO`-dbg-armel [armel], libobjc'OBJC_SO`-dbg-armhf [armhf]')
Priority: extra
Depends: BASEDEP, libobjc`'OBJC_SO`'LS (= ${gcc:Version}), libgcc`'GCC_SO-dbg`'LS, ${misc:Depends}
Description: Runtime library for GNU Objective-C applications (debug symbols)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl libobjc

ifenabled(`lib64objc',`
Package: lib64objc`'OBJC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: Runtime library for GNU Objective-C applications (64bit)
 Library needed for GNU ObjC applications linked against the shared library.

Package: lib64objc`'OBJC_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Priority: extra
Depends: BASEDEP, lib64objc`'OBJC_SO`'LS (= ${gcc:Version}), lib64gcc`'GCC_SO-dbg`'LS, ${misc:Depends}
Description: Runtime library for GNU Objective-C applications (64 bit debug symbols)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl lib64objc

ifenabled(`lib32objc',`
Package: lib32objc`'OBJC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
Description: Runtime library for GNU Objective-C applications (32bit)
 Library needed for GNU ObjC applications linked against the shared library.

Package: lib32objc`'OBJC_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Priority: extra
Depends: BASEDEP, lib32objc`'OBJC_SO`'LS (= ${gcc:Version}), lib32gcc`'GCC_SO-dbg`'LS, ${misc:Depends}
Description: Runtime library for GNU Objective-C applications (32 bit debug symbols)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl lib32objc

ifenabled(`libn32objc',`
Package: libn32objc`'OBJC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: Runtime library for GNU Objective-C applications (n32)
 Library needed for GNU ObjC applications linked against the shared library.

Package: libn32objc`'OBJC_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Priority: extra
Depends: BASEDEP, libn32objc`'OBJC_SO`'LS (= ${gcc:Version}), libn32gcc`'GCC_SO-dbg`'LS, ${misc:Depends}
Description: Runtime library for GNU Objective-C applications (n32 debug symbols)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl libn32objc

ifenabled(`libhfobjc',`
Package: libhfobjc`'OBJC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarchhf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libobjc'OBJC_SO`-armhf [biarchhf_archs]')
Description: Runtime library for GNU Objective-C applications (hard float ABI)
 Library needed for GNU ObjC applications linked against the shared library.

Package: libhfobjc`'OBJC_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`biarchhf_archs')
Priority: extra
Depends: BASEDEP, libhfobjc`'OBJC_SO`'LS (= ${gcc:Version}), libhfgcc`'GCC_SO-dbg`'LS, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libobjc'OBJC_SO`-dbg-armhf [biarchhf_archs]')
Description: Runtime library for GNU Objective-C applications (hard float ABI debug symbols)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl libhfobjc

ifenabled(`libsfobjc',`
Package: libsfobjc`'OBJC_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarchsf_archs')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libobjc'OBJC_SO`-armel [biarchsf_archs]')
Description: Runtime library for GNU Objective-C applications (soft float ABI)
 Library needed for GNU ObjC applications linked against the shared library.

Package: libsfobjc`'OBJC_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`biarchsf_archs')
Priority: extra
Depends: BASEDEP, libsfobjc`'OBJC_SO`'LS (= ${gcc:Version}), libsfgcc`'GCC_SO-dbg`'LS, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libobjc'OBJC_SO`-dbg-armel [biarchsf_archs]')
Description: Runtime library for GNU Objective-C applications (soft float ABI debug symbols)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl libsfobjc

ifenabled(`libneonobjc',`
Package: libobjc`'OBJC_SO-neon`'LS
Section: libs
Architecture: NEON_ARCHS
Priority: PRI(optional)
Depends: BASEDEP, libc6-neon`'LS, ${shlibs:Depends}, ${misc:Depends}
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
Depends: BASEDEP, gcc`'PV`'TS (= ${gcc:Version}), libgfortran`'FORTRAN_SO`'LS (>= ${gcc:Version}), ${dep:libcdev}, ${shlibs:Depends}, ${misc:Depends}
Provides: fortran95-compiler
Suggests: ${gfortran:multilib}, gfortran`'PV-doc, libgfortran`'FORTRAN_SO-dbg`'LS
Replaces: libgfortran`'FORTRAN_SO-dev
Description: GNU Fortran compiler
 This is the GNU Fortran compiler, which compiles
 Fortran on platforms supported by the gcc compiler. It uses the
 gcc backend to generate optimized code.

ifenabled(`multilib',`
Package: gfortran`'PV-multilib`'TS
Architecture: ifdef(`TARGET',`any',MULTILIB_ARCHS)
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gfortran`'PV`'TS (= ${gcc:Version}), gcc`'PV-multilib`'TS (= ${gcc:Version}), ${dep:libgfortranbiarch}, ${shlibs:Depends}, ${misc:Depends}
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
')`'dnl fdev

ifenabled(`libgfortran',`
Package: libgfortran`'FORTRAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
Breaks: ${multiarch:breaks}
')`Provides: libgfortran'FORTRAN_SO`-armel [armel], libgfortran'FORTRAN_SO`-armhf [armhf]')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
Description: Runtime library for GNU Fortran applications
 Library needed for GNU Fortran applications linked against the
 shared library.

Package: libgfortran`'FORTRAN_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
')`Provides: libgfortran'FORTRAN_SO`-dbg-armel [armel], libgfortran'FORTRAN_SO`-dbg-armhf [armhf]')
Priority: extra
Depends: BASEDEP, libgfortran`'FORTRAN_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: Runtime library for GNU Fortran applications (debug symbols)
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl libgfortran

ifenabled(`lib64gfortran',`
Package: lib64gfortran`'FORTRAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: Runtime library for GNU Fortran applications (64bit)
 Library needed for GNU Fortran applications linked against the
 shared library.

Package: lib64gfortran`'FORTRAN_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Priority: extra
Depends: BASEDEP, lib64gfortran`'FORTRAN_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: Runtime library for GNU Fortran applications (64bit debug symbols)
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl lib64gfortran

ifenabled(`lib32gfortran',`
Package: lib32gfortran`'FORTRAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
Description: Runtime library for GNU Fortran applications (32bit)
 Library needed for GNU Fortran applications linked against the
 shared library.

Package: lib32gfortran`'FORTRAN_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Priority: extra
Depends: BASEDEP, lib32gfortran`'FORTRAN_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: Runtime library for GNU Fortran applications (32 bit debug symbols)
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl lib32gfortran

ifenabled(`libn32gfortran',`
Package: libn32gfortran`'FORTRAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: Runtime library for GNU Fortran applications (n32)
 Library needed for GNU Fortran applications linked against the
 shared library.

Package: libn32gfortran`'FORTRAN_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Priority: extra
Depends: BASEDEP, libn32gfortran`'FORTRAN_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: Runtime library for GNU Fortran applications (n32 debug symbols)
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl libn32gfortran

ifenabled(`libhfgfortran',`
Package: libhfgfortran`'FORTRAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarchhf_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgfortran'FORTRAN_SO`-armhf [biarchhf_archs]')
Description: Runtime library for GNU Fortran applications (hard float ABI)
 Library needed for GNU Fortran applications linked against the
 shared library.

Package: libhfgfortran`'FORTRAN_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`biarchhf_archs')
Priority: extra
Depends: BASEDEP, libhfgfortran`'FORTRAN_SO`'LS (= ${gcc:Version}), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgfortran'FORTRAN_SO`-dbg-armhf [biarchhf_archs]')
Description: Runtime library for GNU Fortran applications (hard float ABI debug symbols)
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl libhfgfortran

ifenabled(`libsfgfortran',`
Package: libsfgfortran`'FORTRAN_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarchsf_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgfortran'FORTRAN_SO`-armel [biarchsf_archs]')
Description: Runtime library for GNU Fortran applications (soft float ABI)
 Library needed for GNU Fortran applications linked against the
 shared library.

Package: libsfgfortran`'FORTRAN_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`biarchsf_archs')
Priority: extra
Depends: BASEDEP, libsfgfortran`'FORTRAN_SO`'LS (= ${gcc:Version}), ${misc:Depends}
ifdef(`TARGET',`dnl',`Conflicts: libgfortran'FORTRAN_SO`-dbg-armel [biarchsf_archs]')
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
Depends: BASEDEP, gcc`'PV`'TS (= ${gcc:Version}), libgo`'GO_SO`'LS (>= ${gcc:Version}), ${dep:libcdev}, ${shlibs:Depends}, ${misc:Depends}
Provides: go-compiler
Suggests: ${go:multilib}, gccgo`'PV-doc, libgo`'GO_SO-dbg`'LS
Description: GNU Go compiler
 This is the GNU Go compiler, which compiles Go on platforms supported
 by the gcc compiler. It uses the gcc backend to generate optimized code.

ifenabled(`multilib',`
Package: gccgo`'PV-multilib`'TS
Architecture: ifdef(`TARGET',`any',MULTILIB_ARCHS)
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gccgo`'PV`'TS (= ${gcc:Version}), gcc`'PV-multilib`'TS (= ${gcc:Version}), ${dep:libgobiarch}, ${shlibs:Depends}, ${misc:Depends}
Suggests: ${dep:libgobiarchdbg}
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
Description: Documentation for the GNU Go compiler (gccgo)
 Documentation for the GNU Go compiler in info `format'.
')`'dnl gfdldoc
')`'dnl fdev

ifenabled(`libggo',`
Package: libgo`'GO_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
')`Provides: libgo'GO_SO`-armel [armel], libgo'GO_SO`-armhf [armhf]')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${shlibs:Depends}, ${misc:Depends}
Description: Runtime library for GNU Go applications
 Library needed for GNU Go applications linked against the
 shared library.

Package: libgo`'GO_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`any')
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
')`Provides: libgo'GO_SO`-dbg-armel [armel], libgo'GO_SO`-dbg-armhf [armhf]')
Priority: extra
Depends: BASEDEP, libgo`'GO_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: Runtime library for GNU Go applications (debug symbols)
 Library needed for GNU Go applications linked against the
 shared library.
')`'dnl libgo

ifenabled(`lib64go',`
Package: lib64go`'GO_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: Runtime library for GNU Go applications (64bit)
 Library needed for GNU Go applications linked against the
 shared library.

Package: lib64go`'GO_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Priority: extra
Depends: BASEDEP, lib64go`'GO_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: Runtime library for GNU Go applications (64bit debug symbols)
 Library needed for GNU Go applications linked against the
 shared library.
')`'dnl lib64go

ifenabled(`lib32go',`
Package: lib32go`'GO_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
Description: Runtime library for GNU Go applications (32bit)
 Library needed for GNU Go applications linked against the
 shared library.

Package: lib32go`'GO_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Priority: extra
Depends: BASEDEP, lib32go`'GO_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: Runtime library for GNU Go applications (32 bit debug symbols)
 Library needed for GNU Go applications linked against the
 shared library.
')`'dnl lib32go

ifenabled(`libn32go',`
Package: libn32go`'GO_SO`'LS
Section: ifdef(`TARGET',`devel',`libs')
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
Description: Runtime library for GNU Go applications (n32)
 Library needed for GNU Go applications linked against the
 shared library.

Package: libn32go`'GO_SO-dbg`'LS
Section: debug
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Priority: extra
Depends: BASEDEP, libn32go`'GO_SO`'LS (= ${gcc:Version}), ${misc:Depends}
Description: Runtime library for GNU Go applications (n32 debug symbols)
 Library needed for GNU Go applications linked against the
 shared library.
')`'dnl libn32go
')`'dnl ggo

ifenabled(`java',`
ifenabled(`gcj',`
Package: gcj`'PV-jdk
Section: java
Architecture: any
Priority: PRI(optional)
Depends: gcj`'PV-base (= ${gcj:Version}), ${dep:gcj}, ${dep:libcdev}, gcj`'PV-jre (= ${gcj:Version}), libgcj`'GCJ_SO-dev (= ${gcj:Version}), gcj`'PV-jre-lib (>= ${gcj:SoftVersion}), ${dep:ecj}, fastjar, libgcj-bc, java-common, libantlr-java, ${shlibs:Depends}, dpkg (>= 1.15.4) | install-info, ${misc:Depends}
Recommends: libecj-java-gcj
Suggests: gcj`'PV-source (>= ${gcj:SoftVersion}), libgcj`'GCJ_SO-dbg
Provides: java-compiler, java-sdk, java2-sdk, java5-sdk
Conflicts: gcj-4.4, cpp-4.1 (<< 4.1.1), gcc-4.1 (<< 4.1.1)
Replaces: libgcj11 (<< 4.5-20100101-1)
Description: gcj and classpath development tools for Java(TM)
 GCJ is a front end to the GCC compiler which can natively compile both
 Java(tm) source and bytecode files. The compiler can also generate class
 files. Other java development tools from classpath are included in this
 package.
 .
 The package contains as well a collection of wrapper scripts and symlinks.
 It is meant to provide a Java-SDK-like interface to the GCJ tool set.
')`'dnl gcj

ifenabled(`libgcj',`
ifenabled(`libgcjcommon',`
Package: libgcj-common
Section: java
Architecture: all
Priority: PRI(optional)
Depends: gcj`'PV-base (>= ${gcj:SoftVersion}), ${misc:Depends}
Conflicts: classpath (<= 0.04-4)
Replaces: java-gcj-compat (<< 1.0.65-3), java-gcj-compat-dev (<< 1.0.65-3)
Description: Java runtime library (common files)
 This package contains files shared by classpath and libgcj libraries.
')`'dnl libgcjcommon

Package: gcj`'PV-jre-headless
Priority: optional
Section: java
Architecture: any
Depends: gcj`'PV-base (= ${gcj:Version}), libgcj`'LIBGCJ_EXT (= ${gcj:Version}), ${dep:prctl}, ${shlibs:Depends}, ${misc:Depends}
Suggests: fastjar, gcj`'PV-jdk (= ${gcj:Version}), libgcj`'LIBGCJ_EXT-awt (= ${gcj:Version})
Conflicts: gij-4.4, java-gcj-compat (<< 1.0.76-4)
Provides: java5-runtime-headless, java2-runtime-headless, java1-runtime-headless, java-runtime-headless
Description: Java runtime environment using GIJ/classpath (headless version)
 GIJ is a Java bytecode interpreter, not limited to interpreting bytecode.
 It includes a class loader which can dynamically load shared objects, so
 it is possible to give it the name of a class which has been compiled and
 put into a shared library on the class path.
 .
 The package contains as well a collection of wrapper scripts and symlinks.
 It is meant to provide a Java-RTE-like interface to the GIJ/GCJ tool set,
 limited to the headless tools and libraries.

Package: gcj`'PV-jre
Section: java
Architecture: any
Priority: PRI(optional)
Depends: gcj`'PV-base (= ${gcj:Version}), gcj`'PV-jre-headless (= ${gcj:Version}), libgcj`'LIBGCJ_EXT-awt (= ${gcj:Version}), ${shlibs:Depends}, ${misc:Depends}
Provides: java5-runtime, java2-runtime, java1-runtime, java-runtime
Description: Java runtime environment using GIJ/classpath
 GIJ is a Java bytecode interpreter, not limited to interpreting bytecode.
 It includes a class loader which can dynamically load shared objects, so
 it is possible to give it the name of a class which has been compiled and
 put into a shared library on the class path.
 .
 The package contains as well a collection of wrapper scripts and symlinks.
 It is meant to provide a Java-RTE-like interface to the GIJ/GCJ tool set.

Package: libgcj`'LIBGCJ_EXT
Section: libs
Architecture: any
Priority: PRI(optional)
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
')`'dnl
Depends: gcj`'PV-base (>= ${gcj:Version}), libgcj-common (>= 1:4.1.1-21), ${shlibs:Depends}, ${misc:Depends}
Recommends: gcj`'PV-jre-lib (>= ${gcj:SoftVersion})
Suggests: libgcj`'GCJ_SO-dbg, libgcj`'LIBGCJ_EXT-awt (= ${gcj:Version})
Replaces: gij-4.4 (<< 4.4.0-1)
Description: Java runtime library for use with gcj
 This is the runtime that goes along with the gcj front end to
 gcc. libgcj includes parts of the Java Class Libraries, plus glue to
 connect the libraries to the compiler and the underlying OS.
 .
 To show file names and line numbers in stack traces, the packages
 libgcj`'GCJ_SO-dbg and binutils are required.

Package: gcj`'PV-jre-lib
Section: java
Architecture: all
Priority: PRI(optional)
Depends: gcj`'PV-base (>= ${gcj:SoftVersion}), libgcj`'LIBGCJ_EXT (>= ${gcj:SoftVersion}), ${misc:Depends}
Description: Java runtime library for use with gcj (jar files)
 This is the jar file that goes along with the gcj front end to gcc.

ifenabled(`gcjbc',`
Package: libgcj-bc
Section: java
Architecture: any
Priority: PRI(optional)
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
')`'dnl
Depends: gcj`'PV-base (>= ${gcj:Version}), libgcj`'LIBGCJ_EXT (>= ${gcj:Version}), ${misc:Depends}
Description: Link time only library for use with gcj
 A fake library that is used at link time only.  It ensures that
 binaries built with the BC-ABI link against a constant SONAME.
 This way, BC-ABI binaries continue to work if the SONAME underlying
 libgcj.so changes.
')`'dnl gcjbc

Package: libgcj`'LIBGCJ_EXT-awt
Section: libs
Architecture: any
Priority: PRI(optional)
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
')`'dnl
Depends: gcj`'PV-base (>= ${gcj:Version}), libgcj`'LIBGCJ_EXT (= ${gcj:Version}), ${shlibs:Depends}, ${misc:Depends}
Suggests: ${pkg:gcjqt}
Description: AWT peer runtime libraries for use with gcj
 These are runtime libraries holding the AWT peer implementations
 for libgcj (currently the GTK+ based peer library is required, the
 QT bases library is not built).

ifenabled(`gtkpeer',`
Package: libgcj`'GCJ_SO-awt-gtk
Section: libs
Architecture: any
Priority: PRI(optional)
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
')`'dnl
Depends: gcj`'PV-base (= ${gcj:Version}), libgcj`'LIBGCJ_EXT-awt (= ${gcj:Version}), ${shlibs:Depends}, ${misc:Depends}
Description: AWT GTK+ peer runtime library for use with libgcj
 This is the runtime library holding the GTK+ based AWT peer
 implementation for libgcj.
')`'dnl gtkpeer

ifenabled(`qtpeer',`
Package: libgcj`'GCJ_SO-awt-qt
Section: libs
Architecture: any
Priority: PRI(optional)
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
')`'dnl
Depends: gcj`'PV-base (= ${gcj:Version}), libgcj`'LIBGCJ_EXT-awt (= ${gcj:Version}), ${shlibs:Depends}, ${misc:Depends}
Description: AWT QT peer runtime library for use with libgcj
 This is the runtime library holding the QT based AWT peer
 implementation for libgcj.
')`'dnl qtpeer
')`'dnl libgcj

ifenabled(`libgcjdev',`
Package: libgcj`'GCJ_SO-dev
Section: libdevel
Architecture: any
Priority: PRI(optional)
Depends: gcj`'PV-base (= ${gcj:Version}), gcj`'PV-jdk (= ${gcj:Version}), gcj`'PV-jre-lib (>= ${gcj:SoftVersion}), libgcj`'LIBGCJ_EXT-awt (= ${gcj:Version}), libgcj-bc, ${pkg:gcjgtk}, ${pkg:gcjqt}, zlib1g-dev, ${shlibs:Depends}, ${misc:Depends}
Suggests: libgcj-doc
Description: Java development headers for use with gcj
 These are the development headers that go along with the gcj front end
 to gcc. libgcj includes parts of the Java Class Libraries, plus glue
 to connect the libraries to the compiler and the underlying OS.

Package: libgcj`'GCJ_SO-dbg
Section: debug
Architecture: any
Priority: extra
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
')`'dnl
Depends: gcj`'PV-base (= ${gcj:Version}), libgcj`'LIBGCJ_EXT (= ${gcj:Version}), ${misc:Depends}
Recommends: binutils, libc6-dbg | libc-dbg
Description: Debugging symbols for libraries provided in libgcj`'GCJ_SO-dev
 The package provides debugging symbols for the libraries provided
 in libgcj`'GCJ_SO-dev.
 .
 binutils is required to show file names and line numbers in stack traces.

Package: gcj`'PV-source
Section: java
Architecture: all
Priority: PRI(optional)
Depends: gcj`'PV-base (>= ${gcj:SoftVersion}), gcj`'PV-jdk (>= ${gcj:SoftVersion}), ${misc:Depends}
Description: GCJ java sources for use in IDEs like eclipse and netbeans
 These are the java source files packaged as a zip file for use in development
 environments like eclipse and netbeans.

ifenabled(`gcjdoc',`
Package: libgcj-doc
Section: doc
Architecture: all
Priority: PRI(optional)
Depends: gcj`'PV-base (>= ${gcj:SoftVersion}), ${misc:Depends}
Enhances: libgcj`'GCJ_SO-dev
Provides: classpath-doc
Description: libgcj API documentation and example programs
 Autogenerated documentation describing the API of the libgcj library.
 Sources and precompiled example programs from the classpath library.
')`'dnl gcjdoc
')`'dnl libgcjdev
')`'dnl java

ifenabled(`c++',`
ifenabled(`libcxx',`
Package: libstdc++CXX_SO`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(important))
Depends: BASEDEP, ${dep:libc}, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libstdc++CXX_SO-TARGET-dcv1',
ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
Breaks: ${multiarch:breaks}
')`Provides: libstdc++'CXX_SO`-armel [armel], libstdc++'CXX_SO`-armhf [armhf]')
Conflicts: scim (<< 1.4.2-1)
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
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: extra
Depends: BASEDEP, lib32gcc1`'LS, ${shlibs:Depends}, ${misc:Depends}
Conflicts: ${confl:lib32}
ifdef(`TARGET',`Provides: lib32stdc++CXX_SO-TARGET-dcv1
',`')`'dnl
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
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${shlibs:Depends}, lib64gcc1`'LS, ${misc:Depends}
ifdef(`TARGET',`Provides: lib64stdc++CXX_SO-TARGET-dcv1
',`')`'dnl
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
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${shlibs:Depends}, libn32gcc1`'LS, ${misc:Depends}
ifdef(`TARGET',`Provides: libn32stdc++CXX_SO-TARGET-dcv1
',`')`'dnl
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

ifenabled(`libhfcxx',`
Package: libhfstdc++CXX_SO`'LS
Architecture: ifdef(`TARGET',`all',`biarchhf_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${shlibs:Depends}, libhfgcc1`'LS, ${misc:Depends}
ifdef(`TARGET',`Provides: libhfstdc++CXX_SO-TARGET-dcv1
',`')`'dnl
ifdef(`TARGET',`dnl',`Conflicts: libstdc++'CXX_SO`-armhf [biarchhf_archs]')
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
Architecture: ifdef(`TARGET',`all',`biarchsf_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${shlibs:Depends}, libsfgcc1`'LS, ${misc:Depends}
ifdef(`TARGET',`Provides: libsfstdc++CXX_SO-TARGET-dcv1
',`')`'dnl
ifdef(`TARGET',`dnl',`Conflicts: libstdc++'CXX_SO`-armel [biarchsf_archs]')
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
Description: GNU Standard C++ Library v3 [NEON version]
 This package contains an additional runtime library for C++ programs
 built with the GNU compiler.
 .
 This set of libraries is optimized to use a NEON coprocessor, and will
 be selected instead when running under systems which have one.
')`'dnl

ifenabled(`c++dev',`
Package: libstdc++CXX_SO`'PV-dev`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, g++`'PV`'TS (= ${gcc:Version}), libstdc++CXX_SO`'LS (>= ${gcc:Version}), ${dep:libcdev}, ${misc:Depends}
ifdef(`TARGET',`',`dnl native
Conflicts: libg++27-dev, libg++272-dev (<< 2.7.2.8-1), libstdc++2.8-dev, libg++2.8-dev, libstdc++2.9-dev, libstdc++2.9-glibc2.1-dev, libstdc++2.10-dev (<< 1:2.95.3-2), libstdc++3.0-dev
Suggests: libstdc++CXX_SO`'PV-doc
')`'dnl native
Provides: libstdc++-dev`'LS`'ifdef(`TARGET',`, libstdc++-dev-TARGET-dcv1, libstdc++CXX_SO-dev-TARGET-dcv1')
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

Package: libstdc++CXX_SO`'PV-pic`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: extra
Depends: BASEDEP, libstdc++CXX_SO`'LS (>= ${gcc:Version}), libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version}), ${misc:Depends}
ifdef(`TARGET',`Provides: libstdc++CXX_SO-pic-TARGET-dcv1
',`')`'dnl
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
Architecture: ifdef(`TARGET',`all',`any')
Section: debug
Priority: extra
Depends: BASEDEP, libstdc++CXX_SO`'LS (>= ${gcc:Version}), libgcc`'GCC_SO-dbg`'LS, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libstdc++CXX_SO-dbg-TARGET-dcv1',`dnl
ifdef(`MULTIARCH', `Multi-Arch: same',`dnl')
Provides: libstdc++'CXX_SO`'PV`-dbg-armel [armel], libstdc++'CXX_SO`'PV`-dbg-armhf [armhf]dnl
')
Recommends: libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version})
Conflicts: libstdc++5-dbg`'LS, libstdc++5-3.3-dbg`'LS, libstdc++6-dbg`'LS, libstdc++6-4.0-dbg`'LS, libstdc++6-4.1-dbg`'LS, libstdc++6-4.2-dbg`'LS, libstdc++6-4.3-dbg`'LS, libstdc++6-4.4-dbg`'LS, libstdc++6-4.5-dbg`'LS
Description: GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the shared library of libstdc++ compiled with
 debugging symbols.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: lib32stdc++CXX_SO`'PV-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, lib32stdc++CXX_SO`'LS (>= ${gcc:Version}), libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version}), lib32gcc`'GCC_SO-dbg`'LS, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: lib32stdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
Conflicts: lib32stdc++6-dbg`'LS, lib32stdc++6-4.0-dbg`'LS, lib32stdc++6-4.1-dbg`'LS, lib32stdc++6-4.2-dbg`'LS, lib32stdc++6-4.3-dbg`'LS, lib32stdc++6-4.4-dbg`'LS, lib32stdc++6-4.5-dbg`'LS
Description: GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the shared library of libstdc++ compiled with
 debugging symbols.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: lib64stdc++CXX_SO`'PV-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Section: debug
Priority: extra
Depends: BASEDEP, lib64stdc++CXX_SO`'LS (>= ${gcc:Version}), libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version}), lib64gcc`'GCC_SO-dbg`'LS, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: lib64stdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
Conflicts: lib64stdc++6-dbg`'LS, lib64stdc++6-4.0-dbg`'LS, lib64stdc++6-4.1-dbg`'LS, lib64stdc++6-4.2-dbg`'LS, lib64stdc++6-4.3-dbg`'LS, lib64stdc++6-4.4-dbg`'LS, lib64stdc++6-4.5-dbg`'LS
Description: GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the shared library of libstdc++ compiled with
 debugging symbols.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libn32stdc++CXX_SO`'PV-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarchn32_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libn32stdc++CXX_SO`'LS (>= ${gcc:Version}), libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version}), libn32gcc`'GCC_SO-dbg`'LS, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libn32stdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
Conflicts: libn32stdc++6-dbg`'LS, libn32stdc++6-4.0-dbg`'LS, libn32stdc++6-4.1-dbg`'LS, libn32stdc++6-4.2-dbg`'LS, libn32stdc++6-4.3-dbg`'LS, libn32stdc++6-4.4-dbg`'LS, libn32stdc++6-4.5-dbg`'LS
Description: GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the shared library of libstdc++ compiled with
 debugging symbols.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

ifenabled(`libhfcxx',`
Package: libhfstdc++CXX_SO`'PV-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarchhf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libhfstdc++CXX_SO`'LS (>= ${gcc:Version}), libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version}), libhfgcc`'GCC_SO-dbg`'LS, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libhfstdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
Conflicts: libhfstdc++6-dbg`'LS, libhfstdc++6-4.3-dbg`'LS, libhfstdc++6-4.4-dbg`'LS, libhfstdc++6-4.5-dbg`'LS`'ifdef(`TARGET',`',`, libstdc++'CXX_SO`-armhf [biarchhf_archs]')
Description: GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the shared library of libstdc++ compiled with
 debugging symbols.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libhfcxx

ifenabled(`libsfcxx',`
Package: libsfstdc++CXX_SO`'PV-dbg`'LS
Architecture: ifdef(`TARGET',`all',`biarchsf_archs')
Section: debug
Priority: extra
Depends: BASEDEP, libsfstdc++CXX_SO`'LS (>= ${gcc:Version}), libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version}), libsfgcc`'GCC_SO-dbg`'LS, ${shlibs:Depends}, ${misc:Depends}
ifdef(`TARGET',`Provides: libsfstdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
Conflicts: libsfstdc++6-dbg`'LS, libsfstdc++6-4.3-dbg`'LS, libsfstdc++6-4.4-dbg`'LS, libsfstdc++6-4.5-dbg`'LS`'ifdef(`TARGET',`',`, libstdc++'CXX_SO`-armel [biarchsf_archs]')
Description: GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the shared library of libstdc++ compiled with
 debugging symbols.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libsfcxx

ifdef(`TARGET', `', `
Package: libstdc++CXX_SO`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: gcc`'PV-base (>= ${gcc:SoftVersion}), ${misc:Depends}
Conflicts: libstdc++5-doc, libstdc++5-3.3-doc, libstdc++6-doc, libstdc++6-4.0-doc, libstdc++6-4.1-doc, libstdc++6-4.2-doc, libstdc++6-4.3-doc, libstdc++6-4.4-doc, libstdc++6-4.5-doc
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
Package: gnat`'-GNAT_V
Architecture: any
Priority: PRI(optional)
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
')`'dnl
Depends: gnat`'PV-base (= ${gnat:Version}), gcc`'PV (>= ${gcc:SoftVersion}), ${dep:libgnat}, ${dep:libcdev}, ${shlibs:Depends}, ${misc:Depends}
Suggests: gnat`'PV-doc, ada-reference-manual-html, ada-reference-manual-info, ada-reference-manual-pdf, ada-reference-manual-text, gnat`'-GNAT_V-sjlj
Provides: ada-compiler
Conflicts: gnat (<< 4.1), gnat-3.1, gnat-3.2, gnat-3.3, gnat-3.4, gnat-3.5, gnat-4.0, gnat-4.1, gnat-4.2, gnat-4.3, gnat-4.4
Description: GNU Ada compiler
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 This package provides the compiler, tools and runtime library that handles
 exceptions using the default zero-cost mechanism.

Package: gnat`'-GNAT_V-sjlj
Architecture: any
Priority: extra
ifdef(`MULTIARCH', `Pre-Depends: multiarch-support
')`'dnl
Depends: gnat`'PV-base (= ${gnat:Version}), gnat`'-GNAT_V (= ${gnat:Version}), ${misc:Depends}
Description: GNU Ada compiler (setjump/longjump runtime library)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 This package provides an alternative runtime library that handles
 exceptions using the setjump/longjump mechanism (as a static library
 only).  You can install it to supplement the normal compiler.

ifenabled(`libgnat',`
Package: libgnat`'-GNAT_V
Section: libs
Architecture: any
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
'))`'dnl
Priority: PRI(optional)
Depends: gnat`'PV-base (= ${gnat:Version}), ${shlibs:Depends}, ${misc:Depends}
Description: runtime for applications compiled with GNAT (shared library)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 The libgnat library provides runtime components needed by most
 applications produced with GNAT.
 .
 This package contains the runtime shared library.

Package: libgnat`'-GNAT_V-dbg
Section: debug
Architecture: any
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
'))`'dnl
Priority: extra
Depends: gnat`'PV-base (= ${gnat:Version}), libgnat`'-GNAT_V (= ${gnat:Version}), ${misc:Depends}
Description: runtime for applications compiled with GNAT (debugging symbols)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 The libgnat library provides runtime components needed by most
 applications produced with GNAT.
 .
 This package contains the debugging symbols.

Package: libgnatvsn`'GNAT_V-dev
Section: libdevel
Architecture: any
Priority: extra
Depends: gnat`'PV-base (= ${gnat:Version}), gnat`'PV (= ${gnat:Version}),
 libgnatvsn`'GNAT_V (= ${gnat:Version}), ${misc:Depends}
Conflicts: libgnatvsn-dev (<< `'GNAT_V), libgnatvsn4.1-dev, libgnatvsn4.3-dev, libgnatvsn4.4-dev, libgnatvsn4.5-dev
Description: GNU Ada compiler selected components (development files)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 The libgnatvsn library exports selected GNAT components for use in other
 packages, most notably ASIS tools. It is licensed under the GNAT-Modified
 GPL, allowing to link proprietary programs with it.
 .
 This package contains the development files and static library.

Package: libgnatvsn`'GNAT_V
Architecture: any
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
'))`'dnl
Priority: PRI(optional)
Section: libs
Depends: gnat`'PV-base (= ${gnat:Version}), libgnat`'-GNAT_V (= ${gnat:Version}), ${misc:Depends}
Description: GNU Ada compiler selected components (shared library)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 The libgnatvsn library exports selected GNAT components for use in other
 packages, most notably ASIS tools. It is licensed under the GNAT-Modified
 GPL, allowing to link proprietary programs with it.
 .
 This package contains the runtime shared library.

Package: libgnatvsn`'GNAT_V-dbg
Architecture: any
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
'))`'dnl
Priority: extra
Section: debug
Depends: gnat`'PV-base (= ${gnat:Version}), libgnatvsn`'GNAT_V (= ${gnat:Version}), ${misc:Depends}
Suggests: gnat
Description: GNU Ada compiler selected components (debugging symbols)
 GNAT is a compiler for the Ada programming language. It produces optimized
 code on platforms supported by the GNU Compiler Collection (GCC).
 .
 The libgnatvsn library exports selected GNAT components for use in other
 packages, most notably ASIS tools. It is licensed under the GNAT-Modified
 GPL, allowing to link proprietary programs with it.
 .
 This package contains the debugging symbols.

Package: libgnatprj`'GNAT_V-dev
Section: libdevel
Architecture: any
Priority: extra
Depends: gnat`'PV-base (= ${gnat:Version}), gnat`'PV (= ${gnat:Version}),
 libgnatprj`'GNAT_V (= ${gnat:Version}), libgnatvsn`'GNAT_V-dev (= ${gnat:Version}), ${misc:Depends}
Conflicts: libgnatprj-dev (<< `'GNAT_V), libgnatprj4.1-dev, libgnatprj4.3-dev, libgnatprj4.4-dev, libgnatprj4.5-dev
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

Package: libgnatprj`'GNAT_V
Architecture: any
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
'))`'dnl
Priority: PRI(optional)
Section: libs
Depends: gnat`'PV-base (= ${gnat:Version}), libgnat`'-GNAT_V (= ${gnat:Version}), libgnatvsn`'GNAT_V (= ${gnat:Version}), ${misc:Depends}
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

Package: libgnatprj`'GNAT_V-dbg
Architecture: any
ifdef(`TARGET',`dnl',ifdef(`MULTIARCH', `Multi-Arch: same
Pre-Depends: multiarch-support
'))`'dnl
Priority: extra
Section: debug
Depends: gnat`'PV-base (= ${gnat:Version}), libgnatprj`'GNAT_V (= ${gnat:Version}), ${misc:Depends}
Suggests: gnat
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
Depends: gnat`'PV-base (= ${gnat:Version}), ${dep:libcbiarch}, ${shlibs:Depends}, ${misc:Depends}
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
Conflicts: gnat-4.1-doc, gnat-4.2-doc, gnat-4.3-doc, gnat-4.4-doc
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
Package: gdc`'PV
Architecture: any
Priority: PRI(optional)
Depends: SOFTBASEDEP, g++`'PV (>= ${gcc:SoftVersion}), libphobos`'PHOBOS_V`'PV-dev (= ${gdc:Version}) [libphobos_no_archs], ${shlibs:Depends}, ${misc:Depends}
Provides: gdc, d-compiler, d-v2-compiler
Replaces: gdc (<< 4.4.6-5)
Description: GNU D compiler (version 2), based on the GCC backend
 This is the GNU D compiler, which compiles D on platforms supported by gcc.
 It uses the gcc backend to generate optimised code.
 .
 This compiler supports D language version 2.

ifenabled(`libphobos',`
Package: libphobos`'PHOBOS_V`'PV`'TS-dev
Architecture: any
Section: libdevel
Priority: PRI(optional)
Depends: gdc`'PV`'TS (= ${gdc:Version}), zlib1g-dev, ${shlibs:Depends}, ${misc:Depends}
Provides: libphobos`'PHOBOS_V`'TS-dev
Description: Phobos D standard library
 This is the Phobos standard library that comes with the D2 compiler.
 .
 For more information check http://www.d-programming-language.org/phobos/

Package: libphobos`'PHOBOS_V`'PV`'TS-dbg
Section: debug
Architecture: ifdef(`TARGET',`all',`any')
Priority: extra
Depends: gdc`'PV`'TS (= ${gdc:Version}), libphobos`'PHOBOS_V`'PV-dev (= ${gdc:Version}), ${misc:Depends}
Provides: libphobos`'PHOBOS_V`'TS-dbg
Description: The Phobos D standard library (debug symbols)
 This is the Phobos standard library that comes with the D2 compiler.
 .
 For more information check http://www.d-programming-language.org/phobos/
')`'dnl libphobos
')`'dnl d

ifdef(`TARGET',`',`dnl
ifenabled(`libs',`
Package: gcc`'PV-soft-float
Architecture: arm armel armhf
Priority: PRI(optional)
Depends: BASEDEP, ifenabled(`cdev',`gcc`'PV (= ${gcc:Version}),') ${shlibs:Depends}, ${misc:Depends}
Conflicts: gcc-4.4-soft-float, gcc-4.5-soft-float
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
Description: GCC no-floating-point gcc libraries (powerpc)
 These are versions of basic static libraries such as libgcc.a compiled
 with the -msoft-float option, for CPUs without a floating-point unit.
')`'dnl libnof
')`'dnl

ifenabled(`source',`
Package: gcc`'PV-source
Architecture: all
Priority: PRI(optional)
Depends: make (>= 3.81), autoconf2.64, automake, quilt, patchutils, gawk, ${misc:Depends}
Description: Source of the GNU Compiler Collection
 This package contains the sources and patches which are needed to
 build the GNU Compiler Collection (GCC).
')`'dnl source
dnl
')`'dnl gcc-X.Y
dnl last line in file
