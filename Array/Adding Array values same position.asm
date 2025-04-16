.MODEL SMALL
.STACK 100H

.DATA
    ARR1    DB 1, 2, 3, 4, 5,3,2,1,4,5        ; First array
    ARR2    DB 5, 4, 3, 2, 1, 6,7,9,3,2        ; Second array
    RESULT  DB 5 DUP(?)             ; Result array (uninitialized)
    LEN     EQU 10                   ; Length of arrays (fixed at 5)
    MSG1    DB 'Array 1: $'
    MSG2    DB 0DH,0AH,'Array 2: $'
    MSG3    DB 0DH,0AH,'Sum: $'
    SPACE   DB ' $'
    NEWLINE DB 0DH,0AH,'$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Print Array 1
    MOV AH, 09H
    LEA DX, MSG1
    INT 21H
    MOV SI, OFFSET ARR1
    MOV CX, LEN
    CALL PRINT_ARRAY

    ; Print Array 2
    MOV AH, 09H
    LEA DX, MSG2
    INT 21H
    MOV SI, OFFSET ARR2
    MOV CX, LEN
    CALL PRINT_ARRAY

    ; Add arrays element-wise
    MOV CX, LEN
    MOV SI, 0
ADD_LOOP:
    MOV AL, [ARR1 + SI]    ; Load element from ARR1
    ADD AL, [ARR2 + SI]    ; Add element from ARR2
    MOV [RESULT + SI], AL   ; Store sum in RESULT
    INC SI
    LOOP ADD_LOOP

    ; Print Result Array
    MOV AH, 09H
    LEA DX, MSG3
    INT 21H
    MOV SI, OFFSET RESULT
    MOV CX, LEN
    CALL PRINT_ARRAY

    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; ===== PRINT ARRAY =====
; Input: SI = array offset, CX = length
PRINT_ARRAY PROC
    PUSH AX
    PUSH DX
    PUSH CX
    PUSH SI

PRINT_LOOP:
    MOV AL, [SI]           ; Get array element
    CALL PRINT_DIGIT       ; Print the digit
    
    ; Print space except after last element
    DEC CX
    JZ NO_SPACE
    MOV AH, 09H
    LEA DX, SPACE
    INT 21H
NO_SPACE:
    INC SI
    CMP CX, 0
    JG PRINT_LOOP

    POP SI
    POP CX
    POP DX
    POP AX
    RET
PRINT_ARRAY ENDP

; ===== PRINT SINGLE DIGIT =====
; Input: AL = digit to print (0-9)
PRINT_DIGIT PROC
    ADD AL, '0'            ; Convert to ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    RET
PRINT_DIGIT ENDP

END MAIN