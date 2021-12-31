# Copyright (C) 2010-2021, Jason Colburne
#
# Not to be used in any form without express written consent.
# All rights reserved.
#
# $Id: ios.mk 28 2011-02-10 07:06:19Z jason $

IOS_TOOL_PATH   ?= /Developer/Platforms/iPhoneOS.platform/Developer
RED_TOOL_PATH   := $(IOS_TOOL_PATH)/usr/bin/
RED_TOOL_SUFFIX :=

IOS_SYSTEM_ROOT ?= $(IOS_TOOL_PATH)/SDKs/iPhoneOS4.3.sdk

ECHO := $(shell which echo)

include $(RUMPATH)/os/toolchain/gnu.mk

SED_IN_PLACE:=sed -i ""

A :=.a
SO:=.so
O :=.o
E :=

LDFLAGS  += -arch armv6 -isysroot $(IOS_SYSTEM_ROOT)

CFLAGS   += -arch armv6 -isysroot $(IOS_SYSTEM_ROOT)
CPPFLAGS += $(CFLAGS)

STRIPFLAGS +=
