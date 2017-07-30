;************************************************************************************************************************************	
;************************************************************************************************************************************
	
	;Description: Gets X, Y, Width, Height and color, and then prints it on the screen.

	PROC GRAPHICS_PRINTRECT	
		;Input: 	x, y, width, height, color
		;Output: 	Prints a rectangle on the screen
		;Variables:	MAX_X, MAX_Y
		
		;{	
		;Declare Parameters 
		;{
			x   equ [ss:bp + 12]
			y   equ [ss:bp + 10]
			
			Wid equ [ss:bp + 8]
			Hei equ [ss:bp + 6]
			
			Col equ [ss:bp + 4]
		;}
	
		;Set BasePointer Declare Local Vars {
			push bp
			mov  bp, sp
		
			;LOCAL VARS
			sub sp, 4
			MAX_X equ [ss:bp - 2]
			MAX_Y equ [ss:bp - 4]
			
			;REGS:
			pusha
		;}
		
		
		;Setup local vars 
		;{
			mov ax, x
			add ax, Wid
			mov MAX_X, ax
			
			mov ax, y
			add ax, Hei
			mov MAX_Y, ax
		;}
		
		
		;Main 
		;{
			
			;Setup for print 
			;{
				mov ax, Col
				xor bx, bx
				mov ah, 0Ch
				mov dx, y				
			;}
			
			
			@Yloop:
			;{
				mov cx, x
				
				@Xloop:
				;{
					int 10h
					
					inc cx
					cmp cx, MAX_X
					jnz @Xloop
				;}
				
				inc dx
				cmp dx, MAX_Y
				jnz @Yloop
			;}
		;}
		
		;POP REGS, Destroy local vars 
		;{
			;REGS:
			popa
			add sp, 4 	;Local vars 	
			pop bp 		;BasePointer
		;}
		
		;Clear Parameters and return
		ret 10	
	;}
	
	ENDP GRAPHICS_PRINTRECT

;************************************************************************************************************************************	
;************************************************************************************************************************************
	
	PROC GRAPHICS_GETCOLOR
	;{
	; Input: PX_X, PX_Y
	;Output: AX = COLOR AT (PX_X, PX_Y)
		;PARAMS {
			PX_X EQU [BP + 6]
			PX_Y EQU [BP + 4]
		;}
		
		;BASEPOINTER {
			PUSH BP
			MOV  BP, SP
		;}
		
		;PUSH {
			PUSH CX
			PUSH DX	
		;}
		
		;GET COLOR {
			;PARAMS:
			MOV CX, PX_X
			MOV DX, PX_Y
		
			;INTERRUPT:
			MOV AH, 0DH
			INT 10H
			
			;OUTPUT:
			XOR AH, AH
		;}
		
		;POP {
			POP DX
			POP CX
			
			POP BP
		;}
		
		RET 4
	;}
	ENDP GRAPHICS_GETCOLOR
	
;************************************************************************************************************************************	
;************************************************************************************************************************************

	PROC GRAPHICS_PRINTIMAGE
	;Input: X, Y, ARR_IMG.OFFSET
	;{
		;BASEPOINTER & REGS & PARAMS {
			PUSH BP
			MOV  BP, SP
			
			PUSH AX
			PUSH BX
			PUSH CX
			PUSH DX
			PUSH SI
			
			IMG_OFFSET	EQU [WORD PTR BP + 10]
			IMG_COL		EQU [BP + 8]
			PX_X 		EQU [BP + 6]
			PX_Y 		EQU [BP + 4]
		;}
		
		;CODE {
			MOV SI, IMG_OFFSET
			MOV AX, IMG_COL
			ADD IMG_OFFSET, 9
			
			;CX = X, DX = Y
			MOV CX, PX_X
			MOV DX, PX_Y
			
			MOV AH, 0Ch
			
			;====================
			
			;LOOP B[1 - 10] AND PRINT ACCORDINGLY
			@@LOAD_BYTE:;(int SI = 1; SI < 10; SI++)
			;{
				MOV BH, 7
				@@PRINT_LOOP:;(int BH = 7; BH >= 0; BH--)
				;{
					PUSH CX
					MOV  BL, [SI]
					MOV  CL, BH
					SHR  BL, CL
					POP  CX
					
					AND  BL, 1
					JZ   @@EXIT_PRINT_LOOP
					
					INT  10H
					
					@@EXIT_PRINT_LOOP: ;{
						INC CX
						DEC BH
						CMP BH, 0FFh
						JNZ @@PRINT_LOOP	
					;}					
				;}
				
				MOV CX, PX_X
				INC DX
				
				;(int SI = 1; SI < 9; SI++) { 
					INC SI
					CMP SI, IMG_OFFSET
					JNZ @@LOAD_BYTE
				;}
			;}
			
			;=========================
			
			MOV DX, PX_Y
			ADD CX, 8
			MOV BH, 7
			
			@@PRINT_LASTCOL: ;(int BH = 7; BH <= 0; BH--)
			;{
				PUSH CX
				MOV  BL, [SI]
				MOV  CL, BH
				SHR  BL, CL
				POP  CX
				
				AND  BL, 1
				JZ   @@EXIT_PRINT_LASTCOL
				
				INT  10H
				
				@@EXIT_PRINT_LASTCOL:
				INC DX
				DEC BH
				CMP BH, 0FFh
				JNZ @@PRINT_LASTCOL
			;}
			
			;======================
			
			CMP [BYTE PTR SI + 1], 0

			JZ  @@END_PROC  
			INT 10H
		;}
		
		@@END_PROC:
		;BASEPOINTER & REGS & LOCAL VARS {
			POP SI
			POP DX
			POP CX
			POP BX
			POP AX
			
			POP BP
		;}
		RET 8
	;}
	ENDP GRAPHICS_PRINTIMAGE
	
;************************************************************************************************************************************	
;************************************************************************************************************************************
	PROC GRAPHICS_MODE
	;{
		PUSH AX
		MOV  AX, 13h
		INT  10h
		POP  AX
		RET
	;}
	ENDP GRAPHICS_MODE
