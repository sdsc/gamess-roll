NAME               = gamess_$(ROLLCOMPILER)
VERSION            = 5.2012
RELEASE            = 1
PKGROOT            = /opt/gamess

SRC_SUBDIR         = gamess

SOURCE_NAME        = $(NAME)
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tgz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TGZ_PKGS           = $(SOURCE_PKG)

