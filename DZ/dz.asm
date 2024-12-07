;Структура:  ['Очередь']                            +
;Метод выделения памяти:  ['Куча']                  +
;Список функций (действий):  
;['Добавление в конец',                             +
;'Удаление из начала',                              +
;'Заполнение случайными числами',                   +
;'Подсчет количества чисел, оканчивающихся на 1',   +
;'Подсчет количества простых чисел', 
;'Подсчет количества четных чисел']                 +

format ELF64

public qNew
public qDelete
public qPush
public qPop
public qFillRandom
public qCountEndingWithOne
public qCountEvenNumbers
public qCountPrimeNumbers

section '.bss' writable
    ; for queue
    head rq 1
    tail rq 1
    size rq 1
    ;for random
    number rq 1
    place rb 100
section '.data' writable
    f  db "/dev/urandom", 0

section '.text' executable
qNew:
    xor rdi,rdi             ; brk
    mov rax, 12             ; В ассемблере, если вызвать brk с addr(rdi) = 0, 
    syscall                 ; то также будет возвращено текущее значение точки останова.
    mov [head], rax
    mov [tail], rax
    ret

qDelete:
    .loop:
    mov rax, [head]
    cmp rax, [tail]
    jge .fin
    mov rdi, [tail]
    sub rdi, 8              ; идем по 8 байт назад и переставляем
    mov rax, 12             ; точку останова динамической памяти
    syscall                 ; пока голова и хвостик не будут равны
    ; новый хвостик
    mov [tail], rax
    jmp .loop
    .fin:
    ret

qPush:
    push rdi
    mov rdi, [tail]
    add rdi, 8              ; + 8 байт и ставим там точку дин. памяти
    mov rax, 12
    syscall
    mov [tail], rax
    pop rdi
    sub rax, 8
    mov [rax], rdi
    inc [size]
    ret

qPop:
    mov rax, [head]
    cmp rax, [tail]
    ; пусто???
    jge .pusto

    mov r8, [rax]       ; сохранили отстоявшего свою очередь
    push r8

    ;  цикликом двигаем всю очередь
    mov rdx, rax
    add rdx, 8
    .loop:
    mov rsi, [rdx]
    mov [rax], rsi
    add rax, 8          ; адрес куда
    add rdx, 8          ; адрес откуда
    cmp rax, [tail]
    jl .loop
    ; удаляем хвостик 
    mov rdi, [tail]
    mov rax, 12
    syscall
    ; новый хвостик
    sub rax, 8
    mov [tail], rax
    .pusto:
    dec [size]
    pop r8
    mov rax, r8
    ret

qCountEndingWithOne:
    xor rcx, rcx
    xor rdi, rdi
    mov rdx, [head]         ; сохранили голову(не будем казнить) в rdx
    CEWOloop:               ; идем по памяти по +8 байт и проверяем на...
        mov rax, rdx
        mov rax, [rax]
        ; проверка на 1 в конце
        push rdx
        xor rdx, rdx
        mov rbx, 10
        div rbx
        cmp rdx, 1
        je CEWOcount
        ; конец проверки
        CEWOnext:
        pop rdx
        add rdx, 8
        inc rcx
        cmp rcx, [size] 
    jne CEWOloop
    mov rax, rdi
    ret
    CEWOcount:
        inc rdi
        jmp CEWOnext

qCountEvenNumbers:
    xor rcx, rcx
    xor rdi, rdi
    mov rdx, [head]
    CENloop:                ; идем по памяти по +8 байт и проверяем на...
        mov rax, rdx
        mov rax, [rax]
        ; проверка на четность
        push rdx
        xor rdx, rdx
        mov rbx, 2
        div rbx
        cmp rdx, 0
        je CENcount
        ; конец проверки
        CENnext:
        pop rdx
        add rdx, 8
        inc rcx
        cmp rcx, [size] 
    jne CENloop
    mov rax, rdi
    ret
    CENcount:
        inc rdi
        jmp CENnext

qCountPrimeNumbers:
    xor rcx, rcx
    xor rsi, rsi
    mov rdx, [head]
    CPNloop:                ; идем по памяти по +8 байт и проверяем на...
        mov rax, rdx
        mov rax, [rax]
        call is_prime       ; простое?
        add rsi, rdi        ; если да то rdi = 1, иначе 0
        add rdx, 8
        inc rcx
        cmp rcx, [size] 
    jne CPNloop
    mov rax, rsi
    ret

;input rax - the number
;output rdi - 1 - prime number, 0 - composite number
is_prime:
  push rax
  push rbx
  push rcx
  push rdx

  cmp rax, 2
  je .a1
  
  mov rbx, 2
  mov rdi, rax
  xor rdx, rdx
  div rbx
  mov rcx, rax

  .loop:
    mov rax, rdi
    xor rdx, rdx
    div rbx
    inc rbx
    cmp rdx, 0
    je .a2
    cmp rcx, rbx
    jge .loop
  .a1:
    mov rdi, 1
    jmp .a3
  .a2:
    mov rdi, 0
    jmp .a3
  .a3:
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

qFillRandom:
    mov rcx, rdi
    .lp:
        push rcx
        call gen_random       ; колдуем случайное число
        mov rdi, rax
        call qPush
        pop rcx
    loop .lp
    ret


gen_random:
    mov rdi, f
    mov rax, 2 
    mov rsi, 0o
    syscall 
    cmp rax, 0 
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

