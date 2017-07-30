	PROC LAYOUT_PRINT
	;{
		;PRINT TOP-ROW (23X1){
			PUSH 0		;X
			PUSH 0		;Y
			
			PUSH 207	;Width
			PUSH 9		;Height
			
			PUSH AX		;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT BOT-ROW (23X1){
			PUSH 0		;X
			PUSH 189	;Y
			
			PUSH 207	;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT LEFT-COL (1X22){
			PUSH 0		;X
			PUSH 0		;Y
			
			PUSH 9		;Width
			PUSH 198	;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		
		;PRINT RIGHT-COL (1X21){
			PUSH 198	;X
			PUSH 0		;Y
			
			PUSH 9		;Width
			PUSH 198	;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		
		;PRINT LEFT-TUNNLEBOX (4X6) {
			PUSH 9		;X
			PUSH 63		;Y
			
			PUSH 36		;Width
			PUSH 63		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		
		
		;PRINT RIGHT-TUNNLEBOX (4X6) {
			PUSH 162	;X
			PUSH 63		;Y
			
			PUSH 36		;Width
			PUSH 63		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		
		;PRINT TUNNLES LEFT (5X1){
			PUSH 0		;X
			PUSH 90		;Y
			
			PUSH 45	;Width
			PUSH 9		;Height
			
			PUSH black	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT TUNNLES RIGHT (5X1){
			PUSH 162	;X
			PUSH 90		;Y
			
			PUSH 45	;Width
			PUSH 9		;Height
			
			PUSH black	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT TOP-LEFT-RECT (3X2) {
			PUSH 18		;X
			PUSH 18		;Y
			
			PUSH 27		;Width
			PUSH 18		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		
		;PRINT TOP-RIGHT-RECT (3X2) {
			PUSH 162	;X
			PUSH 18		;Y
			
			PUSH 27		;Width
			PUSH 18		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT TOP-LEFT-RECT (4X2) {
			PUSH 54		;X
			PUSH 18		;Y
			
			PUSH 36		;Width
			PUSH 18		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT TOP-RIGHT-RECT (4X2) {
			PUSH 117	;X
			PUSH 18		;Y
			
			PUSH 36		;Width
			PUSH 18		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT TOP-LEFT-RECT (3X1) {
			PUSH 18		;X
			PUSH 45		;Y
			
			PUSH 27		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT TOP-RIGHT-RECT (3X1) {
			PUSH 162	;X
			PUSH 45		;Y
			
			PUSH 27		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT TOP-LEFT-T(VERT) (1X5) {
			PUSH 54		;X
			PUSH 45		;Y
			
			PUSH 9		;Width
			PUSH 45		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT TOP-LEFT-T(HORZ) (3X1) {
			PUSH 63		;X
			PUSH 63		;Y
			
			PUSH 27		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT TOP-RIGHT-T(VERT) (1X5) {
			PUSH 144	;X
			PUSH 45		;Y
			
			PUSH 9		;Width
			PUSH 45		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT TOP-RIGHT-T(HORZ) (3X1) {
			PUSH 117	;X
			PUSH 63		;Y
			
			PUSH 27		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT TOP-MID-T(VERT) (1X2) {
			PUSH 99 	;X
			PUSH 54		;Y
			
			PUSH 9		;Width
			PUSH 18		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT TOP-MID-T(VERT) (7X1) {
			PUSH 72		;X
			PUSH 45		;Y
			
			PUSH 63		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		
		;=====================================================
		
		;PRINT BOT-MID-T(VERT) (1X2) {
			PUSH 99		;X
			PUSH 126	;Y
			
			PUSH 9		;Width
			PUSH 18		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT BOT-MID-T(HORZ) (3X1) {
			PUSH 72		;X
			PUSH 117	;Y
			
			PUSH 63		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT BOT-MID-T(VERT) (1X2) {
			PUSH 99		;X
			PUSH 162	;Y
			
			PUSH 9		;Width
			PUSH 18		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT BOT-MID-T(HORZ) (3X1) {
			PUSH 72		;X
			PUSH 153	;Y
			
			PUSH 63		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT BOT-LEFT-REV-T(VERT) (1X2) {
			PUSH 54		;X
			PUSH 153	;Y
			
			PUSH 9		;Width
			PUSH 18		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT BOT-MID-T(HORZ) (3X1) {
			PUSH 18		;X
			PUSH 171	;Y
			
			PUSH 72		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT BOT-RIGHT-REV-T(VERT) (1X2) {
			PUSH 144	;X
			PUSH 153	;Y
			
			PUSH 9		;Width
			PUSH 18		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT BOT-RIGHT-T(HORZ) (3X1) {
			PUSH 117	;X
			PUSH 171	;Y
			
			PUSH 72		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT BOT-LEFT-R(VERT) (1X2) {
			PUSH 36		;X
			PUSH 144	;Y
			
			PUSH 9		;Width
			PUSH 18		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT BOT-LEFT-R(HORZ) (3X1) {
			PUSH 18		;X
			PUSH 135	;Y
			
			PUSH 27		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT BOT-LEFT-R(VERT) (1X2) {
			PUSH 162	;X
			PUSH 144	;Y
			
			PUSH 9		;Width
			PUSH 18		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT BOT-LEFT-R(HORZ) (3X1) {
			PUSH 162	;X
			PUSH 135	;Y
			
			PUSH 27		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT BOT-LEFT-STICK_WALL (2X1) {
			PUSH 9		;X
			PUSH 153	;Y
			
			PUSH 18		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT BOT-RIGHT-STICK_WALL (2X1) {
			PUSH 180	;X
			PUSH 153	;Y
			
			PUSH 18		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT BOT-LEFT-RECT (4X1) {
			PUSH 54		;X
			PUSH 135	;Y
			
			PUSH 36		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT BOT-RIGHT-RECT (4X1) {
			PUSH 117	;X
			PUSH 135	;Y
			
			PUSH 36		;Width
			PUSH 9		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT MID-LEFT-RECT (1X2) {
			PUSH 54		;X
			PUSH 99		;Y
			
			PUSH 9		;Width
			PUSH 27		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT MID-RIGHT-RECT (1X2) {
			PUSH 144	;X
			PUSH 99		;Y
			
			PUSH 9		;Width
			PUSH 27		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================
		
		;PRINT TOP-MID-RECT (1X3) {
			PUSH 99		;X
			PUSH 9		;Y
			
			PUSH 9		;Width
			PUSH 27		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}
		
		;=====================================================

		;PRINT GHOST_HOUSE (7X2) {
			PUSH 72		;X
			PUSH 81		;Y
			
			PUSH 63		;Width
			PUSH 27		;Height
			
			PUSH AX	;Color
			CALL GRAPHICS_PRINTRECT
		;}

		;=====================================================
		
		RET
	;}
	ENDP LAYOUT_PRINT

;************************************************************************************************************************************	
;************************************************************************************************************************************

	PROC LAYOUT_CLEAR
	;Input: 	None
	;Output: 	None
	;Variables:	None
	
	;{
		;ClearScreen(x = 0, y = 0, Width = 198d, Height = 198d, Color = Black) 
		;{
			push 0 		;x
			push 0		;y
			
			push 320 	;Width
			push 200 	;Height
			
			push black	;Color
			
			call GRAPHICS_PRINTRECT
		;}
		ret
	;}
	ENDP LAYOUT_CLEAR
	
;************************************************************************************************************************************	
;************************************************************************************************************************************

	PROC LAYOUT_PRINT_DOT
	; INPUT: DOT_X, DOT_Y
	;OUTPUT: PRINTS A DOT IN (DOT_X + 3, DOT_Y + 3)
	;{
		;PARAMS {
			DOT_X EQU [WORD PTR BP + 6]
			DOT_Y EQU [WORD PTR BP + 4]
		;}
		
		;BASEPOINTER {
			PUSH BP
			MOV  BP, SP
		;}
		
		;ADJUST X & Y {
			ADD DOT_X, 4
			ADD DOT_Y, 4
		;}
		
		;PRINT DOT (1X1)PX {
			PUSH DOT_X
			PUSH DOT_Y
			
			PUSH 1
			PUSH 1
			
			PUSH white
			CALL GRAPHICS_PRINTRECT
		;}
		
		POP BP
		RET 4
	;}
	ENDP LAYOUT_PRINT_DOT

;************************************************************************************************************************************	
;************************************************************************************************************************************

	PROC LAYOUT_PRINT_PP
	; INPUT: PP_X, PP_Y
	;OUTPUT: PRINTS A DOT IN (DOT_X + 3, DOT_Y + 3)
	;{
		;PARAMS {
			DOT_X EQU [WORD PTR BP + 6]
			DOT_Y EQU [WORD PTR BP + 4]
		;}
		
		;BASEPOINTER {
			PUSH BP
			MOV  BP, SP
		;}
		
		;ADJUST X & Y {
			ADD DOT_X, 3
			ADD DOT_Y, 2
		;}
		
		;PRINT 1ST RECT (3X5) {
			PUSH DOT_X
			PUSH DOT_Y
			
			PUSH 3
			PUSH 5
			
			PUSH pp_pink
			CALL GRAPHICS_PRINTRECT
		;}
		
		;ADJUST X & Y {
			DEC DOT_X
			INC DOT_Y
		;}
		
		
		;PRINT 2ND RECT (5X3) {
			PUSH DOT_X
			PUSH DOT_Y
			
			PUSH 5
			PUSH 3
			
			PUSH pp_pink
			CALL GRAPHICS_PRINTRECT
		;}
		
		POP BP
		RET 4
	;}
	ENDP LAYOUT_PRINT_PP

;************************************************************************************************************************************	
;************************************************************************************************************************************
	PROC LAYOUT_PRINT_ALLDOTS
	;{
		;PUSH {
			PUSH CX
			PUSH DX
		;}
		
		;SET REGISTERS {
			MOV DX, 9
		;}
		
		;PRINT DOTS {	
			@ALLDOT_Y: 
			;{
				MOV CX, 9
				
				@ALLDOT_X: 
				;{
					PUSH CX
					PUSH DX
					
					CALL LAYOUT_PRINT_DOT
					
					ADD CX, 9
					CMP CX, 198
					JB  @ALLDOT_X
				;}
				
				ADD DX, 9
				CMP DX, 189
				JB  @ALLDOT_Y
			;}
		;}
		
		;CLEAR GHOST_HOUSE AREA {
			PUSH 54
			PUSH 63
			
			PUSH 99 	
			PUSH 63
			
			PUSH black
			CALL GRAPHICS_PRINTRECT
		;}
		
		;PRINT POWER PILLS {
			
			MOV DX, 18
			
			ALLDOT_PP_Y:
			;{
				MOV CX, 9
				ALLDOT_PP_X:
				;{
					PUSH CX
					PUSH DX
					CALL LAYOUT_PRINT_PP
					
					ADD CX, 180
					CMP CX, 189
					JZ  ALLDOT_PP_X
				;}
				
				ADD DX, 117
				CMP DX, 135
				JZ  ALLDOT_PP_Y
			;}
		;}
		;POP {
			POP DX
			POP CX
		;}
		
		RET
	;}
	ENDP LAYOUT_PRINT_ALLDOTS
;************************************************************************************************************************************	
;************************************************************************************************************************************

PROC LAYOUT_BLINK
;{
	;START PROC {
		PUSH AX
		PUSH BX
		PUSH CX
	;}
	
	;CODE 
	;{
		PUSH 015h
		PUSH 4000h
		CALL DELAY
		
		MOV CX, 4
		
		@@BLINK_LOOP: ;{
			MOV AX, WHITE
			CALL LAYOUT_PRINT
			CALL BLINK_DELAY
			
			MOV AX, BLUE
			CALL LAYOUT_PRINT
			CALL BLINK_DELAY
			LOOP @@BLINK_LOOP
		;}
	;}
	
	@@END_PROC: ;{
		POP  CX
		POP  BX
		POP  AX
		RET 
	;}
;}
ENDP LAYOUT_BLINK
;================================
PROC BLINK_DELAY
;{
	PUSH 04h
	PUSH 4000h
	CALL DELAY
	RET
;}
ENDP BLINK_DELAY

;*****************************************************************************
;*****************************************************************************
