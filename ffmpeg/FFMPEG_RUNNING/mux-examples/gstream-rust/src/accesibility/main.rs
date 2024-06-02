use {futures::prelude::*, gstreamer::prelude::*};

use {
    futures::executor,
    gstreamer::{BusStream, ElementFactory, MessageView, Pipeline, Sample, State},
    gstreamer_app::{AppSink, AppSrc},
};

fn generate_samples() -> Vec<Sample> {
    let videotestsrc = ElementFactory::make("videotestsrc", None).unwrap();
    let x264enc = ElementFactory::make("x264enc", None).unwrap();
    let appsink = ElementFactory::make("appsink", None).unwrap();

    // videotestsrc.set_property("num-buffers", &200).unwrap();

    let pipeline = Pipeline::new(None);
    pipeline.add(&videotestsrc).unwrap();
    pipeline.add(&x264enc).unwrap();
    pipeline.add(&appsink).unwrap();

}

async fn write_samples(location: &str, samples: Vec<Sample>) {
    let appsrc = ElementFactory::make("appsrc", None).unwrap();
    let h264parse = ElementFactory::make("h264parse", None).unwrap();
    let mp4mux = ElementFactory::make("mp4mux", None).unwrap();
    let filesink = ElementFactory::make("filesink", None).unwrap();

    mp4mux.set_property("faststart", &true).unwrap();
    filesink.set_property("location", &location).unwrap();

    let pipeline = Pipeline::new(None);
    pipeline.add(&appsrc).unwrap();
    pipeline.add(&h264parse).unwrap();
    pipeline.add(&mp4mux).unwrap();
    pipeline.add(&filesink).unwrap();

    appsrc.link(&h264parse).unwrap();
    h264parse.link(&mp4mux).unwrap();
    mp4mux.link(&filesink).unwrap();

    unreachable!()
}

#[test]
fn stress() {
    gstreamer::init().unwrap();
}
