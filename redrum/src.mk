# Copyright (C) 2010-2021, Redbeard Enterprises Ltd.
#
# Not to be used in any form without express written consent.
# All rights reserved.
#
# $Id: src.mk 28 2011-02-10 07:06:19Z jason $

SILENT ?= @

SRCROOT ?= ..

MODULEID ?= $(word $(words $(subst /, ,$(subst \,/,$(shell pwd)))), $(subst /, ,$(subst \,/,$(shell pwd))))

SRCDIR   ?= ./src
TSTDIR   ?= ./test
PROJROOT ?= $(SRCROOT)/..
PKGROOT  ?= $(PROJROOT)/pkg
OBJROOT  ?= $(word 1, $(SRCDIR))

CPP_EXTS := .cpp .cxx .cc .C .c++

# find objects
OBJDIR     ?= $(OBJROOT)/obj/$(RED_TARGET)/$(RED_BUILD)
C_SOURCES  := $(foreach dir,$(SRCDIR),$(filter-out $(addsuffix .c,$(addprefix $(dir)/,$(EXCLUDE_OBJECTS))),$(wildcard $(dir)/*.c)))
CC_SOURCES := $(foreach dir,$(SRCDIR),$(foreach ext,$(CPP_EXTS),$(filter-out $(addsuffix $(ext),$(addprefix $(dir)/,$(EXCLUDE_OBJECTS))),$(wildcard $(dir)/*$(ext)))))
SOURCES    := $(C_SOURCES) $(CC_SOURCES)
OBJS       := $(addsuffix $O, $(addprefix $(OBJDIR)/,$(notdir $(basename $(SOURCES)))))

# the above crazy business is mainly for porting
TEST_OBJDIR     := $(TSTDIR)/obj/$(RED_TARGET)/$(RED_BUILD)
TEST_C_SOURCES  := $(wildcard $(TSTDIR)/*.c)
TEST_CC_SOURCES := $(foreach ext,$(CPP_EXTS),$(wildcard $(TSTDIR)/*$(ext)))
TEST_SOURCES    := $(TEST_C_SOURCES) $(TEST_CC_SOURCES)
TEST_OBJS       := $(addsuffix $O, $(addprefix $(TEST_OBJDIR)/,$(notdir $(basename $(TEST_SOURCES)))))

# finds the source file for a given object file
find_source = $(foreach dir,$(SRCDIR),$(filter $(patsubst %$O,$(dir)/%,$(notdir $(1))).%,$(SOURCES)))
# finds the test source file
find_test_source = $(filter $(patsubst %$O,$(TSTDIR)/%,$(notdir $(1))).%,$(TEST_SOURCES))
# picks the compiler to use for a given source file
choose_compiler_and_flags = $(if $(filter $(suffix $(1)),$(CPP_EXTS)),$(CPP) $(CPPFLAGS),$(CC) $(CFLAGS))
# display compiler string during compilation
display_compiler = $(if $(filter $(suffix $(1)),$(CPP_EXTS)),c++ $(notdir $(1))...,cc -c $(notdir $(1))...)

# get os specific library dependencies
RED_OS_NO_WIDTH = $(shell $(ECHO) $(RED_OS) | sed s/32$\// | sed s/64$\//)

ifneq ("$(LIBS.$(RED_OS_NO_WIDTH))","")
  LIBS += $(LIBS.$(RED_OS_NO_WIDTH))
endif


HDIRS   += $(wildcard $(SRCROOT)/*/include) $(PKGROOT)/$(RED_TARGET)/$(RED_BUILD)/include

TSTBIN  := $(TEST_OBJDIR)/test_$(MODULEID)$E

LIBDIRS := $(PROJROOT)/lib/$(RED_TARGET)/$(RED_BUILD)
ifeq ("$(wildcard $(PKGROOT)/$(RED_TARGET)/$(RED_BUILD)/lib)","")
  LIBDIRS +=
else
  LIBDIRS += $(PKGROOT)/$(RED_TARGET)/$(RED_BUILD)/lib
endif

LIBDEPS := $(foreach lib,$(LIBS),$(foreach dir,$(LIBDIRS),$(wildcard $(dir)/$(LIBPREFIX)$(lib)*)))

LDFLAGS += $(addprefix -L, $(LIBDIRS))
LDFLAGS += $(LD_START_GROUP)
LDFLAGS += $(addprefix -l, $(LIBS))
LDFLAGS += $(LD_END_GROUP)

CFLAGS  += $(addprefix -I, $(HDIRS))

# default rule - create dependency files and then build objects by recalling
default: prepare
	$(SILENT)$(MAKE) --no-print-directory objects

prepare: $(OBJDIR) $(TEST_OBJDIR) $(subst $O,.d,$(OBJS)) $(subst $O,.d,$(TEST_OBJS))

# build objects
objects: $(OBJS)
	$(SILENT)$(ECHO) -n

list:
	@$(ECHO) $(OBJS)

clean:
	$(SILENT)$(RM) -f $(OBJS) $(TEST_OBJS) $(TSTBIN) $(OBJDIR)/*.d $(TEST_OBJDIR)/*.d

empty:
	$(SILENT)$(RM) -rf $(OBJDIR) $(TEST_OBJDIR) $(TEST_BIN)

$(OBJDIR)/%.d:
	$(SILENT)$(ECHO) "# Autogenerated dependency file - $(shell date)" > $@
	$(SILENT)$(call choose_compiler_and_flags,$(call find_source,$(subst .d,$O,$@))) -M $(call find_source,$(subst .d,$O,$@)) >> $@
	$(SILENT)$(SED_IN_PLACE) "s/^\(.*\$O\):/$(subst /,\/,$(OBJDIR))\/\1 $(subst /,\/,$@):/g" $@
  ifeq ("$(TERM)","cygwin")
	$(SILENT)$(SED_IN_PLACE) "s/\(\s\)\(.\):/\1\/cygdrive\/\2/g" $@
  endif

$(TEST_OBJDIR)/%.d:
	$(SILENT)$(ECHO) "# Autogenerated dependency file - $(shell date)" > $@
	$(SILENT)$(call choose_compiler_and_flags,$(call find_test_source,$(subst .d,$O,$@))) -M $(call find_test_source,$(subst .d,$O,$@)) >> $@
	$(SILENT)$(SED_IN_PLACE) "s/^\(.*\$O\):/$(subst /,\/,$(TEST_OBJDIR))\/\1 $(subst /,\/,$@):/g" $@
  ifeq ("$(TERM)","cygwin")
	$(SILENT)$(SED_IN_PLACE) "s/\(\s\)\(.\):/\1\/cygdrive\/\2/g" $@
  endif


# pretend everything still exists
$(addsuffix /%.h,$(HDIRS) $(SRCDIR) $(TSTDIR)):
	: pretending $(@F) exists...

ifneq ("","$(wildcard $(subst $O,.d,$(OBJS)))")
  -include $(subst $O,.d,$(OBJS))
endif

ifneq ("","$(wildcard $(subst $O,.d,$(TEST_OBJS)))")
  -include $(subst $O,.d,$(TEST_OBJS))
endif

#end dependencies

ifeq ("$(TEST_OBJS)","")
  buildtest:
else
  buildtest: prepare
	$(SILENT)$(MAKE) --no-print-directory $(TSTBIN)
endif

test: $(TSTBIN)
	: running $(notdir $(TSTBIN))
	$(SILENT)$(TSTBIN)

echo:
	$(SILENT)$(ECHO) "MODULEID = $(MODULEID)"
	$(SILENT)$(ECHO)
	$(SILENT)$(ECHO) "CFLAGS   = $(CFLAGS)"
	$(SILENT)$(ECHO) "LDFLAGS  = $(LDFLAGS)"
	$(SILENT)$(ECHO)
	$(SILENT)$(ECHO) "OBJDIR   = $(OBJDIR)"
	$(SILENT)$(ECHO) "SRCDIR   = $(SRCDIR)"
	$(SILENT)$(ECHO)
	$(SILENT)$(ECHO) "LIBS     = $(LIBS)"
	$(SILENT)$(ECHO)
	$(SILENT)$(ECHO) "HDIRS    = $(HDIRS)"
	$(SILENT)$(ECHO) "LIBDIR   = $(LIBDIR)"
	$(SILENT)$(ECHO) "MODDIRS  = $(MODDIRS)"
	$(SILENT)$(ECHO)
	$(SILENT)$(ECHO) "SOURCES  = $(SOURCES)"
	$(SILENT)$(ECHO) "OBJS     = $(OBJS)"
	$(SILENT)$(ECHO) "TEST_OBJS  = $(TEST_OBJS)"


$(TSTBIN): $(TEST_OBJS) $(LIBDEPS)
	: ld $(@F)...
	$(SILENT)$(LDBIN) $(TEST_OBJS) $(LDFLAGS) -o $@


$(TEST_OBJDIR)/%$O:
	: $(call display_compiler,$(call find_test_source,$@))
	$(SILENT)$(call choose_compiler_and_flags,$(call find_test_source,$@)) -c $(call find_test_source,$@) -o $@

$(OBJDIR)/%$O:
	: $(call display_compiler,$(call find_source,$@))
	$(SILENT)$(call choose_compiler_and_flags,$(call find_source,$@)) -c $(call find_source,$@) -o $@

$(OBJDIR) $(TEST_OBJDIR):
	$(SILENT)$(MKDIR) -p $@
