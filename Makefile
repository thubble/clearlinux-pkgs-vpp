PKG_NAME := vpp
URL = https://github.com/FDio/vpp/archive/v22.02/vpp-22.02.tar.gz
ARCHIVES = 

include ../common/Makefile.common

VPP_GIT = ~/git/vpp
VPP_VER = 22.02
VPP_VER_BRANCHNAME = 2202

VPP_TAG = v$(VPP_VER)
VPP_BRANCH = origin/stable/$(VPP_VER_BRANCHNAME)

update:
	test -d $(VPP_GIT) || git clone https://github.com/FDio/vpp.git $(VPP_GIT)
	git -C $(VPP_GIT) remote update -p
	git -C $(VPP_GIT) rev-parse --verify --quiet refs/tags/$(VPP_TAG) > /dev/null
	git -C $(VPP_GIT) rev-parse --verify --quiet $(VPP_BRANCH) > /dev/null
	git -C $(VPP_GIT) shortlog $(VPP_TAG)..$(VPP_BRANCH) > vpp-stable-branch.patch
	git -C $(VPP_GIT) diff $(VPP_TAG)..$(VPP_BRANCH) >> vpp-stable-branch.patch
	! git diff --quiet vpp-stable-branch.patch
	git -C $(VPP_GIT) describe --abbrev=10 --match 'v*' $(VPP_BRANCH) > REVISION
	$(MAKE) bumpnogit
	git commit -m "stable update to `cat REVISION`" -a
	test -n "$(NO_KOJI)" || $(MAKE) koji-nowait
