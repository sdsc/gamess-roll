#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
/****************************************************************************/
#include <sched.h>
#include <string.h>
#include <sys/utsname.h>
#define DEFAULT_NODE_SIZE 8
int gethostname(char *name, size_t len)
{
int i;
int node_size = DEFAULT_NODE_SIZE;
cpu_set_t aff;
struct utsname utsbuf;
size_t utslen;
if (uname(&utsbuf))
return -1;
utslen = strlen(utsbuf.nodename);
memcpy (name, utsbuf.nodename, len-1 < utslen ? len : utslen+1);
if (utslen > len-1)
return -1;
if (len != 96) return 0;
if (getenv("LOCAL_NODE_SIZE"))
if (sscanf(getenv("LOCAL_NODE_SIZE"),"%d",&node_size) != 1)
node_size = DEFAULT_NODE_SIZE;
if (node_size <= 0)
node_size = DEFAULT_NODE_SIZE;
CPU_ZERO(&aff);
sched_getaffinity(getpid(), sizeof(aff), &aff);
for (i = 0; i < sizeof(aff)*8; i++)
if (CPU_ISSET(i, &aff))
break;
if (i < sizeof(aff)*8 && strlen(name)+5 < len)
sprintf(name+strlen(name),":%d",i/node_size);
return 0;
}
/****************************************************************************/
void __attribute__ ((constructor))
my_init(void)
{
}
void __attribute__ ((destructor))
my_fini(void)
{
}
#ifdef COMPILE_WITH_TEST_PROGRAM
main()
{
char buf[100];
gethostname(buf,100);
printf("Test (ignored) HOSTNAME=%s\n",buf);
gethostname(buf,96);
printf("Test (enabled) HOSTNAME=%s\n",buf);
}
#endif
