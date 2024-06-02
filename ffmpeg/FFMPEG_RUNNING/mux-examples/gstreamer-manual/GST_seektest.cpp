// GST_DEBUG="*:2" gst123 http://127.0.0.1/~nosat/NBTEMP/out.mkv
                                                                                                                                                  
/**
 * Author : shubhamr
 * Compile : g++ -g testSeek.cpp -o testSeek `pkg-config --cflags --libs gstreamer-1.0 gstreamer-app-1.0` 
 *
 * Brief Description : Grab raw and decoded data from h264 video after seeking to a particular frame and then 
 *                     create video from raw data and images from decoded data.
 *
 * Stepwise decription of this program:
 * 1. Create a pipeline containing two parallel pipelines 
 * 2. In one part of the pipeline, I am simply parsing the video using h264parse to get raw data.
 * 3. In second part of the pipeline, I am decoding the data using omxh264dec and converting it into Gray.
 * 4. Get preroll buffer from appsink of decoded part of the pipeline to get framerate, width and height.
 *
 * Funcion Description:
 * getRawFrame()     :: Called to pull sample from RAW appsink and write in a .avi file.
 * getDecodedFrame() :: Called to pull sample from DEC appsink and write in a .ppm file.
 * seek()            :: Called to seek to the given frame number.
 */

#include <iostream>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unistd.h>
#include <fstream>

#include <gst/gst.h>
#include <gst/app/gstappsink.h>

using namespace std;

//Global variables
GstElement *g_gstPipeline, *g_gstSinkRaw, *g_gstSinkDec;

int g_imgWidth, g_imgHeight;

int64_t g_timeBase;



//pull data from appSinkRaw
int getRawFrame(unsigned char *data)
{
  int frameSize = -1;
  GstSample *sample = gst_app_sink_pull_sample(GST_APP_SINK(g_gstSinkRaw));

  GstBuffer *buffer = gst_sample_get_buffer (sample);
  if (!buffer)
  {
    cout << "GStreamer :: ERROR :: Failed to pull raw buffer." << endl;
    return -1;
  }

  GstMapInfo map;
  if (gst_buffer_map (buffer, &map, GST_MAP_READ)) 
  {
    if (map.data && data)
    {
      memcpy (data, map.data, map.size);
      frameSize = map.size;       
      cout << "raw pts :: " << buffer->pts << endl;
      cout << "raw dts :: " << buffer->dts << endl;

    }
  }

  gst_buffer_unmap(buffer, &map);
  // gst_buffer_unref(buffer);
  //usleep(20000);
  gst_sample_unref (sample);

  return frameSize;
}

//pull data from appSinkDec
int getDecodedFrame(unsigned char *data)
{
  int frameSize = -1;
  GstSample *sample = gst_app_sink_pull_sample(GST_APP_SINK(g_gstSinkDec));

  GstBuffer *buffer = gst_sample_get_buffer (sample);
  if (!buffer)
  {
    cout << "GStreamer :: ERROR :: Failed to pull raw buffer." << endl;
    return -1;
  }

  GstMapInfo map;
  if (gst_buffer_map (buffer, &map, GST_MAP_READ)) 
  {
    if (map.data && data)
    {
      memcpy (data, map.data, map.size);
      frameSize = map.size; 
    }
  }

  gst_buffer_unmap(buffer, &map);
  // gst_buffer_unref(buffer);
  //usleep(20000);
  gst_sample_unref (sample);

  return frameSize;
}


int seek(int frameNum)
{   
  //Converting frameNum to time
  int64_t seekPos = g_timeBase * frameNum;

  cout << "seekPos :: " << seekPos << endl;

  if (!gst_element_seek (g_gstPipeline, 1.0, GST_FORMAT_TIME, (GstSeekFlags)(GST_SEEK_FLAG_FLUSH | GST_SEEK_FLAG_KEY_UNIT | GST_SEEK_FLAG_SEGMENT), GST_SEEK_TYPE_SET, seekPos, GST_SEEK_TYPE_NONE, -1))
  {
    cout << "GStreamer :: ERROR :: Seeking Failed." << endl;
    return -1;
  }

  GstStateChangeReturn ret = gst_element_get_state (g_gstPipeline, NULL, NULL, 5 * GST_SECOND);
  if (ret == GST_STATE_CHANGE_FAILURE)
  {
    cout << "GStreamer :: ERROR :: Failed to play the stream after Seeking." << endl;
    return -1;
  }

  cout << "GStreamer :: Seek successful.\n";
  return 0;
}


int main(int argc, char **argv)
{
  if(argc != 2)
  {
    cout << "Usage :: " << argv[0] << " AviFilePath \n";
    return -1;
  }

  gst_init (NULL, NULL);

  string filePath(argv[1]);

  //Creating pipeline
  gchar *descr = g_strdup_printf ("filesrc location=%s ! avidemux ! video/x-h264 ! tee name=t ! queue ! h264parse ! video/x-h264, stream-format=byte-stream, alignment=au ! appsink name=sinkRaw sync=false max-buffers=50 drop=false t. ! queue ! h264parse ! omxh264dec ! nvvidconv ! video/x-raw, format=GRAY8 ! appsink name=sinkDec sync=false max-buffers=50 drop=true", filePath.c_str());
 
  //This pipeline works fine in seeking. In this i am using avdec_h264 instead of omxh264dec
  //gchar *descr = g_strdup_printf ("filesrc location=%s ! avidemux ! video/x-h264 ! tee name=t ! queue ! h264parse ! video/x-h264, stream-format=byte-stream, alignment=au ! appsink name=sinkRaw sync=false max-buffers=50 drop=false t. ! queue ! h264parse ! avdec_h264 ! videoconvert ! video/x-raw, format=GRAY8 ! appsink name=sinkDec sync=false max-buffers=50 drop=true", filePath.c_str());

  GError *error = NULL;

  g_gstPipeline = gst_parse_launch (descr, &error);

  if (error != NULL) 
  {
    g_print ("GStreamer :: ERROR :: Could not construct pipeline: %s\n", error->message);
    g_clear_error (&error);
    exit (-1);
  }

  //Create the elements g_gstSinkRaw and g_gstSinkDec from the pipeline.
  g_gstSinkRaw = gst_bin_get_by_name (GST_BIN (g_gstPipeline), "sinkRaw");
  if ( !g_gstSinkRaw )
  {
    g_print ("GStreamer :: ERROR :: No element named sinkRaw found in the pipeline.\n");
    exit (-1);
  }

  g_gstSinkDec = gst_bin_get_by_name (GST_BIN (g_gstPipeline), "sinkDec");
  if ( !g_gstSinkDec )
  {
    g_print ("GStreamer :: ERROR :: No element named sinkDec found in the pipeline.\n");
    exit (-1);
  }

  //setting the pipeline to play.
  GstStateChangeReturn ret = gst_element_set_state (g_gstPipeline, GST_STATE_PLAYING);

  switch (ret) 
  {
    case GST_STATE_CHANGE_FAILURE:
      g_print ("GStreamer :: ERROR :: failed to play the stream\n");
      exit (-1);

    case GST_STATE_CHANGE_NO_PREROLL:
      g_print ("GStreamer :: ERROR :: Element successfully changed its state but is not able to provide data\n");
      exit (-1);

    default:
      break;
  }


  //Checking if the pipeline state is changed successfully.
  ret = gst_element_get_state (g_gstPipeline, NULL, NULL, 5 * GST_SECOND);
  if (ret == GST_STATE_CHANGE_FAILURE) 
  {
    g_print ("GStreamer :: ERROR :: failed to play the stream\n");
    exit (-1);
  }

  //get the preroll buffer from decoded appsink
  GstSample *sampleDec = NULL;
  g_signal_emit_by_name (g_gstSinkDec, "pull-preroll", &sampleDec, NULL);

  if (sampleDec)
  {
    GstCaps *caps = gst_sample_get_caps (sampleDec);
    if (!caps) 
    {
      g_print ("GStreamer :: ERROR :: could not get decoded snapshot format\n");
      exit (-1);
    }

    GstStructure *s = gst_caps_get_structure (caps, 0);

    // Get the final caps on the buffer to get the size and framerate
    // framerate is required to convert the requested frame number in seek function to time 
    gboolean res;
    res = gst_structure_get_int (s, "width", &g_imgWidth);
    res |= gst_structure_get_int (s, "height", &g_imgHeight);

    const GValue *val = gst_structure_get_value (s, "framerate");
    if (val) 
    {
      gint fpsNum = gst_value_get_fraction_numerator (val);
      gint fpsDen = gst_value_get_fraction_denominator (val);
      cout << "GStreamer :: ******* fps " << fpsNum << " " << fpsDen << endl;

      g_timeBase = ( (fpsDen) * GST_SECOND ) / fpsNum * 2; //for h264 multiplying by 2
    }
    if (!res) 
    {
      g_print ("GStreamer :: ERROR :: could not get decoded snapshot dimension\n");
      exit (-1);
    }
    gst_sample_unref (sampleDec);
  } 
  else 
  {
    g_print ("GStreamer :: ERROR :: could not make decoded snapshot\n");
    exit(-1);
  }

  //Allocate memory for raw and decoded data
  unsigned char *dataRaw = new unsigned char[g_imgWidth*g_imgHeight];
  unsigned char *dataDec = new unsigned char[g_imgWidth*g_imgHeight];


  //Creating object of ofstream to write the video file using raw data.
  ofstream vidFile("output.avi", ios::binary);

  //Creating a loop in which I call functions getRawFrame and getDecodedFrame and correspondingly write data to video file and image file.
  //Image is written for each tenth iteration.
  //I am also calling seek function at each iteration just to check at which frame seeking is causing the pipeline to freeze.
  int i = 0;
  while(1)
  {
    int frameSizeRaw = getRawFrame(dataRaw);
    int frameSizeDec = getDecodedFrame(dataDec);
    cout << "FrameNum :: " << i << " Raw Frame size :: " << frameSizeRaw << endl;
    cout << "FrameNum :: " << i << " Dec Frame size :: " << frameSizeDec << endl;

    //write to .avi file
    vidFile.write(reinterpret_cast<const char*> (dataRaw), frameSizeRaw);

    //save image to ppm
    if(i % 10 == 0)
    {
      char loc[512];
      sprintf(loc, "dump/img%04d.ppm", i);

      ofstream imgfile (loc, ios::binary);  
      imgfile << "P5" << endl;
      imgfile << g_imgWidth << " " << g_imgHeight << endl;
      imgfile << 255 << endl;
      imgfile.write(reinterpret_cast<const char*> (dataDec), frameSizeDec);
      imgfile.close();
    }

    // PROBLEM ::
    // Pipeline freezes at seek(12)
    //  
    // set log level
    // export GST_DEBUG=0,videodecoder:6
    //
    // Possible issue : While seeking to a non key frame, the deocder keeps on storing the frames until a keyframe is found as depicted from log:
    // videodecoder gstvideodecoder.c:3321:gst_video_decoder_decode_frame:<omxh264dec-omxh264dec0> decoder frame list getting long: 26 frames,possible internal leaking?    
    seek(i);

    i++ ;

    if(frameSizeRaw < 0)
      break;
  }

  //Cleanup and exit
  delete[] dataRaw;
  delete[] dataDec;
  vidFile.close();
  gst_element_set_state (g_gstPipeline, GST_STATE_NULL);
  gst_object_unref (g_gstPipeline);

  return 0;
}