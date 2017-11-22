ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

CUDAVERSION=cuda
ifneq ("$(ROLLOPTS)", "$(subst cuda=,,$(ROLLOPTS))")
  CUDAVERSION = $(subst cuda=,,$(filter cuda=%,$(ROLLOPTS)))
endif


NAME           = sdsc-gamess
VERSION        = 2017.04
RELEASE        = 2
PKGROOT        = /opt/gamess

SRC_SUBDIR     = gamess

SOURCE_NAME    = gamess
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_NAME)-$(SOURCE_VERSION)


LIBINT_NAME    = libint
LIBINT_SUFFIX  = tar.gz
LIBINT_VERSION = 2.1.0.1f82c27
LIBINT_PKG     = $(LIBINT_NAME)-$(LIBINT_VERSION).$(LIBINT_SUFFIX)
LIBINT_DIR     = $(LIBINT_NAME)

GMP_NAME    = gmp
GMP_SUFFIX  = tar.bz2
GMP_VERSION = 6.1.2
GMP_PKG     = $(GMP_NAME)-$(GMP_VERSION).$(GMP_SUFFIX)
GMP_DIR     = $(GMP_NAME)-$(GMP_VERSION)

TAR_GZ_PKGS       = $(SOURCE_PKG) $(LIBINT_PKG)
TAR_BZ2_PKGS      = $(GMP_PKG)

RPM.EXTRAS     = AutoReq:No
