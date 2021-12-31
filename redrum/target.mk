# Copyright (C) 2010-2021, Redbeard Enterprises Ltd.
#
# Not to be used in any form without express written consent.
# All rights reserved.
#
# $Id: target.mk 2 2010-03-29 03:41:56Z jason $

ifndef RUMPATH
  RUMPATH := .
endif

RED_SUPPORTED_REGISTER_WIDTHS := 32 64

ifdef RED_TARGET

  RED_OS             := $(word 1,$(subst _, ,$(RED_TARGET)))
  RED_PLATFORM       := $(word 2,$(subst _, ,$(RED_TARGET)))
  RED_REGISTER_WIDTH := $(filter-out $(RED_OS),$(foreach _width,$(RED_SUPPORTED_REGISTER_WIDTHS),$(patsubst %$(_width),$(_width),$(RED_OS))))

  RED_TARGET_MAKEFILES := $(wildcard $(RUMPATH)/platform/$(RED_PLATFORM).mk)

  ifneq ("$(words $(RED_TARGET_MAKEFILES))","1")
    $(error Platform '$(RED_PLATFORM)' not supported.)
  endif

  ifeq ("$(RED_REGISTER_WIDTH)","")
    $(warning Register width not defined. Defaulting to 32 bits.)
    RED_REGISTER_WIDTH := 32
    RED_OS := $(RED_OS)32
  endif

  RED_TARGET_MAKEFILES += $(wildcard $(RUMPATH)/os/$(patsubst %$(RED_REGISTER_WIDTH),%,$(RED_OS)).mk)

  ifneq ("$(words $(RED_TARGET_MAKEFILES))","2")
    $(error OS '$(RED_OS)' not supported.)
  endif

  RED_TARGET := $(RED_OS)_$(RED_PLATFORM)

else

  $(error Must define RED_TARGET.)

endif

ifeq ("$(strip $(RED_BUILD))","")

  $(warning "RED_BUILD undefined. Defaulting to 'release'.")
  RED_BUILD := release

endif

include $(RED_TARGET_MAKEFILES)

RED_TARGET_BUILD := $(RED_TARGET)_$(RED_BUILD)

CFLAGS += -DRED_TARGET=\"$(RED_TARGET)\"
CFLAGS += -DRED_BUILD=\"$(RED_BUILD)\"
CFLAGS += -DRED_OS=\"$(RED_OS)\"
CFLAGS += -DRED_REGISTER_WIDTH=$(RED_REGISTER_WIDTH)
CFLAGS += -DRED_PLATFORM=\"$(RED_PLATFORM)\"


ifeq ("$(RED_TEST_TARGET_MK)","1")

echo:
	@$(ECHO) "        target=$(RED_TARGET)"
	@$(ECHO) "            os=$(RED_OS)"
	@$(ECHO) "register_width=$(RED_REGISTER_WIDTH)"
	@$(ECHO) "      platform=$(RED_PLATFORM)"
	@$(ECHO) "         build=$(RED_BUILD)"
	@$(ECHO) "  target_build=$(RED_TARGET_BUILD)"

endif
