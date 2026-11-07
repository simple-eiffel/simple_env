# Builds the object simple_env.ecf links on macOS and Linux.
# Run "make" here before compiling a system that uses simple_env.

CC ?= cc
CFLAGS ?= -O2 -fPIC

simple_env.o: simple_env.c simple_env.h
	$(CC) $(CFLAGS) -c simple_env.c -o simple_env.o

clean:
	rm -f simple_env.o

.PHONY: clean
