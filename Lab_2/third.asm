format ELF64
public _start

array db 36 dup ('$')
simv_newline db 0xA, 0
simv db ?

_start:
    xor rcx, rcx
    xor rdx, rcx

    .iter1:
        inc rdx
        push rdx
        .iter2:
            dec rdx
            push rcx
            push rdx
            mov al, [array+rcx]
            call print_simv
            pop rdx
            pop rcx

            inc rcx

            cmp rdx, 0
            jne .iter2

        pop rdx

        push rdx
        push rcx
        call print_newline
        pop rcx
        pop rdx

        cmp rcx, 36
        jne .iter1
    call exit

print_simv:
    mov [simv], al
    mov rax, 4
    mov rbx, 1
    mov rcx, simv
    mov rdx, 1
    int 0x80
    ret

print_newline:
    mov rax, 4
    mov rbx, 1
    mov rcx, simv_newline
    mov rdx, 1
    int 0x80
    ret

exit:
    mov rax, 1
    xor rbx, rbx
    int 0x80