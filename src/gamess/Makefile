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

GAMESS_VERSION=gamess.1.2009
PKGROOT = /opt/$(GAMESS_VERSION)
REDHAT.ROOT = $(PWD)/../../

-include $(ROCKSROOT)/etc/Rules.mk
GMS_TARGET=linux64
ACTVTE_TARGET=UNX
build:
	mkdir -p BUILD
	(cd BUILD;  tar xvf ../$(GAMESS_VERSION).tgz )
#note: editing commands should be added for a compiler change
# set ddi target
	 (cd BUILD/$(GAMESS_VERSION)/ddi;cat compddi.orig | \
               sed -e '18c"         set TARGET = $(GMS_TARGET)"' >compddi.tmp)
	 (cd BUILD/$(GAMESS_VERSION)/ddi;cat compddi.tmp | sed -e '18s/\"//g'>compddi.tmp2)
	 (cd BUILD/$(GAMESS_VERSION)/ddi;cat compddi.tmp2 | \
               sed -e '1c#!/bin/csh -f' >compddi;chmod 0755 compddi)
# compiled actvte.x for unix
	 (cd BUILD/$(GAMESS_VERSION)/tools;cat actvte.code | \
               sed -e 's/^*$(ACTVTE_TARGET)/    /' >actvte.f)
	 (cd BUILD/$(GAMESS_VERSION)/tools;gfortran -o actvte.x actvte.f)
# set comp target
	 (cd BUILD/$(GAMESS_VERSION);cat comp.orig | \
               sed -e '15cset TARGET=$(GMS_TARGET)' >comp.tmp)
	 (cd BUILD/$(GAMESS_VERSION);cat comp.tmp | \
               sed -e '16cchdir .' >comp.tmp2)
	 (cd BUILD/$(GAMESS_VERSION);cat comp.tmp2 | \
               sed -e '1c#!/bin/csh -f' >comp;chmod 0755 comp)
# set compall target
	 (cd BUILD/$(GAMESS_VERSION);cat compall.orig | \
               sed -e '16cset TARGET=$(GMS_TARGET)' >compall.tmp)
	 (cd BUILD/$(GAMESS_VERSION);cat compall.tmp | \
               sed -e '17cchdir .' >compall.tmp2)
	 (cd BUILD/$(GAMESS_VERSION);cat compall.tmp2 | \
               sed -e '1c#!/bin/csh -f' >compall;chmod 0755 compall)
# set lked target
	 (cd BUILD/$(GAMESS_VERSION);cat lked.orig | \
               sed -e '18cset TARGET=$(GMS_TARGET)' >lked.tmp)
	 (cd BUILD/$(GAMESS_VERSION);cat lked.tmp | \
               sed -e '19cchdir .' >lked.tmp2)
	 (cd BUILD/$(GAMESS_VERSION);cat lked.tmp2 | \
               sed -e '1c#!/bin/csh -f' >lked.tmp3)
	 (cd BUILD/$(GAMESS_VERSION);cat lked.tmp3 | \
               sed -e '466c#        exit 4 jpg' >lked;chmod 0755 lked)
# set local paths for rungms 
	 (cd BUILD/$(GAMESS_VERSION);cat rungms.orig | \
                sed -e '570c"      set spacer2=\"\""'>rungms.tmp)
	 (cd BUILD/$(GAMESS_VERSION);cat rungms.tmp | sed -e '570s/\"//g' >rungms.tmp2)
	 (cd BUILD/$(GAMESS_VERSION);cat rungms.tmp2 | \
               sed -e '477,500d' >rungms.tmp3)
	 (cd BUILD/$(GAMESS_VERSION);cat rungms.tmp3 | \
               sed -e '429c"   if ($$os == Linux)   set GMSPATH=/opt/gamess.1.2009"' >rungms.tmp4)
	 (cd BUILD/$(GAMESS_VERSION);cat rungms.tmp4 | sed -e '429s/\"//g'>rungms.tmp5)
	 (cd BUILD/$(GAMESS_VERSION);cat rungms.tmp5 | \
                sed -e '130,135csetenv  MAKEFP  $$JOB.efp\nsetenv   GAMMA  $$JOB.gamma\n\
setenv TRAJECT  $$JOB.trj\nsetenv RESTART $$JOB.rst\n\
setenv INPUT $$JOB.F05\nsetenv   PUNCH $$JOB.dat' >rungms.tmp6)
	 (cd BUILD/$(GAMESS_VERSION);cat rungms.tmp6 | \
                sed -e '125,126csetenv ERICFMT /opt/gamess.1.2009/ericfmt.dat\n\
setenv MCPPATH /opt/gamess.1.2009/gamess/mcpdata' >rungms.tmp7)
	 (cd BUILD/$(GAMESS_VERSION);cat rungms.tmp7 | \
                sed -e '58cset SCR=.' >rungms;chmod 0755 rungms)
	 (cd BUILD/$(GAMESS_VERSION);rm -f comp.tmp* compall.tmp* lked.tmp* rungms.tmp*)
	 (cd BUILD/$(GAMESS_VERSION);rm -f compddi.tmp*)
	 (cd BUILD/$(GAMESS_VERSION)/ddi;./compddi;mv ddikick.x ..)
	 (cd BUILD/$(GAMESS_VERSION);./compall)
	 (cd BUILD/$(GAMESS_VERSION);./lked )
install::
	mkdir -p $(ROOT)/$(PKGROOT)
	(cd BUILD/$(GAMESS_VERSION);cp -r gamess.00.x rungms ericfmt.dat ddikick.x\
                 *.DOC $(ROOT)/$(PKGROOT))
	(cd BUILD/$(GAMESS_VERSION);cp -r mcpdata runall rungms tests \
                  $(ROOT)/$(PKGROOT))

clean::
	rm -rf BUILD
