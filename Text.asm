	;Description: Takes a number and prints it in hex

	PROC TEXT_PRINT_NUM
	;Input:	 	Num
	;Output: 	prints Num on the screen
	;Variables:	ArrayEnd
	
	;{
		;params {
			num equ [ss:bp + 4]
		;}
		
		;BasePointer {
			push bp
			mov  bp, sp
		;}
		
		;Local Variables {
			sub sp, 2
			ArrayEnd equ [ss:bp - 2]
		;}
		
		;Push REGS
		;{
			pusha
		;}
		
		;CODE
		;{
			mov  bx, OFFSET printNumArr
			mov  cx, 10h
			xchg ax, num
			
			mov ArrayEnd, bx
			add bx, 3

			@breakNum:
			;{
				xor dx, dx
				div cx
				mov [ds:bx], dl
				
				dec bx
				cmp bx, ArrayEnd
				jge @breakNum
			;}
			
			mov bx, OFFSET printNumArr
			add bx, 3
			
			@ToAscii:
			;{
				cmp [byte ptr ds:bx], 9
				ja  toLetter
				
				add [byte ptr ds:bx], '0'
				jmp exitToAscii
				
				toLetter:
				add [byte ptr ds:bx], 37h	; 37h = 'A' - 0Ah 
				
				exitToAscii:
				dec bx
				cmp bx, ArrayEnd
				jge @ToAscii
			;}
		
			;Print Text {
				PUSH OFFSET printNumArr
				CALL TEXT_PRINT_MSG
			;}
			
		;}
		
		;Pop REGS
		;{
			popa
		;}
		
		
		;Local Variables & BasePointer {
			add sp, 2
			pop bp
		;}
		
		ret 2
	;}
	ENDP TEXT_PRINT_NUM

;*****************************************************************************
;*****************************************************************************

	PROC TEXT_NEWLINE
	;{
		;PUSH {
			PUSH AX
			PUSH DX
		;}
		
		;PRINT {
			MOV DL, 0Ah
			MOV AH, 2
			INT 21H
			
			MOV DL, 0Dh
			INT 21H
		;}
		
		;POP {
			POP DX
			POP AX
		;}
		
		RET
	;}
	ENDP TEXT_NEWLINE

;*****************************************************************************
;*****************************************************************************

	PROC TEXT_PRINT_MSG
	;{
		;PARAMS {
			MsgOff EQU [BP + 4]
		;}
		
		;PUSH {
			PUSH BP
			MOV BP, SP
			
			PUSH AX
			PUSH DX
		;}
		
		;PRINT {
			MOV DX, MsgOff
			MOV AH, 9
			INT 21H
		;}
		
		;POP {
			POP DX
			POP AX
			
			POP BP
		;}
		
		RET 2
	;}
	ENDP TEXT_PRINT_MSG

;*****************************************************************************
;*****************************************************************************
	
	PROC TEXT_SET_CURPOS
	;Input: CUR_COL, CUR_ROW
	;Output: Sets cursor position to the ROW & COL
	
	;{
	
		;PARAMS {
			CUR_COL EQU [BP + 6]
			CUR_ROW EQU [BP + 4]
		;}
		
		;BASEPOINTER {
			PUSH BP
			MOV  BP, SP
		;}
		
		;PUSH {
			PUSH AX
			PUSH BX
			PUSH DX
		;}
		
		;INT 10, AH = 2 {
		;	SET CURSOR POSITION
		;	BL = PAGE NUMBER (0)
		;	DL = COL (X)
		;	DH = ROW (Y)
		;}
		
		;USE PARAMS & CALL INTERUPT {
			MOV AH, 2
			MOV BX, CUR_ROW
			MOV DX, CUR_COL
			MOV DH, BL
			INT 10H
		;}
		
		;POP {
			POP DX
			POP BX
			POP AX
			
			POP BP
		;}
		
		RET 4
	;}
	ENDP TEXT_SET_CURPOS
	
;*****************************************************************************
;*****************************************************************************
	
	PROC TEXT_MODE
	;{	
		PUSH AX
		MOV  AX, 3
		INT  10h
		POP  AX
		RET
	;}
	ENDP TEXT_MODE
	
;*****************************************************************************
;*****************************************************************************
	
	PROC TEXT_PRINTDEC
	;{
		;Input: Decimal array offset (array you want to print)
		;PRINTS A DECIMAL NUMBER.
		
		;START PROC {
			PUSH BP
			MOV  BP, SP
			
			PUSH AX
			PUSH BX
			PUSH SI
			PUSH DI
			
			ARR_OFF EQU [BP + 4]
		;}
		
		;CODE {
			MOV SI, ARR_OFF
			MOV DI, OFFSET PRINT_DEC; print_dec db 0,0,0,0,0,'$'
			XOR BX, BX
			
			@@COPY_ARR: ;{
				MOV AL, [SI + BX]
				MOV [DI + BX], AL
				
				INC BX
				CMP BX, 5
				JNZ @@COPY_ARR
			;}
			
			XOR BX, BX
			
			@@TO_ASCII: ;{
				ADD [BYTE PTR DI + BX], '0'
				INC BX
				CMP BX, 5
				JNZ @@TO_ASCII
			;}
			
			XOR BX, BX
			
			@@CHECK_ZERO: ;{
				CMP [BYTE PTR DI + BX], '0'
				JNZ @@PRINT_NUM
				MOV [BYTE PTR DI + BX], ' '
				
				INC BX
				CMP BX, 4
				JNZ @@CHECK_ZERO
			;}
			
			
			@@PRINT_NUM: ;{
				PUSH DI
				CALL TEXT_PRINT_MSG
			;}
			
		;}
		
		@@END_PROC: ;{
			POP DI
			POP SI
			POP BX
			POP AX
			
			POP BP
			RET 2
		;}
	;}
	ENDP TEXT_PRINTDEC

;*****************************************************************************
;*****************************************************************************
	
	PROC TEXT_COLORSTR
	;{
		;PRINTS A STRING WITH COLOR.
		;INPUT: COLOR, STRING OFFSET.
		
		;START PROC {
			PUSH BP
			MOV  BP, SP
			
			SUB  SP, 2
			CURSOR_Y EQU [BP - 2]
			
			PUSH AX
			PUSH BX
			PUSH CX
			PUSH DX
			PUSH SI
			
			TXT_COLOR 	EQU [BP + 6]
			ARR_OFF 	EQU [BP + 4]
			
		;}
		
		;CODE {
			
			;GET CURSOR POS {
				MOV  AH, 3
				XOR  BX, BX
				INT  10H
				XCHG DH, BL
				MOV  CURSOR_Y, BX
			;}
			
			;SETUP FOR INTERRUPT {
				MOV SI, ARR_OFF
				MOV BL, TXT_COLOR
				MOV BH, 0
				MOV AH, 9
				MOV CX, 1
			;}
			
			@@TXT_LOOP: ;{
				MOV AL, [SI]
				CMP AL, '$'
				JZ  @@END_PROC
				
				PUSH DX
				PUSH CURSOR_Y
				CALL TEXT_SET_CURPOS
				
				INT 10H
				INC SI
				INC DX
				JMP @@TXT_LOOP
			;}
			
		;}
		
		@@END_PROC: ;{
			POP SI
			POP DX
			POP CX
			POP BX
			POP AX
			
			ADD SP, 2
			POP BP
			RET 4
		;}
	;}
	ENDP TEXT_COLORSTR

;*****************************************************************************
;*****************************************************************************
	
	