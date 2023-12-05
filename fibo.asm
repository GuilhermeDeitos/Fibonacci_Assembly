;Trabalho Fibonacci Guilherme Deitos e Gabriel Yudi
%define maxChars 3

section .data
    strPrint : db "Digite o numero para calcularmos o fibonacci: "
    strPrintL : equ $ - strPrint

    strError : db "Erro ao calcular o fibonacci, verifique a entrada"
    strErrorL : equ $ - strError

    strLF  : db 10 ; quebra de linha
    strLFL : equ 1

    strNomeArq: db "fib("
    strDotBin: db ").bin"
section .bss
    strInput : resb maxChars
    strInputL : equ $ - strInput
    fileHandle : resd 1
    n1: resd 1
    n2: resd 1
    numFibo : resb 2
    buffer  : resb 32
    newFileName : resb 32  ; Novo nome do arquivo
    fib_arq : resq 1



section .text
    global _start


_start:

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



verificaTamanho:
    cmp byte [strInput], 0xa
    je fim

    cmp byte [strInput + 1], 0xa
    je nome1Digito

    cmp byte [strInput + 2], 0xa
    je nome2Digitos

    jmp writeArqError

nome1Digito:
    mov al, [strInput]
    mov rbx, [strNomeArq]
    mov [newFileName], rbx
    mov [newFileName + 4], al
    mov rbx, [strDotBin]
    mov [newFileName + 5], rbx
    mov bl, [strDotBin + 4]
    mov [newFileName + 9], bl  

nome2Digitos:
    mov cl, [strInput + 1]
        mov al, [strInput]
        mov rbx, [strNomeArq]
        mov [newFileName], rbx
        mov [newFileName + 4], al 
        mov [newFileName + 5], cl 
        mov rbx, [strDotBin] 
        mov [newFileName + 6], rbx
        mov bl, [strDotBin + 4]
        mov [newFileName + 10], bl


    ; Abrir arquivo
    mov rax, 2
    lea rdi, [newFileName]
    mov rsi, 102o  ; createOpenR
    mov rdx, 644o  ; userPermissions
    syscall
    mov [fileHandle], rax


tratandoValores:
    mov r9b, byte [strInput]
    sub r9b, '0' ;transforma o valor em inteiro
    mov r10b, byte [strInput+1]

    cmp r10b, 0xa; Verifica se é enter
    je auxiliar ;Caso tenha 1 digito, já passa para o verifica limites, caso tenha 2, é tratado isso com o r10d


    mov r10b, byte [strInput+1] 
    sub r10b, '0'                ; Transforma o valor em inteiro

    mov rax, 0xa
    mul r9b
    add eax, r10d
    jmp verificaLimites

auxiliar:
    mov eax, r9d


verificaLimites:

    cmp ax, 99
    jle calcFibo

    cmp ax, 0
    jge calcFibo

    jmp writeArqError


calcFibo:
    mov byte[n1], 0
    cmp ax, 0
    je writeArq

    mov byte [n1], 1; f(n-1)
    mov byte [n2], 1; f(n-2)

    cmp ax, 1
    je writeArq

    cmp ax, 2
    je writeArq


forFibo:
    mov r11d, [n1]
    mov r12d, [n2]
    add r12d, [n1]
    mov [n1], r12d
    mov [n2], r11d
    cmp eax, 3
    je writeArq
    dec eax
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
    