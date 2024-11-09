format ELF64
public _start
include 'func.asm'
msg db ?

section '.code' executable
_start:
    call read
    call str_number ; in rax value of n
    cmp rax, 0
    je close0
    mov rdi, 1
    cmp rax, 1
    je close1
    mov rcx, rax    ; n
    sum:
        call first_part ; in rdx 
        call second_part ; in rax
        imul rax, rdx
        add rdi, rax
        dec rcx
        cmp rcx, 1
    jne sum
    close1:
    mov rax, rdi
    close0:
    call print_decimal
    call new_line
    call exit

first_part: ;(-1)^(n-1)
    push rcx 
    push rdx 
    sub rcx, 1
    mov rax, 1
    mov rbx, -1
    call power
    pop rdx 
    pop rcx
    mov rdx, rax
    ret
second_part: ; n^2
    push rdx
    mov rbx, rcx
    mov rax, 1
    push rcx
    mov rcx, 2
    call power
    pop rcx
    pop rdx
    ret
; | input:
; rbx = multiplier
; rcx = degree
; | output:
; rax = result
power:
    imul rbx
    loop power
    ret
section '.print_decimal' executable
; | input:
; rax = number
print_decimal:
    push rax
    push rbx
    push rcx
    push rdx
    xor rcx, rcx
    cmp rax, 0
    jl .is_minus
    jmp .next_iter
    .is_minus:
        neg rax
        push rax
        mov rax, '-'
        call print_char
        pop rax
    .next_iter:
        mov rbx, 10
        xor rdx, rdx
        div rbx
        push rdx
        inc rcx
        cmp rax, 0
        je .print_iter
        jmp .next_iter
    .print_iter:
        cmp rcx, 0
        je .close
        pop rax
        add rax, '0'
        call print_char
        dec rcx
        jmp .print_iter
    .close:
        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret

section '.print_char' executable
; | input
; rax = char
print_char:
    push rax
    push rdx
    push rsi
    push rdi

    push rax
    
    mov rsi, rsp
    mov rdi, 1
    mov rdx, 1
    mov rax, 1
    call do_syscall

    pop rax

    pop rdi
    pop rsi
    pop rdx
    pop rax
    ret

section '.do_syscall' executable
do_syscall:
    push rcx
    push r11 
    syscall
    pop r11 
    pop rcx 
    ret
section '.read' executable 
read:
   mov rax, 0
   mov rdi, 0
   mov rsi, msg
   mov rdx, 255
   call do_syscall
   ret
section '.write' executable
write:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 255
    call do_syscall
    ret
section '.exit' executable
exit:
   mov rax, 60
   mov rdi, 0
   syscall

