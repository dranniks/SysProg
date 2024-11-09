format elf64
public _start

include 'func.asm'

section '.bss' writable
  
  buffer rb 2

_start:
  pop rcx 
  cmp rcx, 1 
  je .l1 

  mov rdi,[rsp+8] 
  mov rax, 2 
  mov rsi, 0o 
  syscall 
  cmp rax, 0 
  jl .l1 
  
  mov r8, rax
  
  mov rdi,[rsp+16] 
  mov rax, 2 
  ;;Формируем O_WRONLY|O_TRUNC|O_CREAT
  mov rsi, 577
  mov rdx, 777o
  syscall 
  cmp rax, 0 
  jl .l1
  
  mov r12, rax

  mov rax, 8
  mov rdi, r8
  mov rsi, 0
  mov rdx, 2
  syscall
  mov r10, rax ;сохраняем длину файла


.loop: 
   cmp r10, 0
   jl .l2
   mov rax, 0
   mov rdi, r8
   mov rsi, buffer
   mov rdx, 1 
   syscall 
   cmp rax, 0         ; проверяем, был ли прочитан байт
   
   mov [buffer+1], 0
   mov rax, 1
   mov rdi, r12
   mov rsi, buffer
   syscall
   dec r10
   mov rax, 8
   mov rdi, r8
   mov rsi, r10
   mov rdx, 0
   syscall
   jmp .loop
   
.l2:
  call new_line
  mov rdi, r8
  mov rax, 3
  syscall

.l1:
  call exit