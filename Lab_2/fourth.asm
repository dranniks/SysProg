format ELF64
public _start
public print
public print_symbl

section '.data' writable
  num dq 1019734634
  place db ?

section '.code' executable
_start:
    mov rax, [num]
    mov rcx, 10
    mov rbx, 0
    iter0:
        mov rdx, 0
        div rcx

        add rbx, rdx

        cmp rax, 0
        jne iter0

    push rax
    push rbx
    push rcx
    push rdx
    call print
    pop rdx
    pop rcx
    pop rbx
    pop rax
    call exit

section '.print' executable
print:
    mov rax, rbx
    mov rcx, 10
    mov rbx, 0
    iter1:
      mov rdx, 0
      div rcx
      add rdx, '0'
      push rdx
      inc rbx
      cmp rax,0
    jne iter1
    iter2:
      pop rax
      call print_symbl
      dec rbx
      cmp rbx, 0
    jne iter2
    mov rax, 0xA
    call print_symbl
    ret


section '.print_symbl' executable   
   print_symbl:
     push rbx
     push rdx
     push rcx
     push rax
     push rax
     mov eax, 4
     mov ebx, 1
     pop rdx
     mov [place], dl
     mov ecx, place
     mov edx, 1
     int 0x80
     pop rax
     pop rcx
     pop rdx
     pop rbx
     ret

exit:
    mov rax, 1
    mov rbx, 0
    int 0x80