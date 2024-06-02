// g++ `pkg-config gstreamer-1.0 gstreamer-app-1.0 --libs --cflags` -lpthread GST_eos.cpp 
// ./a.out http://127.0.0.1/~nosat/NBTEMP/out.mkv
// GST_DEBUG="*:2" gst123 http://127.0.0.1/~nosat/NBTEMP/out.mkv
                                                                                                                                                  
                                                                                                                                                  
#include <cstdlib>
#include <gst/gst.h>
#include <gst/gstinfo.h>
#include <gst/app/gstappsink.h>
#include <glib-unix.h>
#include <dlfcn.h>

#include <iostream>
#include <sstream>
#include <thread>

using namespace std;

#define USE(x) ((void)(x))

static GstPipeline *gst_pipeline = nullptr;
static string launch_string;
static int frame_count = 0;
//static int sleep_count = 0;
static int eos = 0;

static void appsink_eos(GstAppSink * appsink, gpointer user_data)
{
    printf("app sink receive eos\n");
    eos = 1;
//    g_main_loop_quit (hpipe->loop);
}

static GstFlowReturn new_buffer(GstAppSink *appsink, gpointer user_data)
{
    GstSample *sample = NULL;

    g_signal_emit_by_name (appsink, "pull-sample", &sample,NULL);

    if (sample)
    {
        GstBuffer *buffer = NULL;
        GstCaps   *caps   = NULL;
        GstMapInfo map    = {0};

        caps = gst_sample_get_caps (sample);
        if (!caps)
        {
            printf("could not get snapshot format\n");
        }
        gst_caps_get_structure (caps, 0);
        buffer = gst_sample_get_buffer (sample);
        gst_buffer_map (buffer, &map, GST_MAP_READ);

        printf("map.size = %lu, pts: %lu \n", map.size, buffer->pts);
        frame_count++;

        gst_buffer_unmap(buffer, &map);

        gst_sample_unref (sample);
    }
    else
    {
        g_print ("could not make snapshot\n");
    }

    return GST_FLOW_OK;
}

int main(int argc, char** argv) {
    USE(argc);
    USE(argv);

    gst_init (&argc, &argv);

    GMainLoop *main_loop;
    main_loop = g_main_loop_new (NULL, FALSE);
    ostringstream launch_stream;
    int w = 1920;
    int h = 816;
    //GstAppSinkCallbacks callbacks = {appsink_eos, NULL, new_buffer};

/*
    launch_stream
//    << "nvcamerasrc ! "
//    << "video/x-raw(memory:NVMM), width="<< w <<", height="<< h <<", framerate=30/1 ! " 
    << "filesrc location=" << argv[1] << " ! qtdemux ! h264parse ! avdec_h264 ! "
    << "tee name=nt "
    << "nt. ! queue ! nvvidconv ! "
    << "video/x-raw, format=I420, width="<< w <<", height="<< h <<" ! "
    << "appsink name=mysink "
    << "nt. ! queue ! nvoverlaysink ";
    */
    launch_stream
//    << "nvcamerasrc ! "
//    << "video/x-raw(memory:NVMM), width="<< w <<", height="<< h <<", framerate=30/1 ! " 
    << "filesrc location=" << argv[1] << " ! h264parse ! avdec_h264 ! "
    << "tee name=nt "
    << "nt. ! queue ! "
//    << "video/x-raw, format=I420, width="<< w <<", height="<< h <<" ! "
    << "appsink name=mysink "
    << "queue ";

    launch_string = launch_stream.str();

    g_print("Using launch string: %s\n", launch_string.c_str());

    GError *error = nullptr;
    gst_pipeline  = (GstPipeline*) gst_parse_launch(launch_string.c_str(), &error);

    if (gst_pipeline == nullptr) {
        g_print( "Failed to parse launch: %s\n", error->message);
        return -1;
    }
    if(error) g_error_free(error);

    GstElement *appsink_ = gst_bin_get_by_name(GST_BIN(gst_pipeline), "mysink");
    //gst_app_sink_set_callbacks (GST_APP_SINK(appsink_), &callbacks, NULL, NULL);

    gst_element_set_state((GstElement*)gst_pipeline, GST_STATE_PLAYING); 

    /*while (eos == 0) {
        sleep(1);
        sleep_count++;
    }*/
    sleep(3);
    guint64 index = 1;
    guint64 seekPos;
    for (index=1; index < 100; index ++) {
        seekPos = (index%25)*1000000000;
		//seekPos = (index%25)*1;
        printf("[%ld]seek to %ld \n", index, seekPos);
        gst_element_seek ((GstElement*)gst_pipeline, 1.0, GST_FORMAT_TIME, (GstSeekFlags)(GST_SEEK_FLAG_FLUSH | GST_SEEK_FLAG_KEY_UNIT | GST_SEEK_FLAG_SEGMENT), GST_SEEK_TYPE_SET, seekPos, GST_SEEK_TYPE_NONE, -1);

        GstStateChangeReturn ret = gst_element_get_state ((GstElement*)gst_pipeline, NULL, NULL, 5 * GST_SECOND);
        if (ret == GST_STATE_CHANGE_FAILURE)
        {
          printf("seek failed \n");
          break;
        }
        sleep(1);
    }
    sleep(3);
    //sleep(90);
    //g_main_loop_run (main_loop);

    gst_element_set_state((GstElement*)gst_pipeline, GST_STATE_NULL);
    gst_object_unref(GST_OBJECT(gst_pipeline));
    g_main_loop_unref(main_loop);

    g_print("going to exit \n");
    return 0;
}