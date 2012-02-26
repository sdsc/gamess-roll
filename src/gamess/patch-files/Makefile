.PHONY: libddivsmp.so
libddivsmp.so: ddivsmp.c
	gcc -fPIC -shared -Wl,-soname,libddivsmp.so,-version-script,symver -o libddivsmp.so ddivsmp.c
	gcc -g -O0 -o libddivsmp.test ddivsmp.c -lc -DCOMPILE_WITH_TEST_PROGRAM
clean:
	rm libddivsmp.so libddivsmp.test
