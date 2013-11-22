ifeq ($(TOOLDIR),)
    PWD=$(shell pwd)
    TOOLDIR=$(shell dirname $(PWD))/tools
endif
  
ROOT=$(TOOLDIR)/arm-2009q1/bin/arm-none-linux-gnueabi

CC=$(ROOT)-gcc

CFLAGS=-g
LDFLAGS=-lm

SRC = $(wildcard *.c)
EXE = $(SRC:.c=.exe)

all: $(EXE)

%.exe: %.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

clean::
	rm -f $(EXE)
