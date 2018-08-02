gcc -c ptr.c -fpic
gcc -shared -o libptr.so ptr.o
