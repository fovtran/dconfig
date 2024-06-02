$ g++ -lm -DCPU_IS_BIG_ENDIAN=0 -DHAVE_SNDFILE -DHAVE_ALSA -lasound -lsndfile audio_out.c timewarp-file.c
audio_out.c: In function ‘AUDIO_OUT* alsa_open(int, unsigned int)’:
audio_out.c:80:25: error: invalid conversion from ‘void*’ to ‘ALSA_AUDIO_OUT*’ {aka ‘AUDIO_OUT*’} [-fpermissive]
  if ((alsa_out = calloc (1, sizeof (ALSA_AUDIO_OUT))) == NULL)
                  ~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~
audio_out.c: In function ‘AUDIO_OUT* opensoundsys_open(int, int)’:
audio_out.c:338:33: error: invalid conversion from ‘void*’ to ‘OSS_AUDIO_OUT*’ [-fpermissive]
  if ((opensoundsys_out = calloc (1, sizeof (OSS_AUDIO_OUT))) == NULL)
                          ~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~