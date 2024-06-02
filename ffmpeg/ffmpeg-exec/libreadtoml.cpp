#include <iostream>
#include <toml++/toml.h>
#include "libreadtoml.h"

using namespace std::string_view_literals;

StreamParams* StreamConf()
{
	 toml::table tbl;
	 std::string source = "streamer_config.toml";
   try
   {
	   tbl = toml::parse_file(source);
   }
   catch (const toml::parse_error& err)
   {
       std::cerr << "Parsing failed:\n" << err << "\n";
       exit(0);
   }   

	std::optional<std::string>      framerate_final = tbl["framerate_final"].value<std::string>();
	std::optional<std::string>      inres = tbl["inres"].value<std::string>();
	std::optional<std::string>      outres = tbl["outres"].value<std::string>();
	std::optional<std::string>      gop = tbl["gop"].value<std::string>();
	std::optional<std::string>      threads = tbl["threads"].value<std::string>();
	std::optional<std::string>      cbr = tbl["cbr"].value<std::string>();
	std::optional<std::string>      quality = tbl["quality"].value<std::string>();

	std::optional<std::string>      audio_srate = tbl["audio"]["audio_srate"].value<std::string>();
	std::optional<std::string>      audio_channels = tbl["audio"]["audio_channels"].value<std::string>();
	std::optional<std::string>      audio_erate = tbl["audio"]["audio_erate"].value<std::string>();
	std::optional<std::string>      audio_dev = tbl["audio"]["audio_dev"].value<std::string>();
	std::optional<std::string>      audio_codec = tbl["audio"]["audio_codec"].value<std::string>();
	std::optional<std::string>      pulseaudio_params = tbl["audio"]["pulseaudio_params"].value<std::string>();

	std::optional<std::string>      screen_i = tbl["screen"]["i"].value<std::string>();
	std::optional<std::string>      screen_hwaccel = tbl["screen"]["hwaccelapi"].value<std::string>();

	std::optional<std::string>      stream_key = tbl["stream"]["stream_key"].value<std::string>();
	std::optional<std::string>      stream_servers = tbl["stream"]["servers"].value<std::string>();
	std::optional<std::string>      stream_videocodec= tbl["stream"]["videocodec"].value<std::string>();
	std::optional<std::string>      stream_target = tbl["stream"]["target"].value<std::string>();
	std::optional<std::string>      stream_target_local = tbl["stream"]["target_local"].value<std::string>();
	std::optional<std::string>      stream_target_null = tbl["stream"]["target_null"].value<std::string>();
	std::optional<std::string>      stream_outfmt = tbl["screen"]["outfmt"].value<std::string>();

	StreamParams *params = new StreamParams;
	params->framerate_final = *framerate_final;
	params->inres = *inres;	
	params->outres = *outres;
	params->gop = *gop;
	params->threads = *threads;
	params->cbr = *cbr;
	params->quality = *quality;

	params->audio_srate = *audio_srate;
	params->audio_channels = *audio_channels;
	params->audio_erate = *audio_erate;
	params->audio_dev = *audio_dev;
	params->audio_codec = *audio_codec;
	params->pulseaudio_params = *pulseaudio_params;

	params->screen_i = *screen_i;
	params->screen_hwaccel = *screen_hwaccel;

	params->stream_key = *stream_key;
	params->stream_servers = *stream_servers;
	params->stream_videocodec = *stream_videocodec;
	params->stream_target = *stream_target;
	params->stream_target_local = *stream_target_local;
	params->stream_target_null = *stream_target_null;
	params->stream_outfmt = *stream_outfmt;
	
   return params;
}
