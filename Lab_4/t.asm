format ELF64
public _start
include 'func.asm'
msg db ?

_start:
    call read
    call str_number ; in rax value of k
    mov rcx, rax    ; k
    xor rdi, rdi    ; sum
    sum:
        call first_part
        call second_part
        dec rcx
        add rdi, rdx
        cmp rcx, 0
    jne sum
    mov rax, rdi
    call print_decimal
    call new_line
    call exit

first_part: ;(-1)^k*k
    push rcx 
    mov rax, 1
    mov rbx, -1
    call power
    pop rcx
    imul rcx
    mov rdx, rax    ; save result in rdx
    ret
second_part: 
    push rcx
    add rcx, 1 ; (k+1)
    imul rdx, rcx ; ...*(k+1)
    pop rcx
    push rcx
    imul rcx, 3 ; 3k
    add rcx, 1  ; 3k+1
    imul rdx, rcx ; ...*(3k+1)
    pop rcx
    push rcx
    imul rcx, 3 ; 3k
    add rcx, 2 ; 3k+2
    imul rdx, rcx ; ...*(3k+2)
    pop rcx
    mov rax, rdx 
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
section '.exit' executable
exit:
   mov rax, 60
   mov rdi, 0
   syscall