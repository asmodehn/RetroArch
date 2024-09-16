CC = gcc
CFLAGS = -Wall -Werror

OBJS = erlcast.o erl_comm.o complex.o

EI_LIBDIR = /home/alexv/.asdf/installs/erlang/25.1.2/lib/erl_interface-5.3

CFLAGS += -I$(EI_LIBDIR)/include
LDFLAGS = -L$(EI_LIBDIR)/lib
LDLIBS  = -lei -lpthread

all: erlcast complex.beam

erlcast: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@ $(LDFLAGS) $(LDLIBS)

complex.beam: complex.erl
	erlc complex.erl


clean:
	rm -f *~ *.o erlcast