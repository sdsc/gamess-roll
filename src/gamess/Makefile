#
# $Id$
#
# @Copyright@
#
# 				Rocks(tm)
# 		         www.rocksclusters.org
# 		        version 4.3 (Mars Hill)
#
# Copyright (c) 2000 - 2007 The Regents of the University of California.
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
#

PKGROOT = /opt/gamess
SOURCE = gamess.$(VERSION)
REDHAT.ROOT = $(PWD)/../../

-include $(ROCKSROOT)/etc/Rules.mk

ifeq ("$(ROLLCOMPILER)", "intel")
  FCC = ifort
  MATHLIB = mkl
  # TODO figure this out programatically
  INTEL_VERSION = 11
  COMPILERSETUP = export ICCPATH=`which icc 2>/dev/null || true`; \
                  if test -z "$${ICCPATH}" -a \
                  	      -e /etc/profile.d/modules.sh; then \
                  . /etc/profile.d/modules.sh; \
                  module load intel; \
                  fi; \
                  perl -pi -e "s!ROLL_MATHPATH!$${MKL_ROOT}/lib/em64t!" $(SOURCE)/install.info; \
                  perl -pi -e "s!ROLL_INTELVERSION!$(INTEL_VERSION)!" $(SOURCE)/install.info; \
                  perl -pi -e "s!ROLL_MKLVERSION!$(INTEL_VERSION)!" $(SOURCE)/install.info
else
  FCC = gfortran
  MATHLIB = none
  COMPILERSETUP = echo noop > /dev/null
endif

build:
	tar zxvf $(SOURCE).tgz
	cp patch-files/$(SOURCE)/install.info $(SOURCE)
	cp patch-files/$(SOURCE)/rungms $(SOURCE)
	cp patch-files/$(SOURCE)/actvte.f $(SOURCE)/tools
	cp patch-files/$(SOURCE)/compddi $(SOURCE)/ddi
	cp patch-files/$(SOURCE)/comp $(SOURCE)
	cp patch-files/$(SOURCE)/compall $(SOURCE)
	cp patch-files/$(SOURCE)/lked $(SOURCE)
	( \
	  $(COMPILERSETUP); \
	  perl -pi -e 's!ROLL_FCC!$(FCC)!' $(SOURCE)/install.info; \
	  perl -pi -e 's!ROLL_MATHLIB!$(MATHLIB)!' $(SOURCE)/install.info; \
	  perl -pi -e 's!ROLL_GAMESSROOT!$(PWD)/$(SOURCE)!' $(SOURCE)/install.info; \
	  perl -pi -e 's!^(.*ROLL)!# $$1!m' $(SOURCE)/install.info; \
	  cd $(SOURCE)/tools; \
	  $(FCC) -o actvte.x actvte.f; \
	  cd ../ddi; \
	  ./compddi; \
	  mv ddikick.x ..; \
	  cd ..; \
	  ./compall; \
	  ./lked \
	)

install::
	mkdir -p $(ROOT)/$(PKGROOT)
	( \
	  cd $(SOURCE); \
	  cp gamess.00.x runall rungms ericfmt.dat ddikick.x *.DOC \
	     $(ROOT)/$(PKGROOT); \
	  cp -r mcpdata tests $(ROOT)/$(PKGROOT) \
	)

clean::
	rm -rf $(SOURCE)
