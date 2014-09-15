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

ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
ifndef ROLLOPTS
  ROLLOPTS = sockets
endif

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include pull.mk

F90COMP = gfortran
MATHLIB = none
COMPILERSETUP =  \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load intel; \
    export MKLLIB=`find $${MKL_ROOT}/lib/* -maxdepth 0 | head -1`; \
    export iversion=`icc -v 2>&1 | perl -pe 's!\D*(\d+).*!$$1!'`; \
    perl -pi -e "s!ROLL_MATHPATH!$${MKLLIB}!" $(SOURCE_DIR)/install.info; \
    perl -pi -e "s!ROLL_INTELVERSION!$$iversion!" $(SOURCE_DIR)/install.info; \
    perl -pi -e "s!ROLL_MKLVERSION!$$iversion!" $(SOURCE_DIR)/install.info; \
    module unload intel; \
  fi; \
  module load $(ROLLCOMPILER)

ifeq ("$(ROLLNETWORK)", "eth")
  MPIMODULE = $(ROLLMPI)
else
  MPIMODULE = $(ROLLMPI)_$(ROLLNETWORK)
endif

MPISETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(MPIMODULE) || true; \
  fi; \
  if test -z "$${MPIHOME}"; then \
    export MPIHOME=/opt/$(ROLLMPI); \
  fi; \
  echo === MPIHOME ===; \
  echo $${MPIHOME}


ROLL_COMM = mpi
ifeq ("$(ROLLCOMPILER)", "intel")
  F90COMP = ifort
  MATHLIB = mkl
endif
ifeq ("$(ROLLCOMPILER)", "pgi")
   F90COMP = pgfortran
   MATHLIB = mkl
endif


build: $(SRC_DIRS)
	patch $(SOURCE_DIR)/tools/actvte.code  patch-files/actvte.code.patch
	patch $(SOURCE_DIR)/ddi/compddi  patch-files/compddi.patch
	patch $(SOURCE_DIR)/comp  patch-files/comp.patch
	patch $(SOURCE_DIR)/compall  patch-files/compall.patch
	patch $(SOURCE_DIR)/lked  patch-files/lked.patch
	patch $(SOURCE_DIR)/ddi/src/ddi_create.c  patch-files/ddi_create.c.patch
	cp install.info $(SOURCE_DIR)
	patch $(SOURCE_DIR)/rungms  patch-files/rungms.patch
	mkdir $(SOURCE_DIR)/ddivsmp
	cp Makefile.vsmp $(SOURCE_DIR)/ddivsmp/Makefile
	cp ddivsmp.c $(SOURCE_DIR)/ddivsmp
	cp symver $(SOURCE_DIR)/ddivsmp
	perl -pi -e 's!ROLL_FCC!$(F90COMP)!' $(SOURCE_DIR)/install.info
	perl -pi -e 's!ROLL_GAMESSROOT!$(PWD)/$(SOURCE_DIR)!' $(SOURCE_DIR)/install.info
	perl -pi -e 's!ROLL_PATHGAMESS!$(PKGROOT)!' $(SOURCE_DIR)/rungms
	perl -pi -e 's!ROLL_COMM!$(ROLL_COMM)!' $(SOURCE_DIR)/install.info
	perl -pi -e "s!ROLL_BUILDPATH!$(PWD)/$(SOURCE_DIR)!" $(SOURCE_DIR)/install.info
	perl -pi -e "s!ROLL_MPITYPE!$(ROLLMPI)!" $(SOURCE_DIR)/rungms
	( \
	  $(COMPILERSETUP); \
          $(MPISETUP); \
	  perl -pi -e 's!ROLL_MATHLIB!$(MATHLIB)!' $(SOURCE_DIR)/install.info; \
          perl -pi -e "s!ROLLMPI!$${MPIHOME}!" $(SOURCE_DIR)/install.info; \
          perl -pi -e "s!ROLLMPI!$${MPIHOME}!" $(SOURCE_DIR)/rungms; \
          perl -pi -e "s!ROLL_MPIFLAVOR!$(ROLLMPI)!" $(SOURCE_DIR)/install.info; \
	  cd $(SOURCE_DIR); \
          cd tools; \
          mv actvte.code actvte.f; \
	  $(F90COMP) -o actvte.x actvte.f; \
	  if test "$(ROLL_COMM)" != "vsmp"; then \
	    cd ../ddi; \
	    ./compddi; \
	  else \
	    cd ../ddivsmp; \
	    $(MAKE); \
	  fi; \
	  cd ..; \
	  ./compall; \
	  ./lked; \
	)
	@echo "::: Package $(NAME) build complete :::"
	
install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	mkdir -m 755 $(REDHAT.ROOT)/src/build-gamess-modules
	( \
	  cd $(SOURCE_DIR); \
	  cp gamess.00.x runall rungms *.DOC install.info \
	     $(ROOT)/$(PKGROOT); \
	  cp -r gms-files.csh auxdata tests $(ROOT)/$(PKGROOT); \
	  if test $(ROLL_COMM) = "sockets"; then \
	    cp ddi/ddikick.x $(ROOT)/$(PKGROOT); \
	  else \
	    cp -r ddivsmp $(ROOT)/$(PKGROOT); \
	  fi \
	)
	cat gamess.module | perl -pi -e "s!MODULEROOT!/opt/modulefiles/applications/gamess!g;s!VERSION!$(VERSION)!g;s!ROLLCOMPILER!$(ROLLCOMPILER)!g;s!ROLLMPI!$(ROLLMPI)!g;s!ROLLNETWORK!$(ROLLNETWORK)!g" \
          > $(REDHAT.ROOT)/src/build-gamess-modules/$(NAME).module

	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR)

