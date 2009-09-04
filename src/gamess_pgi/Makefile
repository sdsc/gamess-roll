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

PKG_NAME=gamess
VERSION=1.2009
PKGROOT = /opt/pgi/$(PKG_NAME)
REDHAT.ROOT = $(PWD)/../../
PGI_PATH=/opt/pgi/linux86-64/8.0/bin
LIB_PATH=/opt/pgi/linux86-64/8.0/libso

-include $(ROCKSROOT)/etc/Rules.mk
build:
	mkdir -p BUILD_PGI
	mkdir -p $(ROOT)/$(PKGROOT)
	(cd BUILD_PGI;  tar xvf ../$(PKG_NAME).$(VERSION).tgz )
#note: editing commands should be added for a compiler change
# set ddi target
	 (cp patch-files/$(PKG_NAME).$(VERSION)/compddi BUILD_PGI/$(PKG_NAME).$(VERSION)/ddi)
# compiled actvte.x for unix
	 (cp patch-files/$(PKG_NAME).$(VERSION)/actvte.f BUILD_PGI/$(PKG_NAME).$(VERSION)/tools)
	 (export PATH=$(PGI_PATH):$$PATH;export LD_LIBRARY_PATH=$(LIB_PATH):$$LD_LIBRARY_PATH;cd BUILD_PGI/$(PKG_NAME).$(VERSION)/tools;pgf90 -o actvte.x actvte.f)
# set comp target
	 (cp patch-files/$(PKG_NAME).$(VERSION)/comp BUILD_PGI/$(PKG_NAME).$(VERSION) )
# set compall target
	 (cp patch-files/$(PKG_NAME).$(VERSION)/compall BUILD_PGI/$(PKG_NAME).$(VERSION))
# set lked target
	 (cp patch-files/$(PKG_NAME).$(VERSION)/lked BUILD_PGI/$(PKG_NAME).$(VERSION))
# set local paths for rungms 
	 (cp patch-files/$(PKG_NAME).$(VERSION)/rungms BUILD_PGI/$(PKG_NAME).$(VERSION))
	 (export PATH=$(PGI_PATH):$$PATH;export LD_LIBRARY_PATH=$(LIB_PATH):$$LD_LIBRARY_PATH;cd BUILD_PGI/$(PKG_NAME).$(VERSION)/ddi;./compddi;mv ddikick.x ..)
	 (export PATH=$(PGI_PATH):$$PATH;export LD_LIBRARY_PATH=$(LIB_PATH):$$LD_LIBRARY_PATH;cd BUILD_PGI/$(PKG_NAME).$(VERSION);./compall)
	 (export PATH=$(PGI_PATH):$$PATH;export LD_LIBRARY_PATH=$(LIB_PATH):$$LD_LIBRARY_PATH;cd BUILD_PGI/$(PKG_NAME).$(VERSION);./lked )
install::
	mkdir -p $(ROOT)/$(PKGROOT)
	mkdir -p $(PKGROOT)
	(cd BUILD_PGI/$(PKG_NAME).$(VERSION);cp -r gamess.00.x rungms ericfmt.dat ddikick.x\
                 *.DOC $(ROOT)/$(PKGROOT))
	(cd BUILD_PGI/$(PKG_NAME).$(VERSION);cp -r mcpdata runall rungms tests \
                  $(ROOT)/$(PKGROOT))
	(cd BUILD_PGI/$(PKG_NAME).$(VERSION);cp -r gamess.00.x rungms ericfmt.dat ddikick.x\
                 *.DOC $(PKGROOT))
	(cd BUILD_PGI/$(PKG_NAME).$(VERSION);cp -r mcpdata runall rungms tests \
                  $(PKGROOT))

clean::
	rm -rf BUILD_PGI
