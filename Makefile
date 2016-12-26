# Makefile for ini-parser
 
PROJECT=ini-parser

PP=cpp
CC=cc
LD=ld
AR=ar
CCFLAGS=-O3 -Werror -Wall
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
 
static : $(STATIC_TARGET)
shared : $(SHARED_TARGET)

clean : 
	@$(RM) $(BINDIR)/* $(BUILDDIR)/*
	@echo -e $(CLEANMSG)
 
$(STATIC_TARGET) : $(LDOBJS)
	@$(AR) csq $@ $^
	@echo -e $(LINKMSG)
 
$(SHARED_TARGET) : $(LDOBJS)
	@$(CC) -o $@ $^ $(LDFLAGS)
	@echo -e $(LINKMSG)
 
$(BUILDDIR)/%.dep : $(SRCDIR)/%.c
	@$(PP) $(CCFLAGS) -MM -MT $(@:.dep=.o) -o $@ $<
 
$(BUILDDIR)/%.o : $(SRCDIR)/%.c
	@$(CC) $(CCFLAGS) -c -o $@ $<
	@echo -e $(BUILDMSG)
 
-include $(DEPEND)
