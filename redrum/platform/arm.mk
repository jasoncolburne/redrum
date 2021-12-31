# Copyright (C) 2010-2021, Jason Colburne
#
# Not to be used in any form without express written consent.
# All rights reserved.
#
# $Id: arm.mk 28 2011-02-10 07:06:19Z jason $

CFLAGS+=

# required. arm can be either, but defaults to lsb
RED_BYTEORDER=RED_LSB_FIRST

include $(RUMPATH)/platform/byteorder.mk
