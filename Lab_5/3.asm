format ELF64
public _start

include 'func.asm'

section '.bss' writable
    buf db 1
    output dq ?

_start:
    pop rcx
    cmp rcx, 1
    je .fin
    mov rdi,[rsp+8]
    mov rax, 2
    mov rsi, 0o
    syscall
    cmp rax, 0
    jl .fin
    mov r8, rax
    mov rdi,[rsp+16]
    mov rax, 2
    mov rsi, 577
    mov rdx, 777o
    syscall
    cmp rax, 0
    jl .fin
    mov r9, rax
    mov rax, 8
    mov rdi, r8
    mov rsi, -1
    mov rdx, 2
    syscall
    mov r10, rax
    xor rbx, rbx

.printloop:
    cmp r10, 0
    jl .close
    mov rax, 0
    mov rdi, r8
    mov rsi, buf
    mov rdx, 1
    syscall
    mov rax, 1
    mov rdi, r9
    mov rsi, buf
    mov rdx, 1
    syscall
    inc rbx
    mov rax, 8
    mov rdi, r9
    mov rsi, rbx
    mov rdx, 0
    syscall
    dec r10
    mov rax, 8
    mov rdi, r8
    mov rsi, r10
    mov rdx, 0
    syscall
    jmp .printloop

.close:
    mov rdi, r8
    mov rax, 3
    syscall
    mov rdi, r9
    mov rax, 3
    syscall

.fin:
    call exit