# Systems Programming with Rust: A Beginner's Guide

## Table of Contents
1. [Introduction to Systems Programming](#introduction-to-systems-programming)
2. [Memory Management](#memory-management)
3. [Ownership and Borrowing](#ownership-and-borrowing)
4. [Data Representation](#data-representation)
5. [Concurrency and Parallelism](#concurrency-and-parallelism)
6. [Direct Hardware Access](#direct-hardware-access)
7. [Error Handling for Systems Programming](#error-handling-for-systems-programming)
8. [File Systems and I/O](#file-systems-and-io)
9. [Networking Fundamentals](#networking-fundamentals)
10. [Process Management](#process-management)

## Introduction to Systems Programming

Systems programming involves creating software that serves as infrastructure for other software. Unlike application programming that focuses on end-user functionality, systems programming deals with managing computer hardware resources, implementing operating systems, device drivers, firmware, and other low-level components.
Systems programming is the practice of writing software that provides services to a computer's hardware and other software, rather than directly to users. It focuses on creating reliable, efficient, and often resource-constrained software that interfaces closely with hardware.

Systems programming typically includes:
- Operating systems
- Device drivers
- Embedded systems
- Compilers and interpreters
- Database engines
- Game engines
- Networking services
- File systems

### Key Characteristics

- **Performance-critical**: Systems code often needs to be highly optimized
- **Resource-constrained**: Works with limited memory, CPU, or other resources
- **Hardware interaction**: Directly interfaces with hardware components
- **Low-level operations**: Manages memory, interrupts, and I/O
- **High reliability**: Failures can affect the entire system

### Why Rust for Systems Programming?


Rust combines three key elements that make it excellent for systems programming:
1. **Performance**: Comparable to C and C++
2. **Safety**: Memory safety without garbage collection
3. **Concurrency**: Safe multithreading with compile-time guarantees

Rust is designed specifically for systems programming with these key advantages:
- **Memory safety without garbage collection**: Prevents segmentation faults and data races
- **Zero-cost abstractions**: High-level features with no runtime overhead
- **Minimal runtime**: Small footprint, no VM or garbage collector
- **Efficient C bindings**: Easy integration with existing C code
- **Thread safety**: Compiler-enforced thread safety through ownership system

### Hello Systems World

Let's start with a simple Rust program and understand its systems aspects:

```rust
fn main() {
    // Print to standard output - a system resource
    println!("Hello, Systems World!");

    // Access environment variables - another system interface
    match std::env::var("PATH") {
        Ok(path) => println!("Your PATH is: {}", path),
        Err(e) => println!("Couldn't read PATH: {}", e),
    }

    // Get current process ID - interacting with the OS
    println!("Process ID: {}", std::process::id());
}
```

This simple program already demonstrates interaction with system resources: standard output, environment variables, and process information.

## Memory Management

Memory management is a cornerstone of systems programming. Understanding how memory works is crucial for writing efficient and reliable systems code.

### Stack vs. Heap

In systems programming, you work with two types of memory allocations:

**Stack**:
- Fast, automatic allocation and deallocation
- Fixed size, known at compile time
- LIFO (Last In, First Out) structure
- Limited in size (typically a few MB)
- Used for local variables with known, fixed sizes

**Heap**:
- Dynamic allocation at runtime
- Variable size that can grow and shrink
- Manually managed in many languages (Rust handles this through ownership)
- Much larger capacity than stack
- Used for data with unknown size at compile time or that needs to live beyond a function's execution

### Memory Layout Example

```rust
fn main() {
    // Stack allocation
    let stack_int = 42; // Integer on stack
    let stack_array = [1, 2, 3, 4, 5]; // Fixed-size array on stack

    // Heap allocation
    let heap_string = String::from("This is stored on the heap"); // String content on heap
    let heap_vector = vec![1, 2, 3, 4, 5]; // Vector content on heap

    // Print memory addresses
    println!("Address of stack_int: {:p}", &stack_int);
    println!("Address of stack_array: {:p}", &stack_array);
    println!("Address of heap_string pointer: {:p}", &heap_string);
    println!("Address of heap_string content: {:p}", heap_string.as_ptr());
    println!("Address of heap_vector pointer: {:p}", &heap_vector);
    println!("Address of heap_vector content: {:p}", heap_vector.as_ptr());

    // Demonstrating memory layout with a Box
    let boxed_value = Box::new(123);
    println!("Address of boxed_value (stack pointer): {:p}", &boxed_value);
    println!("Address of boxed value content (heap): {:p}", boxed_value);
}
```

This program shows the distinction between stack and heap allocations. The variables themselves (like `heap_string`) are on the stack, but they point to content on the heap.

### Manual Memory Management with Raw Pointers

Rust allows for direct memory manipulation when needed:

```rust
fn main() {
    // SAFETY: This is a demonstration of unsafe code - use with caution
    unsafe {
        // Allocate 4 bytes on the heap
        let raw_ptr = std::alloc::alloc(std::alloc::Layout::from_size_align(4, 4).unwrap());

        // Write to this memory
        *(raw_ptr as *mut i32) = 42;

        // Read from the memory
        println!("Value at raw pointer: {}", *(raw_ptr as *mut i32));

        // IMPORTANT: We must deallocate memory we've allocated
        std::alloc::dealloc(raw_ptr, std::alloc::Layout::from_size_align(4, 4).unwrap());

        // Using raw_ptr after deallocation would cause undefined behavior!
    }
}
```

This example shows manual memory allocation and deallocation, which is typically performed automatically by Rust's ownership system. The `unsafe` block tells Rust we're taking responsibility for memory safety.

## Ownership and Borrowing

Rust's ownership system is its most distinctive feature, eliminating entire classes of memory-related bugs that plague other systems programming languages.

### Ownership Rules

1. Each value has exactly one owner
2. When the owner goes out of scope, the value is dropped (deallocated)
3. Ownership can be transferred ("moved")

### Basic Ownership Example

```rust
fn main() {
    // s1 is the owner of this String
    let s1 = String::from("systems");

    // Ownership moves from s1 to s2
    let s2 = s1;

    // This would cause a compile error since s1 no longer owns the value
    // println!("s1: {}", s1);  // Error: value borrowed after move

    // s2 owns the String now
    println!("s2: {}", s2);  // Works fine

    // Demonstrating ownership transfer to a function
    take_ownership(s2);

    // s2 is no longer valid here
    // println!("s2 again: {}", s2);  // Error: value borrowed after move

    // Creating a new String for demonstration
    let s3 = String::from("programming");

    // get_ownership returns ownership of a new value
    let s4 = get_ownership();
    println!("s4: {}", s4);

    // s3 is moved to the function and then returned back with a modification
    let s5 = take_and_give_back(s3);
    println!("s5: {}", s5);
}

fn take_ownership(s: String) {
    println!("Taking ownership of: {}", s);
    // s is dropped (deallocated) when this function ends
}

fn get_ownership() -> String {
    let s = String::from("new ownership");
    // Ownership of the String is transferred to the calling function
    s
}

fn take_and_give_back(mut s: String) -> String {
    s.push_str(" modified");
    // Return ownership back to the caller
    s
}
```

This example demonstrates how values are moved between owners, preventing use-after-free and double-free errors.

### Borrowing

Borrowing allows you to reference data without taking ownership:

```rust
fn main() {
    let original = String::from("systems programming");

    // Immutable borrow - multiple allowed
    let len = calculate_length(&original);
    println!("Length of '{}' is {}.", original, len);

    let also_borrowed = &original;
    println!("Also borrowed: {}", also_borrowed);

    // Mutable borrow - only one allowed at a time
    // and cannot coexist with immutable borrows
    let mut mutable = String::from("hello");
    modify_string(&mut mutable);
    println!("Modified: {}", mutable);

    // This pattern prevents data races at compile time
    let mut shared_data = String::from("shared");

    {
        let r1 = &mut shared_data;
        r1.push_str(" and modified");
        // r1 is dropped at the end of this scope
    }

    // Now we can borrow mutably again
    let r2 = &mut shared_data;
    r2.push_str(" again");
    println!("Final shared data: {}", r2);
}

fn calculate_length(s: &String) -> usize {
    s.len() // s is borrowed (referenced) but not owned by this function
}

fn modify_string(s: &mut String) {
    s.push_str(" world");
}
```

Borrowing is crucial for efficient memory use without sacrificing safety.

## Data Representation

Systems programmers need to understand how data is represented in memory at the bit and byte level.

### Memory Layout and Alignment

```rust
use std::mem;

#[repr(C)] // Use C representation for predictable memory layout
struct SystemData {
    flag: bool,       // 1 byte
    // 3 bytes of padding here to align the next field to a 4-byte boundary
    value: i32,       // 4 bytes
    code: u16,        // 2 bytes
    // 2 bytes of padding here to align the next field to a 4-byte boundary
    pointer: *const u8, // 8 bytes on 64-bit systems
}

fn main() {
    println!("Size of bool: {} bytes", mem::size_of::<bool>());
    println!("Size of i32: {} bytes", mem::size_of::<i32>());
    println!("Size of u16: {} bytes", mem::size_of::<u16>());
    println!("Size of *const u8: {} bytes", mem::size_of::<*const u8>());

    // Size includes padding for alignment
    println!("Size of SystemData: {} bytes", mem::size_of::<SystemData>());

    // Create an instance and print its memory address
    let data = SystemData {
        flag: true,
        value: 42,
        code: 7,
        pointer: std::ptr::null(),
    };

    println!("Address of data: {:p}", &data);
    println!("Address of data.flag: {:p}", &data.flag);
    println!("Address of data.value: {:p}", &data.value);
    println!("Address of data.code: {:p}", &data.code);
    println!("Address of data.pointer: {:p}", &data.pointer);
}
```

This example demonstrates memory layout, alignment, and padding in structures.

### Bit Manipulation

Bit manipulation is essential for systems programming tasks like:
- Setting configuration flags
- Working with hardware registers
- Implementing efficient data structures
- Protocol implementation

```rust
fn main() {
    // Working with individual bits
    let mut flags: u8 = 0b00000000;

    // Set bit at position 1 (second bit from right)
    flags |= 0b00000010;
    println!("After setting bit 1: {:08b}", flags);

    // Set bit at position 5
    flags |= 0b00100000;
    println!("After setting bit 5: {:08b}", flags);

    // Check if bit 5 is set
    if (flags & 0b00100000) != 0 {
        println!("Bit 5 is set!");
    }

    // Clear bit 1
    flags &= !0b00000010;
    println!("After clearing bit 1: {:08b}", flags);

    // Toggle bit 5
    flags ^= 0b00100000;
    println!("After toggling bit 5: {:08b}", flags);

    // Practical example: RGB color manipulation
    // Colors often packed as 0xRRGGBB
    let color: u32 = 0x00_12_34_56; // Format: 0xAARRGGBB (AA=alpha)

    // Extract components
    let blue = color & 0xFF;
    let green = (color >> 8) & 0xFF;
    let red = (color >> 16) & 0xFF;

    println!("Color: 0x{:08X}", color);
    println!("Red: 0x{:02X}, Green: 0x{:02X}, Blue: 0x{:02X}", red, green, blue);

    // Create a new color with modified components
    let new_color = (red << 16) | (0x7F << 8) | blue; // Change green to 0x7F
    println!("New color: 0x{:08X}", new_color);
}
```

### Endianness

Endianness refers to the order in which bytes are stored in memory:

```rust
fn main() {
    let value: u32 = 0x12345678;

    // Convert to little-endian and big-endian byte arrays
    let le_bytes = value.to_le_bytes();
    let be_bytes = value.to_be_bytes();

    // Print individual bytes
    println!("Value: 0x{:08X}", value);
    print!("Little-endian bytes: ");
    for byte in &le_bytes {
        print!("0x{:02X} ", byte);
    }
    println!();

    print!("Big-endian bytes: ");
    for byte in &be_bytes {
        print!("0x{:02X} ", byte);
    }
    println!();

    // Reconstruct value from bytes
    let from_le = u32::from_le_bytes(le_bytes);
    let from_be = u32::from_be_bytes(be_bytes);
    println!("Reconstructed from LE: 0x{:08X}", from_le);
    println!("Reconstructed from BE: 0x{:08X}", from_be);

    // Check the system's native endianness
    if cfg!(target_endian = "little") {
        println!("This system is little-endian");
    } else {
        println!("This system is big-endian");
    }
}
```

Understanding endianness is crucial when working with binary data, network protocols, or file formats.

## Concurrency and Parallelism

Modern systems programming often involves concurrent or parallel execution to maximize efficiency.

### Threads

```rust
use std::thread;
use std::time::Duration;

fn main() {
    println!("Main thread: {:?}", thread::current().id());

    // Spawn a new thread
    let handle = thread::spawn(|| {
        println!("Spawned thread: {:?}", thread::current().id());

        // Simulate work
        for i in 1..5 {
            println!("Thread counting: {}", i);
            thread::sleep(Duration::from_millis(500));
        }

        // Return a value from the thread
        42
    });

    // Main thread continues execution
    for i in 1..3 {
        println!("Main thread counting: {}", i);
        thread::sleep(Duration::from_millis(300));
    }

    // Wait for the spawned thread to finish and get its return value
    let result = handle.join().unwrap();
    println!("Thread returned: {}", result);
}
```

### Thread Safety: Message Passing

```rust
use std::thread;
use std::sync::mpsc;
use std::time::Duration;

fn main() {
    // Create a channel for communication between threads
    let (tx, rx) = mpsc::channel();

    // Clone sender for use in multiple threads
    let tx1 = tx.clone();

    // Spawn sender thread 1
    thread::spawn(move || {
        let messages = vec![
            "Hello",
            "from",
            "thread",
            "one"
        ];

        for msg in messages {
            tx1.send(msg).unwrap();
            thread::sleep(Duration::from_millis(200));
        }
    });

    // Spawn sender thread 2
    thread::spawn(move || {
        let messages = vec![
            "Greetings",
            "from",
            "thread",
            "two"
        ];

        thread::sleep(Duration::from_millis(100));

        for msg in messages {
            tx.send(msg).unwrap();
            thread::sleep(Duration::from_millis(200));
        }
    });

    // Main thread receives messages
    for received in rx {
        println!("Got: {}", received);
    }
}
```

### Thread Safety: Shared State

```rust
use std::thread;
use std::sync::{Arc, Mutex};
use std::time::Duration;

fn main() {
    // Create shared state - thread-safe counter
    // Arc = Atomic Reference Counting (thread-safe smart pointer)
    // Mutex = Mutual Exclusion (prevents data races)
    let counter = Arc::new(Mutex::new(0));

    let mut handles = vec![];

    for id in 0..5 {
        // Clone the Arc to increment its reference count
        let counter = Arc::clone(&counter);

        // Spawn a thread that increments the counter
        let handle = thread::spawn(move || {
            println!("Thread {} starting", id);

            // Lock the mutex to access the data
            let mut num = counter.lock().unwrap();

            // Modify the shared data
            *num += 1;
            println!("Thread {}: count = {}", id, *num);

            // Sleep to simulate work and demonstrate mutex locking
            thread::sleep(Duration::from_millis(10));

            // Mutex is automatically released when num goes out of scope
        });

        handles.push(handle);
    }

    // Wait for all threads to finish
    for handle in handles {
        handle.join().unwrap();
    }

    // Check final counter value
    println!("Final count: {}", *counter.lock().unwrap());
}
```

### Atomics for Lock-Free Programming

```rust
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::Arc;
use std::thread;

fn main() {
    // Create an atomic counter - doesn't need a mutex
    let counter = Arc::new(AtomicUsize::new(0));

    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);

        let handle = thread::spawn(move || {
            // Increment the counter atomically
            counter.fetch_add(1, Ordering::SeqCst);
        });

        handles.push(handle);
    }

    // Wait for all threads
    for handle in handles {
        handle.join().unwrap();
    }

    println!("Final count: {}", counter.load(Ordering::SeqCst));

    // Demonstrate different memory orderings
    println!("\nDemonstrating memory orderings:");
    let atom = AtomicUsize::new(0);

    // Relaxed - weakest ordering, only atomic operation is guaranteed
    let prev = atom.fetch_add(1, Ordering::Relaxed);
    println!("Relaxed: previous={}, now={}", prev, atom.load(Ordering::SeqCst));

    // Release/Acquire - synchronizes memory access between threads
    let prev = atom.fetch_add(1, Ordering::Release);
    println!("Release: previous={}, now={}", prev, atom.load(Ordering::Acquire));

    // SeqCst - strongest ordering, total global ordering between all SeqCst operations
    let prev = atom.fetch_add(1, Ordering::SeqCst);
    println!("SeqCst: previous={}, now={}", prev, atom.load(Ordering::SeqCst));
}
```

## Direct Hardware Access

Systems programming often involves direct interaction with hardware.

### Memory-Mapped I/O

```rust
#[cfg(target_os = "linux")]
fn main() {
    use std::fs::OpenOptions;
    use std::os::unix::io::AsRawFd;
    use std::io::Error;
    use std::ptr;
    use std::slice;

    // This is a simplified example of memory mapping hardware
    // Real code would use specific device addresses

    // Open the /dev/mem device
    match OpenOptions::new()
        .read(true)
        .write(true)
        .open("/dev/mem")
    {
        Ok(file) => {
            let fd = file.as_raw_fd();

            // Hardware address to map (this is just an example value)
            let hw_addr: usize = 0x1000;
            let length: usize = 4096;

            unsafe {
                // Map the memory region
                let mapped_ptr = libc::mmap(
                    ptr::null_mut(),
                    length,
                    libc::PROT_READ | libc::PROT_WRITE,
                    libc::MAP_SHARED,
                    fd,
                    hw_addr as libc::off_t
                );

                if mapped_ptr == libc::MAP_FAILED {
                    println!("Failed to map memory: {}", Error::last_os_error());
                    return;
                }

                println!("Memory mapped at address: {:p}", mapped_ptr);

                // Create a slice to safely access the mapped memory
                let mapped_mem = slice::from_raw_parts_mut(
                    mapped_ptr as *mut u8,
                    length
                );

                // Read from hardware (first 4 bytes as u32)
                let value = *(mapped_mem.as_ptr() as *const u32);
                println!("Read value: 0x{:08X}", value);

                // Write to hardware (modify first 4 bytes)
                // In real hardware, this would modify a register
                // *(mapped_mem.as_mut_ptr() as *mut u32) = 0x12345678;
                // println!("Wrote value: 0x12345678");

                // Unmap the memory region
                libc::munmap(mapped_ptr, length);
            }
        }
        Err(e) => println!("Failed to open /dev/mem: {}", e),
    }
}

#[cfg(not(target_os = "linux"))]
fn main() {
    println!("This example only works on Linux systems");
}
```

This example demonstrates memory-mapped I/O, which is how systems code often interacts with hardware devices.

### Embedded Programming: Accessing Registers

```rust
#![no_std]
#![no_main]

// This is a simplified example for educational purposes
// Real embedded Rust code would use an MCU-specific crate

// Define hardware addresses (fictional for this example)
const GPIO_BASE: usize = 0x4000_0000;
const GPIO_OUT_REG: usize = GPIO_BASE + 0x00;
const GPIO_IN_REG: usize = GPIO_BASE + 0x04;
const GPIO_DIR_REG: usize = GPIO_BASE + 0x08;

// Safe wrapper for register access
struct GpioRegisters {
    out: *mut u32,
    input: *const u32,
    direction: *mut u32,
}

impl GpioRegisters {
    fn new() -> Self {
        Self {
            out: GPIO_OUT_REG as *mut u32,
            input: GPIO_IN_REG as *const u32,
            direction: GPIO_DIR_REG as *mut u32,
        }
    }

    unsafe fn set_direction_output(&mut self, pin: u32) {
        let current = self.direction.read_volatile();
        self.direction.write_volatile(current | (1 << pin));
    }

    unsafe fn set_pin_high(&mut self, pin: u32) {
        let current = self.out.read_volatile();
        self.out.write_volatile(current | (1 << pin));
    }

    unsafe fn set_pin_low(&mut self, pin: u32) {
        let current = self.out.read_volatile();
        self.out.write_volatile(current & !(1 << pin));
    }

    unsafe fn read_pin(&self, pin: u32) -> bool {
        let value = self.input.read_volatile();
        (value & (1 << pin)) != 0
    }
}

// This is a simplified example for demonstration
// It won't actually run without a proper embedded setup
#[no_mangle]
pub extern "C" fn main() -> ! {
    // Initialize GPIO
    let mut gpio = GpioRegisters::new();

    // Set pin 5 as output
    unsafe { gpio.set_direction_output(5) };

    // Blink LED connected to pin 5
    loop {
        unsafe {
            // Turn LED on
            gpio.set_pin_high(5);

            // Delay (simplified)
            for _ in 0..1_000_000 {
                core::hint::spin_loop();
            }

            // Turn LED off
            gpio.set_pin_low(5);

            // Delay again
            for _ in 0..1_000_000 {
                core::hint::spin_loop();
            }
        }
    }
}

// Required for embedded code to handle panics
#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    loop {}
}
```

This example demonstrates hardware register access patterns commonly used in embedded systems programming.

## Error Handling for Systems Programming

Robust error handling is critical in systems programming where failures can cascade.

### Basic Error Handling

```rust
use std::fs::File;
use std::io::{self, Read};
use std::path::Path;

fn main() {
    match read_file_contents("config.txt") {
        Ok(contents) => println!("File contents: {}", contents),
        Err(e) => eprintln!("Error: {}", e),
    }
}

fn read_file_contents(path: impl AsRef<Path>) -> io::Result<String> {
    // Open the file
    let mut file = File::open(path)?;

    // Read file contents into a string
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;

    Ok(contents)
}
```

### Error Propagation and Custom Error Types

```rust
use std::fs::File;
use std::io::{self, Read};
use std::path::Path;
use std::fmt;
use std::error::Error;

// Define custom error type
#[derive(Debug)]
enum ConfigError {
    IoError(io::Error),
    ParseError(String),
    MissingValue(String),
}

impl fmt::Display for ConfigError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            ConfigError::IoError(e) => write!(f, "I/O error: {}", e),
            ConfigError::ParseError(msg) => write!(f, "Parse error: {}", msg),
            ConfigError::MissingValue(key) => write!(f, "Missing configuration value: {}", key),
        }
    }
}

// Implement standard Error trait
impl Error for ConfigError {
    fn source(&self) -> Option<&(dyn Error + 'static)> {
        match self {
            ConfigError::IoError(e) => Some(e),
            _ => None,
        }
    }
}

// Implement From trait for automatic conversion from io::Error
impl From<io::Error> for ConfigError {
    fn from(error: io::Error) -> Self {
        ConfigError::IoError(error)
    }
}

// Configuration struct
struct Config {
    debug_mode: bool,
    server_port: u16,
    log_level: String,
}

fn load_config(path: impl AsRef<Path>) -> Result<Config, ConfigError> {
    // Read file contents
    let mut file = File::open(path)?; // io::Error converts to ConfigError automatically
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;

    // Parse config (simplified for this example)
    let mut debug_mode = false;
    let mut server_port = None;
    let mut log_level = None;

    for line in contents.lines() {
        if line.trim().is_empty() || line.starts_with('#') {
            continue; // Skip empty lines and comments
        }

        let parts: Vec<&str> = line.splitn(2, '=').collect();
        if parts.len() != 2 {
            return Err(ConfigError::ParseError(format!("Invalid line: {}", line)));
        }

        let key = parts[0].trim();
        let value = parts[1].trim();

        match key {
            "debug_mode" => {
                debug_mode = match value.to_lowercase().as_str() {
                    "true" | "yes" | "1" => true,
                    "false" | "no" | "0" => false,
                    _ => return Err(ConfigError::ParseError(
                        format!("Invalid boolean value: {}", value)
                    )),
                };
            },
            "server_port" => {
                server_port = Some(value.parse::<u16>().map_err(|_| {
                    ConfigError::ParseError(format!("Invalid port number: {}", value))
                })?);
            },
            "log_level" => {
                log_level = Some(value.to_string());
            },
            _ => {} // Ignore unknown keys
        }
    }

    // Ensure required values are present
    let server_port = server_port.ok_or(ConfigError::MissingValue("server_port".to_string()))?;
    let log_level = log_level.ok_or(ConfigError::MissingValue("log_level".to_string()))?;

    Ok(Config {
        debug_mode,
        server_port,
        log_level,
    })
}

fn main() {
    match load_config("config.txt") {
        Ok(config) => {
            println!("Configuration loaded:");
            println!("Debug mode: {}", config.debug_mode);
            println!("Server port: {}", config.server_port);
            println!("Log level: {}", config.log_level);
        },
        Err(e) => {
            eprintln!("Failed to load configuration: {}", e);

            // Print error chain
            let mut source = e.source();
            while let Some(err) = source {
                eprintln!("Caused by: {}", err);
                source = err.source();
            }
        },
    }
}
```

This example demonstrates a complete error handling system with custom error types, error conversion, and propagation - essential practices for robust systems programming.

## File Systems and I/O

File system operations are fundamental to many systems programs.

### Working with Files and Directories

```rust
use std::fs::{self, File, OpenOptions};
use std::io::{self, Read, Write, Seek, SeekFrom};
use std::path::Path;
