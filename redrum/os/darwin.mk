# Copyright (C) 2010, Redbeard Enterprises Ltd.
#
# Not to be used in any form without express written consent.
# All rights reserved.
#
# $Id: darwin.mk 20 2010-04-23 00:43:47Z jason $

RED_TOOL_PATH  :=
RED_TOOL_SUFFIX:=

ECHO := $(shell which echo)

include $(RUMPATH)/os/toolchain/gnu.mk

SED_IN_PLACE:=sed -i ""

A :=.a
SO:=.so
O :=.o
E :=

LIB_FLAGS_STATIC += -c

LDFLAGS  +=

CFLAGS   +=
CPPFLAGS += $(CFLAGS)

STRIPFLAGS +=
