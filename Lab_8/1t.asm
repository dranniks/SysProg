  ;mov rdi, output_f 
  ;movq xmm0, [x]
  ;mov rax, 1 
  ;call printf ; вывод x

  ;mov rdi, output_f 
  ;movq xmm0, [n]
  ;mov rax, 1 
  ;call printf ; вывод n



format elf64
public _start

extrn printf
extrn exact_value
extrn pow
extrn scanf

include 'func.asm'

section '.data' writeable ; секция даты, типо 20.12.24

  input_f db "%lf", 0
  input_i db "%d", 0
  output_f db "%lf", 0xa, 0
  output_i db "%d", 0xa, 0
  four dq 4
  one dq 1
  n dq 1


section '.bss' writable ; секция бесов
  temp rq 1
  x rq 1
  result rq 1

section '.text' executable

_start:

  ; scanf
  mov rdi, input_f
  mov rsi, x
  movq xmm0, rsi
  mov rax, 1
  call scanf ; получем x

  ; считаем в С ту жуть
  movq xmm0, [x]
  call exact_value ; (0.25 * log((1 + x) / (1 - x))) + (0.5 * atan(x))
  movq [result], xmm0

  ; printf
  mov rdi, output_f 
  movq xmm0, [result]
  mov rax, 1 
  call printf ; вывод результата того страшного выражения

  ; scanf
  ;mov rdi, input_f
  ;mov rsi, n
  ;movq xmm0, rsi
  ;mov rax, 1
  ;call scanf ; получем n

  ; (x^4*n + 1) / (4*n + 1)

  ffree st0 
  ffree st1
  fld [four] 
  fld [n]
  fmul st0, st1
  fstp [temp]

  movq xmm0, [temp] 
  mov rax, 1
  mov rdi, output_f
  call printf

  ffree st0 
  ffree st1
  fld [temp] 
  fld [one]
  fadd st0, st1
  fstp [temp]

  mov rdi, output_f
  movq xmm0, [temp] 
  mov rax, 1
  call printf

  call new_line

  xor rbx, rbx
  mov rsi, [temp]
  call print_str
  
  power_loop:
    inc rbx
  LOOP power_loop



; вот и пришел конец
call exit