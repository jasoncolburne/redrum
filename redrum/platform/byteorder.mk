# Copyright (C) 2010, Redbeard Enterprises Ltd.
#
# Not to be used in any form without express written consent.
# All rights reserved.
#
# $Id: byteorder.mk 2 2010-03-29 03:41:56Z jason $

CFLAGS += -DRED_MSB_FIRST=0 \
          -DRED_LSB_FIRST=1 \
          -DRED_BYTEORDER=$(RED_BYTEORDER)
