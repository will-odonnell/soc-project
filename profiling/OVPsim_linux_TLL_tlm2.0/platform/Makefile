# --- Makefile for TLL platform model

# Configuration
SYSTEMC  = /usr/local/packages/systemc-2.2.0
TLM_HOME = /usr/local/packages/systemc-tlm-2.0.1

MAKEFILE= ${IMPERAS_HOME}/ImperasLib/source/buildutils/Makefile.TLM.platform.Linux

PLATFORM= TLL_tlm2.0
PLATFORM_OBJECTS= Build/Linux/usr/Adder.o		\
		  Build/Linux/usr/TLL6219.o		\
		  Build/Linux/usr/TLL5000.o		\
		  Build/Linux/usr/$(PLATFORM).o

CPP	= g++ -m32 -DSC_INCLUDE_DYNAMIC_PROCESSES
LD	= g++ -m32


all:
	$(MAKE) -f ${MAKEFILE} CPP="$(CPP)" LD="$(LD)"	\
		SYSTEMC=$(SYSTEMC) TLM_HOME=$(TLM_HOME)	\
		PLATFORM=$(PLATFORM) PLATFORM_OBJECTS="$(PLATFORM_OBJECTS)" \
		all

clean:
	$(MAKE) -f $(MAKEFILE) CPP="$(CPP)" LD="$(LD)"	\
		SYSTEMC=$(SYSTEMC) TLM_HOME=$(TLM_HOME)	\
		PLATFORM=$(PLATFORM) PLATFORM_OBJECTS="$(PLATFORM_OBJECTS)" \
		clean
	$(RM) *~ *.log
	$(RM) -r Build fs
