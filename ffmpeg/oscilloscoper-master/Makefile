oscilloscoper.exe: src/*.cpp src/*.hpp
	g++ -O3 -o oscilloscoper.exe src/*.cpp src/DspFilters/*.cpp -Isrc -I. -I/usr/include/SDL2 -lSDL2main -lSDL2 -D__STDC_CONSTANT_MACROS -lavcodec -lavutil -lavformat -lavfilter -lavdevice -lswscale -s
