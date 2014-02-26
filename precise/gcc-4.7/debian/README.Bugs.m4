Reporting Bugs in the GNU Compiler Collection for DIST
========================================================

Before reporting a bug, please
------------------------------

- Check that the behaviour really is a bug. Have a look into some
  ANSI standards document.

- Check the list of well known bugs: http://gcc.gnu.org/bugs.html#known

- Try to reproduce the bug with a current GCC development snapshot. You
  usually can get a recent development snapshot from the gcc-snapshot
ifelse(DIST,`Debian',`dnl
  package in the unstable (or experimental) distribution.

  See: http://packages.debian.org/gcc-snapshot
', DIST, `Ubuntu',`dnl
  package in the current development distribution.

  See: http://archive.ubuntu.com/ubuntu/pool/universe/g/gcc-snapshot/
')dnl

- Try to find out if the bug is a regression (an older GCC version does
  not show the bug).

- Check if the bug is already reported in the bug tracking systems.

ifelse(DIST,`Debian',`dnl
    Debian:   http://bugs.debian.org/debian-gcc@lists.debian.org
', DIST, `Ubuntu',`dnl
    Ubuntu:   https://bugs.launchpad.net/~ubuntu-toolchain/+packagebugs
    Debian:   http://bugs.debian.org/debian-gcc@lists.debian.org
')dnl
    Upstream: http://gcc.gnu.org/bugzilla/


Where to report a bug
---------------------

ifelse(DIST,`Debian',`dnl
Please report bugs found in the packaging of GCC to the Debian bug tracking
system. See http://www.debian.org/Bugs/ for instructions (or use the
reportbug script).
', DIST, `Ubuntu',`dnl
Please report bugs found in the packaging of GCC to Launchpad. See below
how issues should be reported.
')dnl

DIST's current policy is to closely follow the upstream development and
only apply a minimal set of patches (which are summarized in the README.Debian
document).

ifelse(DIST,`Debian',`dnl
If you think you have found an upstream bug, you did check the section
above ("Before reporting a bug") and are able to provide a complete bug
report (see below "How to report a bug"), then you may help the Debian
GCC package maintainers, if you report the bug upstream and then submit
a bug report to the Debian BTS and tell us the upstream report number.
This way you are able to follow the upstream bug handling as well. If in
doubt, report the bug to the Debian BTS (but read "How to report a bug"
below).
', DIST, `Ubuntu',`dnl
If you think you have found an upstream bug, you did check the section
above ("Before reporting a bug") and are able to provide a complete bug
report (see below "How to report a bug"), then you may help the Ubuntu
GCC package maintainers, if you report the bug upstream and then submit
a bug report to Launchpad and tell us the upstream report number.
This way you are able to follow the upstream bug handling as well. If in
doubt, report the bug to Launchpad (but read "How to report a bug" below).

Report the issue to https://bugs.launchpad.net/ubuntu/+source/SRCNAME.
')dnl


How to report a bug
-------------------

There are complete instructions in the gcc info manual (found in the
gcc-doc package), section Bugs.

The manual can be read using `M-x info' in Emacs, or if the GNU info
program is installed on your system by `info --node "(gcc)Bugs"'. Or see
the file BUGS included with the gcc source code.

Online bug reporting instructions can be found at

	http://gcc.gnu.org/bugs.html

[Some paragraphs taken from the above URL]

The main purpose of a bug report is to enable us to fix the bug. The
most important prerequisite for this is that the report must be
complete and self-contained, which we explain in detail below.

Before you report a bug, please check the list of well-known bugs and,
if possible in any way, try a current development snapshot.

Summarized bug reporting instructions
-------------------------------------

What we need

Please include in your bug report all of the following items, the
first three of which can be obtained from the output of gcc -v:

    * the exact version of GCC;
    * the system type;
    * the options given when GCC was configured/built;
    * the complete command line that triggers the bug;
    * the compiler output (error messages, warnings, etc.); and
    * the preprocessed file (*.i*) that triggers the bug, generated by
      adding -save-temps to the complete compilation command, or, in
      the case of a bug report for the GNAT front end, a complete set
      of source files (see below).

What we do not want

    * A source file that #includes header files that are left out
      of the bug report (see above)
    * That source file and a collection of header files.
    * An attached archive (tar, zip, shar, whatever) containing all
      (or some :-) of the above.
    * A code snippet that won't cause the compiler to produce the
      exact output mentioned in the bug report (e.g., a snippet with
      just a few lines around the one that apparently triggers the
      bug, with some pieces replaced with ellipses or comments for
      extra obfuscation :-)
    * The location (URL) of the package that failed to build (we won't
      download it, anyway, since you've already given us what we need
      to duplicate the bug, haven't you? :-)
    * An error that occurs only some of the times a certain file is
      compiled, such that retrying a sufficient number of times
      results in a successful compilation; this is a symptom of a
      hardware problem, not of a compiler bug (sorry)
    * E-mail messages that complement previous, incomplete bug
      reports. Post a new, self-contained, full bug report instead, if
      possible as a follow-up to the original bug report
    * Assembly files (*.s) produced by the compiler, or any binary files,
      such as object files, executables, core files, or precompiled
      header files
    * Duplicate bug reports, or reports of bugs already fixed in the
      development tree, especially those that have already been
      reported as fixed last week :-)
    * Bugs in the assembler, the linker or the C library. These are
      separate projects, with separate mailing lists and different bug
      reporting procedures
    * Bugs in releases or snapshots of GCC not issued by the GNU
      Project. Report them to whoever provided you with the release
    * Questions about the correctness or the expected behavior of
      certain constructs that are not GCC extensions. Ask them in
      forums dedicated to the discussion of the programming language


Known Bugs and Non-Bugs
-----------------------

[Please see /usr/share/doc/gcc/FAQ or http://gcc.gnu.org/faq.html first]


C++ exceptions don't work with C libraries
------------------------------------------

[Taken from the closed bug report #22769] C++ exceptions don't work
with C libraries, if the C code wasn't designed to be thrown through.
A solution could be to translate all C libraries with -fexceptions.
Mostly trying to throw an exception in a callback function (qsort,
Tcl command callbacks, etc ...). Example:

    #include <stdio.h>
    #include <tcl.h>

    class A {};

    static
    int SortCondition(void const*, void const*)
    {
        printf("throwing 'sortcondition' exception\n");
        throw A();
    }

    int main(int argc, char *argv[])
    {
        int list[2];

        try {
            SortCondition(NULL,NULL);
        } catch (A) {
            printf("caught test-sortcondition exception\n");
        }
        try {
            qsort(&list, sizeof(list)/sizeof(list[0]),sizeof(list[0]),
                 &SortCondition);
        } catch (A) {
            printf("caught real-sortcondition exception\n");
        }
        return 0;
}

Andrew Macleod <amacleod@cygnus.com> responded:

When compiled with the table driven exception handling, exception can only
be thrown through functions which have been compiled with the table driven EH.
If a function isn't compiled that way, then we do not have the frame
unwinding information required to restore the registers when unwinding.

I believe the setjmp/longjmp mechanism will throw through things like this, 
but its produces much messier code.  (-fsjlj-exceptions)

The C compiler does support exceptions, you just have to turn them on
with -fexceptions.

Your main options are to:
  a) Don't use callbacks, or at least don't throw through them.
  b) Get the source and compile the library with -fexceptions (You have to
     explicitly turn on exceptions in the C compiler)
  c) always use -fsjlj-exceptions (boo, bad choice :-)


g++: "undefined reference" to static const array in class
---------------------------------------------------------

The following code compiles under GNU C++ 2.7.2 with correct results,
but produces the same linker error with GNU C++ 2.95.2.
Alexandre Oliva <oliva@lsd.ic.unicamp.br> responded:

All of them are correct.  A static data member *must* be defined
outside the class body even if it is initialized within the class
body, but no diagnostic is required if the definition is missing.  It
turns out that some releases do emit references to the missing symbol,
while others optimize it away.

#include <iostream>

class Test
{
  public:
    Test(const char *q);
  protected:
    static const unsigned char  Jam_signature[4]   = "JAM";
};

Test::Test(const char *q)
{
  if (memcmp(q, Jam_signature, sizeof(Jam_signature)) != 0)
  cerr << "Hello world!\n";
}

int main(void)
{
  Test::Test("JAM");
  return 0;
}

g++: g++ causes passing non const ptr to ptr to a func with const arg
     to cause an error (not a bug)
---------------------------------------------------------------------

Example:

#include <stdio.h>
void test(const char **b){
        printf ("%s\n",*b);
}
int main(void){
        char *test1="aoeu";
        test(&test1);
}

make const
g++     const.cc   -o const
const.cc: In function `int main()':
const.cc:7: passing `char **' as argument 1 of `test(const char **)' adds cv-quals without intervening `const'
make: *** [const] Error 1

Answer from "Martin v. Loewis" <martin@loewis.home.cs.tu-berlin.de>:

> ok... maybe I missed something.. I haven't really kept up with the latest in
> C++ news.  But I've never heard anything even remotly close to passing a non
> const var into a const arg being an error before.

Thanks for your bug report. This is a not a bug in the compiler, but
in your code. The standard, in 4.4/4, puts it that way

# A conversion can add cv-qualifiers at levels other than the first in
# multi-level pointers, subject to the following rules:
# Two pointer types T1 and T2 are similar if there exists a type T and
# integer n > 0 such that:
#   T1 is cv(1,0) pointer to cv(1,1) pointer to ... cv(1,n-1)
#   pointer to cv(1,n) T
# and
#   T2 is cv(2,0) pointer to cv(2,1) pointer to ... cv(2,n-1)
#   pointer to cv(2,n) T
# where each cv(i,j) is const, volatile, const volatile, or
# nothing. The n-tuple of cv-qualifiers after the first in a pointer
# type, e.g., cv(1,1) , cv(1,2) , ... , cv(1,n) in the pointer type
# T1, is called the cv-qualification signature of the pointer type. An
# expression of type T1 can be converted to type T2 if and only if the
# following conditions are satisfied:
#  - the pointer types are similar.
#  - for every j > 0, if const is in cv(1,j) then const is in cv(2,j) ,
#    and similarly for volatile.
#  - if the cv(1,j) and cv(2,j) are different, then const is in every
#    cv(2,k) for 0 < k < j.

It is the last rule that your code violates. The standard gives then
the following example as a rationale:

# [Note: if a program could assign a pointer of type T** to a pointer
# of type const T** (that is, if line //1 below was allowed), a
# program could inadvertently modify a const object (as it is done on
# line //2). For example,
# int main() { 
#   const char c = 'c'; 
#   char* pc; 
#   const char** pcc = &pc; //1: not allowed 
#   *pcc = &c; 
#   *pc = 'C'; //2: modifies a const object 
# }
# - end note]

If you question this line of reasoning, please discuss it in one of
the public C++ fora first, eg. comp.lang.c++.moderated, or
comp.std.c++.


cpp removes blank lines
-----------------------

With the new cpp, you need to add -traditional to the "cpp -P" args, else 
blank lines get removed.

[EDIT ME: scan Debian bug reports and write some nice summaries ...]