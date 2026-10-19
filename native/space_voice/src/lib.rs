//! Модель создаётся вне аудиопотока; обработчик получает только блоки по 10 мс.
#[cfg(not(target_os = "android"))]
mod processor;
#[cfg(not(target_os = "android"))]
mod worker;

use std::ffi::c_void;
#[cfg(not(target_os = "android"))]
use worker::Worker;

#[unsafe(no_mangle)]
pub extern "C" fn space_voice_create() -> *mut c_void {
    #[cfg(not(target_os = "android"))]
    {
        match std::panic::catch_unwind(Worker::new) {
            Ok(Ok(state)) => Box::into_raw(Box::new(state)).cast(),
            Ok(Err(error)) => {
                eprintln!("DeepFilterNet3 initialization failed: {error:?}");
                std::ptr::null_mut()
            }
            Err(_) => std::ptr::null_mut(),
        }
    }
    #[cfg(target_os = "android")]
    std::ptr::null_mut()
}

/// Контекст принадлежит одному захвату. Вызывающая сторона сериализует process/free.
/// # Safety
/// state — результат create; samples содержит frames изменяемых FloatS16-сэмплов.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn space_voice_process(
    state: *mut c_void,
    samples: *mut f32,
    frames: i32,
    rate: i32,
) -> i32 {
    if state.is_null() || samples.is_null() || frames <= 0 || frames > 480 {
        return 0;
    }
    #[cfg(not(target_os = "android"))]
    {
        let buffer = unsafe { std::slice::from_raw_parts_mut(samples, frames as usize) };
        let processor = unsafe { &mut *state.cast::<Worker>() };
        let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            processor.process(buffer, rate)
        }));
        if matches!(result, Ok(Ok(()))) {
            return 1;
        }
        buffer.fill(0.);
    }
    0
}

/// # Safety
/// state создан create, отсоединён от callback и освобождается ровно один раз.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn space_voice_free(state: *mut c_void) {
    #[cfg(not(target_os = "android"))]
    if !state.is_null() {
        drop(unsafe { Box::from_raw(state.cast::<Worker>()) });
    }
}

#[cfg(all(test, not(target_os = "android")))]
mod tests {
    use super::*;

    #[test]
    fn validates_frames_and_stops_after_invalid_audio() {
        // Создание выполняет рабочий isolate, использование — аудиопоток.
        fn assert_send<T: Send>() {}
        assert_send::<Worker>();
        let state = space_voice_create();
        assert!(!state.is_null());
        let mut samples = [f32::NAN; 480];
        unsafe {
            assert_eq!(
                space_voice_process(std::ptr::null_mut(), samples.as_mut_ptr(), 480, 48000),
                0
            );
            assert_eq!(
                space_voice_process(state, samples.as_mut_ptr(), 480, 48000),
                0
            );
            assert!(samples.iter().all(|value| *value == 0.));
            assert_eq!(
                space_voice_process(state, samples.as_mut_ptr(), 480, 48000),
                0
            );
            space_voice_free(state);
        }
    }

    #[test]
    fn processes_supported_capture_rates_without_nan_or_clipping() {
        for rate in [8000, 16000, 32000, 48000] {
            let state = space_voice_create();
            assert!(!state.is_null());
            let mut samples = vec![0.; rate / 100];
            let length = samples.len();
            for frame in 0..60 {
                for (i, value) in samples.iter_mut().enumerate() {
                    *value = ((frame * length + i) as f32 * 0.1).sin() * 8000.;
                }
                unsafe {
                    assert_eq!(
                        space_voice_process(
                            state,
                            samples.as_mut_ptr(),
                            samples.len() as i32,
                            rate as i32
                        ),
                        1
                    );
                }
                assert!(samples.iter().all(|v| v.is_finite() && v.abs() <= 32768.));
            }
            unsafe {
                space_voice_free(state);
            }
        }
    }
}
