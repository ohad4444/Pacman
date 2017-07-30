PROC MENU_INPUT
;{
	PUSH AX
	PUSH BX
	
	;CODE 
	;{
		;NEW DATA? {
			MOV AH, 1
			INT 16H
			
			JNZ @@NEWDATA 	;NEW DATA
			JMP	@@END_PROC	;ELSE, NO DATA
		;}
		
		;HANDLE NEW DATA {
			@@NEWDATA:
			;CLEAR BUFFER FROM DATA
			MOV AH, 0
			INT 16H
	
			;PROCESS NEW DATA
				
				;DATA = UP ARROW?
				CMP AH, ARR_U
				JZ  @@UP
				
				;DATA = DOWN ARROW?
				CMP AH, ARR_D
				JZ  @@DOWN
				
				;DATA = SPACEBAR?
				CMP AH, SC_SPACE
				JZ  @@CLICK
				
				;DATA = ENTER?
				CMP AH, SC_ENTER
				JZ  @@CLICK
				JMP @@END_PROC

		;}
		
		;SET NEW DIRECTION {
			@@CLICK: ;{
				CALL MENU_CLICK
				JMP  @@END_PROC
			;}
			
			@@UP: ;{
				DEC [MENU_PTR]
				JMP @@OVERFLOW
			;}
			
			@@DOWN: ;{
				INC [MENU_PTR]
			;}		
		;}
	
	@@OVERFLOW: ;{
		CMP [MENU_PTR], 3
		JZ  @@MIN_PTR
		
		CMP [MENU_PTR], 0FFFFh
		JNZ @@COLOR
		
		@@MAX_PTR: ;{
			MOV [MENU_PTR], 2
			JMP @@COLOR
		;}
		
		@@MIN_PTR: ;{
			MOV [MENU_PTR], 0
		;}	
	;}
	
	@@COLOR: ;{
		MOV BX, OFFSET MENU_TXT_COL
		MOV [WORD PTR BX]    , WHITE
		MOV [WORD PTR BX + 2], WHITE
		MOV [WORD PTR BX + 4], WHITE
		
		MOV BL, [MENU_PTR]
		XOR BH, BH
		SHL BX, 1
		ADD BX, OFFSET MENU_TXT_COL
		MOV [WORD PTR BX], RED 
	;}

	@@END_PROC:
	;FLUSH BUFFER {
		XOR AL, AL
		MOV AH, 0CH
		INT 21H
		
		POP BX
		POP AX
		RET
	;}
;}
ENDP MENU_INPUT

;*******************************************************************
;*******************************************************************

PROC MENU_PRINT_TITLE
;{
	;PRINT BASE {
		PUSH 113
		PUSH 40
		PUSH 95
		PUSH 20
		PUSH DARK_RED
		CALL GRAPHICS_PRINTRECT
		
		PUSH 116
		PUSH 43
		PUSH 89
		PUSH 14
		PUSH 29h
		CALL GRAPHICS_PRINTRECT
	
	;}
	
	;PRINT 'P' {
		PUSH OFFSET LETTER_P
		PUSH YELLOW
		PUSH 120
		PUSH 45
		CALL GRAPHICS_PRINTIMAGE
	;}
	
	;PRINT 'A' {
		PUSH OFFSET LETTER_A
		PUSH YELLOW
		PUSH 132
		PUSH 45
		CALL GRAPHICS_PRINTIMAGE
	;}
	
	;PRINT 'C' {
		PUSH OFFSET PACMAN_R_2
		PUSH YELLOW
		PUSH 144
		PUSH 45
		CALL GRAPHICS_PRINTIMAGE
	;}
	
	;PRINT '-' {
		PUSH 157
		PUSH 48
		PUSH 7
		PUSH 3
		PUSH YELLOW
		CALL GRAPHICS_PRINTRECT
	;}
	
	;PRINT 'M' {
		PUSH OFFSET LETTER_M
		PUSH YELLOW
		PUSH 168
		PUSH 45
		CALL GRAPHICS_PRINTIMAGE
	;}
		
	;PRINT 'A' {
		PUSH OFFSET LETTER_A
		PUSH YELLOW
		PUSH 180
		PUSH 45
		CALL GRAPHICS_PRINTIMAGE
	;}	
	
	;PRINT 'N' {
		PUSH OFFSET LETTER_N
		PUSH YELLOW
		PUSH 192
		PUSH 45
		CALL GRAPHICS_PRINTIMAGE
	;}
	
	RET
;}
ENDP MENU_PRINT_TITLE

;*******************************************************************
;*******************************************************************

PROC MENU_PRINT_TEXT
;{
	;PUSH REGS {
		PUSH AX
		PUSH BX
		PUSH SI
		PUSH DI
	;}
	
	;CODE {
		;18 = CUR_X, AX = CUR_Y
		MOV AX, 15
		
		MOV SI, OFFSET MENU_TXT_OFF
		MOV DI, OFFSET MENU_TXT_COL
		XOR BX, BX
				
		@@TEXT_LOOP:
		;{
			PUSH 18
			PUSH AX
			CALL TEXT_SET_CURPOS
			
			PUSH [DI + BX]
			PUSH [SI + BX]
			CALL TEXT_COLORSTR
			
			ADD AX, 2
			ADD BX, 2
			CMP BX, 6
			JNZ @@TEXT_LOOP
		;}
		
	;}
	
	@@END_PROC: ;{
		POP DI
		POP SI
		POP BX
		POP AX
	;}
	RET
;}
ENDP MENU_PRINT_TEXT

;*******************************************************************
;*******************************************************************

PROC MENU_CLICK
;{
	CMP [MENU_PTR], BTN_PLAY
	JZ  @@PLAY
	
	CMP [MENU_PTR], BTN_HELP
	JZ  @@HELP
	JMP EXIT
	
	@@PLAY: ;{
		CALL NEW_GAME
	;}
	
	@@HELP: ;{
		PUSH 14
		PUSH 9
		CALL TEXT_SET_CURPOS
		
		PUSH OFFSET STR_INST_1
		CALL TEXT_PRINT_MSG

		PUSH 14
		PUSH 10
		CALL TEXT_SET_CURPOS
		
		PUSH OFFSET STR_INST_2
		CALL TEXT_PRINT_MSG
		
		PUSH 15
		PUSH 11
		CALL TEXT_SET_CURPOS
		
		PUSH OFFSET STR_INST_3
		CALL TEXT_PRINT_MSG

		MOV AH, 7
		INT 21H
			
		PUSH 112
		PUSH 72
		PUSH 104
		PUSH 24
		PUSH BLACK
		CALL GRAPHICS_PRINTRECT
	;}
	
	@@END_PROC:	
	RET
;}
ENDP MENU_CLICK

;*******************************************************************
;*******************************************************************

PROC MAINMENU
;{
	;MENU INIT {
		MOV BX, OFFSET MENU_TXT_OFF
		MOV [WORD PTR BX]    , OFFSET STR_PLAY
		MOV [WORD PTR BX + 2], OFFSET STR_HELP
		MOV [WORD PTR BX + 4], OFFSET STR_EXIT
		
		MOV BX, OFFSET MENU_TXT_COL
		MOV [WORD PTR BX]    , RED
		MOV [WORD PTR BX + 2], WHITE
		MOV [WORD PTR BX + 4], WHITE
	;}
	
	;PRINT THE TITLE {
		PUSH 0
		PUSH 0
		PUSH 320
		PUSH 200
		PUSH 68h
		CALL GRAPHICS_PRINTRECT
		
		PUSH 85
		PUSH 25
		PUSH 150
		PUSH 150
		PUSH BLACK
		CALL GRAPHICS_PRINTRECT
		
		CALL MENU_PRINT_TITLE
	;}
	
	@@MAINMENU: ;{
		CALL MENU_INPUT
		CALL MENU_PRINT_TEXT
		JMP  @@MAINMENU
	;}
	RET
;}
ENDP MAINMENU

;*******************************************************************
;*******************************************************************
