mod operations;

use std::ffi::{CString, c_char};

pub fn execute(input: &[u8]) -> Vec<u8> {
    let result = operations::execute(input);
    let value = match result {
        Ok(data) => serde_json::json!({"ok":true,"data":data}),
        Err(error) => serde_json::json!({"ok":false,"error":error.to_string()}),
    };
    value.to_string().into_bytes()
}

/// # Safety
/// Указатель должен ссылаться на length доступных байт. Результат освобождается
/// только space_mls_free. Единственный небезопасный участок — граница Dart FFI.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn space_mls_call(input: *const u8, length: usize) -> *mut c_char {
    let output = std::panic::catch_unwind(|| {
        if input.is_null() || length > 160 * 1024 * 1024 {
            return b"{\"ok\":false,\"error\":\"InvalidInput\"}".to_vec();
        }
        // Вызывающая сторона владеет буфером и не меняет его до возврата.
        execute(unsafe { std::slice::from_raw_parts(input, length) })
    })
    .unwrap_or_else(|_| b"{\"ok\":false,\"error\":\"NativeFailure\"}".to_vec());
    match CString::new(output) {
        Ok(output) => output.into_raw(),
        Err(_) => c"{\"ok\":false,\"error\":\"NativeFailure\"}"
            .to_owned()
            .into_raw(),
    }
}

/// # Safety
/// Передавать только результат space_mls_call и освобождать ровно один раз.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn space_mls_free(output: *mut c_char) {
    if !output.is_null() {
        // Буфер создан CString::into_raw в этой же библиотеке.
        let mut bytes = unsafe { CString::from_raw(output) }.into_bytes();
        bytes.fill(0);
    }
}
