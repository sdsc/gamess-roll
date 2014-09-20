# $Id$
#
# @Copyright@
# 
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 5.6 (Emerald Boa)
# 		         version 6.1 (Emerald Boa)
# 
# Copyright (c) 2000 - 2013 The Regents of the University of California.
# All rights reserved.	
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided 
# with the distribution.
# 
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement: 
# 
# 	"This product includes software developed by the Rocks(r)
# 	Cluster Group at the San Diego Supercomputer Center at the
# 	University of California, San Diego and its contributors."
# 
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of 
# the associated name, interested parties should contact Technology 
# Transfer & Intellectual Property Services, University of California, 
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910, 
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
# 
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# @Copyright@
#
# $Log$

REDHAT.ROOT = $(CURDIR)/../../
ROLLPPN=32

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include pull.mk

FC = gfortran
MATHLIB = none
ifeq ("$(COMPILERNAME)", "intel")
  FC = ifort
  MATHLIB = mkl
else ifeq ("$(COMPILERNAME)", "pgi")
  FC = pgfortran
  MATHLIB = mkl
endif

COMPILERSETUP =  \
  module load $(ROLLCOMPILER) || true; \
  echo === Compiler and version ===; \
  $(FC) --version

MKLSETUP = \
  module load mkl || true; \
  echo === MKL_ROOT ===; \
  echo $${MKL_ROOT}; \
  export MKLLIB=`find $${MKL_ROOT}/lib/* -maxdepth 0 | head -1`

ROLL_COMM = sockets
ROLLCOMMENT = \#
ifneq ("$(ROLLOPTS)", "$(subst vsmp,,$(ROLLOPTS))")
  ROLL_COMM = mpi
  ROLLCOMMENT =
endif

build: $(SRC_DIRS)
	patch $(SOURCE_DIR)/tools/actvte.code patch-files/actvte.code.patch
	mv $(SOURCE_DIR)/tools/actvte.code $(SOURCE_DIR)/tools/actvte.f
	patch $(SOURCE_DIR)/ddi/compddi patch-files/compddi.patch
	patch $(SOURCE_DIR)/comp patch-files/comp.patch
	patch $(SOURCE_DIR)/compall patch-files/compall.patch
	patch $(SOURCE_DIR)/lked patch-files/lked.patch
	patch $(SOURCE_DIR)/ddi/src/ddi_create.c patch-files/ddi_create.c.patch
	cp install.info $(SOURCE_DIR)
	patch $(SOURCE_DIR)/rungms patch-files/rungms.patch
	mkdir $(SOURCE_DIR)/ddivsmp
	cp Makefile.vsmp $(SOURCE_DIR)/ddivsmp/Makefile
	cp ddivsmp.c $(SOURCE_DIR)/ddivsmp
	cp symver $(SOURCE_DIR)/ddivsmp
	perl -pi -e 's!ROLL_FCC!$(FC)!' $(SOURCE_DIR)/install.info
	perl -pi -e 's!ROLL_MATHLIB!$(MATHLIB)!' $(SOURCE_DIR)/install.info
	perl -pi -e 's!ROLL_GAMESSROOT!$(PWD)/$(SOURCE_DIR)!' $(SOURCE_DIR)/install.info
	perl -pi -e 's!ROLL_COMM!$(ROLL_COMM)!' $(SOURCE_DIR)/install.info
	perl -pi -e 's!ROLLCOMMENT!$(ROLLCOMMENT)!' $(SOURCE_DIR)/install.info
	perl -pi -e "s!ROLL_BUILDPATH!$(PWD)/$(SOURCE_DIR)!" $(SOURCE_DIR)/install.info
	perl -pi -e 's!ROLL_PATHGAMESS!$(PKGROOT)!' $(SOURCE_DIR)/rungms
	perl -pi -e "s!ROLLPPN!$(ROLLPPN)!" $(SOURCE_DIR)/rungms
	perl -pi -e 's!ROLLCOMMENT!$(ROLLCOMMENT)!' $(SOURCE_DIR)/lked
	( \
	  $(COMPILERSETUP); \
	  $(MKLSETUP); \
	  fversion=`$(FC) --version 2>&1 | grep -o '[0-9][0-9]*' | head -1`; \
	  perl -pi -e "s!ROLL_INTELVERSION!$$fversion!" $(SOURCE_DIR)/install.info; \
	  mklversion=`module avail 2>&1 | grep -o mkl[^0-9]*[0-9][0-9]* | head -1 | grep -o [0-9]*`; \
	  if test $$? -ne 0; then \
	    mklversion=$$fversion; \
	  fi; \
	  perl -pi -e "s!ROLL_MKLVERSION!$$mklversion!" $(SOURCE_DIR)/install.info; \
	  perl -pi -e "s!ROLL_MATHPATH!$${MKLLIB}!" $(SOURCE_DIR)/install.info; \
	  perl -pi -e 's!ROLL_MATHLIB!$${MKLLIB}!' $(SOURCE_DIR)/rungms; \
	  cd $(SOURCE_DIR)/tools; \
	  $(FC) -o actvte.x actvte.f; \
	  if test "$(ROLL_COMM)" = "sockets"; then \
	    cd ../ddi; \
	    ./compddi; \
	  else \
	    cd ../ddivsmp; \
	    $(MAKE); \
	  fi; \
	  cd ..; \
	  ./compall; \
	  ./lked \
	)
	@echo "::: Package $(NAME) build complete :::"
	
install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	( \
	  cd $(SOURCE_DIR); \
	  cp gamess.00.x runall rungms *.DOC install.info gms-files.csh \
	    $(ROOT)/$(PKGROOT); \
	  cp -r auxdata tests $(ROOT)/$(PKGROOT); \
	  if test $(ROLL_COMM) = "sockets"; then \
	    cp ddi/ddikick.x $(ROOT)/$(PKGROOT); \
	  else \
	    cp -r ddivsmp $(ROOT)/$(PKGROOT); \
	  fi \
	)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR)
