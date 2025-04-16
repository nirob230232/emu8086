;-----------------------------
;TAKE AN ARRAY AS INPUT AND PRINT IT
;------------------------------

.MODEL SMALL
.STACK 100H

.DATA
    ARR DW 5 DUP(?)      ; ARRAY TO STORE NUMBERS (WORD-SIZED FOR MULTI-DIGIT)
    N DW 5               ; NUMBER OF ELEMENTS
    PROMPT DB 'ENTER NUMBERS (PRESS SPACE AFTER EACH): $'
    NEWLINE DB 13,10,'$'
    SPACE DB ' $'
    BUFFER DB 10 DUP(0)  ; BUFFER FOR NUMBER CONVERSION
    TEMP DW ?            ; TEMPORARY STORAGE

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; DISPLAY PROMPT
    MOV AH, 09H
    LEA DX, PROMPT
    INT 21H

    ; INPUT LOOP
    MOV CX, N
    MOV SI, 0
INPUT_LOOP:
    CALL READ_NUMBER     ; READ MULTI-DIGIT NUMBER
    MOV ARR[SI], AX      ; STORE IN ARRAY
    ADD SI, 2            ; NEXT ARRAY POSITION (WORD-SIZED)
    LOOP INPUT_LOOP

    ; PRINT NEWLINE
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H

    ; OUTPUT LOOP
    MOV CX, N
    MOV SI, 0
PRINT_LOOP:
    MOV AX, ARR[SI]      ; LOAD NUMBER
    CALL PRINT_NUMBER    ; PRINT NUMBER
    MOV AH, 09H
    LEA DX, SPACE        ; PRINT SPACE
    INT 21H
    ADD SI, 2            ; NEXT ARRAY POSITION
    LOOP PRINT_LOOP

    ; EXIT PROGRAM
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; ====== READ MULTI-DIGIT NUMBER (RETURNS IN AX) ======
READ_NUMBER PROC
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    XOR BX, BX           ; CLEAR BX (WILL STORE RESULT)
    MOV SI, 0            ; BUFFER INDEX

READ_DIGIT:
    MOV AH, 01H          ; READ CHARACTER
    INT 21H

    CMP AL, 32           ; CHECK FOR SPACE (END OF NUMBER)
    JE END_READ
    CMP AL, 13           ; CHECK FOR ENTER (END OF NUMBER)
    JE END_READ

    SUB AL, '0'          ; CONVERT TO DIGIT
    MOV AH, 0
    MOV TEMP, AX         ; STORE DIGIT

    MOV AX, BX           ; CURRENT TOTAL
    MOV CX, 10
    MUL CX               ; AX = AX * 10
    ADD AX, TEMP         ; ADD NEW DIGIT
    MOV BX, AX           ; STORE BACK IN BX

    JMP READ_DIGIT

END_READ:
    MOV AX, BX           ; RETURN RESULT IN AX
    POP SI
    POP DX
    POP CX
    POP BX
    RET
READ_NUMBER ENDP

; ====== PRINT NUMBER (AX CONTAINS NUMBER) ======
PRINT_NUMBER PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    LEA SI, BUFFER + 9   ; POINT TO END OF BUFFER
    MOV [SI], '$'        ; STRING TERMINATOR
    MOV BX, 10           ; DIVISOR

CONVERT_LOOP:
    XOR DX, DX           ; CLEAR DX FOR DIVISION
    DIV BX               ; AX = AX/10, DX = REMAINDER
    ADD DL, '0'          ; CONVERT TO ASCII
    DEC SI               ; MOVE BACK IN BUFFER
    MOV [SI], DL         ; STORE DIGIT
    TEST AX, AX          ; CHECK IF QUOTIENT IS ZERO
    JNZ CONVERT_LOOP

    ; PRINT THE NUMBER
    MOV AH, 09H
    MOV DX, SI
    INT 21H

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUMBER ENDP

END MAIN