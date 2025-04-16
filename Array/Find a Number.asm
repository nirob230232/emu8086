.MODEL SMALL
.STACK 100H

.DATA
ARR DB 25,40,10,75,15,45,45,65,77,69     ; ARRAY ELEMENTS
LEN DB 10                      ; LENGTH OF ARRAY
KEY DB 45                   ; NUMBER TO SEARCH
FOUND DB 0                   ; 0 = NOT FOUND, 1 = FOUND

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    XOR SI, SI                ; INDEX = 0
    MOV CL, LEN               ; LOAD NUMBER OF ELEMENTS

SEARCH_LOOP:
    MOV AL, ARR[SI]           ; LOAD CURRENT ELEMENT
    CMP AL, KEY
    JE FOUND_LABEL            ; IF MATCH FOUND, JUMP
    INC SI
    DEC CL
    JNZ SEARCH_LOOP           ; LOOP UNTIL CL = 0
    JMP END_SEARCH            ; JUMP TO END IF NOT FOUND

FOUND_LABEL:
    MOV FOUND, 1              ; MARK AS FOUND

END_SEARCH:
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
