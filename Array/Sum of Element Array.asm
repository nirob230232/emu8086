.MODEL SMALL
.STACK 100H

.DATA
    ARR DW 10, 20, 30, 40, 50,1,2,3,4,5  ; Sample array (can be modified)
    N DW 10                      ; Number of elements
    SUM DW 0                    ; Variable to store sum
    MSG DB "Sum of array elements: $"
    BUFFER DB 10 DUP('$')       ; Buffer for number-to-string conversion

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; CALCULATE SUM OF ARRAY ELEMENTS
    MOV CX, N                   ; Initialize loop counter
    MOV SI, 0                   ; Initialize array index
    MOV AX, 0                   ; Clear accumulator

SUM_LOOP:
    ADD AX, ARR[SI]             ; Add current element to sum
    ADD SI, 2                   ; Move to next element (DW = 2 bytes)
    LOOP SUM_LOOP

    MOV SUM, AX                 ; Store final sum

    ; DISPLAY RESULT MESSAGE
    MOV AH, 09H
    LEA DX, MSG
    INT 21H

    ; DISPLAY THE SUM
    MOV AX, SUM
    CALL PRINT_NUMBER

    ; EXIT PROGRAM
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; ====== PRINT NUMBER IN AX ======
PRINT_NUMBER PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    LEA SI, BUFFER + 9          ; Point to end of buffer
    MOV [SI], '$'               ; String terminator
    MOV BX, 10                  ; Divisor for base-10

CONVERT:
    XOR DX, DX                  ; Clear DX for division
    DIV BX                      ; AX = AX/10, DX = remainder
    ADD DL, '0'                 ; Convert to ASCII
    DEC SI                      ; Move back in buffer
    MOV [SI], DL                ; Store digit
    TEST AX, AX                 ; Check if quotient is zero
    JNZ CONVERT                 ; Continue if not

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