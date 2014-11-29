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
Maintainer: ABE Hiroki (hATrayflood) <h.rayflood@gmail.com>
Standards-Version: 3.8.2
ifdef(`TARGET',`dnl cross
Build-Depends: dpkg-dev (>= 1.13.9), dpkg-cross (>= 1.25.99), LIBC_BUILD_DEP, LIBC_BIARCH_BUILD_DEP LIBUNWIND_BUILD_DEP LIBATOMIC_OPS_BUILD_DEP AUTOGEN_BUILD_DEP m4, autoconf2.59, autoconf2.13, automake1.9, libtool, gawk, bzip2, BINUTILS_BUILD_DEP, debhelper (>= 5.0), bison (>= 1:2.3), flex, realpath (>= 1.9.12), lsb-release, make (>= 3.81)
',`dnl native
Build-Depends: dpkg-dev (>= 1.13.9), gcc-multilib [amd64 i386 powerpc ppc64 s390 sparc kfreebsd-amd64], LIBC_BUILD_DEP, LIBC_BIARCH_BUILD_DEP AUTOGEN_BUILD_DEP libunwind7-dev (>= 0.98.5-6) [ia64], libatomic-ops-dev [ia64], m4, autoconf2.59, autoconf2.13, automake1.9, libtool, gawk, CHECK_BUILD_DEP, bzip2, BINUTILS_BUILD_DEP, binutils-hppa64 (>= BINUTILSV) [hppa], debhelper (>= 5.0), gperf (>= 3.0.1), bison (>= 1:2.3), flex, gettext, texinfo (>= 4.3), zlib1g-dev, libmpfr-dev (>= 2.3.0~rc1.dfsg.1) [fortran_no_archs], locales [locale_no_archs], procps [linux_gnu_archs], sharutils, PASCAL_BUILD_DEP GDC_BUILD_DEP JAVA_BUILD_DEP GNAT_BUILD_DEP realpath (>= 1.9.12), chrpath, lsb-release, make (>= 3.81)
Build-Depends-Indep: LIBSTDCXX_BUILD_INDEP JAVA_BUILD_INDEP
')dnl
Homepage: https://launchpad.net/~h-rayflood/+archive/gcc-lower
XS-Vcs-Browser: https://github.com/hATrayflood/gcc-ppa

ifelse(SRCNAME,gcc-snapshot,`dnl
Package: gcc-snapshot
Architecture: any
Section: devel
Priority: extra
Depends: binutils`'TS (>= ${binutils:Version}), ${dep:libcdev}, ${dep:libunwinddev}, ${shlibs:Depends}
Provides: c++abi2-dev
Description: A SNAPSHOT of the GNU Compiler Collection
 This package contains a recent development SNAPSHOT of all files
 contained in the GNU Compiler Collection (GCC).
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

ifdef(`TARGET', `', `
ifenabled(`gccbase',`

Package: gcc`'PV-base
Architecture: any
Section: libs
Priority: PRI(optional)
Description: The GNU Compiler Collection (base package)
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
dnl set via DEB_CROSS_INDEPENDENT=yes
define(`BASETARGET', `PV`'TS')
define(`BASEDEP', `gcc`'BASETARGET-base (= ${gcc:Version})')
define(`SOFTBASEDEP', `gcc`'BASETARGET-base (>= ${gcc:SoftVersion})')

Package: gcc`'BASETARGET-base
Architecture: any
Section: devel
Priority: PRI(optional)
Conflicts: gcc-3.5-base
Replaces: gcc-3.5-base
Description: The GNU Compiler Collection (base package)
 This package contains files common to all languages and libraries
 contained in the GNU Compiler Collection (GCC).
')`'dnl

ifenabled(`java',`
Package: gcj`'PV-base
Architecture: any
Section: libs
Priority: PRI(optional)
Description: The GNU Compiler Collection (gcj base package)
 This package contains files common to all java related packages
 built from the GNU Compiler Collection (GCC).
')`'dnl java

ifenabled(`ada',`
Package: gnat`'PV-base
Architecture: any
Section: libs
Priority: PRI(optional)
Description: The GNU Compiler Collection (gnat base package)
 This package contains files common to all Ada related packages
 built from the GNU Compiler Collection (GCC).
')`'dnl ada

ifenabled(`libgcc',`
Package: libgcc1`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',required)
Depends: BASEDEP, ${shlibs:Depends}
ifdef(`TARGET',`Provides: libgcc1-TARGET-dcv1
',`')`'dnl
Description: GCC support library`'ifdef(`TARGET)',` (TARGET)', `')
 Shared version of the support library, a library of internal subroutines
 that GCC uses to overcome shortcomings of particular machines, or
 special needs for some languages.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libgcc2`'LS
Architecture: ifdef(`TARGET',`all',`m68k')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',required)
Depends: BASEDEP, ${shlibs:Depends}
ifdef(`TARGET',`Provides: libgcc2-TARGET-dcv1
',`')`'dnl
Description: GCC support library`'ifdef(`TARGET)',` (TARGET)', `')
 Shared version of the support library, a library of internal subroutines
 that GCC uses to overcome shortcomings of particular machines, or
 special needs for some languages.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libgcc

ifenabled(`lib4gcc',`
Package: libgcc4`'LS
Architecture: ifdef(`TARGET',`all',`hppa')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',required)
Depends: ifdef(`STANDALONEJAVA',`gcj`'PV-base (>= ${gcj:Version})',`BASEDEP'), ${shlibs:Depends}
Description: GCC support library`'ifdef(`TARGET)',` (TARGET)', `')
 Shared version of the support library, a library of internal subroutines
 that GCC uses to overcome shortcomings of particular machines, or
 special needs for some languages.
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
Depends: BASEDEP, ${dep:libcbiarch}
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
')`'dnl lib64gcc

ifdef(`TARGET', `', `dnl
ifenabled(`lib32gcc',`
Package: lib32gcc1`'LS
Architecture: biarch32_archs
Section: libs
Priority: optional
Depends: BASEDEP, ${dep:libcbiarch}
ifdef(`TARGET',`Provides: lib32gcc1-TARGET-dcv1
',`')`'dnl
ifelse(DIST,`Ubuntu', `Replaces: ia32-libs-openoffice.org (<< 1ubuntu3)', `dnl')
Description: GCC support library (32 bit Version)
 Shared version of the support library, a library of internal subroutines
 that GCC uses to overcome shortcomings of particular machines, or
 special needs for some languages.
')`'dnl
')`'dnl

ifenabled(`cdev',`
Package: gcc`'PV`'TS
Architecture: any
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, cpp`'PV`'TS (= ${gcc:Version}), binutils`'TS (>= ${binutils:Version}), ${dep:libgcc}, ${dep:libssp}, ${dep:libunwinddev}, ${shlibs:Depends}
Recommends: ${dep:libcdev}
Suggests: ${gcc:multilib}, gcc`'PV-doc (>= ${gcc:SoftVersion}), gcc`'PV-locales (>= ${gcc:SoftVersion}), libmudflap`'MF_SO-dev`'LS (>= ${gcc:Version})
Provides: c-compiler`'TS, libssp0-dev
ifdef(`TARGET',`dnl',`Conflicts: libssp0-dev (<< 4.1.1-6)')
ifdef(`TARGET',`dnl',`Replaces: gcj-4.1 (<< 4.1.1), libssp0-dev (<< 4.1.1-6)')
Description: The GNU C compiler`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU C compiler, a fairly portable optimizing compiler for C.
ifdef(`TARGET', `dnl
 .
 This package contains C cross-compiler for TARGET architecture.
')`'dnl

ifenabled(`multilib',`
Package: gcc`'PV-multilib`'TS
Architecture: MULTILIB_ARCHS
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gcc`'PV`'TS (= ${gcc:Version}), ${dep:libcbiarchdev}, ${dep:libgccbiarch}, ${dep:libsspbiarch}, ${dep:libgompbiarch}, ${shlibs:Depends}
Recommends: ${dep:libmudflapbiarch}
Replaces: gcc-4.1 (<< 4.1.2-4)
Description: The GNU C compiler (multilib files)`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU C compiler, a fairly portable optimizing compiler for C.
 .
 On architectures with multilib support, the package contains files
 and dependencies for the non-default multilib architecture(s).
')`'dnl multilib
')`'dnl cdev

ifenabled(`cdev',`
ifdef(`TARGET', `', `
Package: gcc`'PV-hppa64
Architecture: hppa
Section: devel
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}
Conflicts: gcc-3.3-hppa64 (<= 1:3.3.4-5), gcc-3.4-hppa64 (<= 3.4.1-3)
Description: The GNU C compiler (cross compiler for hppa64)
 This is the GNU C compiler, a fairly portable optimizing compiler for C.
')`'dnl native
')`'dnl cdev

ifenabled(`cdev',`
Package: cpp`'PV`'TS
Architecture: any
Section: ifdef(`TARGET',`devel',`interpreters')
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}
Suggests: gcc`'PV-locales (>= ${gcc:SoftVersion})
ifdef(`TARGET',`dnl',`Conflicts: gcj-4.1 (<< 4.1.1), gnat-4.1 (<= 4.1.1-22)')
ifdef(`TARGET',`dnl',`Replaces: gcj-4.1 (<< 4.1.1)')
Description: The GNU C preprocessor
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
Depends: gcc`'PV-base (>= ${gcc:SoftVersion})
Description: Documentation for the GNU C preprocessor (cpp)
 Documentation for the GNU C preprocessor in info `format'.
')`'dnl gfdldoc
')`'dnl native

ifdef(`TARGET', `', `
Package: gcc`'PV-locales
Architecture: all
Section: devel
Priority: PRI(optional)
Depends: SOFTBASEDEP, cpp`'PV (>= ${gcc:SoftVersion})
Recommends: gcc`'PV (>= ${gcc:SoftVersion})
Description: The GNU C compiler (native language support files)
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
Depends: BASEDEP, gcc`'PV`'TS (= ${gcc:Version}), libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version}), ${shlibs:Depends}
Provides: c++-compiler`'TS, c++abi2-dev
Suggests: ${gxx:multilib}, gcc`'PV-doc (>= ${gcc:SoftVersion})
Description: The GNU C++ compiler`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU C++ compiler, a fairly portable optimizing compiler for C++.
ifdef(`TARGET', `dnl
 .
 This package contains C++ cross-compiler for TARGET architecture.
')`'dnl

ifenabled(`multilib',`
Package: g++`'PV-multilib`'TS
Architecture: MULTILIB_ARCHS
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, g++`'PV`'TS (= ${gcc:Version}), gcc`'PV-multilib`'TS (= ${gcc:Version}), ${dep:libcxxbiarch}, ${shlibs:Depends}
Suggests: ${dep:libcxxbiarchdbg}
Replaces: libstdc++6-4.1-dev (<< 4.1.2-4)
Description: The GNU C++ compiler (multilib files)`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU C++ compiler, a fairly portable optimizing compiler for C++.
 .
 On architectures with multilib support, the package contains files
 and dependencies for the non-default multilib architecture(s).
')`'dnl multilib
')`'dnl c++dev
')`'dnl c++

ifdef(`TARGET', `', `
ifenabled(`mudflap',`
Package: libmudflap`'MF_SO
Architecture: any
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}
Description: GCC mudflap shared support libraries
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.

Package: lib32mudflap`'MF_SO
Architecture: biarch32_archs
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}
Replaces: libmudflap0 (<< 4.1)
Description: GCC mudflap shared support libraries (32bit)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.

Package: lib64mudflap`'MF_SO
Architecture: biarch64_archs
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}
Replaces: libmudflap0 (<< 4.1)
Description: GCC mudflap shared support libraries (64bit)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.

Package: libmudflap`'MF_SO-dev
Architecture: any
Section: libdevel
Priority: PRI(optional)
Depends: BASEDEP, libmudflap`'MF_SO (>= ${gcc:Version}), ${dep:libcdev}, ${shlibs:Depends}
Suggests: ${sug:libmudflapdev}
Conflicts: libmudflap0-4.2-dev
Description: GCC mudflap support libraries (development files)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.
 .
 This package contains the headers and the static libraries.
')`'dnl
')`'dnl native

ifdef(`TARGET', `', `
ifenabled(`ssp',`
Package: libssp`'SSP_SO
Architecture: any
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}
Description: GCC stack smashing protection library
 GCC can now emit code for protecting applications from stack-smashing attacks.
 The protection is realized by buffer overflow detection and reordering of
 stack variables to avoid pointer corruption.

Package: lib32ssp`'SSP_SO
Architecture: biarch32_archs
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}
Replaces: libssp0 (<< 4.1)
Description: GCC stack smashing protection library (32bit)
 GCC can now emit code for protecting applications from stack-smashing attacks.
 The protection is realized by buffer overflow detection and reordering of
 stack variables to avoid pointer corruption.

Package: lib64ssp`'SSP_SO
Architecture: biarch64_archs
Section: libs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}
Replaces: libssp0 (<< 4.1)
Description: GCC stack smashing protection library (64bit)
 GCC can now emit code for protecting applications from stack-smashing attacks.
 The protection is realized by buffer overflow detection and reordering of
 stack variables to avoid pointer corruption.
')`'dnl
')`'dnl native

ifenabled(`proto',`
Package: protoize
Architecture: any
Priority: PRI(optional)
Depends: BASEDEP, gcc`'PV (>= ${gcc:Version}), ${shlibs:Depends}
Description: Create/remove ANSI prototypes from C code
 "protoize" can be used to add prototypes to a program, thus converting
 the program to ANSI C in one respect.  The companion program "unprotoize"
 does the reverse: it removes argument types from any prototypes
 that are found.
')`'dnl proto

ifenabled(`objpp',`
ifenabled(`objppdev',`
Package: gobjc++`'PV`'TS
Architecture: any
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gobjc`'PV`'TS (= ${gcc:Version}), g++`'PV`'TS (= ${gcc:Version}), ${shlibs:Depends}, libobjc`'OBJC_SO`'LS (>= ${gcc:EpochVersion})
Suggests: ${gobjcxx:multilib}, gcc`'PV-doc (>= ${gcc:SoftVersion})
Provides: objc++-compiler`'TS
Description: The GNU Objective-C++ compiler
 This is the GNU Objective-C++ compiler, which compiles
 Objective-C++ on platforms supported by the gcc compiler. It uses the
 gcc backend to generate optimized code.
')`'dnl obcppdev

ifenabled(`multilib',`
Package: gobjc++`'PV-multilib`'TS
Architecture: MULTILIB_ARCHS
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gobjc++`'PV`'TS (= ${gcc:Version}), g++`'PV-multilib`'TS (= ${gcc:Version}), gobjc`'PV-multilib`'TS (= ${gcc:Version}), ${shlibs:Depends}
Description: The GNU Objective-C++ compiler (multilib files)
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
Depends: BASEDEP, gcc`'PV`'TS (= ${gcc:Version}), ${dep:libcdev}, ${shlibs:Depends}, libobjc`'OBJC_SO`'LS (>= ${gcc:EpochVersion})
Suggests: ${gobjc:multilib}, gcc`'PV-doc (>= ${gcc:SoftVersion})
Provides: objc-compiler`'TS
ifdef(`OBJC_GC',`Recommends: libgc-dev', `dnl')
ifdef(`__sparc__',`Conflicts: gcc`'PV-sparc64', `dnl')
Description: The GNU Objective-C compiler
 This is the GNU Objective-C compiler, which compiles
 Objective-C on platforms supported by the gcc compiler. It uses the
 gcc backend to generate optimized code.

ifenabled(`multilib',`
Package: gobjc`'PV-multilib`'TS
Architecture: MULTILIB_ARCHS
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gobjc`'PV`'TS (= ${gcc:Version}), gcc`'PV-multilib`'TS (= ${gcc:Version}), ${dep:libobjcbiarch}, ${shlibs:Depends}
Replaces: gobjc-4.1 (<< 4.1.2-4)
Description: The GNU Objective-C compiler (multilib files)`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
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
Architecture: any
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, ${shlibs:Depends}
Description: Runtime library for GNU Objective-C applications
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl libobjc

ifenabled(`lib64objc',`
Package: lib64objc`'OBJC_SO
Section: libs
Architecture: biarch64_archs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}
Description: Runtime library for GNU Objective-C applications (64bit)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl lib64objc

ifenabled(`lib32objc',`
Package: lib32objc`'OBJC_SO
Section: libs
Architecture: biarch32_archs
Priority: PRI(optional)
Depends: gcc`'PV-base (>= ${gcc:Version}), ${dep:libcbiarch}, ${shlibs:Depends}
Description: Runtime library for GNU Objective-C applications (32bit)
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl lib32objc
')`'dnl objc

ifenabled(`fortran',`
ifenabled(`fdev',`
Package: gfortran`'PV
Architecture: any
Priority: PRI(optional)
Depends: BASEDEP, gcc`'PV (= ${gcc:Version}), libgfortran`'FORTRAN_SO (>= ${gcc:Version}), ${dep:libcdev}, ${shlibs:Depends}
Provides: fortran95-compiler
Suggests: ${gfortran:multilib}, gfortran`'PV-doc
Replaces: libgfortran`'FORTRAN_SO-dev
Description: The GNU Fortran 95 compiler
 This is the GNU Fortran compiler, which compiles
 Fortran 95 on platforms supported by the gcc compiler. It uses the
 gcc backend to generate optimized code.

ifenabled(`multilib',`
Package: gfortran`'PV-multilib`'TS
Architecture: MULTILIB_ARCHS
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(optional)')
Depends: BASEDEP, gfortran`'PV`'TS (= ${gcc:Version}), gcc`'PV-multilib`'TS (= ${gcc:Version}), ${dep:libfortranbiarch}, ${shlibs:Depends}
Replaces: gfortran-4.1 (<< 4.1.2-4)
Description: The GNU Fortran 95 compiler (multilib files)`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU Fortran compiler, which compiles Fortran 95 on platforms
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
Depends: gcc`'PV-base (>= ${gcc:SoftVersion})
Description: Documentation for the GNU Fortran compiler (gfortran)
 Documentation for the GNU Fortran 95 compiler in info `format'.
')`'dnl gfdldoc
')`'dnl fdev

ifenabled(`libgfortran',`
Package: libgfortran`'FORTRAN_SO
Section: libs
Architecture: any
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}
Description: Runtime library for GNU Fortran applications
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl libgfortran

ifenabled(`lib64gfortran',`
Package: lib64gfortran`'FORTRAN_SO
Section: libs
Architecture: biarch64_archs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}
Description: Runtime library for GNU Fortran applications (64bit)
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl lib64gfortran

ifenabled(`lib32gfortran',`
Package: lib32gfortran`'FORTRAN_SO
Section: libs
Architecture: biarch32_archs
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcbiarch}, ${shlibs:Depends}
Description: Runtime library for GNU Fortran applications (32bit)
 Library needed for GNU Fortran applications linked against the
 shared library.
')`'dnl lib32gfortran
')`'dnl fortran

ifenabled(`java',`
ifenabled(`gcj',`
Package: gcj`'PV
Architecture: any
Priority: PRI(optional)
Depends: gcj`'PV-base (= ${gcj:Version}), ${dep:gcj}, ${dep:libcdev}, gij`'PV (= ${gcj:Version}), libgcj`'GCJ_SO-dev (= ${gcj:Version}), libgcj`'GCJ_SO-jar (>= ${gcj:SoftVersion}), libecj-java (>= 3.3.0-2), java-common, ${shlibs:Depends}
Recommends: fastjar, libecj-java-gcj
Suggests: java-gcj-compat-dev
Provides: java-compiler
Conflicts: cpp-4.1 (<< 4.1.1), gcc-4.1 (<< 4.1.1), java-gcj-compat-dev (<< 1.0.56-2)
Description: The GNU compiler for Java(TM)
 GCJ is a front end to the GCC compiler which can natively compile both
 Java(tm) source and bytecode files. The compiler can also generate class
 files.
')`'dnl gcj

ifenabled(`libgcj',`
ifenabled(`libgcjcommon',`
Package: libgcj-common
Section: libs
Architecture: all
Priority: PRI(optional)
Depends: gcj`'PV-base (>= ${gcj:SoftVersion})
Conflicts: classpath (<= 0.04-4)
Replaces: java-gcj-compat (<< 1.0.65-3), java-gcj-compat-dev (<< 1.0.65-3)
Description: Java runtime library (common files)
 This package contains files shared by classpath and libgcj libraries.
')`'dnl libgcjcommon

Package: gij`'PV
Priority: optional
Architecture: any
Depends: gcj`'PV-base (= ${gcj:Version}), libgcj`'LIBGCJ_EXT (= ${gcj:Version}), ${dep:prctl}, ${shlibs:Depends}
Recommends: libgcj`'LIBGCJ_EXT-awt (= ${gcj:Version})
Suggests: fastjar, gcj`'PV (= ${gcj:Version}), java-gcj-compat
Provides: java-virtual-machine, java2-runtime, java1-runtime, java-runtime
Replaces: libgcj7, libgcj7-0 (<< 4.1.2-31)
Conflicts: java-gcj-compat (<< 1.0.69)
Description: The GNU Java bytecode interpreter
 GIJ is not limited to interpreting bytecode. It includes a class loader which
 can dynamically load shared objects, so it is possible to give it the name
 of a class which has been compiled and put into a shared library on the
 class path.

Package: libgcj`'LIBGCJ_EXT
Section: libs
Architecture: any
Priority: PRI(optional)
Depends: gcj`'PV-base (>= ${gcj:Version}), libgcj-common (>= 1:4.1.1-21), ${shlibs:Depends}
Recommends: libgcj`'GCJ_SO-jar (>= ${gcj:SoftVersion}), libgcj`'LIBGCJ_EXT-awt (= ${gcj:Version})
Suggests: libgcj`'GCJ_SO-dbg
Conflicts: libgcj7
Replaces: libgcj7, libgcj7-awt (<< 4.1.1-12)
Description: Java runtime library for use with gcj
 This is the runtime that goes along with the gcj front end to
 gcc. libgcj includes parts of the Java Class Libraries, plus glue to
 connect the libraries to the compiler and the underlying OS.
 .
 To show file names and line numbers in stack traces, the packages
 libgcj`'GCJ_SO-dbg and binutils are required.

Package: libgcj`'GCJ_SO-jar
Section: libs
Architecture: all
Priority: PRI(optional)
Depends: gcj`'PV-base (>= ${gcj:SoftVersion}), libgcj`'LIBGCJ_EXT (>= ${gcj:SoftVersion})
Conflicts: libgcj7-common
Replaces: libgcj7-common
Description: Java runtime library for use with gcj (jar files)
 This is the jar file that goes along with the gcj front end to gcc.

Package: libgcj`'LIBGCJ_EXT-awt
Section: libs
Architecture: any
Priority: PRI(optional)
Depends: gcj`'PV-base (>= ${gcj:Version}), libgcj`'LIBGCJ_EXT (= ${gcj:Version}), ${shlibs:Depends}
Description: AWT peer runtime libraries for use with gcj
 These are runtime libraries holding the AWT peer implementations
 for libgcj (currently only the GTK based peer library).

Package: gappletviewer`'PV
Section: utils
Architecture: any
Priority: PRI(optional)
Depends: gcj`'PV-base (= ${gcj:Version}), gij`'PV (= ${gcj:Version}), libgcj`'LIBGCJ_EXT-awt (= ${gcj:Version}), ${shlibs:Depends}
Description: Standalone application to execute Java (tm) applets
 gappletviewer is a standalone application to execute Java (tm) applets.

Package: gcjwebplugin`'PV
Section: web
Architecture: any
Priority: PRI(optional)
Depends: gcj`'PV-base (= ${gcj:Version}), gappletviewer`'PV (= ${gcj:Version}), ${shlibs:Depends}, firefox | mozilla-browser | epiphany-browser | galeon | konqueror
Description: Web browser plugin to execute Java (tm) applets
 gcjwebplugin is a little web browser plugin to execute Java (tm) applets.
 It is targeted for Mozilla and compatible browsers that support the NPAPI.
')`'dnl libgcj

ifenabled(`libgcjdev',`
Package: libgcj`'GCJ_SO-dev
Section: libdevel
Architecture: any
Priority: PRI(optional)
Depends: gcj`'PV-base (= ${gcj:Version}), gcj`'PV (= ${gcj:Version}), libgcj`'GCJ_SO-jar (>= ${gcj:SoftVersion}), libgcj`'LIBGCJ_EXT-awt (= ${gcj:Version}), libgcj-bc, zlib1g-dev, ${shlibs:Depends}
Suggests: libgcj-doc
Provides: classpath-doc
Description: Java development headers and static library for use with gcj
 These are the development headers and static libraries that go along
 with the gcj front end to gcc. libgcj includes parts of the Java Class
 Libraries, plus glue to connect the libraries to the compiler and the
 underlying OS.

Package: libgcj`'GCJ_SO-dbg
Section: debug
Architecture: any
Priority: extra
Depends: gcj`'PV-base (= ${gcj:Version}), libgcj`'LIBGCJ_EXT (= ${gcj:Version})
Recommends: binutils
Description: Debugging symbols for libraries provided in libgcj`'GCJ_SO-dev
 The package provides debugging symbols for the libraries provided
 in libgcj`'GCJ_SO-dev.
 .
 binutils is required to show file names and line numbers in stack traces.

Package: libgcj`'GCJ_SO-src
Section: libdevel
Architecture: all
Priority: PRI(optional)
Depends: gcj`'PV-base (>= ${gcj:SoftVersion}), gcj`'PV (>= ${gcj:SoftVersion}), libgcj`'GCJ_SO-jar (= ${gcj:Version})
Description: libgcj java sources for use in eclipse
 These are the java source files packaged as a zip file for use in development
 environments like eclipse.

Package: libgcj-doc
Section: doc
Architecture: all
Priority: PRI(optional)
Depends: gcj`'PV-base (>= ${gcj:SoftVersion})
Enhances: libgcj`'GCJ_SO-dev
Description: libgcj API documentation and example programs
 Autogenerated documentation describing the API of the libgcj library.
 Sources and precompiled example programs from the classpath library.
')`'dnl libgcjdev
')`'dnl java

ifenabled(`fastjar',`
Package: fastjar
Section: devel
Architecture: any
Priority: PRI(optional)
Depends: ${shlibs:Depends}
Provides: jar
Description: Jar creation utility
 Replacement for Suns .jar creation program.  It is written in C
 instead of java and is tons faster.
')`'dnl fastjar

ifenabled(`libffi',`
Package: libffi`'FFI_SO
Section: libs
Architecture: any
Priority: PRI(optional)
Depends: gcc`'PV`'-base (= ${gcc:Version}), ${shlibs:Depends}
Description: Foreign Function Interface library runtime
 A foreign function interface is the popular name for the interface that
 allows code written in one language to call code written in another
 language.

Package: lib32ffi`'FFI_SO
Section: libs
Architecture: biarch32_archs
Priority: PRI(optional)
Depends: gcc`'PV`'-base (= ${gcc:Version}), ${dep:libcbiarch}, ${shlibs:Depends}
Replaces: libffi4 (<< 4.1)
Description: Foreign Function Interface library runtime (32bit)
 A foreign function interface is the popular name for the interface that
 allows code written in one language to call code written in another
 language.

Package: lib64ffi`'FFI_SO
Section: libs
Architecture: biarch64_archs
Priority: PRI(optional)
Depends: gcc`'PV`'-base (= ${gcc:Version}), ${dep:libcbiarch}, ${shlibs:Depends}
Replaces: libffi4 (<< 4.1)
Description: Foreign Function Interface library runtime (64bit)
 A foreign function interface is the popular name for the interface that
 allows code written in one language to call code written in another
 language.

Package: libffi`'FFI_SO-dev
Section: libdevel
Architecture: any
Priority: PRI(optional)
Depends: gcc`'PV`'-base (= ${gcc:Version}), libffi`'FFI_SO (>= ${gcc:Version})
Suggests: ${sug:libffidev}
Provides: libffi-dev
Conflicts: libffi1-dev, libffi2-dev, libffi3-dev, libffi-dev, libffi
Description: Foreign Function Interface library (development files)
 This package contains the headers and static library files necessary for
 building programs which use libffi.
 .
 A foreign function interface is the popular name for the interface that
 allows code written in one language to call code written in another
 language.
')`'dnl libffi

ifenabled(`c++',`
ifenabled(`libcxx',`
Package: libstdc++CXX_SO`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(required))
Depends: BASEDEP, ${shlibs:Depends}
ifdef(`TARGET',`Provides: libstdc++CXX_SO-TARGET-dcv1
',`')`'dnl
Conflicts: scim (<< 1.4.2-1)
Description: The GNU Standard C++ Library v3`'ifdef(`TARGET)',` (TARGET)', `')
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
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, lib32gcc1`'LS
ifdef(`TARGET',`Provides: lib32stdc++CXX_SO-TARGET-dcv1
',`')`'dnl
Description: The GNU Standard C++ Library v3 (32 bit Version)
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
Depends: BASEDEP, ${shlibs:Depends}, lib64gcc1`'LS
ifdef(`TARGET',`Provides: lib64stdc++CXX_SO-TARGET-dcv1
',`')`'dnl
Description: The GNU Standard C++ Library v3`'ifdef(`TARGET)',` (TARGET)', `') (64bit)
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

ifenabled(`c++dev',`
Package: libstdc++CXX_SO`'PV-dev`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, g++`'PV`'TS (= ${gcc:Version}), libstdc++CXX_SO`'LS (>= ${gcc:Version}), ${dep:libcdev}
ifdef(`TARGET',`',`dnl native
Conflicts: libg++27-dev, libg++272-dev (<< 2.7.2.8-1), libstdc++2.8-dev, libg++2.8-dev, libstdc++2.9-dev, libstdc++2.9-glibc2.1-dev, libstdc++2.10-dev (<< 1:2.95.3-2), libstdc++3.0-dev
Suggests: libstdc++CXX_SO`'PV-doc
')`'dnl native
Provides: libstdc++-dev`'LS`'dnl
ifdef(`TARGET',`, libstdc++-dev-TARGET-dcv1, libstdc++CXX_SO-dev-TARGET-dcv1
',`
')`'dnl
Description: The GNU Standard C++ Library v3 (development files)`'ifdef(`TARGET)',` (TARGET)', `')
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
Depends: BASEDEP, libstdc++CXX_SO`'LS (>= ${gcc:Version}), libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version})
ifdef(`TARGET',`Provides: libstdc++CXX_SO-pic-TARGET-dcv1
',`')`'dnl
Description: The GNU Standard C++ Library v3 (shared library subset kit)`'ifdef(`TARGET)',` (TARGET)', `')
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
Depends: BASEDEP, libstdc++CXX_SO`'LS (>= ${gcc:Version}), ${shlibs:Depends}
ifdef(`TARGET',`Provides: libstdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
Recommends: libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version})
Conflicts: libstdc++5-dbg`'LS, libstdc++5-3.3-dbg`'LS, libstdc++6-dbg`'LS, libstdc++6-4.0-dbg`'LS
Description: The GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
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
Depends: BASEDEP, lib32stdc++CXX_SO`'LS (>= ${gcc:Version}), libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version})
ifdef(`TARGET',`Provides: lib32stdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
Conflicts: lib32stdc++6-dbg`'LS, lib32stdc++6-4.0-dbg`'LS
Description: The GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
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
Depends: BASEDEP, lib64stdc++CXX_SO`'LS (>= ${gcc:Version}), libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version})
ifdef(`TARGET',`Provides: lib64stdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
Conflicts: lib64stdc++6-dbg`'LS, lib64stdc++6-4.0-dbg`'LS
Description: The GNU Standard C++ Library v3 (debugging files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the shared library of libstdc++ compiled with
 debugging symbols.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

ifdef(`TARGET', `', `
Package: libstdc++CXX_SO`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: gcc`'PV-base (>= ${gcc:SoftVersion})
Conflicts: libstdc++5-doc, libstdc++5-3.3-doc, libstdc++6-doc, libstdc++6-4.0-doc
Description: The GNU Standard C++ Library v3 (documentation files)
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
Depends: gnat`'PV-base (= ${gnat:Version}), gcc`'PV (>= ${gcc:Version}), ${dep:libgnat}, ${dep:libcdev}, ${shlibs:Depends}
Suggests: gnat`'PV-doc, ada-reference-manual
Provides: ada-compiler
Conflicts: gnat (<< 4.1), gnat-3.1, gnat-3.2, gnat-3.3, gnat-3.4, gnat-3.5, gnat-4.0, gnat-4.2
Description: The GNU Ada compiler
 This is the GNU Ada compiler, which compiles Ada on platforms supported
 by the gcc compiler. It uses the gcc backend to generate optimized code.

ifenabled(`libgnat',`
Package: libgnat`'-GNAT_V
Section: libs
Architecture: any
Priority: PRI(optional)
Depends: gnat`'PV-base (= ${gnat:Version}), ${shlibs:Depends}
Description: Runtime library for GNU Ada applications
 Library needed for GNU Ada applications linked against the shared library.

Package: libgnat`'-GNAT_V-dbg
Section: debug
Architecture: any
Priority: extra
Depends: gnat`'PV-base, libgnat`'-GNAT_V
Recommends: gnat-gdb (>= 6.4)
Description: Runtime library for GNU Ada applications
 Debugging symbols for the library needed for GNU Ada applications linked
 against the shared library.

Package: libgnatvsn`'GNAT_V-dev
Section: libdevel
Architecture: any
Priority: PRI(optional)
Depends: gnat`'PV-base (= ${gnat:Version}), gnat`'PV (= ${gnat:Version}), libgnatvsn`'GNAT_V (= ${gnat:Version})
Conflicts: libgnatvsn-dev (<< 4.1.2-19)
Description: GNU Ada compiler version library - development files
 This library exports selected components of GNAT, the GNU Ada compiler, for use
 in other packages, most notably ASIS and ASIS-based packages.  It is licensed
 under the GNAT-Modified GPL, allowing to link proprietary programs with it.
 .
 This package contains the development files and static library.

Package: libgnatvsn`'GNAT_V
Architecture: any
Priority: PRI(optional)
Section: libs
Depends: gnat`'PV-base (= ${gnat:Version}), libgnat`'-GNAT_V (= ${gnat:Version})
Description: GNU Ada compiler version library
 This library exports selected components of GNAT, the GNU Ada compiler, for use
 in other packages, most notably ASIS and ASIS-based packages.  It is licensed
 under the GNAT-Modified GPL, allowing to link proprietary programs with it.
 .
 This package contains the run-time shared library.

Package: libgnatvsn`'GNAT_V-dbg
Architecture: any
Priority: extra
Section: debug
Depends: gnat`'PV-base, libgnatvsn`'GNAT_V
Recommends: gnat-gdb (>= 6.4)
Description: GNU Ada compiler version library
 This library exports selected components of GNAT, the GNU Ada compiler, for use
 in other packages, most notably ASIS and ASIS-based packages.  It is licensed
 under the GNAT-Modified GPL, allowing to link proprietary programs with it.
 .
 This package contains the debugging symbols for the run-time shared library.

Package: libgnatprj`'GNAT_V-dev
Section: libdevel
Architecture: any
Priority: PRI(optional)
Depends: gnat`'PV-base (= ${gnat:Version}), gnat`'PV (= ${gnat:Version}), libgnatprj`'GNAT_V (= ${gnat:Version}), libgnatvsn`'GNAT_V-dev (= ${gnat:Version})
Conflicts: libgnatprj-dev (<< 4.1.2-19)
Description: GNU Ada Project Manager development files
 GNAT, the GNU Ada compiler, uses project files to organise source and object
 files in large-scale development efforts.  Several other tools, such as
 ASIS tools (package asis-programs) and GNAT Programming Studio (package
 gnat-gps) also use project files.  This library contains the necessary
 support; it was built from GNAT itself.  It is licensed under the pure GPL;
 all programs that use it must also be distributed under the GPL, or not
 distributed at all.
 .
 This package contains development files: install it to develop applications
 that understand GNAT project files.

Package: libgnatprj`'GNAT_V
Architecture: any
Priority: PRI(optional)
Section: libs
Depends: gnat`'PV-base (= ${gnat:Version}), libgnat`'-GNAT_V (= ${gnat:Version}), libgnatvsn`'GNAT_V (= ${gnat:Version})
Description: GNU Ada Project Manager
 GNAT, the GNU Ada compiler, uses project files to organise source and object
 files in large-scale development efforts.  Several other tools, such as
 ASIS tools (package asis-programs) and GNAT Programming Studio (package
 gnat-gps) also use project files.  This library contains the necessary
 support; it was built from GNAT itself.  It is licensed under the pure GPL;
 all programs that use it must also be distributed under the GPL, or not
 distributed at all.
 .
 This package contains the run-time shared library.

Package: libgnatprj`'GNAT_V-dbg
Architecture: any
Priority: extra
Section: debug
Depends: gnat`'PV-base, libgnatprj`'GNAT_V
Recommends: gnat-gdb (>= 6.4)
Description: GNU Ada Project Manager
 GNAT, the GNU Ada compiler, uses project files to organise source and object
 files in large-scale development efforts.  Several other tools, such as
 ASIS tools (package asis-programs) and GNAT Programming Studio (package
 gnat-gps) also use project files.  This library contains the necessary
 support; it was built from GNAT itself.  It is licensed under the pure GPL;
 all programs that use it must also be distributed under the GPL, or not
 distributed at all.
 .
 This package contains the debugging symbols for the run-time shared library.
')`'dnl libgnat

ifenabled(`lib64gnat',`
Package: lib64gnat`'-GNAT_V
Section: libs
Architecture: biarch64_archs
Priority: PRI(optional)
Depends: gnat`'PV-base (= ${gnat:Version}), ${dep:libcbiarch}, ${shlibs:Depends}
Description: Runtime library for GNU Ada applications
 Library needed for GNU Ada applications linked against the shared library.
')`'dnl libgnat

ifenabled(`gfdldoc',`
Package: gnat`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: SOFTBASEDEP
Suggests: gnat`'PV
Description: Documentation for the GNU Ada compiler (gnat)
 Documentation for the GNU Ada compiler in info `format'.
')`'dnl gfdldoc
')`'dnl ada

ifenabled(`pascal',`
Package: gpc`'PV
Architecture: any
Priority: PRI(optional)
Depends: SOFTBASEDEP, gcc`'PV (>= ${gcc:SoftVersion}), ${dep:libcdev}, ${shlibs:Depends}
Recommends: libgmp3-dev, libncurses5-dev
Suggests: gpc`'PV-doc (>= ${gpc:Version})
Provides: pascal-compiler
Description: The GNU Pascal compiler
 This is the GNU Pascal compiler, which compiles Pascal on platforms supported
 by the gcc compiler. It uses the gcc backend to generate optimized code.
Homepage: http://www.gnu-pascal.de/gpc/h-index.html

Package: gpc`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: SOFTBASEDEP, dpkg (>= 1.15.4) | install-info
Replaces: gpc (<= 2.91.58-3)
Suggests: gpc`'PV
Description: Documentation for the GNU Pascal compiler (gpc)
 Documentation for the GNU Pascal compiler in info `format'.
 .
 WARNING: the integration of gpc into gcc-4.x is still in an experimental
 stage. For production use, please use gpc or gpc-2.1-3.4.
Homepage: http://www.gnu-pascal.de/gpc/h-index.html
')`'dnl pascal

ifenabled(`d ',`
Package: gdc`'PV`'TS
Architecture: any
Priority: PRI(optional)
Depends: SOFTBASEDEP, g++`'PV`'TS (>= ${gcc:SoftVersion}), libphobos`'PHOBOS_V`'PV`'TS-dev (= ${gdc:Version}) [libphobos_no_archs], ${shlibs:Depends}
Provides: d-compiler`'TS
Description: The D compiler
 This is the D compiler, which compiles D on platforms supported by the gcc
 compiler. It uses the GCC backend to generate optimised code.
 .
Homepage: http://dgcc.sourceforge.net/

ifenabled(`libphobos',`
Package: libphobos`'PHOBOS_V`'PV`'TS-dev
Architecture: any
Section: libdevel
Priority: PRI(optional)
Depends: ${shlibs:Depends}, gdc`'PV`'TS (= ${gdc:Version}), zlib1g-dev (>= 1:1.2.3.3)
Provides: libphobos`'PHOBOS_V`'TS-dev
Replaces: gdc-4.1`'TS (<< 0.25-4.1.2-17)
Description: The phobos D standard library
 This is the Phobos standard library that comes with the D compiler.
 .
Homepage: http://www.digitalmars.com/d/phobos/phobos.html
')`'dnl libphobos
')`'dnl d

ifdef(`TARGET',`',`dnl
ifenabled(`libs',`
Package: gcc`'PV-soft-float
Architecture: arm armeb
Priority: PRI(optional)
Depends: BASEDEP, ifenabled(`cdev',`gcc`'PV (= ${gcc:Version}),') ${shlibs:Depends}
Replaces: gcc-soft-float-ss
Description: The soft-floating-point gcc libraries (arm)
 These are versions of basic static libraries such as libgcc.a compiled
 with the -msoft-float option, for CPUs without a floating-point unit.
')`'dnl commonlibs
')`'dnl

ifenabled(`fixincl',`
Package: fixincludes
Architecture: any
Priority: PRI(optional)
Depends: BASEDEP, gcc`'PV (= ${gcc:Version}), ${shlibs:Depends}
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
Depends: gcc`'PV-base (>= ${gcc:SoftVersion})
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
Depends: BASEDEP, ${shlibs:Depends}ifenabled(`cdev',`, gcc`'PV (= ${gcc:Version})')
Conflicts: gcc-3.2-nof
Description: The no-floating-point gcc libraries (powerpc)
 These are versions of basic static libraries such as libgcc.a compiled
 with the -msoft-float option, for CPUs without a floating-point unit.
')`'dnl libnof
')`'dnl

ifenabled(`source',`
Package: gcc`'PV-source
Architecture: all
Priority: PRI(optional)
Depends: gcc`'PV-base (>= ${gcc:SoftVersion}), make (>= 3.81)
Description: Source of the GNU Compiler Collection
 This package contains the sources and patches which are needed to
 build the GNU Compiler Collection (GCC).
')`'dnl source
dnl
')`'dnl gcc-X.Y
dnl last line in file
