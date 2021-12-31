# Copyright (C) 2010-2021, Jason Colburne
#
# Not to be used in any form without express written consent.
# All rights reserved.
#
# $Id: vxworks.mk 2 2010-03-29 03:41:56Z jason $

ifeq ("$(RED_OS_VERSION)","")
  $(warning Should define OS version for VxWorks. Defaulting to 6_7)
  RED_OS_VERSION:=6_7
endif

$(error VxWorks makefile incomplete.)
# check for 5_x
  WRBASE    ?= C:/Tornado2.2
  RED_TOOL_PATH ?= $(WRBASE)/host/x86-win32/bin/

  OS_INCLUDE_DIRS = $(WRBASE)/target/h
# endif

# check for 6_x
WRBASE = $(subst \,/,$(WIND_BASE))

OS_INCLUDE_DIRS += $(WRBASE)/target/h
OS_INCLUDE_DIRS += $(WRBASE)/target/h/wrn/coreip

CFLAGS += -D_VSB_CONFIG_FILE=\"$(WRBASE)/target/lib/h/config/vsbConfig.h \" \
          -fno-implicit-fp  \
          -DTOOL_FAMILY=gnu \
          -DTOOL=gnu
# endif

# assume a windows build environment
TOOL_SUFFIX:=$(RED_TOOL_SUFFIX).exe

include $(RUMPATH)/target/os/toolchain/gnu.mk

LDBIN:=$(RED_TOOL_PATH)ld$(RED_TOOL_SUFFIX)

A :=.a
SO:=.a
O :=.o
E :=.out

LDFLAGS  += -r

LS_START_GROUP := --start-group
LD_END_GROUP   := --end-group

CFLAGS   += -D__vxworks__     \
            -DVXWORKS         \
            -D_WRS_KERNEL     \
            -D_HAS_C9X        \
            -mhard-float      \
            -DTOOL_FAMILY=gnu \
            -DTOOL=gnu        \
            -I$(OS_INCLUDE_DIRS)

ifneq ("$(RED_PLATFORM)", "SIMPC")
CFLAGS +=   -mstrict-align    \
            -mlongcall
endif

ifeq ("$(RED_PLATFORM)", "SIMPC")
CFLAGS +=   -fno-builtin   \
            -fno-defer-pop
endif

CPPFLAGS += $(CFLAGS)

STRIPFLAGS +=
