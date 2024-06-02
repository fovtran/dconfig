
/*
These are the dependencies I've used:

futures = "0.3.1"
gstreamer = "0.15.1"
gstreamer-app = "0.15.0"
*/
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

    videotestsrc.set_property("num-buffers", &200).unwrap();

    let pipeline = Pipeline::new(None);
    pipeline.add(&videotestsrc).unwrap();
    pipeline.add(&x264enc).unwrap();
    pipeline.add(&appsink).unwrap();

    videotestsrc.link(&x264enc).unwrap();
    x264enc.link(&appsink).unwrap();

    let app_sink = appsink.dynamic_cast::<AppSink>().unwrap();

    pipeline.set_state(State::Playing).unwrap();

    let mut samples = Vec::new();

    while let Ok(sample) = app_sink.pull_sample() {
        samples.push(sample);
    }

    pipeline.set_state(State::Null).unwrap();

    samples
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

    let app_src = appsrc.dynamic_cast::<AppSrc>().unwrap();

    for sample in samples {
        app_src.push_sample(&sample).unwrap();
    }

    app_src.end_of_stream().unwrap();

    let bus = pipeline.get_bus().unwrap();
    let mut bus_stream = BusStream::new(&bus);

    pipeline.set_state(State::Playing).unwrap();

    while let Some(message) = bus_stream.next().await {
        println!("new message [{:?}]", message.get_type());

        match message.view() {
            MessageView::Eos(..) => {
                pipeline.set_state(State::Null).unwrap();
                return;
            }
            MessageView::Error(..) => {
                pipeline.set_state(State::Null).unwrap();
                panic!("error");
            }
            _ => (),
        }
    }

    unreachable!()
}

#[test]
fn stress() {
    gstreamer::init().unwrap();

    let samples = generate_samples();

    for index in 0.. {
        println!("Iteration {} began.", index);

        let file_path = "/home/valmirpretto/video.mp4";
        let samples = samples.iter().cloned().collect();
        executor::block_on(write_samples(file_path, samples));

        println!("Iteration {} ended.", index);
    }
}
