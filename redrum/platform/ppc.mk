# Copyright (C) 2010-2021, Redbeard Enterprises Ltd.
#
# Not to be used in any form without express written consent.
# All rights reserved.
#
# $Id: ppc.mk 2 2010-03-29 03:41:56Z jason $

CFLAGS+=-D__powerpc__

# may not want this always, but often we crosscompile
RED_TOOL_SUFFIX:=ppc

# required
RED_BYTEORDER=RED_MSB_FIRST

include $(RUMPATH)/platform/byteorder.mk
