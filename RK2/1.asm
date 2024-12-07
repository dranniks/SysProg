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
	extrn clear
	extrn addch
	extrn refresh
	extrn endwin
	extrn exit
	extrn color_pair
	extrn insch
	extrn cbreak
	extrn timeout
	extrn mydelay
	extrn setrnd
	extrn get_random


	section '.bss' writable
	x rb 0
    y rb 0
	xmax dq 1
	ymax dq 1
	rand_x dq 1
	rand_y dq 1
	palette dq 1
	count dq 1

	;section '.data' writable


	section '.text' executable
	
_start:
	;; Инициализация
	call initscr

	;; Размеры экрана
	xor rdi, rdi
	mov rdi, [stdscr]
	call getmaxx
	mov [xmax], rax
	call getmaxy
	mov [ymax], rax

	call start_color

	;; Синий цвет
	mov rdx, 0x4
	mov rsi,0x0
	mov rdi, 0x1
	call init_pair

	;; Черный цвет
	mov rdx, 0x0
	mov rsi,0xf
	mov rdi, 0x2
	call init_pair

	call refresh
	call noecho
	call cbreak
	call setrnd

	;; Начальная инициализация палитры
	mov rax, ' '
	or rax, 0x100
	mov [palette], rax
	mov [count], 0
    xor r13, r13
    xor r14, r14
	;; Главный цикл программы
mloop:

    
    ;; Выбираем случайную позицию по осям x, y
	call get_random
	add r13, rax

    mov rax, [xmax]
    mov rcx, 2
    xor rdx, rdx
    div rcx
    add rax, r13

	mov [rand_x], rax
    
	call get_random
	add r14, rax

    mov rax, [ymax]
    mov rcx, 2
    xor rdx, rdx
    div rcx
    add rax, r14

	mov [rand_y], rax
	


	;; Перемещаем курсор в случайную позицию
	mov rdi, [rand_y]
	mov rsi, [rand_x]
	call move

	;; Печатаем случайный символ в палитре
	mov  rdi, [palette]
	call addch
	;; 	call insch
	
	;; Задержка
	mov rdi, 100000
	call mydelay

	;; Обновляем экран и количество выведенных знакомест в заданной палитре
	call refresh
		 
    ;;Задаем таймаут для getch
	mov rdi, 1
	call timeout
	call getch
    
    ;;Анализируем нажатую клавишу
	cmp rax, 'q'
	je next
	jmp mloop
next:	
	call endwin
	call exit

;;Анализируем количество выведенных знакомест в заданной палитре, меняем палитру, если количество больше 10000

;;Выбираем случайную цифру
