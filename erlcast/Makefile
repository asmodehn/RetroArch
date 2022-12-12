CC = gcc
CFLAGS = -Wall -Werror -Wmissing-prototypes

OBJS = erlcast.o

EI_LIBDIR = /home/alexv/.asdf/installs/erlang/25.1.2/lib/erl_interface-5.3

CFLAGS += -I$(EI_LIBDIR)/include
LDFLAGS = -L$(EI_LIBDIR)/lib
LDLIBS  = -lei

all: erlcast

erlcast: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@ $(LDFLAGS) $(LDLIBS)

clean:
	rm -f *~ *.o erlcast