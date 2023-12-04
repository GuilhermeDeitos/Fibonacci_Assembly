;Trabalho Fibonacci Guilherme Deitos e Gabriel Yudi
%define maxChars 10

section .data
    strPrint : db "Digite o numero para calcularmos o fibonacci: "
    strPrintL : equ $ - strPrint

    strError : db "Erro ao calcular o fibonacci, verifique a entrada"
    strErrorL : equ $ - strError

    strLF  : db 10 ; quebra de linha
    strLFL : equ 1

    strNomeArq: db "fib(n).bin"
section .bss
    strInput : resb maxChars
    strInputL : equ $ - strInput
    fileHandle : resd 1
    n1: resd 1
    n2: resd 1
    numFibo : resb 2
    buffer  : resb 32


    resultFibonacci : resd 8
    resultFibonacciL : equ $ - resultFibonacci

section .text
    global _start


_start:

openArq:
    ; Abrir arquivo
    mov rax, 2
    lea rdi, [strNomeArq]
    mov rsi, 102o  ; createOpenR
    mov rdx, 644o  ; userPermissions
    syscall
    mov [fileHandle], rax

write:
    mov rax, 1
    mov rdi, 1
    lea rsi, [strPrint]
    mov edx, strPrintL
    syscall 

read:
    ; Ler input do usuário
    mov rax, 0
    mov rdi, 0
    lea rsi, [strInput]
    mov rdx, strInputL
    syscall


tratandoValores:
    mov r9b, byte [strInput]
    sub r9b, '0' ;transforma o valor em inteiro
    mov r10b, byte [strInput+1]

    cmp r10d, 0xa; Verifica se é enter
    je verificaLimites ;Caso tenha 1 digito, já passa para o verifica limites, caso tenha 2, é tratado isso com o r10d


    mov r10b, byte[strInput]
    sub r10d, '0' ;transforma o valor em inteiro

    mov rax, 0xa
    mul r9d
    add eax, r10d 

verificaLimites:
    cmp ax, 99
    jle calcFibo

    cmp ax, 0
    jge calcFibo

    jmp writeArqError


calcFibo:
    cmp byte [strInput], 1
    je writeArq

    cmp byte [strInput], 2
    je writeArq

    mov byte [n1], 1; f(n-2)
    mov byte [n2], 1; f(n-2)
    mov r13d, 3

forFibo:
    mov r11d, [n1]
    mov r12d, [n1]
    add r12d, [n1]
    mov [n1], r12d
    mov [n2], r11d
    cmp r13d, 0
    je writeArq
    inc r13d
    jnz forFibo

limpabuffer:
    ; lê 32 byte (32 char) do buffer
    mov rax, 0
    mov rdi, 0
    lea rsi, buffer
    mov edx, 32
    syscall

    mov r9, 0       
    
writeArqError:
    mov rax, 1
    mov rdi, 1
    lea rsi, [strError]
    mov edx, strErrorL
    syscall
    jmp fecharArq

writeArq:
    mov rax, 1
    mov rdi, [fileHandle]
    lea rsi, [n1]
    mov edx, 4
    syscall



fecharArq:
    mov rax, 3
    mov rdi, [fileHandle]
    syscall


fim:
    mov rax, 60
    mov rdi, 0
    syscall
    