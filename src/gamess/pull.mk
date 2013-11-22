ifndef __PULL_MK
__PULL_MK = yes

DL.CMD                  = $(shell which curl)
DL.OPTS                 = -f -LO
DL.SERVER               = http://forge.sdsc.edu
DL.PATH                 = triton/$(ROLLNAME)/src/$(SRC_SUBDIR)
GREP.CMD                = $(shell which grep)
STAT.CMD                = $(shell which stat)
TAR.CMD                 = $(shell which tar)
TGZ.OPTS                = -xzf
TBZ2.OPTS               = -xjf
UNZIP.CMD               = $(shell which unzip)
UNZIP.OPTS              = -q
VERIFY.CMD              = $(shell which git)
VERIFY.OPTS             = hash-object -t blob
VERIFY.HASHES           = binary_hashes

# ALL packages are part of SRC_PKGS
SRC_PKGS = $(TAR_GZ_PKGS) $(TAR_BZ2_PKGS) $(TGZ_PKGS) $(ZIP_PKGS)

# Download the required packages, verify size and hash...
.PHONY : download $(SRC_PKGS)
download : $(SRC_PKGS)
$(SRC_PKGS):
	@echo "::: Downloading $(DL.SERVER)/$(DL.PATH)/$@ :::"
	@ if [ -f $@ ]; then \
		echo "::: $@ exists. Skipping... :::" ; \
	else \
		$(DL.CMD) $(DL.OPTS) $(DL.SERVER)/$(DL.PATH)/$@ ; \
		echo "::: Verifying size of $@ :::" ; \
		$(GREP.CMD) `$(STAT.CMD) --printf="%s" $@` $(VERIFY.HASHES) ; \
		echo "::: Verifying hash of $@ :::" ; \
		$(GREP.CMD) `$(VERIFY.CMD) $(VERIFY.OPTS) $@ ` $(VERIFY.HASHES) ; \
		echo "" ; \
	fi

# For cleanup convert that package archive names into directory names.
# This can likely be 'generalized' with a variable I don't know yet...
TAR_GZ_DIRS = $(TAR_GZ_PKGS:%.tar.gz=%)
TAR_BZ2_DIRS = $(TAR_BZ2_PKGS:%.tar.bz2=%)
TGZ_DIRS = $(TGZ_PKGS:%.tgz=%)
ZIP_DIRS = $(ZIP_PKGS:%.zip=%)

# Unbundle the package archives to create SRC_DIRS.
# Can this be done with pattern matching/variables/filters?
$(TAR_GZ_DIRS): $(TAR_GZ_PKGS)
	@echo "::: Unbundling $@.tar.gz :::"
	@$(TAR.CMD) $(TGZ.OPTS) $@.tar.gz
	@echo ""

$(TAR_BZ2_DIRS): $(TAR_BZ2_PKGS)
	@echo "::: Unbundling $@.tar.bz2 :::"
	@$(TAR.CMD) $(TBZ2.OPTS) $@.tar.bz2
	@echo ""

$(TGZ_DIRS): $(TGZ_PKGS)
	@echo "::: Unbundling $@.tgz :::"
	@$(TAR.CMD) $(TGZ.OPTS) $@.tgz
	@echo ""

$(ZIP_DIRS): $(ZIP_PKGS)
	@echo "::: Unbundling $@.zip :::"
	@$(UNZIP.CMD) $(UNZIP.OPTS) $@.zip
	@echo ""

# SRC_DIRS is the target that build will depend on
SRC_DIRS = $(TAR_GZ_DIRS) $(TAR_BZ2_DIRS) $(TGZ_DIRS) $(ZIP_DIRS)

# Clean up after ourselves...
clean::
	-rm -rf $(SRC_DIRS)

distclean:: clean
	-rm -rf $(SRC_PKGS)

endif # __PULL_MK
