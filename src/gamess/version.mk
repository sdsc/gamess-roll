ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

NAME           = sdsc-gamess
VERSION        = 2014.12
RELEASE        = 4
PKGROOT        = /opt/gamess

SRC_SUBDIR     = gamess

SOURCE_NAME    = gamess
SOURCE_SUFFIX  = tgz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME).$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_NAME).$(SOURCE_VERSION)

TGZ_PKGS       = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
