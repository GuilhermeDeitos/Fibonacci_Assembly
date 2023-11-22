;Trabalho Fibonacci Guilherme Deitos e Gabriel Yudi
%define maxChars 3
%define createOpenR 101o
%define userPermissions 644o 

section .data
    strPrint : db "Digite o numero para calcularmos o fibonacci: "
    strPrintL : equ $ - strPrint

    strError : db "Erro ao calcular o fibonacci, verifique a entrada"
    strErrorL : equ $ - strError

    strNomeArq: db "./fibonacci.bin"
section .bss
    strInput : resb maxChars
    strInputL : equ $ - strInput
    fileHandle : resd 1
    numFibo : resb 2

    resultFibonacci : resd 8
    resultFibonacciL : equ $ - resultFibonacci

section .text
    global _start


_start:

openArq:
    mov rax, 2
    lea rdi, [strNomeArq]
    mov rsi, createOpenR
    mov rdx, userPermissions
    syscall

    mov [fileHandle], rax

write:
    mov rax, 1
    mov rdi, 1
    lea rsi, [strPrint]
    mov edx, strPrintL
    syscall 

read:
    mov rax, 0
    mov rdi, 1
    lea rsi, [strInput]
    mov rdx, strInputL
    syscall

    mov ax, [strInput]


tratandoValores:
    sub ah, '0'
    sub al, '0'
    mov [numFibo], ax
    

verificaLimites:
    cmp ax, 99
    jle calcFibo

    cmp ax, 0
    jge calcFibo

    jmp writeArqError


calcFibo:
    mov r8d, 0  ;f(n-2)
    mov r9d, 1  ;f(n-1)
    mov r10d, 1 ;f(n)

    cmp ax, 1
    je writeArq

forFibo:
    mov r10d, r8d
    add r10d, r9d
    mov r8d, r9d
    mov r9d, r10d

    
    dec ax
    jnz forFibo

writeArqError:
    mov rax, 1
    mov rdi, 1
    lea rsi, [strError]
    mov edx, strErrorL
    syscall
    jmp fecharArq

writeArq:
    mov [resultFibonacci], r10d
    mov rax, 1
    mov rdi, [fileHandle]
    lea rsi, [resultFibonacci]
    mov edx, resultFibonacciL
    syscall



fecharArq:
    mov rax, 3
    mov rdi, [fileHandle]
    syscall


fim:
    mov rax, 60
    mov rdi, 0
    syscall
    