# Copyright (C) 2015, Redbeard Enterprises Ltd.
#
# Not to be used in any form without express written consent.
# All rights reserved.
#
# $Id: simpc.mk 2 2010-03-29 03:41:56Z jason $

CFLAGS  += -mpentium -DCPU=SIMNT -DVXSIM
LDFLAGS += -nostdlib

# seems unlikely we don't want this
ifeq ("$(RED_BUILD)","debug")
  LDFLAGS += --force-stabs-reloc
endif

RED_TOOL_SUFFIX:=simpc

# required
RED_BYTEORDER=RED_LSB_FIRST

include $(RUMPATH)/platform/byteorder.mk
