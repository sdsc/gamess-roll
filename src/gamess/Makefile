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

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include pull.mk

FC = gfortran
ifeq ("$(COMPILERNAME)", "intel")
  FC = ifort
else ifeq ("$(COMPILERNAME)", "pgi")
  FC = pgfortran
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

ifeq ("$(ROLLNETWORK)", "eth")
  MPIMODULE = $(ROLLMPI)
else
  MPIMODULE = $(ROLLMPI)_$(ROLLNETWORK)
endif

MPISETUP = \
  module load $(MPIMODULE) || true; \
  echo === MPIHOME ===; \
  echo $${MPIHOME}

# Contents of install.info--gamess compilation configuration file
INSTALL.INFO := \
\#!/bin/csh -f\n\
setenv GMS_PATH           $(PWD)/$(SOURCE_DIR)\n\
setenv GMS_BUILD_DIR      $(PWD)/$(SOURCE_DIR)\n\
\# machine type\n\
setenv GMS_TARGET         linux64\n\
\# FORTRAN compiler setup\n\
setenv GMS_FORTRAN        $(FC)\n

# Note: config wants major.minor version for gnu, major only for intel
ifeq ("$(COMPILERNAME)", "gnu")
  INSTALL.INFO += setenv GMS_GFORTRAN_VERNO $${fortVers}\n
else ifeq ("$(COMPILERNAME)", "intel")
  INSTALL.INFO += setenv GMS_IFORT_VERNO    $${fortVers}\n
endif

INSTALL.INFO += \
\# mathematical library setup\n\
setenv GMS_MATHLIB        mkl\n\
setenv GMS_MATHLIB_PATH   $${MKLLIB}\n\
setenv GMS_MKL_VERNO      $${mklVers}\n\
\# parallel message passing model setup\n\
setenv GMS_DDI_COMM       mpi\n\
setenv GMS_MPI_LIB        $(ROLLMPI)\n\
setenv GMS_MPI_PATH       $${MPIHOME}\n

build: $(SRC_DIRS)
	perl -pe 's/^.UNX/    /' $(SOURCE_DIR)/tools/actvte.code > \
	  $(SOURCE_DIR)/tools/actvte.f
	patch $(SOURCE_DIR)/ddi/compddi patch-files/compddi.patch
	patch $(SOURCE_DIR)/comp patch-files/comp.patch
	patch $(SOURCE_DIR)/compall patch-files/compall.patch
	patch $(SOURCE_DIR)/lked patch-files/lked.patch
	patch $(SOURCE_DIR)/ddi/src/ddi_create.c patch-files/ddi_create.c.patch
	patch $(SOURCE_DIR)/rungms patch-files/rungms.patch
	perl -pi -e 's!ROLL_PATHGAMESS!$(PKGROOT)!' $(SOURCE_DIR)/rungms
	perl -pi -e "s!ROLL_MPITYPE!$(ROLLMPI)!" $(SOURCE_DIR)/rungms
	( \
	  $(COMPILERSETUP); \
	  $(MKLSETUP); \
	  $(MPISETUP); \
	  if test "$(COMPILERNAME)" = "intel"; then \
	    fortVers=`$(FC) --version 2>&1 | \
	              perl -ne 'print $$1 and exit if m/(\d+)/'`; \
	  else \
	    fortVers=`$(FC) --version 2>&1 | \
	              perl -ne 'print $$1 and exit if m/(\d+(\.\d+)?)/'`; \
	  fi; \
	  mklVers=`module avail 2>&1 | \
	           perl -ne 'print $$1 and exit if m/mkl\D+(\d+)/'`; \
	  if test $$? -ne 0; then \
	    mklVers=$$fortVers; \
	  fi; \
	  echo -e "$(INSTALL.INFO)" > $(SOURCE_DIR)/install.info; \
	  perl -pi -e "s!ROLLMPI!$${MPIHOME}!" $(SOURCE_DIR)/rungms; \
	  cd $(SOURCE_DIR)/tools; \
	  $(FC) -o actvte.x actvte.f; \
	  cd ../ddi; \
	  ./compddi; \
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
	  cp -r auxdata tests $(ROOT)/$(PKGROOT) \
	)

	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR)
