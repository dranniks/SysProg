;Структура:  ['Очередь']
;Метод выделения памяти:  ['Куча']
;Список функций (действий):  
;['Добавление в конец', 
;'Удаление из начала', 
;'Заполнение случайными числами', 
;'Подсчет количества чисел, оканчивающихся на 1', 
;'Подсчет количества простых чисел', 
;'Подсчет количества четных чисел']

format ELF64

public new_queue
public del_queue
public q_push
public q_pop


section '.bss' writable
head rq 1
tail rq 1
num rb 1
size rq 1
f db "/dev/random", 0

section '.text' executable

new_queue:
xor rdi,rdi
mov rax, 12
syscall
mov [head], rax
mov [tail], rax
ret

del_queue:
.loop:
mov rax, [head]
cmp rax, [tail]
jge .fin
mov rdi, [tail]
sub rdi, 8
mov rax, 12
syscall
; новый хвостик
mov [tail], rax
jmp .loop
.fin:
ret

q_push:
push rdi
mov rdi, [tail]
add rdi, 8
mov rax, 12
syscall
mov [tail], rax
pop rdi
sub rax, 8
mov [rax], rdi
inc [size]
ret

q_pop:
; проверка на пустоту
mov rax, [head]
cmp rax, [tail]

jge .fin

mov r8, [rax]
push r8

; идем циклом и смещаем все на один вперед 
mov rdx, rax
add rdx, 8
.loop:
mov rsi, [rdx]
mov [rax], rsi
add rax, 8
add rdx, 8
cmp rax, [tail]
jl .loop
; удаляем хвостик 
mov rdi, [tail]
;sub rdi, 8
mov rax, 12
syscall
; новый хвостик
sub rax, 8
mov [tail], rax
.fin:
dec [size]
pop r8
mov rax, r8
ret