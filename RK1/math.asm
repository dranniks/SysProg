format ELF64
public _start
include 'func.asm'

section '.data' writable
msg db "error: even number", 0, 0xA

_start:
    mov rsi,[rsp+16]
    call str_number
    push rax
    call check_error
    pop rax
    mov rcx, rax    ; n
    xor rdi, rdi    ; result
    sum:
        call f
        dec rcx
        cmp rcx, -1
        jne sum
    mov rax, rdi
    call print_decimal
    call new_line   
    call exit
f:
    mov rax, rcx
    imul rax, 2
    add rdi, rax
    add rdi, 1
    ret

check_error:
    mov rbx, 2
    div rbx
    cmp rdx, 0
    jne ok
    mov rsi, msg
    call print_str
    call new_line
    call do_syscall
    call exit
    ok:
    ret