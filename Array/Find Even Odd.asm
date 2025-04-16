.MODEL SMALL
.STACK 100H

.DATA
    ARR DW 123, 45, 6, 78, 99, 100, 255, 34  ; Array with 3-digit numbers
    N DW 8                                   ; Number of elements
    MSG1 DB "ODD NUMBERS: $"
    MSG2 DB 13,10,"EVEN NUMBERS: $"
    BUFFER DB 10 DUP('$')                    ; Buffer for number-to-string conversion
    SPACE DB ' $'                            ; Space separator

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; PRINT ODD NUMBERS HEADER
    MOV AH, 09H
    LEA DX, MSG1
    INT 21H

    ; FIND AND PRINT ODD NUMBERS
    MOV CX, N
    MOV SI, 0
ODD_LOOP:
    MOV AX, ARR[SI]         ; Load number
    TEST AX, 1              ; Check LSB (odd if set)
    JZ NOT_ODD              ; Jump if even

    CALL PRINT_NUMBER       ; Print the odd number
    MOV AH, 09H
    LEA DX, SPACE
    INT 21H                 ; Print space

NOT_ODD:
    ADD SI, 2               ; Move to next element (DW)
    LOOP ODD_LOOP

    ; PRINT EVEN NUMBERS HEADER
    MOV AH, 09H
    LEA DX, MSG2
    INT 21H

    ; FIND AND PRINT EVEN NUMBERS
    MOV CX, N
    MOV SI, 0
EVEN_LOOP:
    MOV AX, ARR[SI]         ; Load number
    TEST AX, 1              ; Check LSB (even if clear)
    JNZ NOT_EVEN            ; Jump if odd

    CALL PRINT_NUMBER       ; Print the even number
    MOV AH, 09H
    LEA DX, SPACE
    INT 21H                 ; Print space

NOT_EVEN:
    ADD SI, 2               ; Move to next element (DW)
    LOOP EVEN_LOOP

    ; EXIT PROGRAM
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; ========== PRINT 3-DIGIT NUMBER (AX) ==========
PRINT_NUMBER PROC
    LEA DI, BUFFER + 9      ; Point to end of buffer
    MOV [DI], '$'           ; String terminator
    MOV BX, 10              ; Divisor for base-10 conversion

CONVERT_LOOP:
    XOR DX, DX              ; Clear DX for division
    DIV BX                  ; AX = AX/10, DX = remainder
    ADD DL, '0'             ; Convert to ASCII
    DEC DI                  ; Move back in buffer
    MOV [DI], DL            ; Store digit
    TEST AX, AX             ; Check if quotient is zero
    JNZ CONVERT_LOOP        ; Continue if not

    ; PRINT THE NUMBER
    MOV AH, 09H
    MOV DX, DI
    INT 21H
    RET
PRINT_NUMBER ENDP

END MAIN