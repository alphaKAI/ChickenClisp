gcc -c str.c -fpic
gcc -shared -o libstr.so str.o
