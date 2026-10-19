use df::tract::{DfParams, DfTract, RuntimeParams};
use ndarray::{ArrayView2, ArrayViewMut2};
use rubato::{FftFixedInOut, Resampler};

type Result<T> = std::result::Result<T, Box<dyn std::error::Error>>;

struct RateAdapter {
    rate: i32,
    up: FftFixedInOut<f32>,
    down: FftFixedInOut<f32>,
    input: Vec<Vec<f32>>,
    high: Vec<Vec<f32>>,
    filtered: Vec<Vec<f32>>,
    output: Vec<Vec<f32>>,
}

impl RateAdapter {
    fn new(rate: usize) -> Result<Self> {
        // В rubato 0.14.1 расчёт FftFixedInOut использует выходную длину
        // (min_chunk_out), несмотря на имя аргумента chunk_size_in.
        let up = FftFixedInOut::new(rate, 48000, 480, 1)?;
        let down = FftFixedInOut::new(48000, rate, rate / 100, 1)?;
        if up.input_frames_next() != rate / 100 || up.output_frames_next() != 480 {
            return Err("Недопустимый размер блока ресэмплера".into());
        }
        Ok(Self {
            rate: rate as i32,
            input: up.input_buffer_allocate(true),
            high: up.output_buffer_allocate(true),
            filtered: down.input_buffer_allocate(true),
            output: down.output_buffer_allocate(true),
            up,
            down,
        })
    }
}

pub struct Processor {
    model: DfTract,
    input: [f32; 480],
    output: [f32; 480],
    rates: Vec<RateAdapter>,
    failed: bool,
}

impl Processor {
    pub fn new() -> Result<Self> {
        let mut params = RuntimeParams::default_with_ch(1);
        // Те же пороги, что у проверенной официальной CLI 0.5.6.
        params.min_db_thresh = -15.;
        params.max_db_erb_thresh = 35.;
        params.max_db_df_thresh = 35.;
        Ok(Self {
            model: DfTract::new(DfParams::default(), &params)?,
            input: [0.; 480],
            output: [0.; 480],
            rates: [8000, 16000, 32000]
                .into_iter()
                .map(RateAdapter::new)
                .collect::<Result<_>>()?,
            failed: false,
        })
    }

    pub fn process(&mut self, samples: &mut [f32], rate: i32) -> Result<()> {
        if self.failed || rate != samples.len() as i32 * 100 {
            self.failed = true;
            return Err("Недопустимый аудиоблок".into());
        }
        let result = self.process_block(samples, rate);
        if result.is_err() {
            self.failed = true;
        }
        result
    }

    fn process_block(&mut self, samples: &mut [f32], rate: i32) -> Result<()> {
        if samples.iter().any(|sample| !sample.is_finite()) {
            return Err("Некорректные аудиосэмплы".into());
        }
        if rate == 48000 {
            for (input, sample) in self.input.iter_mut().zip(samples.iter()) {
                *input = *sample / 32768.;
            }
            self.model.process(
                ArrayView2::from_shape((1, 480), &self.input)?,
                ArrayViewMut2::from_shape((1, 480), &mut self.output)?,
            )?;
            return copy_output(samples, &self.output);
        }
        let adapter = self
            .rates
            .iter_mut()
            .find(|item| item.rate == rate)
            .ok_or("Частота микрофона не поддерживается DeepFilterNet3")?;
        for (input, sample) in adapter.input[0].iter_mut().zip(samples.iter()) {
            *input = *sample / 32768.;
        }
        adapter
            .up
            .process_into_buffer(&adapter.input, &mut adapter.high, None)?;
        self.model.process(
            ArrayView2::from_shape((1, 480), &adapter.high[0])?,
            ArrayViewMut2::from_shape((1, 480), &mut adapter.filtered[0])?,
        )?;
        adapter
            .down
            .process_into_buffer(&adapter.filtered, &mut adapter.output, None)?;
        copy_output(samples, &adapter.output[0])
    }
}

fn copy_output(target: &mut [f32], source: &[f32]) -> Result<()> {
    if source.len() != target.len() || source.iter().any(|value| !value.is_finite()) {
        return Err("Некорректный выход DeepFilterNet3".into());
    }
    for (sample, value) in target.iter_mut().zip(source) {
        *sample = (value * 32768.).clamp(-32768., 32767.);
    }
    Ok(())
}
