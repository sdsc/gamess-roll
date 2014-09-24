NAME        = gamess-modules
RELEASE     = 1
PKGROOT     = /opt/modulefiles/applications/gamess

VERSION_SRC = $(REDHAT.ROOT)/src/gamess/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
