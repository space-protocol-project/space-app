mod session;
#[cfg(test)] mod tests;

use base64::{Engine, engine::general_purpose::STANDARD};
use serde::Deserialize;
use serde_json::{Value, json};
use session::{Result, Session};
use std::{collections::BTreeMap, ffi::{CString,c_char}, sync::{Mutex,OnceLock}, time::{Duration,Instant}};
use zeroize::Zeroize;

#[derive(Deserialize)]
#[serde(tag="op", rename_all="snake_case", deny_unknown_fields)]
enum Request {
    Create {initiator:bool, context:String, expected:Option<String>},
    WriteHandshake {handle:u64},
    ReadHandshake {handle:u64,data:String},
    Confirm {handle:u64,sas:String},
    Confirmation {handle:u64},
    ReceiveConfirmation {handle:u64,data:String},
    Seal {handle:u64,data:String},
    Open {handle:u64,frames:Vec<String>},
    Receipt {handle:u64},
    ReceiveReceipt {handle:u64,data:String},
    Close {handle:u64},
}

struct Entry {created:Instant, session:Session}
#[derive(Default)]
struct Registry {next:u64, entries:BTreeMap<u64,Entry>}
static REGISTRY: OnceLock<Mutex<Registry>> = OnceLock::new();

fn decode(value:&str, max:usize) -> Result<Vec<u8>> {
    if value.len()>max.div_ceil(3)*4 {return Err("length")}
    let data=STANDARD.decode(value).map_err(|_| "encoding")?;
    if data.len()>max {return Err("length")}; Ok(data)
}

fn operate(session:&mut Session, request:Request) -> Result<Value> {
    match request {
        Request::WriteHandshake{..} => {let data=session.write_handshake()?;Ok(json!({"data":STANDARD.encode(data),"sas":session.sas}))},
        Request::ReadHandshake{data,..} => {session.read_handshake(&decode(&data,512)?)?;Ok(json!({"sas":session.sas}))},
        Request::Confirm{sas,..} => {session.confirm(&sas)?;Ok(json!({}))},
        Request::Confirmation{..} => Ok(json!({"data":STANDARD.encode(session.confirmation()?)})),
        Request::ReceiveConfirmation{data,..} => {session.receive_confirmation(&decode(&data,256)?)?;Ok(json!({}))},
        Request::Seal{data,..} => {
            let plain=zeroize::Zeroizing::new(decode(&data,session::MAX_PLAIN)?);
            let frames=session.seal(&plain)?.into_iter().map(|v|STANDARD.encode(v)).collect::<Vec<_>>();
            Ok(json!({"frames":frames}))
        },
        Request::Open{frames,..} => {
            if frames.len()>71 {return Err("length")}
            let frames=frames.iter().map(|s|decode(s,session::CHUNK+16)).collect::<Result<Vec<_>>>()?;
            Ok(json!({"data":STANDARD.encode(session.open(&frames)?)}))
        },
        Request::Receipt{..} => Ok(json!({"data":STANDARD.encode(session.receipt()?)})),
        Request::ReceiveReceipt{data,..} => {session.receive_receipt(&decode(&data,256)?)?;Ok(json!({}))},
        _ => Err("state"),
    }
}

fn handle_of(request:&Request) -> Result<u64> {
    match request {
        Request::WriteHandshake{handle}|Request::ReadHandshake{handle,..}|Request::Confirm{handle,..}|
        Request::Confirmation{handle}|Request::ReceiveConfirmation{handle,..}|Request::Seal{handle,..}|
        Request::Open{handle,..}|Request::Receipt{handle}|Request::ReceiveReceipt{handle,..}|Request::Close{handle} => Ok(*handle),
        Request::Create{..}=>Err("state"),
    }
}

fn execute(input:&[u8]) -> Result<Value> {
    if input.len()>8*1024*1024 {return Err("length")}
    let request:Request=serde_json::from_slice(input).map_err(|_| "input")?;
    let mut registry=REGISTRY.get_or_init(||Mutex::new(Registry::default())).lock().map_err(|_| "nativeState")?;
    registry.entries.retain(|_,e|e.created.elapsed()<Duration::from_secs(300));
    if let Request::Create{initiator,context,expected}=request {
        if registry.entries.len()>=32 {return Err("capacity")}
        let expected=expected.map(|s|decode(&s,32)).transpose()?;
        let (session,public)=Session::new(initiator,context.as_bytes(),expected)?;
        registry.next=registry.next.checked_add(1).filter(|v|*v<9_007_199_254_740_991).ok_or("capacity")?;
        let handle=registry.next;registry.entries.insert(handle,Entry{created:Instant::now(),session});
        return Ok(json!({"handle":handle,"public":STANDARD.encode(public)}))
    }
    let handle=handle_of(&request)?;
    let mut entry=registry.entries.remove(&handle).ok_or("expired")?;
    if matches!(request,Request::Close{..}) {return Ok(json!({}))}
    let output=operate(&mut entry.session,request)?;
    registry.entries.insert(handle,entry); Ok(output)
}

/// # Safety
/// Указатель принадлежит вызывающему коду и содержит length доступных байт.
/// Результат освобождается ровно один раз через space_directory_noise_free.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn space_directory_noise_call(input:*const u8,length:usize)->*mut c_char {
    let output=std::panic::catch_unwind(|| {
        if input.is_null() || length>8*1024*1024 {return json!({"ok":false,"error":"input"})}
        match execute(unsafe {std::slice::from_raw_parts(input,length)}) {
            Ok(data)=>json!({"ok":true,"data":data}),Err(error)=>json!({"ok":false,"error":error}),
        }
    }).unwrap_or_else(|_|json!({"ok":false,"error":"nativeState"}));
    CString::new(output.to_string()).map(CString::into_raw).unwrap_or(std::ptr::null_mut())
}

/// # Safety
/// Принимается только ещё не освобождённый результат space_directory_noise_call.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn space_directory_noise_free(output:*mut c_char) {
    if !output.is_null() {let mut bytes=unsafe {CString::from_raw(output)}.into_bytes_with_nul();bytes.zeroize();}
}
