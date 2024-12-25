format ELF64
include 'func.asm'
public _start

section '.bss' writable
    bufer db ?
    newline db 0xA

section '.text' executable
    _start:
        pop rcx
        cmp rcx, 1
        je .l1

        mov rdi,[rsp+8] ;имя открываемого файла
        mov rax, 2      ;open
        mov rsi, 0o     ;режим открытия чтение
        syscall
        cmp rax, 0
        jl .l1          ;rax = -1
        mov r8, rax     ;fd

        mov rax, 2
        mov rdi, [rsp+16]
        mov rsi, 1101o  ; O_WRONLY|O_TRUNC|O_CREAT
        mov rdx, 777o
        syscall
        mov r9, rax     ;fd

        mov rax, 8      ;lseek
        mov rdi, r8     ;fd
        mov rsi, 0      ;смещение
        mov rdx, 2      ;seek_end
        syscall
        mov r10, rax    ;len of file для итерации по символам

        .loop:
            xor rbx, rbx    ;count symb
            .reading:
                mov rax, 0       ;read
                mov rdi, r8      ;откуда читаем
                mov rsi, bufer  ;адрес буфера
                mov rdx, 1     ;длина буфера
                syscall
                cmp byte[rsi], 0xA
                je .l2
                cmp byte[rsi], 0    ;eof
                je .offset

                inc rbx
                mov r11b, byte[rsi]
                push r11

                .offset:
                    cmp r10, 0
                    je .l2

                    dec r10
                    mov rax, 8       ;lseek
                    mov rdi, r8      ;fd
                    mov rsi, r10     ;смещение в конец файла на -1 символ
                    mov rdx, 0       ;seek_set
                    syscall
                    jmp .reading
            .l2:
            mov rax, 1      ;write
            mov rdi, r9
            mov rsi, bufer
            mov rdx, 1
            .print:
                cmp rbx, 0
                je .new_line
                pop r11
                mov byte[rsi], r11b
                syscall

                dec rbx
                jmp .print

            .new_line:
                cmp r10, 0
                je .l1
                ;call new_line
                call l3
                dec r10
                mov rax, 8       ;lseek
                mov rdi, r8      ;fd
                mov rsi, r10     ;смещение в конец файла на -1 символ
                mov rdx, 0       ;seek_set
                syscall
                jmp .loop
        .l1:
            call exit
l3:
    mov rax, 1      ;write
    mov rdi, r9
    mov rsi, newline
    mov rdx, 1
    syscall
    ret

