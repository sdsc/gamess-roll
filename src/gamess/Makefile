#
# $Id$
#
# @Copyright@
#
# 				Rocks(tm)
# 		         www.rocksclusters.org
# 		        version 4.3 (Mars Hill)
#
# Copyright (c) 2000 - 2011 The Regents of the University of California.
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
# 	"This product includes software developed by the Rocks(tm)
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

ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif

PKGROOT = /opt/gamess
SOURCE = gamess.$(VERSION)
REDHAT.ROOT = $(PWD)/../../

-include $(ROCKSROOT)/etc/Rules.mk

COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load intel; \
    export MKLLIB=`find $${MKL_ROOT}/lib/* -maxdepth 0 | head -1`; \
    export iversion=`icc -v 2>&1 | perl -pe 's!\D*(\d+).*!$$1!'`; \
    module unload intel; \
    module load $(ROLLCOMPILER); \
  fi

F90COMP = gfortran
MATHLIB = mkl
ifeq ("$(ROLLCOMPILER)", "intel")
  F90COMP = ifort
endif

build:
	tar zxvf $(SOURCE).tgz
	cp patch-files/install.info $(SOURCE)
	cp patch-files/rungms $(SOURCE)
	cp patch-files/actvte.f $(SOURCE)/tools
	cp patch-files/compddi $(SOURCE)/ddi
	cp patch-files/comp $(SOURCE)
	cp patch-files/compall $(SOURCE)
	cp patch-files/lked $(SOURCE)
	perl -pi -e 's!ROLL_FCC!$(F90COMP)!' $(SOURCE)/install.info
	perl -pi -e 's!ROLL_MATHLIB!$(MATHLIB)!' $(SOURCE)/install.info
	perl -pi -e 's!ROLL_GAMESSROOT!$(PWD)/$(SOURCE)!' $(SOURCE)/install.info
	( \
	  $(COMPILERSETUP); \
	  perl -pi -e 's!^(.*ROLL)!# $$1!m' $(SOURCE)/install.info; \
	  perl -pi -e "s!ROLL_MATHPATH!$${MKLLIB}!" $(SOURCE)/install.info; \
	  perl -pi -e "s!ROLL_INTELVERSION!$$iversion!" $(SOURCE)/install.info; \
	  perl -pi -e "s!ROLL_MKLVERSION!$$iversion!" $(SOURCE)/install.info; \
	  export GMS_IFORT_VERNO=$$iversion; \
	  export GMS_MKL_VERNO=$$iversion; \
	  export GMS_MATHLIB_PATH=$$MKLLIB; \
	  cd $(SOURCE)/tools; \
	  $(F90COMP) -o actvte.x actvte.f; \
	  cd ../ddi; \
	  ./compddi; \
	  mv ddikick.x ..; \
	  cd ..; \
	  ./compall; \
	  ./lked \
	)

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	( \
	  cd $(SOURCE); \
	  cp gamess.00.x runall rungms ddikick.x *.DOC \
	     $(ROOT)/$(PKGROOT); \
	  cp -r auxdata tests $(ROOT)/$(PKGROOT) \
	)

clean::
	rm -rf $(SOURCE)
