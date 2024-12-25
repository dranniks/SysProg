format ELF64
include 'func.asm'
public _start

arrlenght = 1024

section '.bss' writable
    f db "/dev/random", 0
    array rb arrlenght
    place rb 100
    number dq 300

section '.text' executable
_start:
    mov rsi, place
    call input_keyboard
    call new_line
    call str_number
    mov [number], rax

    mov rdi, f
    mov rax, 2 
    mov rsi, 0o
    syscall 
    cmp rax, 0 
    jl .end
    mov r8, rax

    xor rcx, rcx
    mov rsi, array
    .loop:
    push rcx
    mov rax, 0
    mov rdi, r8
    mov rdx, 1
    syscall
    
    movzx rax, byte [rsi]
    push rsi
   
    mov rsi, place
    call number_str
    call print_str
    call new_line
    pop rsi

    add rsi, 1  
    pop rcx
    inc rcx         
    cmp rcx, [number]
    jl .loop
    mov rax, 3
    mov rdi, r8
    syscall

    ; 1 дочерний процесса
    mov rdi, 0
    mov rsi, 0
    call birth_child

    ; 2 дочерний процесс
    mov rdi, 1
    mov rsi, 1
    call birth_child
    mov rax, 231               

.end:
  call exit

birth_child:
    mov rax, 56                ; clone
    mov rdi, rsi               
    mov rsi, rbx             
    syscall
    test rax, rax
    jnz .stop_child
    call sum_el
    mov rax, 60
    xor rdi, rdi
    syscall

.stop_child:
    ret

sum_el:
    mov rsi, array
    add rsi, rdi
    xor rdx, rdx

.sum:
    movzx rax, byte [rsi]
    add rdx, rax
    add rsi, 2
    inc rbx
    cmp rbx, [number]
    jl .sum

.result:
    mov rax, rdx
    mov rsi, place
    call number_str 
    call new_line
    call print_str 
    call new_line
    ret