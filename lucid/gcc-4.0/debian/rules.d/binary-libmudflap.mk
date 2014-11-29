arch_binaries  := $(arch_binaries) libmudflap

p_mf	= libmudflap$(MUDFLAP_SONAME)
p_mfd	= libmudflap$(MUDFLAP_SONAME)-dev

d_mf	= debian/$(p_mf)
d_mfd	= debian/$(p_mfd)

dirs_mf = \
	$(docdir)/$(p_mf) \
	$(PF)/$(libdir)
files_mf = \
	$(PF)/$(libdir)/libmudflap*.so.*

dirs_mfd = \
	$(docdir) \
	$(PF)/include \
	$(PF)/$(libdir)
files_mfd = \
	$(PF)/include/mf-runtime.h \
	$(PF)/$(libdir)/libmudflap*.{a,so,la}

ifeq ($(with_lib64mudflap),yes)
	dirs_mf   += $(PF)/$(lib64)
	files_mf  += $(PF)/$(lib64)/libmudflap*.so.*
	dirs_mfd  += $(PF)/$(lib64)
	files_mfd += $(PF)/$(lib64)/libmudflap*.{a,so,la}
endif

$(binary_stamp)-libmudflap: $(install_stamp)
	dh_testdir
	dh_testroot
	mv $(install_stamp) $(install_stamp)-tmp

	rm -rf $(d_mf) $(d_mfd)
	dh_installdirs -p$(p_mf) $(dirs_mf)
	dh_installdirs -p$(p_mfd) $(dirs_mfd)

	DH_COMPAT=2 dh_movefiles -p$(p_mf) $(files_mf)
	DH_COMPAT=2 dh_movefiles -p$(p_mfd) $(files_mfd)

	dh_installdocs -p$(p_mf)
	dh_installchangelogs -p$(p_mf) $(srcdir)/libmudflap/ChangeLog
	cp -p debian/libmudflap.copyright $(d_mf)/$(docdir)/$(p_mf)/copyright
	debian/dh_doclink -p$(p_mfd) $(p_mf)

	debian/dh_rmemptydirs -p$(p_mf)
	debian/dh_rmemptydirs -p$(p_mfd)

	dh_strip -p$(p_mf) -p$(p_mfd)
	dh_compress -p$(p_mf) -p$(p_mfd)
	dh_fixperms -p$(p_mf) -p$(p_mfd)
	dh_makeshlibs -p$(p_mf) -V '$(p_mf) (>= $(DEB_SOVERSION))'
	dh_shlibdeps -p$(p_mf) -p$(p_mfd)
	dh_gencontrol -p$(p_mf) -p$(p_mfd) \
		-- -v$(DEB_VERSION) $(common_substvars)
	dh_installdeb -p$(p_mf) -p$(p_mfd)
	dh_md5sums -p$(p_mf) -p$(p_mfd)
	dh_builddeb -p$(p_mf) -p$(p_mfd)

	trap '' 1 2 3 15; touch $@; mv $(install_stamp)-tmp $(install_stamp)
