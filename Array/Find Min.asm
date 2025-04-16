.MODEL SMALL
.STACK 100H

.DATA
ARR DB 25,40,10,75,15,5,3,8,9,99     ; ARRAY ELEMENTS
LEN DB 10                      ; LENGTH OF ARRAY
MIN DB ?                      ; TO STORE MINIMUM VALUE

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
    JBE SKIP                  ; IF AL <= BL, SKIP UPDATE
    MOV AL, BL                ; UPDATE MIN VALUE

SKIP:
    INC SI
    DEC CL
    JNZ NEXT

    MOV MIN, AL               ; STORE MIN IN 'MIN' VARIABLE

    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
