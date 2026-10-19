use crate::processor::Processor;
use std::sync::mpsc::{Receiver, SyncSender, sync_channel};
use std::thread::{self, JoinHandle};

struct Frame {
    samples: [f32; 480],
    frames: usize,
    rate: i32,
    valid: bool,
}

// Tract содержит Rc и состояние операторов без Send. Модель создаётся,
// используется и уничтожается строго на одном собственном потоке.
pub struct Worker {
    input: Option<SyncSender<Frame>>,
    output: Receiver<Frame>,
    thread: Option<JoinHandle<()>>,
}

impl Worker {
    pub fn new() -> Result<Self, String> {
        let (input, requests) = sync_channel::<Frame>(1);
        let (replies, output) = sync_channel(1);
        let (ready, initialized) = sync_channel(1);
        let thread = thread::Builder::new()
            .name("space-deepfilter".into())
            .spawn(move || {
                let Ok(Ok(mut model)) = std::panic::catch_unwind(Processor::new) else {
                    return;
                };
                if ready.send(()).is_err() {
                    return;
                }
                while let Ok(mut frame) = requests.recv() {
                    let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                        model.process(&mut frame.samples[..frame.frames], frame.rate)
                    }));
                    frame.valid = matches!(result, Ok(Ok(())));
                    let valid = frame.valid;
                    if replies.send(frame).is_err() || !valid {
                        break;
                    }
                }
            })
            .map_err(|error| error.to_string())?;
        if initialized.recv().is_err() {
            let _ = thread.join();
            return Err("Не удалось создать модель DeepFilterNet3".into());
        }
        Ok(Self {
            input: Some(input),
            output,
            thread: Some(thread),
        })
    }

    pub fn process(&mut self, samples: &mut [f32], rate: i32) -> Result<(), ()> {
        let mut frame = Frame {
            samples: [0.; 480],
            frames: samples.len(),
            rate,
            valid: false,
        };
        frame.samples[..samples.len()].copy_from_slice(samples);
        self.input.as_ref().ok_or(())?.send(frame).map_err(|_| ())?;
        let result = self.output.recv().map_err(|_| ())?;
        if !result.valid {
            return Err(());
        }
        samples.copy_from_slice(&result.samples[..samples.len()]);
        Ok(())
    }
}

impl Drop for Worker {
    fn drop(&mut self) {
        drop(self.input.take());
        if let Some(thread) = self.thread.take() {
            let _ = thread.join();
        }
    }
}
