NAME               = gamess_$(ROLLCOMPILER)
VERSION            = 5.2012
RELEASE            = 0
PKGROOT            = /opt/gamess
RPM.EXTRAS         = AutoReq:No

SRC_SUBDIR         = gamess

SOURCE_NAME        = gamess
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tgz
SOURCE_PKG         = $(SOURCE_NAME).$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TGZ_PKGS           = $(SOURCE_PKG)

