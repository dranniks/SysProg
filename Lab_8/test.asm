format elf64
public _start

extrn scanf
extrn printf
extrn exact_value

include 'func.asm'

section '.data' writeable

    f db "n  |sum       |precision", 0xa, "%d  |%f  |%f", 0xa, 0
    input_f db "%lf", 0
    prt db "%f", 0xa, 0
    prtn db "%d", 0xa, 0
    temp dq 1.0
    n dq 1.0
    xxx dq 1.0
    result dq 1
    total dq 1
    ideal dq 1
    precision dq 0.00001
    difference dq 1


section '.bss' writable ; секция бесов
    
    x rq 1


section '.text' executable

_start:

    ; scanf
    mov rdi, input_f
    mov rsi, x
    movq xmm0, rsi
    mov rax, 1
    call scanf ; получем x

    mov rdi, input_f
    mov rsi, precision
    movq xmm0, rsi
    mov rax, 1
    call scanf ; получем x

    ; printf
    ;mov rdi, prt 
    ;movq xmm0, [x]
    ;mov rax, 1 
    ;call printf

    ; считаем в С ту жуть
    movq xmm0, [x]
    call exact_value ; (0.25 * log((1 + x) / (1 - x))) + (0.5 * atan(x))
    movq [ideal], xmm0

    ; printf
    mov rdi, prt 
    movq xmm0, [ideal]
    mov rax, 1 
    call printf ; вывод результата того страшного выражения

    movq xmm0, [x]
    movq [total], xmm0

    xor rdx, rdx
    mov rdx, 1
   
    ; тут типо начнется цикл
    loopchik:

        mov [n], rdx
        push rdx
        mov rax, 4
        mov rbx, [n]
        mul rbx
        add rax, 1
        mov [temp], rax ; 4n+1
        pop rdx

        movq xmm0, [x]
        movq [xxx], xmm0

        ffree st0
        ffree st1
        fld [xxx]
        fld [xxx]
        
        mov rcx, [temp]
        dec rcx
        .lp:
            fmul st0, st1
        LOOP .lp
        fstp [result]
        
        ffree st0
        fild [temp]
        fstp [temp]

        ffree st0
        ffree st1
        fld [temp]
        fld [result]
        fdiv st0, st1
        fstp [result]
        
        ffree st0
        ffree st1
        fld [total]
        fld [result]
        fadd st0, st1
        fstp [total]

        ffree st0
        ffree st1
        fld [total]
        fld [ideal]
        fsub st0, st1
        fstp [difference]

        ffree st0
        fld [difference]
        fabs
        fstp [difference]

        inc rdx
        ;mov rdi, prt
        ;movq xmm0, [difference]
        ;call printf

        ffree st0
        ffree st1
        fld [precision]
        fld [difference]   
        fcomi st0, st1
    ja loopchik

    mov [n], rdx
    ;mov rdi, prtn
    ;mov rsi, [n]
    ;call printf    

    ;mov rdi, prt
    ;movq xmm0, [total]
    ;call printf

    movq xmm0, [total]
    mov rsi, [n]
    movq xmm1, [precision]
    mov rdi, f
    call printf
    


    mov rax, 60
    mov rdi, 0
    syscall