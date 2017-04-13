arch_binaries  := $(arch_binaries) fixincl

p_fix	= fixincludes
d_fix	= debian/$(p_fix)

dirs_fix = \
	$(docdir)/$(p_xbase)/fixincludes \
	$(PF)/share/man/man1 \
	$(PF)/bin \
	$(gcc_lexec_dir) \
	$(gcc_lib_dir)
files_fix = \
	$(gcc_lexec_dir)/install-tools \
	$(gcc_lib_dir)/install-tools

# ----------------------------------------------------------------------
$(binary_stamp)-fixincl: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_fix)
	dh_installdirs -p$(p_fix) $(dirs_fix)
	$(dh_compat2) dh_movefiles -p$(p_fix) $(files_fix)

#	$(IP) $(builddir)/gcc/fixinc/fixincl $(d_fix)/$(PF)/lib/fixincludes/
#	sed -e "s,^FIXINCL=\(.*\),FIXINCL=/$(PF)/lib/fixincludes/fixincl," \
#	    $(builddir)/gcc/fixinc.sh \
#		> $(d_fix)/$(PF)/lib/fixincludes/fixinc.sh
#	chmod 755 $(d_fix)/$(PF)/lib/fixincludes/fixinc.sh
	$(IR) $(srcdir)/fixincludes/README \
	    $(d_fix)/$(docdir)/$(p_xbase)/fixincludes
	sed -e 's,@LIBEXECDIR@,$(gcc_lexec_dir),g' debian/fixincludes.in \
	    > $(d_fix)/$(PF)/bin/fixincludes
	chmod 755 $(d_fix)/$(PF)/bin/fixincludes

	debian/dh_doclink -p$(p_fix) $(p_xbase)
	dh_strip -p$(p_fix)
	dh_shlibdeps -p$(p_fix)
	echo $(p_fix) >> debian/arch_binaries.epoch

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
