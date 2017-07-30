PROC TestWin
;{
	;IS THE SCREEN CLEAR? {
		CALL SCAN_SCREEN; IS THE SCREEN CLEAR?
		JC   @@WIN		; JMP CLEAR, @@WIN.
		JMP  @@END_PROC ; IF NOT CLEAR, EXIT.
	;}
	
	@@WIN: ;{
		MOV BX, OFFSET GHOSTS
		@@CLEAR_LOOP: ;{
			CALL G_CLEAR
			ADD BX, [ARR_JMP]
			CMP BX, [ARR_END]
			JNZ @@CLEAR_LOOP
		;}

		CALL LAYOUT_BLINK
		CALL NEW_LEVEL
	;}
	
	@@End_Proc: ;{
		RET
	;}
;}
ENDP TestWin

;*****************************************************************************
;*****************************************************************************

PROC TestLose
;{
	PUSH AX
	PUSH BX
	MOV  BX, OFFSET GHOSTS 
	
	@@COLL_LOOP:
	;{
		;IS THE GHOST ENABLED? {
			CMP [WORD PTR G_ENABLED], TRUE
			JNZ @@END_LOSE	;IF NO, EXIT
		;}
		
		;IF YES:
		;IS PACX = G_X? {
			MOV AX, [PACX]
			CMP AX, [G_X]
			JNZ @@END_LOSE ;IF NO
		;}
		;IF YES:
		
		;IS PACY = G_Y? {
			MOV AX, [PACY]
			CMP AX, [G_Y]
			JNZ @@END_LOSE ;IF NO
		;}

		;IF YES, THERE IS A COLLISION {	
			
			;ARE THE GHOSTS FIRGHTENED?
			CMP [IS_FRIGH], TRUE
			JZ  @@EAT	;IF YES, EAT THE GHOST.
			
			;KILL PACMAN {	
				;DELAY FOR A BIT {
					PUSH 0Eh	
					PUSH 4000h	
					CALL DELAY
				;}
				
				;KILL PACMAN {
					CALL DIE
					
					;FLUSH BUFFER {
						XOR AL, AL
						MOV AH, 0CH
						INT 21H
					;}

					ADD SP, 10		;UPDATE STACK POINTER BECAUSE OF DIRECT JMP.
					JMP GetFirstDir	;IF NO, RESET THE GAME.
				;}
			;}
			
		;}

		@@EAT: ;{
			CALL EAT_GHOST
		;}
		
		@@END_LOSE: ;{
			ADD BX, [ARR_JMP]
			CMP BX, [ARR_END]
			JNZ @@COLL_LOOP
		;}
	;}
	
	POP BX
	POP AX
	RET
;}
ENDP TestLose

;*****************************************************************************
;*****************************************************************************

PROC GAME_INPUT
;{
	PUSH AX
	PUSH CX
	PUSH DX
	
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
			
			;CX = centerX, DX = centerY ;{
				MOV CX, [PACX]
				MOV DX, [PACY]
				
				ADD CX, 4
				ADD DX, 4
			;}
			
			;CHECK NEW DATA
	
				;UP ARROW?
				CMP AH, ARR_U
				JZ  @@UP
				
				;DOWN ARROW?
				CMP AH, ARR_D
				JZ  @@DOWN
				
				;LEFT ARROW?
				CMP AH, ARR_L
				JZ  @@LEFT
				
				;RIGHT ARROW?
				CMP AH, ARR_R
				JZ  @@RIGHT
				
				;ESC KEY?
				CMP AH, 1
				JZ  @@PAUSE
				JMP @@END_PROC
				
				@@PAUSE: ;{
				
					;PRINT "PAUSED" {
						PUSH 29
						PUSH 5
						CALL TEXT_SET_CURPOS
						
						PUSH OFFSET STR_PAUSED
						CALL TEXT_PRINT_MSG
					;}	
					
					;PRINT "PRESS 'E' TO EXIT" {
						PUSH 27
						PUSH 6
						CALL TEXT_SET_CURPOS
						
						PUSH OFFSET STR_PAUSED_1
						CALL TEXT_PRINT_MSG
					;}
					
					;PRINT "PRESS 'R' TO RESUME" {
						PUSH 26
						PUSH 7
						CALL TEXT_SET_CURPOS
						
						PUSH OFFSET STR_PAUSED_2
						CALL TEXT_PRINT_MSG
					;}
					
					@@PAUSE_LOOP: ;{
					
						
						;GET INPUT {
							MOV AH, 7
							INT 21H
						;}
						
						;INPUT = 'e'? {
							CMP  AL, 'e'
							JNZ  @@DONT_EXIT ;IF NO, CONTINUE.
							CALL END_GAME
							CALL MAINMENU
						;}
						
						@@DONT_EXIT: ;(INPUT = 'r'?) {
							CMP AL, 'r'	
							JNZ @@PAUSE_LOOP ;IF NO GET ANOTHER INPUT.
							
							;CLEAR TEXT {
								PUSH 208
								PUSH 40
								PUSH 96
								PUSH 24
								PUSH BLACK
								CALL GRAPHICS_PRINTRECT
							;}
							
							JMP @@END_PROC ;IF YES, RESUME THE GAME.
						;}
					;}
				;}
		;}
		
		;SET NEW DIRECTION {
			
			@@UP: ;{
				SUB DX, 9
				MOV AX, DIR_U
				JMP @@Update
			;}
			
			@@DOWN: ;{
				ADD DX, 9
				MOV AX, DIR_D
				JMP @@Update
			;}
			
			@@LEFT: ;{
				SUB CX, 9
				MOV AX, DIR_L
				JMP @@Update
			;}
			
			@@RIGHT: ;{
				ADD CX, 9
				MOV AX, DIR_R
			;}
		;}
		
	;}
	
	@@Update:
	;Is The Direction Clear? {		
		PUSH CX
		PUSH DX
		CALL CLEAR_MOVE
		JNC  @@NextDir
	;}
	
	MOV [DIR], AX
	MOV [WORD PTR NEXTDIR], DIR_N
	JMP @@END_PROC
	
	@@NextDir:
	MOV [NEXTDIR], AX
	
	@@END_PROC: ;{
		;FLUSH BUFFER {
			XOR AL, AL
			MOV AH, 0CH
			INT 21H
		;}
		
		POP DX
		POP CX
		POP AX
		RET
	;}
;}
ENDP GAME_INPUT

;*****************************************************************************
;*****************************************************************************

PROC EAT_GHOST
;{
	;DISABLE THE GHOST AND "KILL" IT {
		MOV  [WORD PTR G_ENABLED], FALSE
		MOV  [WORD PTR G_MODE], MODE_DEAD
	;}
	
	CALL G_CLEAR
	CALL PAC_ANIMATION	;PRINT PACMAN
	
	;UPDATE SCORE {
		PUSH [EATGHOST]
		CALL UPDATE_SCORE
		SHL  [EATGHOST], 1
	;}
	
	;EAT THE GHOST'S OBJ {
		
		;OBJ = DOT? {
			CMP [WORD PTR G_OBJ], OBJ_DOT
			JZ  @@DOT
		;}
		
		;OBJ = PP? {
			CMP [WORD PTR G_OBJ], OBJ_PP
			JNZ @@END_PROC
		;}
		
		;PP {
			CALL EAT_PP
			JMP  @@END_PROC
		;}
		
		@@DOT: ;{
			CALL EAT_DOT
		;}
	;}
	
	@@END_PROC: ;{
		;DELAY WHEN EATING A GHOST {
			PUSH 06h
			PUSH 4000h
			CALL DELAY
		;}
		
		;CLEAR NUMBER {
			PUSH 29
			PUSH 13
			CALL TEXT_SET_CURPOS
			
			PUSH BLACK
			PUSH OFFSET PRINT_DEC
			CALL TEXT_COLORSTR
		;}
		
		RET
	;}
;}
ENDP EAT_GHOST

;*****************************************************************************
;*****************************************************************************

PROC UPDATE_SCORE
;{
	;START PROC {
		PUSH BP
		MOV  BP, SP
		NUMBER EQU [WORD PTR BP + 4]
		PUSH AX
	;}

	;UPDATE SCORE {
		MOV AX, NUMBER
		ADD [SCORE], AX
	;}

	;IS THE EXTRA_LIVE_FLAG ON? {
		CMP [BYTE PTR HP_FLAG], TRUE
		JZ  @@PRINT_SCORE ;IF YES, PRINT THE SCORE
	;}
	
	;IF NO, THEN IS (SCORE >= 10,000)? {
		CMP [WORD PTR SCORE], 10000
		JB  @@PRINT_SCORE	;IF NO, PRINT THE SCORE		
	;}
	
	;IF YES, GIVE PACMAN AN EXTRA LIFE {
		INC  [LIVES]
		CALL PRINT_LIVES
		MOV  [BYTE PTR HP_FLAG], TRUE
	;}
	
	@@PRINT_SCORE: ;{
		PUSH 29
		PUSH 12
		CALL TEXT_SET_CURPOS
		
		PUSH OFFSET ARR_DEC
		PUSH [SCORE]
		CALL HEX2DEC
		
		PUSH OFFSET ARR_DEC
		CALL TEXT_PRINTDEC
	;}
	
	CMP NUMBER, 50
	JBE @@END_PROC
	
	;PRINT NUMBER {
		PUSH 29
		PUSH 13
		CALL TEXT_SET_CURPOS
		
		PUSH OFFSET ARR_DEC
		PUSH NUMBER
		CALL HEX2DEC
		
		PUSH OFFSET ARR_DEC
		CALL TEXT_PRINTDEC
		
		PUSH 29
		PUSH 13
		CALL TEXT_SET_CURPOS
		
		PUSH GREEN
		PUSH OFFSET PRINT_DEC
		CALL TEXT_COLORSTR
	;}
	
	@@END_PROC: ;{
		POP AX
		POP BP
		RET 2
	;}
;}
ENDP UPDATE_SCORE

;*****************************************************************************
;*****************************************************************************

PROC DIE
;{
	PUSH BX
	;IF PACMAN IS ON TO A GHOST, CLEAR HER OBJECT {
		MOV [WORD PTR G_OBJ], OBJ_VOID
	;}
	
	;DEC LIVES {
		DEC  [WORD PTR LIVES]
		CALL PRINT_LIVES
	;}
	
	;CLEAR GHOSTS {
		MOV BX, OFFSET GHOSTS
		@@CLEAR: ;{
			CALL G_CLEAR
			ADD BX, [ARR_JMP]
			CMP BX, [ARR_END]
			JNZ @@CLEAR
		;}
	;}
	
	;PLAY THE LOSING ANIMATION {
		CALL PLAY_LOSE_ANI
	;}
	
	;RESET VARIABLES {
		CALL RESET_LIFE
	;}
	
	;IS PACMAN OUT OF LIVES? {
		CMP [WORD PTR LIVES], 0
		JNZ @@PRINT_PAC 
		
		CALL END_GAME
		CALL MAINMENU
	;}
	
	@@PRINT_PAC: ;{
		CALL PAC_PRINT
	;}
	
	POP BX
	RET
;}
ENDP DIE

;*****************************************************************************
;*****************************************************************************

PROC PRINT_LIVES
;{
	;START_PROC {
		PUSH AX
		PUSH CX
		;JMP  @@END_PROC
	;}
	
	;CLEAR LIVES {
		PUSH 208
		PUSH 0
		PUSH 112 ;320 - 208 = 112
		PUSH 9
		PUSH BLACK
		CALL GRAPHICS_PRINTRECT
	;}
	
	;PRINT LIVES {
		;IF LIVES = 0, DONT PRINT.
		CMP [WORD PTR LIVES], 0
		JZ  @@END_PROC
		
		;ELSE, PRINT [LIVES] TIMES
		MOV CX, [LIVES]
		MOV AX, 208; 208 = 207edge of the layout + 1px space
		
		@@LIFE_LOOP: ;{
			PUSH OFFSET PACMAN_R_2
			PUSH YELLOW
			PUSH AX
			PUSH 0
			
			CALL GRAPHICS_PRINTIMAGE
			ADD AX, 10 ;14 = 9px per image + 1px Space
			
			LOOP @@LIFE_LOOP
		;}
	;}
	
	@@END_PROC: ;{
		POP CX
		POP AX
	;}
RET
;}
ENDP PRINT_LIVES

;*****************************************************************************
;*****************************************************************************

PROC INPUT_LOOP
;{
	@@LOOP: ;{
		CALL GAME_INPUT
		JMP @@LOOP
	;}

	RET
;}
ENDP INPUT_LOOP

;*****************************************************************************
;*****************************************************************************

PROC NEW_LEVEL
;{
	;INC LEVEL & UPDATE DIFFICULTY {
		INC [WORD PTR LEVEL]
		
		@@DIFF_0: ;{
			CMP  [WORD PTR LEVEL], 1
			JA   @@DIFF_1
			CALL SET_DIFFICULTY_0
			JMP  @@RESET_GAME
		;}
		
		@@DIFF_1: ;{
			CMP [WORD PTR LEVEL], 2
			JA  @@DIFF_2
			CALL SET_DIFFICULTY_1
			JMP  @@RESET_GAME
		;}
		
		@@DIFF_2: ;{
			CMP [WORD PTR LEVEL], 3
			JA  @@DIFF_3
			CALL SET_DIFFICULTY_2
			JMP  @@RESET_GAME
		;}
		
		@@DIFF_3: ;{
			CMP [WORD PTR LEVEL], 5
			JA  @@DIFF_4
			CALL SET_DIFFICULTY_3
			JMP  @@RESET_GAME
		;}
		
		@@DIFF_4: ;{
			CMP [WORD PTR LEVEL], 7
			JA  @@DIFF_5
			CALL SET_DIFFICULTY_4
			JMP  @@RESET_GAME
		;}
		
		@@DIFF_5: ;{
			CMP  [WORD PTR LEVEL], 10
			JA   @@DIFF_6
			CALL SET_DIFFICULTY_5
			JMP  @@RESET_GAME
		;}
		
		@@DIFF_6: ;{
			CALL SET_DIFFICULTY_6
		;}
	;}
	 
	@@RESET_GAME: ;{
		CALL LAYOUT_CLEAR	;CLEAR LAYOUT, DOTS, GHOSTS, PACMAN
		CALL LAYOUT_PRINT_ALLDOTS;PRINT DOTS
		MOV  AX, BLUE
		CALL LAYOUT_PRINT	;PRINT LAYOUT
		
		CALL RESET_LIFE
		CALL PAC_PRINT
		CALL PRINT_LIVES	

	;}
	
	;GENERAL STUFF {
		MOV [WORD PTR CNT_DOTS], 0	
		MOV [BYTE PTR IS_FRIGH], 0
		MOV [WORD PTR EATGHOST], 200
		
		;print str_score {
			PUSH 29
			PUSH 11
			CALL TEXT_SET_CURPOS
			
			PUSH OFFSET STR_SCORE
			CALL TEXT_PRINT_MSG
		;}
		
		;print score {
			PUSH 29
			PUSH 12
			CALL TEXT_SET_CURPOS
			
			PUSH OFFSET ARR_DEC
			PUSH [SCORE]
			CALL HEX2DEC
			
			PUSH OFFSET ARR_DEC
			CALL TEXT_PRINTDEC
		;}
	;}

	;FLUSH BUFFER {
		XOR AL, AL
		MOV AH, 0CH
		INT 21H
	;}
	
	ADD SP, 10		;UPDATE SP BECAUSE OF DIRECT JMP.
	JMP GetFirstDir	;START THE GAME.
	RET
;}
ENDP NEW_LEVEL

;*****************************************************************************
;*****************************************************************************

PROC PLAY_LOSE_ANI
;{
	;START PROC {
		PUSH BX
		PUSH CX
	;}
	
	;PLAY ANIMATION {
		;PRINT 1st FRAME {
			CALL PAC_CLEAR
			CALL PAC_PRINT
	
			PUSH 2
			PUSH 0BF20h
			CALL DELAY
			
			CALL PAC_CLEAR
		;}
		
		;PRINT 2nd-7th FRAMES {
			MOV BX, OFFSET LOSE_ANI
			MOV CX, 6
			
			@@ANIMATION_LOOP: ;{
				
				;PRINT FRAME {
					PUSH [BX]
					PUSH YELLOW
					PUSH [PACX]
					PUSH [PACY]
					CALL GRAPHICS_PRINTIMAGE
				;}
				
				;DELAY BETWEEN FRAMES {
					PUSH 2
					PUSH 0BF20h
					CALL DELAY
				;}
				
				;CLEAR FRAME {
					CALL PAC_CLEAR
				;}
				
				ADD BX, 2
				LOOP @@ANIMATION_LOOP
			;}
		;}
	;}
	
	@@END_PROC: ;{
		POP CX
		POP BX
		RET
	;}
;}
ENDP PLAY_LOSE_ANI

;*****************************************************************************
;*****************************************************************************

PROC RESET_LIFE
;{
	PUSH AX
	
	;RESET GHOSTS {		
		CALL G_ZERO
		CALL G_INIT
	;}
	
	;RESET_TIMERS: {
		
		;MOVE TIMERS {
			MOV AX, [SPEED]
			
			MOV  [INT_MOV],  AX
			MOV  [WORD PTR CNT_MOV], 0
	        
			MOV  [INT_GMOV], AX
			MOV  [WORD PTR CNT_GMOV], 0
		;}
    
		;MODE SWAPING {
			;1ST SCAT {
				MOV  AX, [DUR_1ST_SCAT]
				MOV  [INT_MODE], AX
				MOV  [WORD PTR CNT_MODE], 0
			;}
			
			;CHASE & SCATTER DURATIONS {
				MOV AX, [DUR_CHASE]
				MOV [INT_CHASE], AX
				
				MOV AX, [DUR_SCAT]
				MOV [INT_SCAT], AX
				
			;}
		;}
		
		;FRIGHTENED & BLINK TIMER {
			MOV AX, [DUR_FRI]
			MOV [INT_FRI], AX
			MOV [CNT_FRI], 0
			
			MOV [CNT_BLINK], 0
		;}
	;}
	
	;RESET PACMAN {
		MOV  [WORD PTR PACX], 99
		MOV  [WORD PTR PACY], 144
		MOV  [WORD PTR DIR], DIR_N
		MOV  [WORD PTR NEXTDIR], DIR_N
		MOV  [WORD PTR CNT_DOTS_TEMP], 0
		MOV  [WORD PTR PAC_FP], 0
	;}
	
	POP AX
	RET
;}
ENDP RESET_LIFE

;*****************************************************************************
;*****************************************************************************

PROC SCAN_SCREEN
;{
	;START PROC {
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
	;}
	
	MOV BX, OFFSET GHOSTS
	@@GHOST_LOOP: ;{
	
		;IS THE GHOST DISABLED? {
			CMP [WORD PTR G_ENABLED], FALSE
			JZ  @@GHOST_END	;IF YES, EXIT THE LOOP
		;}
		
		;IS GHOST.OBJ = OBJ_DOT? {
			CMP [WORD PTR G_OBJ], OBJ_DOT
			JZ  @@END_PROC	;IF YES, EXIT PROCEDURE
		;}
		
		;IS GHOST.OBJ = OBJ_PP? {
			CMP [WORD PTR G_OBJ], OBJ_PP
			JZ  @@END_PROC ;IF YES, EXIT PROCEDURE
		;}
		
		@@GHOST_END: ;{
			ADD BX, [ARR_JMP]
			CMP BX, [ARR_END]
			JNZ @@GHOST_LOOP
		;}
	;}
	
	;IF NONE OF THE GHOTS OBJ = DOT/PP, CONTINUE:
	
	;SCAN THE SCREEN FOR DOTS {
		MOV DX, 13
		
		;PRINT DOTS {	
			@@Y_LOOP: ;{
				MOV CX, 13
				
				@@X_LOOP: ;{
					PUSH CX
					PUSH DX
					CALL GRAPHICS_GETCOLOR
					
					;IS THERE A DOT/PP AT THIS LOCATION? {
						CMP AX, WHITE
						JZ  @@CLC		;IF YES, OUTPUT 0.
						
						CMP AX, PP_PINK
						JZ  @@CLC		;IF YES, OUUTPUT 0.
					;}
					
					;X_END {
						ADD CX, 9
						CMP CX, 202
						JNZ @@X_LOOP
					;}
				;}
				
				ADD DX, 9
				CMP DX, 193
				JB  @@Y_LOOP
			;}
		;}
	;}
	
	;@@STC: PACMAN WON {
		STC
		JMP @@END_PROC
	;}
	
	@@CLC: ;PACMAN DIDN'T WIN { 
		CLC
	;}
	
	@@END_PROC: ;{
		POP DX
		POP CX
		POP BX
		POP AX
		RET
	;}
;}
ENDP SCAN_SCREEN

;*****************************************************************************
;*****************************************************************************
PROC NEW_GAME
;{
	MOV [WORD PTR LEVEL], 0
	MOV [WORD PTR LIVES], 4
	MOV [WORD PTR SCORE], 0
	
	MOV [BYTE PTR HP_FLAG], FALSE
	
	CALL NEW_LEVEL
	RET
;}
ENDP NEW_GAME
;*****************************************************************************
;*****************************************************************************
PROC END_GAME
;{
	CALL LAYOUT_CLEAR
	
	;PRINT "GAME OVER" {
		PUSH 15
		PUSH 11
		CALL TEXT_SET_CURPOS
		
		PUSH RED
		PUSH OFFSET STR_GAMEOVER
		CALL TEXT_COLORSTR
	;}
	
	;PRINT SCORE {
		PUSH 15
		PUSH 13
		CALL TEXT_SET_CURPOS
		
		PUSH OFFSET STR_SCORE
		CALL TEXT_PRINT_MSG     
		;=============
		PUSH 21
		PUSH 13
		CALL TEXT_SET_CURPOS
	
		PUSH OFFSET ARR_DEC
		PUSH [SCORE]
		CALL HEX2DEC
		
		PUSH OFFSET ARR_DEC
		CALL TEXT_PRINTDEC
	;}
	
	;DELAY 4 SECONDS {
		PUSH 3Dh
		PUSH 900h
		CALL DELAY
	;}
	
	RET
	
;}
ENDP END_GAME