# Copyright (C) 2010-2021, Redbeard Enterprises Ltd.
#
# Not to be used in any form without express written consent.
# All rights reserved.
#
# $Id: lib.mk 20 2010-04-23 00:43:47Z jason $

SILENT ?= @

LIBROOT  ?= .
PROJROOT ?= $(LIBROOT)/..

LIBDIR ?= $(LIBROOT)/$(RED_TARGET)/$(RED_BUILD)

STATICLIBS  ?=
DYNAMICLIBS ?=

ALLLIBS     := $(STATICLIBS) $(DYNAMICLIBS)
LIBSTOBUILD := $(addprefix $(LIBDIR)/$(LIBPREFIX),$(addsuffix $A,$(STATICLIBS))) \
	       $(addprefix $(LIBDIR)/$(LIBPREFIX),$(addsuffix $(SO),$(DYNAMICLIBS)))

find_src_dirs =$(addprefix $(PROJROOT)/,$($(subst /$(LIBPREFIX),,$(subst $(SO),,$(subst $A,,$(1))))))
full_libname  =$(addprefix $(LIBDIR)/,$(if $(filter $(subst $(LIBPREFIX),,$(1)),$(STATICLIBS)),$(1)$A,$(1)$(SO)))

LIBDEPENDS := $(addprefix $(LIBDIR)/$(LIBPREFIX),$(addsuffix .d,$(ALLLIBS)))


cleandeps:
	$(SILENT)$(RM) -f $(LIBDEPENDS)
	$(SILENT)$(MAKE) --no-print-directory libs

libs: $(LIBDIR) $(LIBDEPENDS)
	$(SILENT)$(MAKE) --no-print-directory build

build: $(LIBSTOBUILD)
	$(SILENT)$(ECHO) -n

list:
	@$(ECHO) $(LIBSTOBUILD)

ifneq ("","$(wildcard $(LIBDEPENDS))")
  -include $(LIBDEPENDS)
endif

$(LIBDIR)/%.d:
	$(SILENT)$(ECHO) "# Automatically generated dependency file. Do not edit. $(shell date)" > $@
	$(SILENT)$(ECHO) -n "$(call full_libname,$(subst .d,,$(@F))): " >> $@
	$(SILENT)$(foreach dir,$(call find_src_dirs,/$(subst .d,,$(@F))),$(ECHO) -n " $(addprefix $(dir)/,$(shell $(MAKE) --no-print-directory -C $(dir) list))" >> $@ && )$(ECHO) >> $@
	$(SILENT)$(ECHO) >> $@
	$(SILENT)$(foreach dir,$(call find_src_dirs,/$(subst .d,,$(@F))),$(ECHO) -n " $(addprefix $(dir)/,$(shell $(MAKE) --no-print-directory -C $(dir) list))" >> $@ && )$(ECHO) -n >> $@
	$(SILENT)$(ECHO) ":" >> $@

$(LIBDIR)/$(LIBPREFIX)%$A:
	: creating $(@F)...
	$(SILENT)$(AR) $(LIB_FLAGS_STATIC) $@ $^

ifneq ("$(strip $(SO))","$(strip $A)")
$(LIBDIR)/%$(SO):
	: creating $(@F)...
	: TODO!! need to resolve all symbols here
#	$(SILENT)$(LD) $(LIB_FLAGS_DYNAMIC) -o $@ $^
endif

$(LIBDIR):
	$(SILENT)$(MKDIR) -p $@

empty:
	$(SILENT)$(RM) -rf $(LIBDIR)

clean:
	$(SILENT)$(RM) -rf $(LIBDIR)

echo:
	$(SILENT)$(ECHO) "LIBROOT     = $(LIBROOT)"
	$(SILENT)$(ECHO)
	$(SILENT)$(ECHO) "STATICLIBS  = $(STATICLIBS)"
	$(SILENT)$(ECHO) "DYNAMICLIBS = $(DYNAMICLIBS)"
	$(SILENT)$(ECHO)
	$(SILENT)$(ECHO) "LIBSTOBUILD = $(LIBSTOBUILD)"
	$(SILENT)$(ECHO) "LIBDEPENDS  = $(LIBDEPENDS)"

test:
