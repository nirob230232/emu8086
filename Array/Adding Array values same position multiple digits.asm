.MODEL SMALL
.STACK 100H

.DATA
    ; Arrays with two-digit numbers (0-99)
    ARR1    DW 12, 34, 56, 78, 90,5,4,3,2,1    ; Changed to DW for 16-bit numbers
    ARR2    DW 23, 45, 67, 89, 10,1,2,3,4,5    ; DW allows sums up to 65535
    RESULT  DW 10 DUP(0)              ; Result array (16-bit)
    
    ; Constants and messages
    ARRAY_LENGTH EQU 10               ; Predefined length
    MSG1    DB 'Array 1: $'
    MSG2    DB 13,10,'Array 2: $'
    MSG3    DB 13,10,'Sum: $'
    SPACE   DB ' $'

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; ----- PRINT ARRAY 1 -----
    MOV AH, 09H
    LEA DX, MSG1
    INT 21H
    
    MOV SI, 0
    MOV CX, ARRAY_LENGTH
PRINT_ARRAY1:
    MOV AX, ARR1[SI]        ; Get 16-bit element
    CALL PRINT_NUMBER       ; Print number (1-3 digits)
    
    ; Print space (except after last element)
    CMP SI, (ARRAY_LENGTH-1)*2  ; DW elements are 2 bytes each
    JE SKIP_SPACE1
    MOV AH, 09H
    LEA DX, SPACE
    INT 21H
SKIP_SPACE1:
    ADD SI, 2               ; Next DW element
    LOOP PRINT_ARRAY1

    ; ----- PRINT ARRAY 2 -----
    MOV AH, 09H
    LEA DX, MSG2
    INT 21H
    
    MOV SI, 0
    MOV CX, ARRAY_LENGTH
PRINT_ARRAY2:
    MOV AX, ARR2[SI]
    CALL PRINT_NUMBER
    
    CMP SI, (ARRAY_LENGTH-1)*2
    JE SKIP_SPACE2
    MOV AH, 09H
    LEA DX, SPACE
    INT 21H
SKIP_SPACE2:
    ADD SI, 2
    LOOP PRINT_ARRAY2

    ; ----- ADD ARRAYS -----
    MOV SI, 0
    MOV CX, ARRAY_LENGTH
ADD_LOOP:
    MOV AX, ARR1[SI]     ; Load 16-bit from first array
    ADD AX, ARR2[SI]     ; Add 16-bit from second array
    MOV RESULT[SI], AX    ; Store 16-bit result
    ADD SI, 2
    LOOP ADD_LOOP

    ; ----- PRINT RESULT -----
    MOV AH, 09H
    LEA DX, MSG3
    INT 21H
    
    MOV SI, 0
    MOV CX, ARRAY_LENGTH
PRINT_RESULT:
    MOV AX, RESULT[SI]
    CALL PRINT_NUMBER
    
    CMP SI, (ARRAY_LENGTH-1)*2
    JE EXIT_PROGRAM
    MOV AH, 09H
    LEA DX, SPACE
    INT 21H
    
    ADD SI, 2
    LOOP PRINT_RESULT

EXIT_PROGRAM:
    ; Return to DOS
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; ===== PRINT NUMBER (1-3 digits) =====
; Input: AX = number to print (0-65535)
PRINT_NUMBER PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ; Handle zero case
    CMP AX, 0
    JNE NOT_ZERO
    MOV DL, '0'
    MOV AH, 02H
    INT 21H
    JMP PRINT_DONE
    
NOT_ZERO:
    ; Count digits
    MOV CX, 0              ; Digit counter
    MOV BX, 10             ; Divisor
    
COUNT_DIGITS:
    INC CX
    MOV DX, 0
    DIV BX                 ; AX = quotient, DX = remainder
    PUSH DX                ; Save digit
    CMP AX, 0
    JNE COUNT_DIGITS
    
    ; Print digits
PRINT_DIGITS:
    POP DX
    ADD DL, '0'            ; Convert to ASCII
    MOV AH, 02H
    INT 21H
    LOOP PRINT_DIGITS
    
PRINT_DONE:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUMBER ENDP

END MAIN