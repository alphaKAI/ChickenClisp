gcc -c sq.c -fpic
gcc -shared -o libsq.so sq.o
