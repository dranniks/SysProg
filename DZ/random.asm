format elf64
public _start

include 'func.asm'




section '.bss' writable

  number rq 1
  place rb 100

section '.text' executable

_start:
    call gen_random
     
gen_random:
    mov rdi, f
    mov rax, 2 
    mov rsi, 0o
    syscall 
    cmp rax, 0 
    jl .l1 
    mov r8, rax

    mov rax, 0 ;
    mov rdi, r8
    mov rsi, number
    mov rdx, 1
    syscall
    
    mov rax, [number]
    mov rsi, place
    
    push rax
    mov rax, 3
    mov rdi, r8
    syscall
    pop rax
    ret