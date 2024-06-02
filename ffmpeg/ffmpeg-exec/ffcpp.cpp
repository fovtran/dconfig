#include <iostream>
#include <cstdlib>
#include <sstream>
#include <cstring>
#include "libreadtoml.h"

int main(int argc, char *argv[])
{
	StreamParams* rc;
	rc = StreamConf();

	std::cout << "framerate_final" << " " << rc->framerate_final << std::endl;
	std::cout << "stream_target" << " " << rc->stream_target << std::endl;

	std::stringstream stream;    
	stream << "\"/usr/bin/ffmpeg\""
		<< " " // espacio entre args
		<< "-h";
	system(stream.str().c_str());

	return 0;
}