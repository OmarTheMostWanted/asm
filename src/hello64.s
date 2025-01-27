.section .data          # Section for initialized data, .data is used for initialized data
message:                # Label for the message string
    .ascii "Hello world\n"  # The message to be printed
prompt:                 # Label for the prompt string
    .ascii "Enter your name: "  # The prompt message

.section .bss           # Section for uninitialized data, .bss is used for variables that are not initialized
.lcomm name, 100        # Allocate 100 bytes for the user's name

.section .text          # Section for code, .text is used for code
.globl _start           # Declare the _start label as global, the entry point of the program must be defined so that the linker can link the program

# Entry point of the program
_start:
    call print_prompt   # Call the function to print the prompt
    call read_name      # Call the function to read the user's name
    call print_greeting # Call the function to print the greeting
    call exit_program   # Call the function to exit the program

# Function to print the prompt
print_prompt:
    mov $1, %rax        # System call number (1 for sys_write)
    mov $1, %rdi        # File descriptor (1 for stdout)
    mov $prompt, %rsi   # Pointer to the prompt string
    mov $17, %rdx       # Number of bytes to write (length of the prompt)
    syscall             # Make the system call
    ret                 # Return from the function

# Function to read the user's name
read_name:
    mov $0, %rax        # System call number (0 for sys_read)
    mov $0, %rdi        # File descriptor (0 for stdin)
    mov $name, %rsi     # Pointer to the buffer for the user's name
    mov $100, %rdx      # Number of bytes to read (buffer size)
    syscall             # Make the system call
    ret                 # Return from the function

# Function to print the greeting
print_greeting:
    mov $1, %rax        # System call number (1 for sys_write)
    mov $1, %rdi        # File descriptor (1 for stdout)
    mov $name, %rsi     # Pointer to the buffer containing the user's name
    mov $100, %rdx      # Number of bytes to write (buffer size)
    syscall             # Make the system call
    ret                 # Return from the function

# Function to exit the program
exit_program:
    mov $60, %rax       # System call number (60 for sys_exit)
    xor %rdi, %rdi      # Exit status (0), rdi is used as the first argument
    syscall             # Make the system call
    ret                 # Return from the function