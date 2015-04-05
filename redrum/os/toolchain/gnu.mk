# Copyright (C) 2015, Redbeard Enterprises Ltd.
#
# Not to be used in any form without express written consent.
# All rights reserved.
#
# $Id: gnu.mk 28 2011-02-10 07:06:19Z jason $

MAKE  ?=make
MKDIR ?=mkdir
RM    ?=rm
MV    ?=mv
CP    ?=cp
ECHO  ?=echo

CC   :=$(RED_TOOL_PATH)cc$(RED_TOOL_SUFFIX)
CPP  :=$(RED_TOOL_PATH)c++$(RED_TOOL_SUFFIX)
LD   :=$(RED_TOOL_PATH)ld$(RED_TOOL_SUFFIX)
AR   :=$(RED_TOOL_PATH)ar$(RED_TOOL_SUFFIX)
NM   :=$(RED_TOOL_PATH)nm$(RED_TOOL_SUFFIX)
STRIP:=$(RED_TOOL_PATH)strip$(RED_TOOL_SUFFIX)
LDBIN:=$(RED_TOOL_PATH)cc$(RED_TOOL_SUFFIX)

SED_IN_PLACE:=sed -i

LIBPREFIX ?= lib

CFLAGS += -Wall -Werror

LIB_FLAGS_STATIC  += -r
LIB_FLAGS_DYNAMIC += -shared

ifeq ("$(RED_BUILD)", "release")
  CFLAGS += -O3
endif

ifeq ("$(RED_BUILD)", "debug")
  CFLAGS += -g -DDEBUG=1
endif
