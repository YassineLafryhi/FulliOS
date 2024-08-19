use std::ffi::{CStr, c_char};

#[no_mangle]
pub extern "C" fn count_words(text: *const c_char) -> usize {
    let c_str = unsafe { CStr::from_ptr(text) };
    let rust_str = c_str.to_str().unwrap_or("");
    rust_str.split_whitespace().count()
}

#[no_mangle]
pub extern "C" fn count_characters(text: *const c_char) -> usize {
    let c_str = unsafe { CStr::from_ptr(text) };
    let rust_str = c_str.to_str().unwrap_or("");
    rust_str.chars().count()
}

#[no_mangle]
pub extern "C" fn simple_sentiment_analysis(text: *const c_char) -> f64 {
    let c_str = unsafe { CStr::from_ptr(text) };
    let rust_str = c_str.to_str().unwrap_or("");
    
    let positive_words = ["good", "great", "excellent", "happy", "wonderful"];
    let negative_words = ["bad", "awful", "terrible", "sad", "horrible"];
    
    let words: Vec<&str> = rust_str.split_whitespace().collect();
    let total_words = words.len() as f64;
    
    let positive_count = words.iter().filter(|&word| positive_words.contains(word)).count() as f64;
    let negative_count = words.iter().filter(|&word| negative_words.contains(word)).count() as f64;
    
    (positive_count - negative_count) / total_words
}
