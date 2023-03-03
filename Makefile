build : buildlibs buildsrc
buildsrc :
	haxe Makefile.hxml
buildin :
	gcc lib/in.c -fPIC -shared -lneko -o lib/in.so
	mv lib/in.so lib/in.ndll
buildlibs: buildin