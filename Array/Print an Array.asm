;-------------------------------
;PRINT ALL ELEMENTS OF AN ARRAY
;-------------------------------

.MODEL SMALL
.STACK 100H

.DATA
    ARR DW 1, 22, 333, 4, 55, 6, 77, 888, 99  ; ARRAY WITH SINGLE, DOUBLE, AND TRIPLE-DIGIT NUMBERS
    N DW 9                                     ; NUMBER OF ELEMENTS
    SPACE DB ' $'                              ; SPACE SEPARATOR
    BUFFER DB 10 DUP('$')                     ; BUFFER FOR NUMBER-TO-STRING CONVERSION

.CODE
MAIN PROC
    MOV AX, @DATA         ; INITIALIZE DATA SEGMENT
    MOV DS, AX
    
    MOV CX, N             ; LOOP COUNTER = NUMBER OF ELEMENTS
    MOV SI, 0            ; ARRAY INDEX (0-BASED)

PRINT_LOOP:
    MOV AX, ARR[SI]      ; LOAD ARRAY ELEMENT (WORD-SIZED)
    
    CALL PRINT_NUMBER    ; PRINT THE NUMBER
    
    ; PRINT SPACE SEPARATOR (EXCEPT AFTER LAST ELEMENT)
    CMP CX, 1            ; CHECK IF LAST ELEMENT
    JE NO_SPACE          ; SKIP SPACE IF LAST
    MOV AH, 09H
    LEA DX, SPACE
    INT 21H
    
NO_SPACE:
    ADD SI, 2            ; MOVE TO NEXT ELEMENT (DW = 2 BYTES)
    LOOP PRINT_LOOP
    
    MOV AH, 4CH          ; TERMINATE PROGRAM
    INT 21H
MAIN ENDP

; ========== PRINT NUMBER IN AX ==========
PRINT_NUMBER PROC
    LEA DI, BUFFER + 9   ; POINT TO END OF BUFFER
    MOV [DI], '$'        ; STRING TERMINATOR
    MOV BX, 10           ; DIVISOR FOR BASE-10 CONVERSION

CONVERT:
    XOR DX, DX           ; CLEAR DX FOR DIVISION
    DIV BX               ; AX = AX/10, DX = REMAINDER
    ADD DL, '0'          ; CONVERT TO ASCII
    DEC DI               ; MOVE BACK IN BUFFER
    MOV [DI], DL         ; STORE DIGIT
    TEST AX, AX          ; CHECK IF QUOTIENT IS ZERO
    JNZ CONVERT          ; CONTINUE IF NOT

    ; PRINT THE NUMBER
    MOV AH, 09H
    MOV DX, DI
    INT 21H
    RET
PRINT_NUMBER ENDP

END MAIN