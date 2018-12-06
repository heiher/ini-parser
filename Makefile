# Makefile for ini-parser
 
PROJECT=ini-parser

CROSS_PREFIX :=
PP=$(CROSS_PREFIX)cpp
CC=$(CROSS_PREFIX)gcc
LD=$(CROSS_PREFIX)ld
AR=$(CROSS_PREFIX)ar
CCFLAGS=-O3 -pipe -Werror -Wall
LDFLAGS=
 
SRCDIR=src
BINDIR=bin
BUILDDIR=build
 
STATIC_TARGET=$(BINDIR)/libini-parser.a
SHARED_TARGET=$(BINDIR)/libini-parser.so

$(SHARED_TARGET) : CCFLAGS+=-fPIC
$(SHARED_TARGET) : LDFLAGS+=-shared -pthread

CCOBJS=$(wildcard $(SRCDIR)/*.c)
LDOBJS=$(patsubst $(SRCDIR)%.c,$(BUILDDIR)%.o,$(CCOBJS))
DEPEND=$(LDOBJS:.o=.dep)

BUILDMSG="\e[1;31mBUILD\e[0m $<"
LINKMSG="\e[1;34mLINK\e[0m  \e[1;32m$@\e[0m"
CLEANMSG="\e[1;34mCLEAN\e[0m $(PROJECT)"
 
V :=
ECHO_PREFIX := @
ifeq ($(V),1)
	undefine ECHO_PREFIX
endif

static : $(STATIC_TARGET)
shared : $(SHARED_TARGET)

clean : 
	$(ECHO_PREFIX) $(RM) -rf $(BINDIR) $(BUILDDIR)
	@echo -e $(CLEANMSG)
 
$(STATIC_TARGET) : $(LDOBJS)
	$(ECHO_PREFIX) mkdir -p $(dir $@)
	$(ECHO_PREFIX) $(AR) csq $@ $^
	@echo -e $(LINKMSG)
 
$(SHARED_TARGET) : $(LDOBJS)
	$(ECHO_PREFIX) mkdir -p $(dir $@)
	$(ECHO_PREFIX) $(CC) -o $@ $^ $(LDFLAGS)
	@echo -e $(LINKMSG)
 
$(BUILDDIR)/%.dep : $(SRCDIR)/%.c
	$(ECHO_PREFIX) mkdir -p $(dir $@)
	$(ECHO_PREFIX) $(PP) $(CCFLAGS) -MM -MT$(@:.dep=.o) -MF$@ $< 2>/dev/null
 
$(BUILDDIR)/%.o : $(SRCDIR)/%.c
	$(ECHO_PREFIX) mkdir -p $(dir $@)
	$(ECHO_PREFIX) $(CC) $(CCFLAGS) -c -o $@ $<
	@echo -e $(BUILDMSG)
 
-include $(DEPEND)
