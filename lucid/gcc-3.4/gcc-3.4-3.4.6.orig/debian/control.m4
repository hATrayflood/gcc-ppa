divert(-1)

define(`checkdef',`ifdef($1, , `errprint(`error: undefined macro $1
')m4exit(1)')')
define(`errexit',`errprint(`error: undefined macro `$1'
')m4exit(1)')

dnl The following macros must be defined, when called:
dnl ifdef(`SRCNAME',	, errexit(`SRCNAME'))
dnl ifdef(`PV',		, errexit(`PV'))
dnl ifdef(`ARCH',	, errexit(`ARCH'))

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
Build-Depends: dpkg-dev (>= 1.13.9), LIBC_BUILD_DEP, m4, autoconf2.13, autoconf, automake1.4, automake1.7, libtool, autotools-dev, gawk, bzip2, dpkg-cross (>= 1.18.1), BINUTILS_BUILD_DEP, debhelper (>= 4.1), bison (>= 1:2.3), flex (>= 2.5.33), realpath (>= 1.9.12), lsb-release`'TARGETBD
',`dnl native
Build-Depends: dpkg-dev (>= 1.13.9), LIBC_BUILD_DEP, LIBC_BIARCH_BUILD_DEP libunwind7-dev (>= 0.98.5-7) [ia64], libatomic-ops-dev [ia64], m4, autoconf2.13, autoconf, automake1.4, automake1.7, libtool, autotools-dev, gawk, dejagnu (>= 1.4.3) [check_no_archs], bzip2, BINUTILS_BUILD_DEP, binutils-hppa64 (>= BINUTILSV) [hppa], debhelper (>= 4.1), gperf (>= 2.7-3), bison (>= 1:2.3), flex (>= 2.5.33), gettext, texinfo (>= 4.3), zlib1g-dev, gcc, locales [locale_no_archs !hurd-i386], procps [check_no_archs], sharutils, PASCAL_BUILD_DEP JAVA_BUILD_DEP GNAT_BUILD_DEP realpath (>= 1.9.12), lsb-release
Build-Depends-Indep: doxygen (>= 1.4.2), graphviz (>= 2.2), gsfonts-x11
')dnl
Homepage: https://launchpad.net/~h-rayflood/+archive/gcc-lower
XS-Vcs-Browser: https://github.com/hATrayflood/gcc-ppa

ifdef(`TARGET', `', `
ifenabled(`gccbase',`
Package: gcc`'PV-base
Architecture: any
Section: devel
Priority: PRI(required)
Description: The GNU Compiler Collection (base package)
 This package contains files common to all languages and libraries
 contained in the GNU Compiler Collection (GCC).
ifdef(`BASE_ONLY', `dnl
 .
 This version of GCC is not yet available for this architecture.
 Please use the compilers from the gcc-snapshot package for testing.
')`'dnl
')`'dnl gccbase
')`'dnl native

ifenabled(`libgcc',`
Package: libgcc1`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',required)
Depends: ${shlibs:Depends}
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
Architecture: ifdef(`TARGET',`all',`hppa m68k')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(required))
Depends: ${shlibs:Depends}
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

ifenabled(`lib64gcc',`
Package: lib64gcc1`'LS
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: ${dep:libcbiarch}
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
Package: lib32gcc1
Architecture: biarch32_archs
Section: libs
Priority: optional
Depends: ${dep:libcbiarch}
ifdef(`TARGET',`Provides: lib32gcc1-TARGET-dcv1
',`')`'dnl
Conflicts: ia32-libs-openoffice.org (<= 1ubuntu2)
Replaces: ia32-libs-openoffice.org (<= 1ubuntu2)
Description: GCC support library (32-bit version)
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
Depends: gcc`'PV-base (= ${gcc:Version}), cpp`'PV`'TS (= ${gcc:Version}), binutils`'TS (>= ${binutils:Version}), ${dep:libgcc}, ${dep:libunwinddev}, ${shlibs:Depends}
Recommends: ${dep:libcdev}
Conflicts: gcc-3.2`'TS (<= 1:3.2.3-0pre8)
Suggests: gcc`'PV-doc (>= ${gcc:SoftVersion}), ${dep:libcbiarchdev}, ${dep:libgccbiarch}
Provides: c-compiler`'TS
Description: The GNU C compiler`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU C compiler, a fairly portable optimizing compiler for C.
 .
 ABIs changed between gcc-3.3 and gcc-3.4 on some architectures (hppa, m68k,
 mips, mipsel, sparc). Please read /usr/share/doc/gcc-3.4/README.Debian
 for more details.
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
Priority: PRI(optional)
Depends: gcc`'PV-base (= ${gcc:Version}), ${dep:libcdev}, ${shlibs:Depends}
Conflicts: gcc-3.3-hppa64 (<= 1:3.3.4-5), gcc-3.5-hppa64 (<= 3.5-0pre1)
Description: The GNU C compiler (cross compiler for hppa64)
 This is the GNU C compiler, a fairly portable optimizing compiler for C.
')`'dnl native
')`'dnl cdev

ifenabled(`cdev',`
Package: cpp`'PV`'TS
Architecture: any
Section: ifdef(`TARGET',`devel',`interpreters')
Priority: ifdef(`TARGET',`extra',`PRI(standard)')
Depends: gcc`'PV-base (= ${gcc:Version}), ${shlibs:Depends}
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
Replaces: cpp (<= 1:2.93.12)
Description: Documentation for the GNU C preprocessor (cpp)
 Documentation for the GNU C preprocessor in info `format'.
')`'dnl gfdldoc
')`'dnl native
')`'dnl cdev

ifenabled(`c++',`
ifenabled(`c++dev',`
Package: g++`'PV`'TS
Architecture: any
Section: devel
Priority: ifdef(`TARGET',`extra',`PRI(standard)')
Depends: gcc`'PV-base (= ${gcc:Version}), gcc`'PV`'TS (= ${gcc:Version}), libstdc++CXX_SO-dev`'LS (= ${gcc:Version}), ${shlibs:Depends}, libstdc++6 (>= 4.0.2-4)
Replaces: gcc`'TS (<= 2.7.2.3-3)
Provides: c++-compiler`'TS, c++abi2-dev
Suggests: gcc`'PV-doc (>= ${gcc:SoftVersion}), ${dep:libcxxbiarch}
Description: The GNU C++ compiler`'ifdef(`TARGET)',` (cross compiler for TARGET architecture)', `')
 This is the GNU C++ compiler, a fairly portable optimizing compiler for C++.
 .
 ABIs changed between gcc-3.3 and gcc-3.4 on some architectures (hppa, m68k,
 mips, mipsel, sparc). Please read /usr/share/doc/gcc-3.4/README.Debian
 for more details. Do not mix code compiled with g++-3.3 and g++-3.4.
ifdef(`TARGET', `dnl
 .
 This package contains C++ cross-compiler for TARGET architecture.
')`'dnl
')`'dnl c++dev
')`'dnl c++

ifenabled(`proto',`
Package: protoize
Architecture: any
Priority: PRI(optional)
Depends: gcc`'PV-base ((= ${gcc:Version}), gcc`'PV (>= ${gcc:Version}), ${shlibs:Depends}
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
Depends: gcc`'PV-base (= ${gcc:Version}), gcc`'PV (= ${gcc:Version}), ${shlibs:Depends}, libobjc`'OBJC_SO (>= ${gcc:EpochVersion})
Suggests: gcc`'PV-doc (>= ${gcc:SoftVersion})
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
Depends: gcc`'PV-base (= ${gcc:Version}), ${shlibs:Depends}
Description: Runtime library for GNU Objective-C applications
 Library needed for GNU ObjC applications linked against the shared library.
')`'dnl libobjc
')`'dnl objc

ifenabled(`f77',`
ifenabled(`fdev',`
Package: g77`'PV
Architecture: any
Priority: PRI(optional)
Depends: gcc`'PV-base (= ${gcc:Version}), gcc`'PV (= ${gcc:Version}), libg2c`'G2C_SO-dev (>= ${gcc:EpochVersion}), ${shlibs:Depends}
Provides: fortran77-compiler
Suggests: g77`'PV-doc
Conflicts: g77-2.95 (<= 1:2.95.4-19), g77-3.0 (<= 1:3.0.4-16), g77-3.2 (<= 1:3.2.3-9), g77-3.3 (<= 1:3.3.4-3)
Description: The GNU Fortran 77 compiler
 This is the GNU g77 Fortran compiler, which compiles
 Fortran 77 on platforms supported by the gcc compiler. It uses the
 gcc backend to generate optimized code.

ifenabled(`gfdldoc',`
Package: g77`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: gcc`'PV-base (>= ${gcc:SoftVersion})
Replaces: g77 (<= 1:2.91.58-3)
Description: Documentation for the GNU Fortran compiler (g77)
 Documentation for the GNU Fortran 77 compiler in info `format'.
')`'dnl gfdldoc
')`'dnl fdev

ifenabled(`libg2c',`
Package: libg2c`'G2C_SO
Section: libs
Architecture: any
Priority: PRI(optional)
Depends: gcc`'PV-base (= ${gcc:Version}), ${shlibs:Depends}
Description: Runtime library for GNU Fortran 77 applications
 Library needed for GNU Fortran 77 applications linked against the
 shared library.

Package: libg2c`'G2C_SO-dev
Section: libdevel
Architecture: any
Priority: PRI(optional)
Depends: gcc`'PV-base (= ${gcc:Version}), libg2c`'G2C_SO (= ${gcc:EpochVersion}), ${shlibs:Depends}
Conflicts: g77-2.95, g77-2.96, g77-3.0 (<= 1:3.0.4-16), g77-3.2 (<= 1:3.2.3-9), g77-3.3 (<= 1:3.3.3-0pre3)
Description: GNU Fortran 77 library development
 Headers and static libraries for g2c.
')`'dnl libg2c

ifenabled(`lib64g2c',`
Package: lib64g2c`'G2C_SO
Section: libs
Architecture: biarch64_archs
Priority: PRI(optional)
Depends: gcc`'PV-base (= ${gcc:Version}), ${dep:libcbiarch}, ${shlibs:Depends}
Replaces: libg2c0 (<< 1:3.4.4-7)
Description: Runtime library for GNU Fortran 77 applications (64bit)
 Library needed for GNU Fortran 77 applications linked against the
 shared library.
')`'dnl lib64g2c

ifenabled(`lib32g2c',`
Package: lib32g2c`'G2C_SO
Section: libs
Architecture: biarch32_archs
Priority: PRI(optional)
Depends: gcc`'PV-base (= ${gcc:Version}), ${dep:libcbiarch}, ${shlibs:Depends}
Replaces: libg2c0 (<< 1:3.4.4-7)
Description: Runtime library for GNU Fortran 77 applications (32bit)
 Library needed for GNU Fortran 77 applications linked against the
 shared library.
')`'dnl lib32g2c
')`'dnl f77

ifenabled(`java',`
ifenabled(`javadev',`
Package: gcj`'PV
Architecture: any
Priority: PRI(optional)
Depends: gcc`'PV-base (= ${gcc:Version}), g++`'PV (= ${gcc:Version}), libgcj`'GCJ_SO-common (>= ${gcc:SoftVersion}), ${shlibs:Depends}, java-common
Recommends: fastjar, gij`'PV (>= ${gcc:Version}), libgcj`'GCJ_SO-dev (>= ${gcc:Version})
Provides: java-compiler
Suggests: libgcj`'GCJ_SO-awt (>= ${gcc:Version})
Conflicts: libgcj4-dev, libgcj6-dev, libgcj7-dev
Description: The GNU compiler for Java(TM)
 GCJ is a front end to the GCC compiler which can natively compile both
 Java(tm) source and bytecode files. The compiler can also generate class
 files.
')`'dnl javadev

ifenabled(`libgcj',`
Package: gij`'PV
Priority: optional
Architecture: any
Depends: gcc`'PV-base (= ${gcc:Version}), ${shlibs:Depends}
Suggests: fastjar, gcj`'PV (= ${gcc:Version}), libgcj`'GCJ_SO-awt (= ${gcc:Version})
Provides: java-virtual-machine, java1-runtime
Description: The GNU Java bytecode interpreter
 GIJ is not limited to interpreting bytecode. It includes a class loader which
 can dynamically load shared objects, so it is possible to give it the name
 of a class which has been compiled and put into a shared library on the
 class path.

Package: libgcj-common
Section: libs
Architecture: all
Priority: PRI(optional)
Depends: gcc`'PV-base (>= ${gcc:SoftVersion})
Conflicts: classpath (<= 0.04-4), libgcj3 (<< 1:3.2-0pre2)
Description: Java runtime library (common files)
 This package contains files shared by classpath and libgcj libraries.

Package: libgcj`'GCJ_SO
Section: libs
Architecture: any
Priority: PRI(optional)
Depends: gcc`'PV-base (= ${gcc:Version}), libgcj-common (>= ${gcc:SoftVersion}), ${shlibs:Depends}
Recommends: libgcj`'GCJ_SO-common (>= ${gcc:SoftVersion})
Description: Java runtime library for use with gcj
 This is the runtime that goes along with the gcj front end to
 gcc. libgcj includes parts of the Java Class Libraries, plus glue to
 connect the libraries to the compiler and the underlying OS.

Package: libgcj`'GCJ_SO-common
Section: libs
Architecture: all
Priority: PRI(optional)
Depends: gcc`'PV-base (>= ${gcc:SoftVersion}), libgcj`'GCJ_SO (>= ${gcc:SoftVersion})
Conflicts: libgcj5 (<< 3.4.0-1)
Replaces: libgcj5 (<< 3.4.0-1)
Description: Java runtime library for use with gcj (jar files)
 This is the jar file that goes along with the gcj front end to gcc.

Package: libgcj`'GCJ_SO-awt
Section: libs
Architecture: any
Priority: PRI(optional)
Depends: libgcj`'GCJ_SO (= ${gcc:Version}), ${shlibs:Depends}
Conflicts: libgcj5 (<< 3.4.0-2), libgcj-awt5
Replaces: libgcj5 (<< 3.4.0-2), libgcj-awt5
Description: AWT peer runtime libraries for use with gcj
 These are runtime libraries holding the AWT peer implementations
 for libgcj (currently only the GTK based peer library).
')`'dnl libgcj

ifenabled(`javadev',`
Package: libgcj`'GCJ_SO-dev
Section: libdevel
Architecture: any
Priority: PRI(optional)
Depends: gcj`'PV (= ${gcc:Version}), libgcj`'GCJ_SO (>= ${gcc:Version}), libgcj`'GCJ_SO-common (>= ${gcc:SoftVersion}), libgcj`'GCJ_SO-awt (>= ${gcc:Version}), zlib1g-dev, ${shlibs:Depends}
Conflicts: libgcj2-dev, libgcj3-dev, libgcj4-dev
Description: Java development headers and static library for use with gcj
 This is the development headers and static libraries that go along
 with the gcj front end to gcc. libgcj includes parts of the Java Class
 Libraries, plus glue to connect the libraries to the compiler and the
 underlying OS.
')`'dnl javadev
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

Package: libffi`'FFI_SO-dev
Section: libdevel
Architecture: any
Priority: PRI(optional)
Depends: gcc`'PV`'-base (= ${gcc:Version}), libffi`'FFI_SO (>= ${gcc:EpochVersion})
Recommends: gcc-3.4
Conflicts: libffi1-dev, libffi2-dev
Description: Foreign Function Interface library (development files)
 This package contains the headers and static library files necessary for
 building building programs which use libffi.
 .
 Use this package together with gcc-3.4.
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
Depends: gcc`'PV-base (= ${gcc:Version}), ${shlibs:Depends}
ifdef(`TARGET',`Provides: libstdc++CXX_SO-TARGET-dcv1
',`')`'dnl
Conflicts: libstdc++6-0
Replaces: libstdc++6-0
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

Package: lib32stdc++CXX_SO`'LS
Architecture: ifdef(`TARGET',`all',`biarch32_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(optional))
Depends: gcc`'PV-base (= ${gcc:Version}), lib32gcc`'GCC_SO`'LS
ifdef(`TARGET',`Provides: lib32stdc++CXX_SO-TARGET-dcv1
',`')`'dnl
Description: The GNU Standard C++ Library v3 (ia32)
 This package contains an additional runtime library for C++ programs
 built with the GNU compiler.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl
')`'dnl libcxx

ifenabled(`lib64cxx',`
Package: lib64stdc++CXX_SO`'LS
Architecture: ifdef(`TARGET',`all',`biarch64_archs')
Section: ifdef(`TARGET',`devel',`libs')
Priority: ifdef(`TARGET',`extra',PRI(important))
Depends: gcc`'PV-base (= ${gcc:Version}), ${shlibs:Depends}
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
Package: libstdc++CXX_SO-dev`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: ifdef(`TARGET',`extra',PRI(standard))
Depends: gcc`'PV-base (= ${gcc:Version}), g++`'PV`'TS (= ${gcc:Version}), libstdc++CXX_SO`'LS (>= ${gcc:Version}), ${dep:libcdev}
ifdef(`TARGET',`',`dnl
Conflicts: libstdc++6-0-dev, libg++27-dev, libg++272-dev (<< 2.7.2.8-1), libstdc++2.8-dev, libg++2.8-dev, libstdc++2.9-dev, libstdc++2.9-glibc2.1-dev, libstdc++2.10-dev (<< 1:2.95.3-2), libstdc++3.0-dev
Replaces: libstdc++6-0-dev
Suggests: libstdc++CXX_SO-doc
')`'dnl native
Provides: libstdc++-dev`'LS`'dnl
ifdef(`TARGET',`, libstdc++-dev-TARGET-dcv1, libstdc++CXX_SO-dev-TARGET-dcv1
',`
')`'dnl
Description: The GNU Standard C++ Library v3 (development files)`'ifdef(`TARGET)',` (TARGET)', `')
 This package contains the headers and static library files necessary for
 building C++ programs which use libstdc++. Be advised that this only works
 with the GNU C++ compiler (version 3.0), and no earlier library will work it.
 .
 libstdc++-v3 is a complete rewrite from the previous libstdc++-v2, which
 was included up to g++-2.95. The first version of libstdc++-v3 appeared
 in g++-3.0.
ifdef(`TARGET', `dnl
 .
 This package contains files for TARGET architecture, for use in cross-compile
 environment.
')`'dnl

Package: libstdc++CXX_SO-pic`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: extra
Depends: gcc`'PV-base (= ${gcc:Version}), libstdc++CXX_SO`'LS (>= ${gcc:Version}), libstdc++CXX_SO-dev`'LS (= ${gcc:Version})
ifdef(`TARGET',`Provides: libstdc++CXX_SO-pic-TARGET-dcv1
',`')`'dnl
Conflicts: libstdc++6-0-pic
Replaces: libstdc++6-0-pic
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

Package: libstdc++CXX_SO-dbg`'LS
Architecture: ifdef(`TARGET',`all',`any')
Section: ifdef(`TARGET',`devel',`libdevel')
Priority: extra
Depends: gcc`'PV-base (= ${gcc:Version}), libstdc++CXX_SO`'LS (>= ${gcc:Version})
ifdef(`TARGET',`Provides: libstdc++CXX_SO-dbg-TARGET-dcv1
',`')`'dnl
Recommends: libstdc++CXX_SO-dev`'LS (= ${gcc:Version})
Conflicts: libstdc++6-0-dbg, libstdc++5-dbg`'LS, libstdc++5-3.3-dbg`'LS, libstdc++6-4.0-dbg`'LS
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
Package: libstdc++6-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: gcc`'PV-base (>= ${gcc:SoftVersion})
Conflicts: libstdc++5-doc, libstdc++5-3.3-doc
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
Depends: gcc`'PV-base (= ${gcc:Version}), gcc`'PV (= ${gcc:Version}), ${dep:libgnat}, ${shlibs:Depends}
Suggests: gnat`'PV-doc, ada-reference-manual
Provides: ada-compiler
Conflicts: gnat, gnat-3.1, gnat-3.2, gnat-3.3
Provides: gnat
Description: The GNU Ada compiler
 This is the GNU Ada compiler, which compiles Ada on platforms supported
 by the gcc compiler. It uses the gcc backend to generate optimized code.

ifenabled(`libgnat',`
Package: libgnat`'-GNAT_V
Section: libs
Architecture: any
Priority: PRI(optional)
Depends: gcc`'PV-base (= ${gcc:Version}), ${shlibs:Depends}
Description: Runtime library for GNU Ada applications
 Library needed for GNU Ada applications linked against the shared library.
')`'dnl libgnat

ifenabled(`gfdldoc',`
Package: gnat`'PV-doc
Architecture: all
Section: doc
Priority: PRI(optional)
Depends: gcc`'PV-base (>= ${gcc:SoftVersion})
Suggests: gnat`'PV
Description: Documentation for the GNU Ada compiler (gnat)
 Documentation for the GNU Ada compiler in info `format'.
')`'dnl gfdldoc
')`'dnl ada

ifenabled(`pascal',`
Package: gpc`'GPC_PV
Architecture: any
Priority: PRI(optional)
Depends: gcc`'PV-base (= ${gcc:Version}), gcc`'PV (= ${gcc:Version}), ${shlibs:Depends}
Recommends: libgmp3-dev, libncurses5-dev
Suggests: gpc`'GPC_PV-doc (>= ${gcc:Version})
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
Depends: gcc`'PV-base (>= ${gcc:SoftVersion})
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
Depends: gcc`'PV-base (= ${gcc:Version}), gcc`'PV (= ${gcc:Version}), ${shlibs:Depends}
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
Depends: gcc`'PV-base (= ${gcc:Version}), ifenabled(`cdev',`gcc`'PV (= ${gcc:Version}),') ${shlibs:Depends}
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
Depends: gcc`'PV-base (= ${gcc:Version}), gcc`'PV (= ${gcc:Version}), ${shlibs:Depends}
Description: Fix non-ANSI header files
 FixIncludes was created to fix non-ANSI system header files. Many
 system manufacturers supply proprietary headers that are not ANSI compliant.
 The GNU compilers cannot compile non-ANSI headers. Consequently, the
 FixIncludes shell script was written to fix the header files.
 .
 Not all packages with header files are installed at gcc's build time, so
 we make fixincludes available at build time of other packages, such that
 checking tools like lintian can make use of it.
')`'dnl proto

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
Depends: gcc`'PV-base (= ${gcc:Version}), ${shlibs:Depends}ifenabled(`cdev',`, gcc`'PV (= ${gcc:Version})')
Conflicts: gcc-3.2-nof
Description: The no-floating-point gcc libraries (powerpc)
 These are versions of basic static libraries such as libgcc.a compiled
 with the -msoft-float option, for CPUs without a floating-point unit.
')`'dnl libnof
')`'dnl
dnl
dnl last line in file
