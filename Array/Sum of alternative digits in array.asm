.MODEL SMALL
.STACK 100H

.DATA
    ARRAY   DW 1,2,3,4,5,6,7,8  ; 3-digit numbers
    COUNT   EQU ($ - ARRAY)/2         ; Number of elements
    SUM     DW 0                      ; 16-bit sum storage
    MSG     DB 'Sum of alternate elements: $'
    NL      DB 13,10,'$'

.CODE
MAIN PROC
    MOV AX, @DATA         ; Initialize DS
    MOV DS, AX

    ; Calculate sum of alternate elements
    MOV CX, (COUNT + 1)/2 ; Number of alternate elements
    MOV SI, 0             ; Start at first element
    XOR AX, AX            ; Clear accumulator

SUM_LOOP:
    ADD AX, ARRAY[SI]     ; Add element to sum
    ADD SI, 4             ; Skip next element (each DW = 2 bytes)
    LOOP SUM_LOOP

    MOV SUM, AX           ; Store result

    ; Display result
    MOV AH, 09H
    LEA DX, MSG
    INT 21H
    
    MOV AX, SUM
    CALL PRINT_NUMBER     ; Display sum
    
    MOV AH, 09H
    LEA DX, NL
    INT 21H

    MOV AH, 4CH           ; Exit to DOS
    INT 21H
MAIN ENDP

; Prints number in AX (0-65535)
PRINT_NUMBER PROC
    PUSHA                 ; Save all registers
    
    ; Handle zero case
    TEST AX, AX
    JNZ NON_ZERO
    MOV DL, '0'
    MOV AH, 02H
    INT 21H
    JMP DONE

NON_ZERO:
    ; Count digits and push them onto stack
    MOV CX, 0             ; Digit counter
    MOV BX, 10            ; Divisor
DIGIT_LOOP:
    XOR DX, DX            ; Clear DX for division
    DIV BX                ; AX = quotient, DX = remainder
    PUSH DX               ; Save digit
    INC CX                ; Count digits
    TEST AX, AX           ; Check if quotient is zero
    JNZ DIGIT_LOOP

    ; Pop and print digits
PRINT_LOOP:
    POP DX
    ADD DL, '0'           ; Convert to ASCII
    MOV AH, 02H
    INT 21H
    LOOP PRINT_LOOP

DONE:
    POPA                  ; Restore registers
    RET
PRINT_NUMBER ENDP

END MAIN