.MODEL SMALL
.STACK 100H

.DATA
    ; Array with word-sized elements (supports values up to 65535)
    ARRAY    DW 011h, 022h, 033h, 044h, 055h, 066h, 077h, 088h, 099h, 100h
    LEN      EQU ($ - ARRAY)/2           ; Number of elements (DW = 2 bytes each)
    ADD_VAL  DW 10                       ; Value to add (word-sized)
    
    ; Messages
    ORIG_MSG DB 'Original array: $'
    MOD_MSG  DB 13,10,'After adding 10: $'
    SPACE    DB ' $'
    NEWLINE  DB 13,10,'$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; ====== PRINT ORIGINAL ARRAY ======
    MOV AH, 09H
    LEA DX, ORIG_MSG
    INT 21H
    CALL PRINT_ARRAY

    ; ====== ADD 10 TO ALL ELEMENTS ======
    MOV SI, 0
    MOV CX, LEN
ADD_LOOP:
    MOV AX, ARRAY[SI]      ; Load word-sized element
    ADD AX, ADD_VAL        ; Add 10 (word-sized addition)
    MOV ARRAY[SI], AX      ; Store back in array
    ADD SI, 2              ; Move to next word-sized element
    LOOP ADD_LOOP

    ; ====== PRINT MODIFIED ARRAY ======
    MOV AH, 09H
    LEA DX, MOD_MSG
    INT 21H
    CALL PRINT_ARRAY

    ; Exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP

PRINT_ARRAY PROC
    MOV SI, 0
    MOV CX, LEN
PRINT_LOOP:
    MOV AX, ARRAY[SI]      ; Load word-sized element
    CALL PRINT_NUM
    MOV AH, 09H
    LEA DX, SPACE
    INT 21H
    ADD SI, 2              ; Next word element
    LOOP PRINT_LOOP
    RET
PRINT_ARRAY ENDP

; ====== PRINT NUMBER (0-65535) ======
; Input: AX = number to print
PRINT_NUM PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ; Handle zero case
    CMP AX, 0
    JNE NON_ZERO
    MOV DL, '0'
    MOV AH, 02H
    INT 21H
    JMP PRINT_DONE

NON_ZERO:
    ; Count digits
    MOV CX, 0              ; Digit counter
    MOV BX, 10             ; Divisor
    
COUNT_LOOP:
    INC CX
    XOR DX, DX             ; Clear DX for division
    DIV BX                 ; AX = quotient, DX = remainder
    PUSH DX                ; Save digit
    CMP AX, 0
    JNE COUNT_LOOP

    ; Print digits
PRINT_LOOP1:
    POP DX
    ADD DL, '0'            ; Convert to ASCII
    MOV AH, 02H
    INT 21H
    LOOP PRINT_LOOP1

PRINT_DONE:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUM ENDP

END MAIN