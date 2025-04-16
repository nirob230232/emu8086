.MODEL SMALL
.STACK 100H

.DATA
ARR DB 25, 40, 10, 75, 15     ; ARRAY ELEMENTS
LEN DB 5                      ; LENGTH OF ARRAY
MAX DB ?                      ; TO STORE MAX VALUE

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    XOR SI, SI                ; SI = 0 (INDEX)
    MOV AL, ARR[SI]           ; AL = FIRST ELEMENT
    INC SI                    ; MOVE TO NEXT ELEMENT
    MOV CL, LEN
    DEC CL                    ; LOOP FOR (LEN - 1) TIMES

NEXT:
    MOV BL, ARR[SI]           ; BL = CURRENT ELEMENT
    CMP AL, BL
    JNC SKIP                  ; IF AL >= BL, SKIP UPDATE
    MOV AL, BL                ; UPDATE MAX VALUE

SKIP:
    INC SI
    DEC CL
    JNZ NEXT

    MOV MAX, AL               ; STORE MAX IN 'MAX' VARIABLE

    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
