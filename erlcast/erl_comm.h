#ifndef ERL_COMM_H
#define ERL_COMM_H

#include <stdio.h>
#include <unistd.h>

/* signed char to match declarations in ei.h */
typedef char byte;

int read_cmd(byte *buf);
int write_cmd(byte *buf, int len);

#endif
