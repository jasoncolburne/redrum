# Copyright (C) 2015, Redbeard Enterprises Ltd.
#
# Not to be used in any form without express written consent.
# All rights reserved.
#
# $Id: makefile 2 2010-03-29 03:41:56Z jason $

RUMPATH := ../redrum

include $(RUMPATH)/target.mk

MODULES := $(strip $(subst /, ,$(dir $(wildcard */makefile))))

modules:
	@$(foreach MODULE, $(MODULES),$(MAKE) -w -C $(MODULE) &&) $(ECHO) -n

%:
	@$(foreach MODULE, $(MODULES),$(MAKE) -w -C $(MODULE) $@ &&) $(ECHO) -n
