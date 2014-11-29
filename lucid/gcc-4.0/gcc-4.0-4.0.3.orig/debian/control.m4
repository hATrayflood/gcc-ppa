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
Priority: PRI(standard)
Maintainer: ABE Hiroki (hATrayflood) <h.rayflood@gmail.com>
Standards-Version: 3.6.2
ifdef(`TARGET',`dnl cross
Build-Depends: dpkg-dev (>= 1.13.9), dpkg-cross (>= 1.25.99), LIBC_BUILD_DEP, LIBC_BIARCH_BUILD_DEP LIBUNWIND_BUILD_DEP LIBATOMIC_OPS_BUILD_DEP m4, autoconf2.59, automake1.9, libtool, autogen, gawk, bzip2, BINUTILS_BUILD_DEP, debhelper (>= 5.0), bison (>= 1:1.875a-1), flex, realpath (>= 1.9.12), lsb-release
',`dnl native
Build-Depends: dpkg-dev (>= 1.13.9), LIBC_BUILD_DEP, LIBC_BIARCH_BUILD_DEP libunwind7-dev (>= 0.98.5-6) [ia64], libatomic-ops-dev [ia64], m4, autoconf2.59, automake1.9, libtool, autogen, gawk, dejagnu (>= 1.4.3) [check_no_archs], expect-tcl8.3 [check_no_archs], bzip2, BINUTILS_BUILD_DEP, binutils-hppa64 (>= BINUTILSV) [hppa], debhelper (>= 5.0), gperf (>= 3.0.1), bison (>= 1:1.875a-1), flex, gettext, texinfo (>= 4.3), zlib1g-dev, libmpfr-dev [f95_no_archs], locales [locale_no_archs], procps [linux_gnu_archs], sharutils, PASCAL_BUILD_DEP`'JAVA_BUILD_DEP`'GNAT_BUILD_DEP realpath (>= 1.9.12), chrpath, lsb-release, dash [hppa]
Build-Depends-Indep: doxygen (>= 1.4.2), graphviz (>= 2.2), gsfonts-x11
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
Section: devel
Priority: PRI(required)
Conflicts: gcc-3.5-base, lib32gcc1 (= 1:4.0.2-9), lib32stdc++6 (= 4.0.2-9), lib64gcc1 (= 1:4.0.2-9), lib64stdc++6 (= 4.0.2-9)
Replaces: gcc-3.5-base
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
Priority: PRI(required)
Conflicts: gcc-3.5-base
Replaces: gcc-3.5-base
Description: The GNU Compiler Collection (base package)
 This package contains files common to all languages and libraries
 contained in the GNU Compiler Collection (GCC).
')`'dnl

ifenabled(`libgcc',`
Package: libgcc1`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',required)
Depends: BASEDEP, ${shlibs:Depends}
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
Architecture: ifdef(`TARGET',`all',`hppa m68k')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',required)
Depends: BASEDEP, ${shlibs:Depends}
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

ifenabled(`lib64gcc',`
Package: lib64gcc1`'LS
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: BASEDEP, ${dep:libcbiarch}
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
Priority: ifdef(`TARGET',`extra',`PRI(standard)')
Depends: BASEDEP, cpp`'PV`'TS (= ${gcc:Version}), binutils`'TS (>= ${binutils:Version}), ${dep:libgcc}, ${dep:libunwinddev}, ${shlibs:Depends}
Recommends: ${dep:libcdev}, libmudflap`'MF_SO-dev`'LS (>= ${gcc:Version})
Conflicts: gcc-3.2`'TS (<= 1:3.2.3-0pre8), gcc-3.5`'ifelse(DIST,`Ubuntu', `, amd64-libs-dev (<= 1.1ubuntu1)')
Replaces: gcc-3.5
Suggests: gcc`'PV-doc (>= ${gcc:SoftVersion}), gcc`'PV-locales (>= ${gcc:SoftVersion}), ${dep:libcbiarchdev}, ${dep:libgccbiarch}
Provides: c-compiler`'TS
Description: The GNU C compiler`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU C compiler, a fairly portable optimizing compiler for C.
ifdef(`TARGET', `dnl
 .
 This package contains C cross-compiler for TARGET architecture.
')`'dnl
')`'dnl cdev

ifenabled(`cdev',`
ifdef(`TARGET', `', `
Package: gcc`'PV-hppa64
Architecture: hppa
Section: devel
Priority: PRI(standard)
Depends: BASEDEP, ${dep:libcdev}, ${shlibs:Depends}
Conflicts: gcc-3.3-hppa64 (<= 1:3.3.4-5), gcc-3.4-hppa64 (<= 3.4.1-3), gcc-3.5-hppa64
Replaces: gcc-3.5-hppa64
Description: The GNU C compiler (cross compiler for hppa64)
 This is the GNU C compiler, a fairly portable optimizing compiler for C.
')`'dnl native
')`'dnl cdev

ifenabled(`cdev',`
Package: cpp`'PV`'TS
Architecture: any
Section: ifdef(`TARGET',`devel',`interpreters')
Priority: ifdef(`TARGET',`extra',`PRI(standard)')
Depends: BASEDEP, ${shlibs:Depends}
Replaces: cpp-3.5
Suggests: gcc`'PV-locales (>= ${gcc:SoftVersion})
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
Package: cpp`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: SOFTBASEDEP
Conflicts: cpp-3.5-doc
Replaces: cpp (<= 1:2.93.12), cpp-3.5-doc
Description: Documentation for the GNU C preprocessor (cpp)
 Documentation for the GNU C preprocessor in info `format'.
')`'dnl native

ifdef(`TARGET', `', `
Package: gcc`'PV-locales
Architecture: all
Section: devel
Priority: PRI(optional)
Depends: SOFTBASEDEP, cpp`'PV (>= ${gcc:SoftVersion})
Recommends: gcc`'PV (>= ${gcc:SoftVersion})
Replaces: cpp-4.0 (<< 4.0-0pre8), gcc-4.0 (<< 4.0-0pre8)
Description: The GNU C compiler (native language support files)
 Native language support files for GCC.
')`'dnl native
')`'dnl cdev

ifenabled(`c++',`
ifenabled(`c++dev',`
Package: g++`'PV`'TS
Architecture: any
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(standard)')
Depends: BASEDEP, gcc`'PV`'TS (= ${gcc:Version}), libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version}), ${shlibs:Depends}
Conflicts: g++-3.5
Replaces: gcc`'TS (<= 2.7.2.3-3), g++-3.5
Provides: c++-compiler`'TS, c++abi2-dev
Suggests: gcc`'PV-doc (>= ${gcc:SoftVersion}), ${dep:libcxxbiarch}
Description: The GNU C++ compiler`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU C++ compiler, a fairly portable optimizing compiler for C++.
ifdef(`TARGET', `dnl
 .
 This package contains C++ cross-compiler for TARGET architecture.
')`'dnl
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

Package: libmudflap`'MF_SO-dev
Architecture: any
Section: libdevel
Priority: PRI(optional)
Depends: BASEDEP, ${dep:libcdev}, libmudflap`'MF_SO (>= ${gcc:Version}), ${shlibs:Depends}
Description: GCC mudflap support libraries (development files)
 The libmudflap libraries are used by GCC for instrumenting pointer and array
 dereferencing operations.
 .
 This package contains the headers and the static libraries.
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

ifenabled(`objc',`
ifenabled(`objcdev',`
Package: gobjc`'PV
Architecture: any
Priority: PRI(optional)
Depends: BASEDEP, gcc`'PV (= ${gcc:Version}), ${dep:libcdev}, ${shlibs:Depends}, libobjc`'OBJC_SO (>= ${gcc:EpochVersion})
Suggests: gcc`'PV-doc (>= ${gcc:SoftVersion})
Conflicts: gobjc-3.5
Replaces: gobjc-3.5
Provides: objc-compiler
ifdef(`OBJC_GC',`Recommends: libgc-dev', `dnl')
ifdef(`__sparc__',`Conflicts: gcc`'PV-sparc64', `dnl')
Description: The GNU Objective-C compiler
 This is the GNU Objective-C compiler, which compiles
 Objective-C on platforms supported by the gcc compiler. It uses the
 gcc backend to generate optimized code.
')`'dnl objcdev

ifenabled(`libobjc',`
Package: libobjc`'OBJC_SO
Section: libs
Architecture: any
Priority: PRI(optional)
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

ifenabled(`f95',`
ifenabled(`fdev',`
Package: gfortran`'PV
Architecture: any
Priority: PRI(optional)
Depends: BASEDEP, gcc`'PV (= ${gcc:Version}), libgfortran`'FORTRAN_SO-dev (= ${gcc:Version}), ${dep:libcdev}, ${shlibs:Depends}
Provides: fortran95-compiler
Suggests: gfortran`'PV-doc
Conflicts: gfortran-3.5
Replaces: gfortran-3.5
Description: The GNU Fortran 95 compiler
 This is the GNU Fortran compiler, which compiles
 Fortran 95 on platforms supported by the gcc compiler. It uses the
 gcc backend to generate optimized code.

Package: gfortran`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: SOFTBASEDEP
Conflicts: gfortran-3.5-doc
Replaces: gfortran-3.5-doc
Description: Documentation for the GNU Fortran compiler (gfortran)
 Documentation for the GNU Fortran 95 compiler in info `format'.
')`'dnl fdev

ifenabled(`libfortran',`
Package: libgfortran`'FORTRAN_SO
Section: libs
Architecture: any
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}
Description: Runtime library for GNU Fortran applications
 Library needed for GNU Fortran applications linked against the
 shared library.

Package: libgfortran`'FORTRAN_SO-dev
Section: libdevel
Architecture: any
Priority: PRI(optional)
Depends: BASEDEP, libgfortran`'FORTRAN_SO (>= ${gcc:Version}), ${shlibs:Depends}
Replaces: gfortran-4.0 (<< 4.0.1-3)
Description: GNU Fortran library development
 Headers and static libraries for gfortran.
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
')`'dnl f95

ifenabled(`java',`
Package: gcj`'PV-base
Architecture: any
Section: libs
Priority: PRI(optional)
Conflicts: libgcj6 (= 4.0.2-9)
Description: The GNU Compiler Collection (gcj base package)
 This package contains files common to all java related packages
 built from the GNU Compiler Collection (GCC).

ifenabled(`gcj',`
Package: gcj`'PV
Architecture: any
Priority: PRI(optional)
Depends: gcj`'PV-base (= ${gcj:Version}), gcc`'PV (>= ${gcc:Version}), gij`'PV (= ${gcj:Version}), libgcj`'GCJ_SO-dev (= ${gcj:Version}), libgcj`'GCJ_SO-jar (>= ${gcj:SoftVersion}), java-common, ${shlibs:Depends}
Recommends: fastjar
Provides: java-compiler
Conflicts: gcj-3.5
Replaces: gcj-3.5
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
Conflicts: classpath (<= 0.04-4), libgcj3 (<< 1:3.2-0pre2)
Description: Java runtime library (common files)
 This package contains files shared by classpath and libgcj libraries.
')`'dnl libgcjcommon

Package: gij`'PV
Priority: optional
Architecture: any
Depends: gcj`'PV-base (= ${gcj:Version}), libgcj`'GCJ_SO (= ${gcj:Version}), ${shlibs:Depends}
Suggests: fastjar, gcj`'PV (= ${gcj:Version}), libgcj`'GCJ_SO-awt (= ${gcj:Version})
Provides: java-virtual-machine, java1-runtime, java-runtime
Conflicts: gij-3.5
Replaces: gij-3.5, gcj-4.0 (<< 4.0.0-2)
Description: The GNU Java bytecode interpreter
 GIJ is not limited to interpreting bytecode. It includes a class loader which
 can dynamically load shared objects, so it is possible to give it the name
 of a class which has been compiled and put into a shared library on the
 class path.

Package: libgcj`'GCJ_SO
Section: libs
Architecture: any
Priority: PRI(optional)
Depends: gcj`'PV-base (= ${gcj:Version}), libgcj-common, ${shlibs:Depends}
Recommends: libgcj`'GCJ_SO-jar (>= ${gcj:SoftVersion})
Description: Java runtime library for use with gcj
 This is the runtime that goes along with the gcj front end to
 gcc. libgcj includes parts of the Java Class Libraries, plus glue to
 connect the libraries to the compiler and the underlying OS.

Package: libgcj`'GCJ_SO-jar
Section: libs
Architecture: all
Priority: PRI(optional)
Depends: gcj`'PV-base (>= ${gcj:Version}), libgcj`'GCJ_SO (>= ${gcj:SoftVersion})
Conflicts: libgcj6-common
Replaces: libgcj6-common
Description: Java runtime library for use with gcj (jar files)
 This is the jar file that goes along with the gcj front end to gcc.

Package: libgcj`'GCJ_SO-awt
Section: libs
Architecture: any
Priority: PRI(optional)
Depends: gcj`'PV-base (= ${gcj:Version}), libgcj`'GCJ_SO (= ${gcj:Version}), ${shlibs:Depends}
Description: AWT peer runtime libraries for use with gcj
 These are runtime libraries holding the AWT peer implementations
 for libgcj (currently only the GTK based peer library).
')`'dnl libgcj

ifenabled(`lib64gcj',`
Package: lib64gcj`'GCJ_SO
Section: libs
Architecture: biarch64_archs
Priority: PRI(optional)
Depends: gcj`'PV-base (= ${gcj:Version}), libgcj-common, ${shlibs:Depends}
Description: Java runtime library for use with gcj (64bit)
 This is the runtime that goes along with the gcj front end to
 gcc. libgcj includes parts of the Java Class Libraries, plus glue to
 connect the libraries to the compiler and the underlying OS.
')`'dnl lib64gcj

ifenabled(`lib32gcj',`
Package: lib32gcj`'GCJ_SO
Section: libs
Architecture: biarch32_archs
Priority: PRI(optional)
Depends: gcj`'PV-base (= ${gcj:Version}), libgcj-common, lib32z1
Description: Java runtime library for use with gcj (32bit)
 This is the runtime that goes along with the gcj front end to
 gcc. libgcj includes parts of the Java Class Libraries, plus glue to
 connect the libraries to the compiler and the underlying OS.
')`'dnl lib32gcj

ifenabled(`libgcjdev',`
Package: libgcj`'GCJ_SO-dev
Section: libdevel
Architecture: any
Priority: PRI(optional)
Depends: gcj`'PV-base (= ${gcj:Version}), gcj`'PV (= ${gcj:Version}), libgcj`'GCJ_SO (>= ${gcj:Version}), libgcj`'GCJ_SO-jar (>= ${gcj:SoftVersion}), libgcj`'GCJ_SO-awt (>= ${gcj:Version}), zlib1g-dev, ${shlibs:Depends}
Conflicts: libgcj7-dev, libgcj5-dev, libgcj4-dev, libgcj3-dev, libgcj2-dev
Replaces: libstdc++6-4.0-dev (<< 4.0.1)
Description: Java development headers and static library for use with gcj
 These are the development headers and static libraries that go along
 with the gcj front end to gcc. libgcj includes parts of the Java Class
 Libraries, plus glue to connect the libraries to the compiler and the
 underlying OS.

Package: lib32gcj`'GCJ_SO-dev
Section: libdevel
Architecture: biarch32_archs
Priority: PRI(optional)
Depends: gcj`'PV-base (= ${gcj:Version}), libgcj`'GCJ_SO-dev (= ${gcj:Version}), lib32gcj`'GCJ_SO (>= ${gcj:Version}), lib32z1-dev, ${shlibs:Depends}
Description: Java development and static library for use with gcj (32bit)
 These are the development headers and static libraries that go along
 with the gcj front end to gcc. libgcj includes parts of the Java Class
 Libraries, plus glue to connect the libraries to the compiler and the
 underlying OS.

Package: libgcj`'GCJ_SO-dbg
Section: libdevel
Architecture: any
Priority: extra
Depends: gcj`'PV-base (= ${gcj:Version}), libgcj`'GCJ_SO-dev (= ${gcj:Version})
Description: Debugging symbols for libraries provided in libgcj`'GCJ_SO-dev
 The package provides debugging symbols for the libraries provided
 in libgcj`'GCJ_SO-dev.

Package: lib32gcj`'GCJ_SO-dbg
Section: libdevel
Architecture: biarch32_archs
Priority: extra
Depends: gcj`'PV-base (= ${gcj:Version}), lib32gcj`'GCJ_SO-dev (= ${gcj:Version})
Description: Debugging symbols for libraries provided in lib32gcj`'GCJ_SO-dev
 The package provides debugging symbols for the libraries provided
 in lib32gcj`'GCJ_SO-dev.

Package: libgcj`'GCJ_SO-src
Section: libdevel
Architecture: all
Priority: PRI(optional)
Depends: gcj`'PV-base (>= ${gcj:Version}), gcj`'PV (>= ${gcj:SoftVersion}), libgcj`'GCJ_SO-jar (= ${gcj:Version})
Description: libgcj java sources for use in eclipse
 These are the java source files packaged as a zip file for use in development
 environments like eclipse.
')`'dnl libgcjdev
')`'dnl java

ifenabled(`fastjar',`
Package: fastjar
Section: devel
Architecture: any
Priority: PRI(optional)
Depends: ${shlibs:Depends}
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
Description: Foreign Function Interface library runtime (32bit)
 A foreign function interface is the popular name for the interface that
 allows code written in one language to call code written in another
 language.

Package: lib64ffi`'FFI_SO
Section: libs
Architecture: biarch64_archs
Priority: PRI(optional)
Depends: gcc`'PV`'-base (= ${gcc:Version}), ${dep:libcbiarch}, ${shlibs:Depends}
Description: Foreign Function Interface library runtime (64bit)
 A foreign function interface is the popular name for the interface that
 allows code written in one language to call code written in another
 language.

Package: libffi`'FFI_SO-dev
Section: libdevel
Architecture: any
Priority: PRI(optional)
Depends: gcc`'PV`'-base (= ${gcc:Version}), libffi`'FFI_SO (>= ${gcc:Version})
Provides: libffi-dev
Conflicts: libffi1-dev, libffi2-dev, libffi3-dev, libffi-dev
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
Priority: ifdef(`TARGET',`extra',PRI(standard))
Depends: BASEDEP, g++`'PV`'TS (= ${gcc:Version}), libstdc++CXX_SO`'LS (>= ${gcc:Version}), ${dep:libcdev}
ifdef(`TARGET',`',`dnl native
Conflicts: libg++27-dev, libg++272-dev (<< 2.7.2.8-1), libstdc++2.8-dev, libg++2.8-dev, libstdc++2.9-dev, libstdc++2.9-glibc2.1-dev, libstdc++2.10-dev (<< 1:2.95.3-2), libstdc++3.0-dev, libstdc++6-0-dev
Replaces: libstdc++6-0-dev
Suggests: libstdc++CXX_SO`'PV-doc, stl-manual
')`'dnl native
Provides: libstdc++-dev`'LS
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
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: extra
Depends: BASEDEP, libstdc++CXX_SO`'LS (>= ${gcc:Version})
Recommends: libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version})
Conflicts: libstdc++5-dbg`'LS, libstdc++5-3.3-dbg`'LS, libstdc++6-dbg`'LS, libstdc++6-0-dbg
Replaces: libstdc++6-0-dbg
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
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: extra
Depends: BASEDEP, lib32stdc++CXX_SO`'LS (>= ${gcc:Version}), libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version})
Conflicts: libstdc++5-dbg`'LS, libstdc++5-3.3-dbg`'LS, libstdc++6-dbg`'LS, libstdc++6-0-dbg, libstdc++6-4.0-dbg (<< 4.0.0-7ubuntu7)
Replaces: libstdc++6-0-dbg
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
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: extra
Depends: BASEDEP, lib64stdc++CXX_SO`'LS (>= ${gcc:Version}), libstdc++CXX_SO`'PV-dev`'LS (= ${gcc:Version})
Conflicts: libstdc++5-dbg`'LS, libstdc++5-3.3-dbg`'LS, libstdc++6-dbg`'LS, libstdc++6-0-dbg, libstdc++6-4.0-dbg (<< 4.0.0-7ubuntu7)
Replaces: libstdc++6-0-dbg
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
Depends: SOFTBASEDEP
Conflicts: libstdc++5-doc, libstdc++5-3.3-doc, libstdc++6-doc
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
Depends: BASEDEP, gcc`'PV (= ${gcc:Version}), ${dep:libgnat}, ${dep:libcdev}, ${shlibs:Depends}
Suggests: gnat`'PV-doc, ada-reference-manual
Provides: ada-compiler, gnat
Conflicts: gnat, gnat-3.1, gnat-3.2, gnat-3.3, gnat-3.4, gnat-3.5
Replaces: gnat-3.5
Description: The GNU Ada compiler
 This is the GNU Ada compiler, which compiles Ada on platforms supported
 by the gcc compiler. It uses the gcc backend to generate optimized code.

ifenabled(`libgnat',`
Package: libgnat`'-GNAT_V
Section: libs
Architecture: any
Priority: PRI(optional)
Depends: BASEDEP, ${shlibs:Depends}
Conflicts: libgnat-3.5
Replaces: libgnat-3.5
Description: Runtime library for GNU Ada applications
 Library needed for GNU Ada applications linked against the shared library.
')`'dnl libgnat

Package: gnat`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: SOFTBASEDEP
Suggests: gnat`'PV
Conflicts: gnat-3.5-doc
Replaces: gnat-3.5-doc
Description: Documentation for the GNU Ada compiler (gnat)
 Documentation for the GNU Ada compiler in info `format'.
')`'dnl ada

ifenabled(`pascal',`
Package: gpc`'GPC_PV
Architecture: any
Priority: PRI(optional)
Depends: BASEDEP, gcc`'PV (= ${gcc:Version}), ${dep:libcdev}, ${shlibs:Depends}
Recommends: libgmp3-dev, libncurses5-dev
Suggests: gpc`'GPC_PV-doc (>= ${gpc:Version})
Provides: pascal-compiler
Description: The GNU Pascal compiler
 This is the GNU Pascal compiler, which compiles Pascal on platforms supported
 by the gcc compiler. It uses the gcc backend to generate optimized code.
 .
 WARNING: the integration of gpc into gcc-3.x is still in an experimental
 stage. For production use, please use gpc or gpc-2.95.

Package: gpc`'GPC_PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: SOFTBASEDEP
Replaces: gpc (<= 2.91.58-3)
Suggests: gpc`'GPC_PV
Description: Documentation for the GNU Pascal compiler (gpc)
 Documentation for the GNU Pascal compiler in info `format'.
 .
 WARNING: the integration of gpc into gcc-3.x is still in an experimental
 stage. For production use, please use gpc or gpc-2.95.
')`'dnl pascal

ifenabled(`treelang',`
Package: treelang`'PV
Architecture: any
Priority: PRI(optional)
Depends: BASEDEP, gcc`'PV (= ${gcc:Version}), ${shlibs:Depends}
Conflicts: treelang-3.5
Replaces: treelang-3.5
Description: The GNU Treelang compiler
 Treelang is a sample language, useful only to help people understand how
 to implement a new language front end to GCC. It is not a useful
 language in itself other than as an example or basis for building a new
 language. Therefore only language developers are likely to have an
 interest in it.
')`'dnl treelang

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
Package: gcc`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: SOFTBASEDEP
Conflicts: gcc-docs (<< 2.95.2), gcc-3.5-doc
Replaces: gcc (<=2.7.2.3-4.3), gcc-docs (<< 2.95.2), gcc-3.5-doc
Description: Documentation for the GNU compilers (gcc, gobjc, g++)
 Documentation for the GNU compilers in info `format'.
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
dnl
')`'dnl gcc-X.Y
dnl last line in file
