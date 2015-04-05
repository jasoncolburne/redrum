# Copyright (C) 2015, Redbeard Enterprises Ltd.
#
# Not to be used in any form without express written consent.
# All rights reserved.
#
# $Id: linux.mk 2 2010-03-29 03:41:56Z jason $

RED_TOOL_PATH  :=
RED_TOOL_SUFFIX:=

include $(RUMPATH)/os/toolchain/gnu.mk

A :=.a
SO:=.so
O :=.o
E :=

LDFLAGS  +=

CFLAGS   +=
CPPFLAGS += $(CFLAGS)

STRIPFLAGS += --strip-unneeded
