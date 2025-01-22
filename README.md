# AT&T Assembly Language Cheat Sheet

## General Syntax
- OP src, dest

## X86-64 Registers

| Register | Description And Common Usage |
|----------|-------------|
| RAX      | Accumulator: Used in arithmetic operations |
| RBX      | Base: Used as a pointer to data |
| RCX      | Counter: Used in shift/rotate instructions |
| RDX      | Data: Used in arithmetic operations |
| RDI      | Destination Index: Used as a pointer to a destination |
| RSP      | Stack Pointer: Pointer to the top of the stack |
| RBP      | Base Pointer: Pointer to the base of the stack frame |
| RSI      | Source Index: Used as a pointer to a source |
| R8-R15   | General Purpose Registers |


## Referencing Lower Bits
- d suffix: Lower 32 bits of the register
- w suffix: Lower 16 bits of the register
- b suffix: Lower 8 bits of the register
- no suffix: Full register


## Common Assembly Instructions Cheat Sheet (AT&T Syntax)

| Instruction | Description | Syntax | Example |
| --- | --- | --- | --- |
| `mov` | Move data | `mov src, dest` | `mov %eax, %ebx` |
| `push` | Push to stack | `push src` | `push %eax` |
| `pop` | Pop from stack | `pop dest` | `pop %eax` |
| `add` | Add values | `add src, dest` | `add $5, %eax` |
| `sub` | Subtract values | `sub src, dest` | `sub $5, %eax` |
| `inc` | Increment by 1 | `inc dest` | `inc %eax` |
| `dec` | Decrement by 1 | `dec dest` | `dec %eax` |
| `cmp` | Compare values | `cmp src, dest` | `cmp $5, %eax` |
| `jmp` | Jump to label | `jmp label` | `jmp label` |
| `call` | Call subroutine | `call label` | `call function` |
| `ret` | Return from subroutine | `ret` | `ret` |
| `lea` | Load address | `lea src, dest` | `lea (%eax, %ebx, 4), %ecx` |
| `neg` | Negate value | `neg dest` | `neg %eax` |
| `imul` | Signed multiply | `imul src, dest` | `imul $5, %eax` |
| `idiv` | Signed divide | `idiv src` | `idiv %ebx` |

## Instruction Suffixes in AT&T Syntax

| Suffix | Operand Size | Example |
| --- | --- | --- |
| **b** | Byte (8 bits) | `movb $1, %al` |
| **w** | Word (16 bits) | `movw $1, %ax` |
| **l** | Long (32 bits) | `movl $1, %eax` |
| **q** | Quad (64 bits) | `movq $1, %rax` |

Absolutely! Here's a table that includes more detailed descriptions of the different types of operands:

## Types of Operands

| Type | Description | Syntax  | Example |
|---------------------|-------------------------------------------------------------------------------------------------|---------------------------|-----------------------------------------------------|
| **Immediate**       | Constant values directly within the instruction itself, used immediately by the CPU.            | `$value`                  | `movl $10, %eax`    # Moves 10 into %eax            |
| **Register**        | Values stored in the CPU's registers, which are small, fast storage locations within the CPU.    | `%register`               | `movl %ebx, %eax`   # Moves value in %ebx to %eax   |
| **Memory**          | Data stored in memory locations, specified by addresses in the operand.                         | `(address)` or `(base, index, scale, displacement)` | `movl 4(%ebp), %eax` # Moves value at (4 + %ebp) to %eax<br/>`movl (%eax,%ebx,4), %ecx` # Moves value at (%eax + 4 * %ebx) to %ecx |
| **Effective Address** | Addresses dynamically calculated using base, index, scale, and displacement.                 | `(base, index, scale, displacement)` | `leal (%eax,%ebx,4), %ecx` # Loads effective address into %ecx |


### Memory Addressing Modes

#### Most General Form:
```
D(B, I, S)
```
Where:
- **D**: Constant displacement value (immediate value) or offset
- **B**: Base register
- **I**: Index register (except `%rsp`)
- **S**: Scale factor (1, 2, 4, or 8)

This form translates to the effective address:
```
Mem[Reg[B] + S * Reg[I] + D]
```

#### Example:
```
movq 8(%rbp, %rax, 4), %rdx
```
Breaking this down:
- **D (8)**: Displacement value of `8`
- **B (%rbp)**: Base register `%rbp`
- **I (%rax)**: Index register `%rax`
- **S (4)**: Scale factor `4`

Now, using the most general form, we get:
```
Effective Address = Reg[%rbp] + 4 * Reg[%rax] + 8
```

Let's illustrate it step by step:
1. **Base Register (%rbp)**:
   - Assume `%rbp` contains the value `1000`.
2. **Index Register (%rax)**:
   - Assume `%rax` contains the value `2`.
3. **Scale Factor (4)**:
   - Multiply the value in `%rax` by the scale factor `4`:
     ```
     4 * 2 = 8
     ```
4. **Displacement (8)**:
   - Add the constant displacement `8`.

Combining all these:
```
Effective Address = 1000 + 8 + 8 = 1016
```

So, the instruction `movq 8(%rbp, %rax, 4), %rdx` translates to:
- Move the value at memory address `1016` into the register `%rdx`.


## Endianness
- Memory is represented as a sequence of byte integers

- Example: 0x0A0B0C0Dh
    - Big Endian: High-order byte stored at the lowest memory address
        - 0A 0B 0C 0D
    - Little Endian: Low-order byte stored at the lowest memory address
        - 0D 0C 0B 0A

## Load Effective Address (LEA)
- `lea src, dest`: Load the effective address of the source into the destination

By effective address, we mean the address of the source operand, not the value stored at that address.

- Computing addresses without a memory dereference


### Example

`leaq (%rdi,%rdi,2), %rax` step by step:

#### Instruction Breakdown:
- **leaq**: Load Effective Address, the instruction computes an address and loads it into a register.
- **Operands**: `(%rdi,%rdi,2)` and `%rax`

#### Components:
- **Base Register (%rdi)**: The base register in the addressing mode.
- **Index Register (%rdi)**: The index register, also `%rdi` in this case.
- **Scale Factor (2)**: The scale factor which multiplies the index register.
- **Displacement**: There is no explicit displacement in this instruction (implicitly `0`).

#### Effective Address Calculation:
The effective address is calculated using the formula:
```
Effective Address = Base + (Index * Scale) + Displacement
```
For `leaq (%rdi,%rdi,2), %rax`:
- **Base** = `%rdi`
- **Index** = `%rdi`
- **Scale** = `2`
- **Displacement** = `0` (implicitly)

Plugging in the values:
```
Effective Address = %rdi + (%rdi * 2) + 0
```
Simplified:
```
Effective Address = %rdi + 2 * %rdi
Effective Address = 3 * %rdi
```

#### Final Interpretation:
- The instruction `leaq (%rdi,%rdi,2), %rax` calculates `3 * %rdi` and loads this value into the `%rax` register.

So, the value in `%rdi` is tripled and stored in `%rax`. This is an example of using the `leaq` instruction to perform a simple arithmetic operation efficiently.


## Control Flow Instructions

### Jump
Sets PC and redirects the flow of control to another part of the program.
- Relative jump: `jmp label`: label is a symbolic name for a memory location
- Absolute jump: `jmp *address`: absulute address in register or memory location

### Conditional Jump
Sets PC and redirects the flow of control based on a condition.
- Usually follows a `cmp` instruction or a test of a register value
- Always direct jumps
- other architectures have indirect jumps

### Call
Calls a subroutine or function.
- Relative (fixed offset): `call label` (direct call)
- Absolute (register or memory location): `call *address` (indirect call)
- Also pushes the return address onto the stack (address of the next instruction after the call)

### Return
Returns from a subroutine.
- Pops the return address from the stack
- Sets PC to absolute address popped from the stack


### Example
```c
if (a > b) {
    c = d;
} else {
    d = c;
}
```

```assembly
cmp -0x8(%rbp),%eax      # Compare the value at -0x8(%rbp) (b) with %eax (a)
jle else_part            # Jump to the else part if a <= b
mov -0x10(%rbp),%eax     # (If part) Move the value at -0x10(%rbp) (d) to %eax
mov %eax,-0xc(%rbp)      # Move the value in %eax to -0xc(%rbp) (c)
jmp end_if               # Jump to the end of the if-else block
else_part:
mov -0xc(%rbp),%eax      # (Else part) Move the value at -0xc(%rbp) (c) to %eax
mov %eax,-0x10(%rbp)     # Move the value in %eax to -0x10(%rbp) (d)
end_if:
```