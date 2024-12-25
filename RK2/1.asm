format ELF64

public _start
public gen_random

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
extrn timeout
extrn printw
extrn mvaddch
extrn erase
extrn curs_set
extrn usleep

section '.bss' writable
    xmax dq 1
	ymax dq 1
	palette dq 1
    
	; для gen_random
	f db "/dev/random", 0
	number rq 1
  	place rb 100

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
	; синенький
    mov rdi, 1
    mov rsi, 4
    mov rdx, 4
    call init_pair
	; красненький
    mov rdi, 2
    mov rsi, 5
    mov rdx, 1
    call init_pair

    call refresh
	call noecho
	
    xor rax, rax
    mov rax, ' '
    or rax, 0x100
    mov [palette], rax

    xor r13, r13		; x 
    xor r14, r14		; y

	mov r13, 10			; начальные координаты, 
	mov r14, 10			; просто чтобы сразу из угла не стартовал

    .loop:
        
        mov rdi, r14
        mov rsi, r13
        push r13
        push r14
		; рисуем
        mov rdx, [palette]
        call mvaddch
        call refresh
		; ловим нажатие кьюшки
        mov rdi, 10
        call timeout
        call getch
        cmp rax, 'q'
        je .end

        pop r14
        pop r13
        ; генерирум {-1, 0, 1} и добавляем к текущей координате
        call gen_random
        add r13, rdx
        xor rdx, rdx
        call gen_random
        add r14, rdx

        xor rcx, rcx
        cmp r13, 0
        jnl @f   ; если x >= 0, переходим дальше
        inc r13
        inc rcx
        @@:
        cmp r13, [xmax]
        jle @f   ; если x <= xmax, переходим дальше
        dec r13
        inc rcx
        @@:
        cmp r14, 0
        jnl @f  ; если y >= 0, переходим дальше
        inc r14
        inc rcx
        @@:
        cmp r14, [ymax]
        jle @f  ; если y <= ymax, переходим
        dec r14
        inc rcx

        @@:
        cmp rcx, 0
        je .delay
        mov rax, [palette]
        and rax, 0x100
        cmp rax, 0    ; Проверяем цвет
        jne .red
        mov rax, [palette]
        and rax, 0xff
        or rax, 0x100
        jmp @f ; дальше
        .red:
        mov rax, [palette]
        and rax, 0xff
        or rax, 0x200
        @@:
        mov [palette], rax

        .delay:		; задержка в развитии
        push r14
        push r13
        mov rdi, 100000
        call usleep
        pop r13
        pop r14
        jmp .loop

    .end:
    mov rdi, 1
    call endwin
    mov rax, 60
    syscall

gen_random:
    mov rdi, f
    mov rax, 2 
    mov rsi, 0o
    syscall 
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
	;xor rax, rax
    xor rbx, rbx
    xor rdx, rdx
	mov rbx, 3  ; делаем дипазон {-1, 0, 1}
    div rbx
    sub rdx, 1
    ret