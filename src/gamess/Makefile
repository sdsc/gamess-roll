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
LIBINT_CACHE = $(REDHAT.ROOT)/cache/libint
GMP_CACHE = $(REDHAT.ROOT)/cache/gmp

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

# Contents of install.info--gamess compilation configuration file
INSTALL.INFO := \
\#!/bin/csh -f\n\
setenv GMS_PATH           $(PWD)/$(SOURCE_DIR)\n\
setenv GMS_BUILD_DIR      $(PWD)/$(SOURCE_DIR)\n\
\# machine type\n\
setenv GMS_TARGET         linux64\n\
\# FORTRAN compiler setup\n\
setenv GMS_FORTRAN        $(FC)\n

INSTALL.LIBCCHEM.INFO := \
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
  INSTALL.LIBCCHEM.INFO += setenv GMS_GFORTRAN_VERNO $${fortVers}\n
else ifeq ("$(COMPILERNAME)", "intel")
  INSTALL.INFO += setenv GMS_IFORT_VERNO    $${fortVers}\n
  INSTALL.LIBCCHEM.INFO += setenv GMS_IFORT_VERNO    $${fortVers}\n
endif

# List of recognized MPI flavors from gamess/comp. A comment in gamess/config
# indicates that openmpi doesn't work, but minimal testing passes.
MPIFLAVORS = impi mvapich2 myrinet openmpi mpt mpich2 msmpi

INSTALL.INFO += \
\# mathematical library setup\n\
setenv GMS_MATHLIB        mkl\n\
setenv GMS_MATHLIB_PATH   $${MKLLIB}\n\
setenv GMS_MKL_VERNO      $${mklVers}\n\
\# parallel message passing model setup\n\
setenv GMS_DDI_COMM       mpi\n\
setenv GMS_MPI_LIB        $${MPIFLAVOR}\n\
setenv GMS_MPI_PATH       $${MPIHOME}\n\
setenv GMS_MVAPICH2_VERNO $${mvapich2Vers}\n\
setenv GMS_PHI            false\n\
setenv GMS_OPENMP         false\n\
setenv GMS_SHMTYPE        posix\n

INSTALL.LIBCCHEM.INFO += \
\# mathematical library setup\n\
setenv GMS_MATHLIB        mkl\n\
setenv GMS_MATHLIB_PATH   $${MKLLIB}\n\
setenv GMS_MKL_VERNO      $${mklVers}\n\
\# parallel message passing model setup\n\
setenv GMS_DDI_COMM       mpi\n\
setenv GMS_MPI_LIB        $${MPIFLAVOR}\n\
setenv GMS_MPI_PATH       $${MPIHOME}\n\
setenv GMS_MVAPICH2_VERNO $${mvapich2Vers}\n\
setenv GMS_PHI            false\n\
setenv GMS_OPENMP         false\n\
setenv GMS_SHMTYPE        posix\n\
setenv GMS_LIBCCHEM       true\n\
setenv GMS_LIBCCHEM_GPU   true\n\
setenv GMS_LIBCCHEM_GPU_SUPPORT true\n\
setenv GMS_CUDA_BOARD        kepler\n\
setenv GMS_CUDA_PATH         $${CUDAHOME}\n\
setenv GMS_HDF5_PATH         $${HDF5HOME}\n\
setenv GMS_LIBCCHEM_LIBINT   true\n\
setenv GMS_EIGEN_PATH $${EIGENHOME}/include\n\
setenv GMS_LIBINT_PATH $(LIBINT_CACHE)\n


MODULE_LOAD_GAMESS_CUDA = $(call MODULE_LOAD_PACKAGE, $(CUDAVERSION), CUDAHOME)
DESCRIBE_GAMESS_CUDA = echo built with cuda $(call GET_MODULE_VERSION, $(CUDAVERSION))

CUDABUILD = no
ifneq ("$(ROLLOPTS)", "$(subst cuda,,$(ROLLOPTS))")
  CUDABUILD = yes
endif


MODULE_LOAD_GAMESS_MKL = $(call MODULE_LOAD_PACKAGE, $(L_MKL_VERSION), MKLHOME)
DESCRIBE_GAMESS_MKL = echo built with mkl $(call GET_MODULE_VERSION, $(L_MKL_VERSION))

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_FC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_FC); \
	  $(DESCRIBE_GAMESS_MKL); \
	  $(DESCRIBE_MPI); \
          if test "$(CUDABUILD)" = "yes"; then \
              $(DESCRIBE_GAMESS_CUDA); \
              $(DESCRIBE_HDF5); \
              $(DESCRIBE_BOOST); \
              $(DESCRIBE_EIGEN); \
          fi \
	) > $@

LICENSE: $(SRC_DIRS)
	cp license-files/LICENSE $(SOURCE_DIR)
	$(CHECK_LICENSE_FILES)
	echo gamess > $@

build: $(SRC_DIRS)
	perl -pe 's/^.UNX/    /' $(SOURCE_DIR)/tools/actvte.code > \
	  $(SOURCE_DIR)/tools/actvte.f
	patch $(SOURCE_DIR)/ddi/compddi patch-files/compddi.patch
	patch $(SOURCE_DIR)/comp patch-files/comp.patch
	patch $(SOURCE_DIR)/compall patch-files/compall.patch
	patch $(SOURCE_DIR)/lked patch-files/lked.patch
	patch $(SOURCE_DIR)/rungms patch-files/rungms.patch
	patch $(SOURCE_DIR)/source/gamess.src patch-files/gamess.src.patch
	patch $(SOURCE_DIR)/source/iolib.src patch-files/iolib.src.patch
	patch $(SOURCE_DIR)/gms-files.csh patch-files/gms-files.csh.patch
	perl -pi -e 's!ROLL_PATHGAMESS!$(PKGROOT)!' $(SOURCE_DIR)/rungms
	( \
	  $(MODULE_LOAD_FC); \
	  $(MODULE_LOAD_GAMESS_MKL); \
	  export MKLLIB=$${MKLHOME}/lib/intel64; \
	  $(MODULE_LOAD_MPI); \
	  MPILIBS=`mpif77 -show|sed 's/.*-L/-L/'` ; \
	  perl -pi -e "s!ROLLMPILIBS!$${MPILIBS}!" $(SOURCE_DIR)/lked; \
	  if test "$(COMPILERNAME)" = "intel"; then \
	    fortVers=`$(FC) --version 2>&1 | \
	              perl -ne 'print $$1 and exit if m/(\d+)/'`; \
	  else \
	    fortVers=`$(FC) --version 2>&1 | \
	              perl -ne 'print $$1 and exit if m/(\d+(\.\d+)?)/'`; \
	  fi; \
	  if [[ "$(ROLLMPI)" =~ "mvapich2" ]]; then \
            mvapich2Vers=`module display $(ROLLMPI) 2>&1 | grep -i version |awk '{print $$3}'|sed 's/[a-z].*//'`; \
          fi; \
	  mklVers=`module avail 2>&1 | \
	           perl -ne 'print $$1 and exit if m/mkl\D+(\d+)/'`; \
	  if test $$? -ne 0; then \
	    mklVers=$$fortVers; \
	  fi; \
	  MPIFLAVOR=unknown; \
	  for F in $(MPIFLAVORS); do \
	    if [[ "$(ROLLMPI)" =~ "$$F" ]]; then \
	      MPIFLAVOR=$$F; \
	    fi; \
	  done; \
	  perl -pi -e "s!ROLL_MPITYPE!$$MPIFLAVOR!" $(SOURCE_DIR)/rungms; \
	  echo -e "$(INSTALL.INFO)" > $(SOURCE_DIR)/install.info; \
	  perl -pi -e "s!ROLLMPI!$${MPIHOME}!" $(SOURCE_DIR)/rungms; \
	  cd $(SOURCE_DIR)/tools; \
	  $(FC) -o actvte.x actvte.f; \
	  cd ../ddi; \
	  ./compddi; \
	  cd ..; \
	  ./compall; \
	  ./lked; \
          if test "$(CUDABUILD)" = "yes"; then \
             $(MODULE_LOAD_GAMESS_CUDA); \
             $(MODULE_LOAD_HDF5); \
             $(MODULE_LOAD_BOOST); \
             $(MODULE_LOAD_EIGEN); \
             export CC=$(CC); \
             export CXX=$(CXX); \
             cd ../$(GMP_DIR); \
             ./configure --prefix=$(GMP_CACHE) --enable-cxx; \
             make -j 16; \
             make install; \
             cd ../$(LIBINT_DIR); \
             ./autogen.sh; \
             export LD_LIBRARY_PATH=$(GMP_CACHE)/lib:$${LD_LIBRARY_PATH}; \
             ./configure --enable-1body=1 --enable-eri=1 --with-max-am=4 \
               --with-cartgauss-ordering=gamess \
               --with-incdirs="-I$${BOOSTHOME}/include -I$(GMP_CACHE)/include" \
               --with-libdirs="-L$${BOOSTHOME}/boost/lib -L$(GMP_CACHE)/lib" \
               --with-cxx-optflags="-O2 -std=c++11" \
               --prefix=$(LIBINT_CACHE); \
             $(MAKE) -j 16; \
             $(MAKE) install; \
             patch $(LIBINT_CACHE)/include/libint2/shell.h ../patch-files/shell.h.patch; \
             cd ../$(SOURCE_DIR); \
	     echo -e "$(INSTALL.LIBCCHEM.INFO)" > install.info; \
             patch libcchem/boost/Makefile ../patch-files/Makefile.patch; \
             cd libcchem; \
             ./build-cchem; \
          fi; \
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
	$(INSTALL_LICENSE_FILES)

	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) $(LIBINT_DIR) $(GMP_DIR) DESCRIPTION LICENSE
