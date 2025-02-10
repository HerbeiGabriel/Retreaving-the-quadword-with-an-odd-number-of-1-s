bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...                           
    A dq 1, 2, 3, 4, 14
    l equ ($-A)/8;                  The length of string A
    D resb l;                       An empty string
; our code starts here
segment code use32 class=code
    start:
    ; ...
    mov esi, 0;                     keeps the current position of the element in the source string for the bytes(A)
    mov edi, 0;                     keeps the current position of the element in the source string but for the quadwords (A)
    mov ebx, 0;                     keeps the current position of the element in the destination string for the quadwords (D)
    mov ecx, l*8;                   shows how many times the loop should repeat (l*8-in bytes)
    mov dl, 8;                      lenght of a quadword
    mov dh, 0;                      number of bytes in a quadword
    
    repeat:
        mov al, byte[A+esi]
        shift:
            clc
            shl al, 1
            adc dh, 0
            clc
            cmp al, 0
            je final
            jne shift
    final:
        add esi, 1;                 adds to the source
        sub dl, 1    
        cmp dl, 0;                  check if the quadword was 
        je dmek
        loop repeat
        
    dmek:
        test dh, 0001b;             checks if the number dh is odd or even
        jnz impar
        jz par
    
    impar:
        mov edx, [A+esi-4]
        mov eax, [A+esi-8]
        mov [D+edi+0], eax;         moves in D the quadword with an odd numbers of 1-s in binary
        mov [D+edi+4], edx;         moves in D the quadword with an odd numbers of 1-s in binary
        mov dl, 8;                  reset dl
        mov dh, 0;                  reset dh
        add edi, 8
        loop repeat
        
    par:
        mov dl, 8
        mov dh, 0
        loop repeat
        

    
    
    
    
    
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
