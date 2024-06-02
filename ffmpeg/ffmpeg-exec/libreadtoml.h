#ifndef _LIBREADTOML_H
#define _LIBREADTOML_H
#include <iostream>

typedef struct StreamParams
{
	std::string framerate_final;
	std::string inres;
	std::string outres;
	std::string gop;
	std::string threads;
	std::string cbr;
	std::string quality;
	std::string audio_srate;
	std::string audio_channels;
	std::string audio_erate;
	std::string audio_dev;
	std::string audio_codec;
	std::string pulseaudio_params;
	
	std::string screen_i;
	std::string screen_hwaccel;

	std::string stream_key;
	std::string stream_servers;
	std::string stream_videocodec;
	std::string stream_target;
	std::string stream_target_local;
	std::string stream_target_null;
	std::string stream_outfmt;
}StreamParams;

StreamParams* StreamConf();

#endif