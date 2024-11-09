format ELF64
public _start
include 'func.asm'

section '.data' writable
    msg db ?
section '.bss' writable
    ent db "Enter the number of judges: ", 0
    inf db "Each judge must enter either 1(Yes) or 0(No)", 0xA, 0
    y db "Votes 'Yes' more.", 0xA, 0
    n db "Votes 'No' more.", 0xA, 0
    e db "Number of votes 'Yes' and 'No' is equal.", 0xA, 0
section '.code' executable
_start:
    mov rsi, ent
    mov rdx, 28
    call write
    call read
    call str_number ; in rax value of n
    mov rsi, inf
    mov rdx, 45
    call write
    mov rdx, rax    ; save n in rdx
    xor rcx, rcx
    xor rdi, rdi    ; counter
    voting:
        push rdx
        call read
        call str_number
        cmp rax, 1
        je yes
        sub rdi, 2
        yes:
            inc rdi
        inc rcx
        pop rdx
        cmp rcx, rdx
    jne voting
    mov rax, rdi
    cmp rdi, 0   ; if > 0 
    jg closePositive
    je closeEqu
    mov rsi, n
    mov rdx, 17
    call write
    call exit
    closePositive:
    mov rsi, y
    mov rdx, 18
    call write
    call exit
    closeEqu:
    mov rsi, e
    mov rdx, 44
    call write
    call exit

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
    push rax
    push rdi
    push rdx
    mov rax, 0
    mov rdi, 0
    mov rsi, msg
    mov rdx, 255
    call do_syscall
    pop rdx
    pop rdi
    pop rax
    ret
section '.write' executable
write:
    push rax
    push rdi
    push rsi
    push rdx
    mov rax, 1
    mov rdi, 1
    call do_syscall
    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret
section '.exit' executable
exit:
   mov rax, 60
   mov rdi, 0
   syscall