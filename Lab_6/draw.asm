format ELF64

public _start

extrn initscr
extrn start_color
extrn init_pair
extrn getmaxx
extrn getmaxy
extrn raw
extrn noecho
extrn keypad
extrn stdscr
extrn move
extrn getch
extrn addch
extrn refresh
extrn endwin
extrn exit
extrn timeout
extrn usleep
extrn printw

;ld draw.o -lc -lncurses -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o draw
section '.bss' writable
    xmax dq 1
	ymax dq 1
	palette dq 1
    delay dq ?
    step dq ?

section '.text' executable

_start:
    call initscr
    xor rdi, rdi
	mov rdi, [stdscr]
	call getmaxx
    dec rax
	mov [xmax], rax
	call getmaxy
    dec rax
	mov [ymax], rax

    call start_color

    
    mov rdi, 1
    mov rsi, 1
    mov rdx, 1
    call init_pair

    
    mov rdi, 2
    mov rsi, 5
    mov rdx, 5
    call init_pair

    call refresh
	call noecho
	call raw

    mov rax, ' '
    or rax, 0x100
    mov [palette], rax
    mov r8, [xmax]
    xor r9, r9
    mov [step], -1
    mov [delay], 2000
    .main_loop:
        cmp [ymax], r9
        jnl .loop
        mov r8, [xmax]
        xor r9, r9
        mov [step], -1
        
        mov rax, [palette]
        and rax, 0x100
        cmp rax, 0
        jne .mag
        mov rax, [palette]
        and rax, 0xff
        or rax, 0x100
        jmp @f
        .mag:
        mov rax, [palette]
        and rax, 0xff
        or rax, 0x200
        @@:
        mov [palette], rax

        .loop:
            mov rdi, r9
            mov rsi, r8
            push r8
            push r9
            call move
            mov rdi, [palette]
            call addch
            call refresh
            mov rdi, 1
            call timeout
            call getch

            cmp rax, 'g'
            jne @f
            jmp .exit

            @@:
            cmp rax, 'a'
            jne @f
            cmp [delay], 2000
            je .fast
            mov [delay], 2000
            jmp @f
            .fast:
            mov [delay], 100
            @@:
            mov rdi, [delay]
            call usleep

            pop r9
            pop r8
            add r8, [step]
            cmp r8, 0
            jl .chdir
            cmp r8, [xmax]
            jg .chdir

            jmp .loop
        
        .chdir:
        cmp r8, 0
        jl @f
        mov [step], -1
        mov r8, [xmax]
        inc r9
        jmp .main_loop

        @@:
        mov [step], 1
        mov r8, 0
        inc r9
        jmp .main_loop
    
    .exit:
    call endwin
    call exit