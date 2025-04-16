.MODEL SMALL
.STACK 100H

.DATA
    ARR DB 1, 2, 3, 4, 5, 6, 7,4,3,2,5,6,3,1,2   ; Array to reverse
    LEN EQU $ - ARR               ; Calculate length automatically
    SPACE DB ' $'                 ; Space for printing

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; === REVERSE ARRAY IN-PLACE ===
    MOV SI, 0                ; Start index
    MOV DI, LEN - 1          ; End index

REVERSE_LOOP:
    CMP SI, DI
    JAE DISPLAY              ; Stop when pointers cross

    ; Swap elements
    MOV AL, ARR[SI]
    MOV BL, ARR[DI]
    MOV ARR[SI], BL
    MOV ARR[DI], AL

    ; Move pointers
    INC SI
    DEC DI
    JMP REVERSE_LOOP

DISPLAY:
    MOV CX, LEN             ; Counter for printing
    MOV SI, 0               ; Reset index

PRINT_LOOP:
    ; Load and print number
    MOV AL, ARR[SI]
    CALL PRINT_NUM

    ; Print space (except after last number)
    CMP SI, LEN - 1
    JE SKIP_SPACE
    MOV DX, OFFSET SPACE
    MOV AH, 09H
    INT 21H

SKIP_SPACE:
    INC SI
    LOOP PRINT_LOOP

    ; Exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; === PRINT NUMBER IN AL (0-99) ===
PRINT_NUM PROC
    MOV AH, 0               ; Clear AH
    MOV BL, 10              ; Divisor
    DIV BL                  ; AL=quotient, AH=remainder

    ; Print tens digit (if any)
    OR AL, AL               ; Check if zero
    JZ PRINT_DIGIT          ; Skip if zero
    ADD AL, '0'             ; Convert to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H

PRINT_DIGIT:
    ; Print units digit
    MOV DL, AH
    ADD DL, '0'
    MOV AH, 02H
    INT 21H

    RET
PRINT_NUM ENDP

END MAIN