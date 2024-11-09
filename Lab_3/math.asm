format ELF64
public _start
include 'func.asm'

place db ?
temp dq 0

; (((a/b)+a)/c)
_start:
    mov rsi,[rsp+16]
    call str_number
    mov rdi, rax
    
    mov rsi,[rsp+24]
    call str_number
    mov rbp, rax
    
    call division
    mov rbp, [temp]
    call sum
    mov rsi,[rsp+32]
    call str_number
    mov rdi, [temp]
    mov rbp, rax
    call division

    mov rax, [temp]
    call print_num
    call new_line
    call exit

division:
    push rdi
    push rbp
    push rax
    push rbx
    push rcx
    push rdx
    mov rax, rdi
    mov rcx, rbp
    div rcx
    mov [temp], rax
    pop rdx
    pop rcx
    pop rbx
    pop rax
    pop rbp
    pop rdi
    ret
sum:
    push rdi
    push rbp
    push rax
    push rbx
    push rcx
    push rdx
    add rdi, rbp
    mov [temp], rdi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    pop rbp
    pop rdi
    ret
print_num:
    mov rcx, 10
    xor rbx, rbx
    iter1:
        xor rdx, rdx
        div rcx
        add rdx, '0'
        push rdx
        inc rbx
        cmp rax, 0
    jne iter1
    iter2:
        pop rax
        call print_symbl_num
        dec rbx
        cmp rbx, 0
    jne iter2
    ret

print_symbl_num:
    push rbx
    push rdx
    push rcx
    push rax
    push rax
    mov rax, 4
    mov rbx, 1
    pop rdx
    mov [place], dl
    mov rcx, place
    mov rdx, 1
    int 0x80
    pop rax
    pop rcx
    pop rdx
    pop rbx
    ret