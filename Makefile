# Makefile for ini-parser

PROJECT=ini-parser
 
AR=ar
PP=cpp
CC=cc
CCFLAGS=-O3
 
SRCDIR=src
BINDIR=bin
BUILDDIR=build
 
TARGET=$(BINDIR)/libini-parser.a
CCOBJSFILE=$(BUILDDIR)/ccobjs
-include $(CCOBJSFILE)
LDOBJS=$(patsubst $(SRCDIR)%.c,$(BUILDDIR)%.o,$(CCOBJS))
 
DEPEND=$(LDOBJS:.o=.dep)
 
static : $(CCOBJSFILE) $(TARGET)
	@$(RM) $(CCOBJSFILE)
 
clean : 
	@echo -en "\e[1;34mClean $(PROJECT) \e[0m... " && $(RM) $(BINDIR)/* $(BUILDDIR)/* && echo -e "\e[1;32mOK\e[0m"
 
$(CCOBJSFILE) : 
	@echo CCOBJS=`ls $(SRCDIR)/*.c` > $(CCOBJSFILE)
 
$(TARGET) : $(LDOBJS)
	@echo -en "\e[1;34mLinking $@ \e[0m... " && $(AR) csq $@ $^ && echo -e "\e[1;32mOK\e[0m"
 
$(BUILDDIR)/%.dep : $(SRCDIR)/%.c
	@$(PP) $(CCFLAGS) -MM -MT $(@:.dep=.o) -o $@ $<
 
$(BUILDDIR)/%.o : $(SRCDIR)/%.c
	@echo -en "\e[1;31mCompiling $< \e[0m... " && $(CC) $(CCFLAGS) -c -o $@ $< && echo -e "\e[1;32mOK\e[0m"
 
-include $(DEPEND)

