// c++ -lm `pkg-config gstreamer-1.0 --libs --cflags` -DCPU_IS_BIG_ENDIAN=0 -DHAVE_SNDFILE -DHAVE_ALSA -lasound -lsndfile GST_buffering.cpp ^C
// ** (a.out:27801): WARNING **: 05:14:03.181: failed to PAUSE
// $ g++ `pkg-config gstreamer-1.0 --libs --cflags` GST_buffering.cpp 
// ./a.out /usr/lib/lv2/avw.lv2/vco2_cv.ttl 

// GST_DEBUG="*:2" ./a.out file:///../../DOLBY/testtones/79-1khz_108dB-sweep.wav
// GST_DEBUG="*:4" ./a.out file:///../../DOLBY/testtones/79-1khz_108dB-sweep.wav
// cp ../../DOLBY/testtones/75-10khz_84dB_att.wav ~/public_html/NBTEMP/a.wav
// ffmpeg -f lavfi -i "smptebars=duration=25:size=1280x720:rate=30" -vf "drawtext=fontfile=/usr/share/fonts/truetype/DroidSans.ttf: timecode='09\:57\:00\:00': r=25:x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000000@1" -an -y ~/public_html/NBTEMP/out.mkv
// GST_DEBUG_FILE=test.log GST_DEBUG="*:2" ./a.out http://127.0.0.1/~nosat/NBTEMP/out.mkv
// gedit --display=:0.1        --g-fatal-warnings        --gtk-no-debug=FLAGS       --gtk-debug=FLAGS       --gtk-module=MODULE
// $ GTK_DEBUG=geometry gedit
// 
// GTK_DEBUG=plugsocket GST_DEBUG="*:5" ./a.out http://127.0.0.1/~nosat/NBTEMP/out.mkv
/*
Live buffering
In live pipelines we usually introduce some fixed latency between the capture and the playback elements. This latency can be introduced by a queue (such as a jitterbuffer) or by other means (in the audiosink).

Buffering messages can be emitted in those live pipelines as well and serve as an indication to the user of the latency buffering. The application usually does not react to these buffering messages with a state change.
Buffering strategies
What follows are some ideas for implementing different buffering strategies based on the buffering messages and buffering query.
No-rebuffer strategy

We would like to buffer enough data in the pipeline so that playback continues without interruptions. What we need to know to implement this is know the total remaining playback time in the file and the total remaining download time. If the buffering time is less than the playback time, we can start playback without interruptions.
We have all this information available with the DURATION, POSITION and BUFFERING queries. We need to periodically execute the buffering query to get the current buffering status. We also need to have a large enough buffer to hold the complete file, worst case. It is best to use this buffering strategy with download buffering (see Download buffering).
*/
#include <gst/gst.h>

GstState target_state;
static gboolean is_live;
static gboolean is_buffering;

static gboolean buffer_timeout (gpointer data)
{
  // ADDED DIEGO _GOBJECT
  GstElement *pipeline;
  // void* source;
  // source = (GObject*)data;
  const GValue* val = static_cast<GValue*>( data );
  pipeline = static_cast<GstElement*>( g_value_get_object (val) );

  GstQuery *query;
  gboolean busy;
  gint percent;
  gint64 estimated_total;
  gint64 position, duration;
  guint64 play_left;

  query = gst_query_new_buffering (GST_FORMAT_TIME);

  if (!gst_element_query (pipeline, query))
    return TRUE;

  gst_query_parse_buffering_percent (query, &busy, &percent);
  gst_query_parse_buffering_range (query, NULL, NULL, NULL, &estimated_total);

  if (estimated_total == -1)
    estimated_total = 0;

  /* calculate the remaining playback time */
  if (!gst_element_query_position (pipeline, GST_FORMAT_TIME, &position))
    position = -1;
  if (!gst_element_query_duration (pipeline, GST_FORMAT_TIME, &duration))
    duration = -1;
    
  if (duration != -1 && position != -1)
    play_left = GST_TIME_AS_MSECONDS (duration - position);
  else
    play_left = 0;
    
  /* we are buffering or the estimated download time is bigger than the
   * remaining playback time. We keep buffering. */
  is_buffering = (busy || estimated_total * 1.1 > play_left);
  g_message ("play_left %" G_GUINT64_FORMAT", estimated_total %" G_GUINT64_FORMAT ", percent %d", play_left, estimated_total, percent);

  if (!is_buffering)
    gst_element_set_state (pipeline, target_state);
  else
        gst_element_set_state((GstElement*)pipeline, GST_STATE_NULL);

  return is_buffering;
}

static void on_message_buffering (GstBus *bus, GstMessage *message, gpointer user_data)
{
  GstElement* val = static_cast<GstElement*>( user_data );
  GstElement *pipeline = val;
  gint percent;

  g_message("on_message_buffering");
  /* no state management needed for live pipelines */
  if (is_live)
    return;

  gst_message_parse_buffering (message, &percent);
  
  if (percent < 100) {
    /* buffering busy */
    if (!is_buffering) {
      is_buffering = TRUE;
      if (target_state == GST_STATE_PLAYING) {
        /* we were not buffering but PLAYING, PAUSE  the pipeline. */
        gst_element_set_state (pipeline, GST_STATE_PAUSED);

      }
    }
  }
}

static void on_message_async_done (GstBus *bus, GstMessage *message, gpointer user_data)
{
  g_message("on_message_async_done");

  // MOD DIEGO
  GstElement* val = static_cast<GstElement*>( user_data );
  GstElement *pipeline = val;

  if (!is_buffering)
    gst_element_set_state (pipeline, target_state);
  else
    g_timeout_add_seconds (5, buffer_timeout, pipeline);
    //g_timeout_add (500, buffer_timeout, pipeline);
}

gint main (gint   argc,  gchar *argv[])
{
  GstElement *pipeline;
  GMainLoop *loop;
  GstBus *bus;
  GstStateChangeReturn ret;

  /* init GStreamer */
  gst_init (&argc, &argv);
  loop = g_main_loop_new (NULL, FALSE);

  g_message ("Gst Program started\n");

  /* make sure we have a URI */
  if (argc != 2) {
    g_print ("Usage: %s <URI>;\n", argv[0]);
    return -1;
  }

  g_message ("Gst running..\n");
  // setenv("GST_DEBUG","cat:level...", 1);

  /* set up */
  // something like this?
  pipeline = gst_element_factory_make ("playbin", "pipeline");
  g_object_set (G_OBJECT (pipeline), "uri", argv[1], NULL);
  g_object_set (G_OBJECT (pipeline), "flags", 0x697 , NULL);

  bus = gst_pipeline_get_bus (GST_PIPELINE (pipeline));
  gst_bus_add_signal_watch (bus);

  g_signal_connect (bus, "message::buffering",  (GCallback) on_message_buffering, pipeline);
  g_signal_connect (bus, "message::async-done", (GCallback) on_message_async_done, pipeline);
  //g_signal_connect (bus, "message::buffer-timeout", (GCallback) buffer_timeout, pipeline);
  
  gst_object_unref (bus);

  is_buffering = FALSE;
  target_state = GST_STATE_PLAYING;
  ret = gst_element_set_state (pipeline, GST_STATE_PAUSED);

  g_message ("Entering state b..\n");

  switch (ret) {
    case GST_STATE_CHANGE_SUCCESS:
      is_live = FALSE;
      break;

    case GST_STATE_CHANGE_FAILURE:
      // g_message ("failed to PAUSE");
      return -1;

    case GST_STATE_CHANGE_NO_PREROLL:
      is_live = TRUE;
      break;

    default:
      break;
  }

  /* now run */
  g_message("Looping..\n");

  g_main_loop_run (loop);

  /* also clean up */
  gst_element_set_state (pipeline, GST_STATE_NULL);
  gst_object_unref (GST_OBJECT (pipeline));
  g_main_loop_unref (loop);

  return 0;
}

