PROC G_TARGET
;{
	PUSH BX
	MOV  BX, OFFSET GHOSTS
	
	;G_MODE = CHASE?	{
		CMP  [WORD PTR G_MODE], MODE_CHASE
		JZ   @@CHASE
	;}
	
	;IF NOT, THEN G_MODE = SCATTER:
	
	;SET BLINKY'S(RED) TARGET {
		MOV [WORD PTR G_TARX], 198
		MOV [WORD PTR G_TARY], 0
	;}
	
	ADD BX, [ARR_JMP]
	;SET PINKY'S(PINK) TARGET {	
		MOV [WORD PTR G_TARX], 0
		MOV [WORD PTR G_TARY], 0
	;}
	
	ADD BX, [ARR_JMP]
	;SET INKY'S(LIGHT_BLUE) TARGET{
		MOV [WORD PTR G_TARX], 198
		MOV [WORD PTR G_TARY], 189
	;}
	ADD BX, [ARR_JMP] 
	;SET CLYDE'S(ORANGE) TARGET{	
		MOV [WORD PTR G_TARX], 0
		MOV [WORD PTR G_TARY], 189
	;}
	JMP @@END_PROC	
		
	@@CHASE:
	;{
		;DETERMINES A TARGET TILE FOR EACH GHOST,
		;EACH GHOST HAS A DIFFERNT WAY TO DETERMINE A TARGET TIEL.
		CALL RED_AI
		CALL PINK_AI
		CALL BLUE_AI
		CALL ORANGE_AI
	;}
	
	@@END_PROC:
	POP BX
	RET
;}
ENDP G_TARGET

;************************************************************************
;************************************************************************

PROC G_PRINT
;{
	;PUSH REGS {
		PUSH CX
		PUSH DX
	;}
	
	;IS THE GHOST ENABLED? {
		CMP [WORD PTR G_ENABLED], FALSE
		JNZ @@PRINT		;IF YES, PRINT IT.
		JMP @@END_PROC	;IF NO,  DONT.
	;}
	
	@@PRINT:
	;ARE THE GHOSTS FIRGHTENED? IF SO PRINT SCARED GHOSTS {
		CMP [BYTE PTR IS_FRIGH], TRUE
		JZ  @@PRINT_FIRGH
	;}
	
	;ELSE, PRINT NORMAL GHOSTS:
	;PRINT GHOST IMAGE {
		PUSH OFFSET GHOST_0
		PUSH [G_COLOR]
		PUSH [G_X]
		PUSH [G_Y]
		CALL GRAPHICS_PRINTIMAGE
	;}
	
	MOV CX, [G_X]
	MOV DX, [G_Y]
	
	;PRINT EYES {
		;LEFT EYE {
			INC CX
			ADD DX, 2

			PUSH CX
			PUSH DX
			PUSH 3
			PUSH 3
			PUSH WHITE
			CALL GRAPHICS_PRINTRECT
		;}	
		
		;RIGHT EYE {
			ADD  CX, 4
			PUSH CX
			PUSH DX
			PUSH 3
			PUSH 3
			PUSH WHITE
			CALL GRAPHICS_PRINTRECT
		;}
		
		;EYEBALLS {

			;DIR = UP?
			CMP [WORD PTR G_DIR], DIR_U
			JZ  @@UP
			
			;DIR = DOWN?
			CMP [WORD PTR G_DIR], DIR_D
			JZ  @@DOWN
			
			;DIR = LEFT?
			CMP [WORD PTR G_DIR], DIR_L
			JZ  @@LEFT
			
			;ELSE, DIR = RIGHT
			JMP @@RIGHT
			
			@@UP: ;{
				INC CX
				JMP @@EYEBALLS
			;}
			
			@@DOWN: ;{
				INC CX
				ADD DX, 2
				JMP @@EYEBALLS
			;}
			
			@@LEFT: ;{
				INC DX
				JMP @@EYEBALLS
			;}
			
			@@RIGHT: ;{
				ADD CX, 2
				INC DX
			;}
			
			@@EYEBALLS: ;{
				PUSH CX
				PUSH DX
				PUSH 1
				PUSH 1
				PUSH BLACK
				CALL GRAPHICS_PRINTRECT
				
				SUB CX, 4
				
				PUSH CX
				PUSH DX
				PUSH 1
				PUSH 1
				PUSH BLACK
				CALL GRAPHICS_PRINTRECT
			;}
			JMP @@END_PROC
		;}
		
		@@PRINT_FIRGH: ;{
			PUSH SI
			MOV SI, [G_BLINK]
			INC SI
			SHL SI, 1
			ADD SI, OFFSET G_FRI_COL
			
			;PRINT GHOST IMAGE {
				PUSH OFFSET GHOST_0
				PUSH [SI]
				PUSH [G_X]
				PUSH [G_Y]
				CALL GRAPHICS_PRINTIMAGE
			;}
			
			;PRINT EYES {
				PUSH OFFSET FRIGH_EYES
				PUSH [SI + 2]
				PUSH [G_X]
				PUSH [G_Y]
				CALL GRAPHICS_PRINTIMAGE
			;}		
			POP SI
		;}
	;}
	
	@@END_PROC: ;{
		POP DX
		POP CX
		RET
	;}
;}
ENDP G_PRINT

;************************************************************************
;************************************************************************

PROC G_CLEAR
;{	
	;IS THE GHOST ENABLED? {
		CMP [WORD PTR G_ENABLED], TRUE
		JZ  @@ENABLED	;IF YES, CLEAR.
		JMP @@END_PROC
	;}
	
	@@ENABLED:
	;IS THE GHOST AT (0,0)? {
		CMP [WORD PTR G_X], 0
		JNZ @@CLEAR
	    
		CMP [WORD PTR G_Y], 0
		JNZ @@CLEAR
		JMP @@END_PROC
	;}

	@@CLEAR: ;{
		PUSH [G_X]
		PUSH [G_Y]
		PUSH 9
		PUSH 9
		PUSH BLACK
		CALL GRAPHICS_PRINTRECT
	;}
	
	;PRINT OBJ (OBJ = THE THING THE GHOST IS STANDING ON) {
		;OBJ = DOT? {
			CMP [WORD PTR G_OBJ], OBJ_DOT
			JZ  @@DOT
		;}
		
		;OBJ = PP?
			CMP [WORD PTR G_OBJ], OBJ_PP
			JZ  @@PP
		;}
		
		;OBJ = VOID {
			JMP @@END_PROC
		;}
		
		@@DOT: ;{
			PUSH [G_X]
			PUSH [G_Y]
			CALL LAYOUT_PRINT_DOT
			JMP  @@END_PROC
		;}
		
		@@PP: ;{			
			PUSH [G_X]
			PUSH [G_Y]
			CALL LAYOUT_PRINT_PP
		;}
	;}
	
	@@END_PROC: ;{
		MOV [WORD PTR G_OBJ], OBJ_VOID
		RET 
	;}
;}
ENDP G_CLEAR

;************************************************************************
;************************************************************************

PROC G_GETPOSDIR
;{
	PUSH AX
	PUSH CX
	PUSH DX
	
	;CODE {
		;UP {
			MOV CX, [G_X]
			MOV DX, [G_Y]
			
			;(Y = 144) OR (Y = 72)? {
			;(AT 4 POINTS OF THE MAP THE GHOSTS CAN'T TURN UP.)
			;(THE Y OF ALL POINTS IS 144 OR 72)
				CMP DX, 144
				JZ  @@TRUE_Y
				
				CMP DX, 72
				JZ  @@TRUE_Y
				JMP @@FALSE
			;}
			
			@@TRUE_Y: ;{
				;(X = 90 || X = 108)? {
					CMP CX, 90
					JZ  @@TRUE_X
					CMP CX, 108
					JNZ @@FALSE
				;}
			;}
			
			@@TRUE_X: ;{
				MOV [WORD PTR G_PDIR_U], LOC_N
				JMP @@DOWN
			;}
			
			@@FALSE:
			
			;CX & DX POINT TO THE TILE THE GHOST WOULD BE IN
			;IF IT WOULD GO UP:			
			SUB DX, 9	
			MOV [WORD PTR G_PDIR_U], LOC_N	;LOC_N = LOC_NULL = 0FFFFh, 
											;IT MEANS THE TILE IS NOT CLEAR.
			
			;CHECK IF THE TILE IS CLEAR
			PUSH CX
			PUSH DX
			CALL CLEAR_MOVE
			JNC @@DOWN	;JMP NOT CLEAR DOWN, TILE REMAINS AT LOC_N
			
			;IF CLEAR, SET THE WORD TO [Xbyte,Ybyte]
			MOV AH, CL
			MOV AL, DL
			MOV [G_PDIR_U], AX
			
			;THE CODE BELOW REPEATS THE SAME PROCCESS, BUT FOR THE REST
			;OF THE DIRECTIONS.
		;}
		
		@@DOWN: ;{
			MOV CX, [G_X]
			MOV DX, [G_Y]
			ADD DX, 9
			MOV [WORD PTR G_PDIR_D], LOC_N
			
			PUSH CX
			PUSH DX
			CALL CLEAR_MOVE
			JNC @@LEFT
			
			MOV AH, CL
			MOV AL, DL
			MOV [G_PDIR_D], AX
		;}
		
		@@LEFT: ;{
			MOV CX, [G_X]
			MOV DX, [G_Y]
			SUB CX, 9
			MOV [WORD PTR G_PDIR_L], LOC_N
			
			;CHECKS IF THE TILE OVERFLOWS THROUGH THE TUNNLES.
			CMP CX, 0FFF7h		;X = -9?
			JNZ @@NO_OVERFLOW_L	;IF NOT, NOT OVERFLOW
			
			MOV CX, 198			;IF YES, SET X TO 198 (RIGHT EDGE OF THE MAP)
			
			@@NO_OVERFLOW_L:
			PUSH CX
			PUSH DX
			CALL CLEAR_MOVE
			JNC @@RIGHT
			
			MOV AH, CL
			MOV AL, DL
			MOV [G_PDIR_L], AX		
		;}
		
		@@RIGHT: ;{
			MOV CX, [G_X]
			MOV DX, [G_Y]
			ADD CX, 9
			MOV [WORD PTR G_PDIR_R], LOC_N
		
			CMP CX, 207			;X = 207 (PAST THE EDGE OF THE MAP)
			JNZ @@NO_OVERFLOW_R	;IF NO, NO OVERFLOW
			MOV CX, 0			;IF YES, X = 0 (LEFT EDGE)
			
			@@NO_OVERFLOW_R:
			PUSH CX
			PUSH DX
			CALL CLEAR_MOVE
			JNC @@BACK
			
			MOV AH, CL
			MOV AL, DL
			MOV [G_PDIR_R], AX
		;}
		
		@@BACK: ;{
			;MAKES IT SO THAT THE GHOST CAN'T TURN BACK (180 DEG TURN)
			
			MOV AX, [G_DIR]
			NEG AL	;NEG Xbyte 
			NEG AH	;NEG Ybyte
			
			MOV CH, [BYTE PTR G_X]
			MOV CL, [BYTE PTR G_Y]				
			
			ADD CL, AL	;CL = BACK_Y
			ADD CH, AH	;CH = BACK_X
			
			;HANDLE OVERFLOW {			
				CMP CH, 0F7h
				JZ  @@OVERFLOW_L
				
				CMP CH, 207
				JZ  @@OVERFLOW_R
				JMP @@AFTER_OVERFLOW
				
				
				@@OVERFLOW_L:
				MOV CH, 198
				JMP @@AFTER_OVERFLOW
				
				@@OVERFLOW_R:
				MOV CH, 0
			;}
			
			@@AFTER_OVERFLOW:
			MOV AX, BX
			ADD AX, 16	;AX = POSSIBLE TILES ARRAY.OFFSET
			
			PUSH CX		;CX = [Ybyte,Xbyte]
			PUSH LOC_N	
			PUSH 4 		;ARRAY.LENGTH
			PUSH AX		;ARRAY.OFFSET
			CALL FINDNREP_W ;FIND(CX) AND REPLACE WITH(LOC_N)
		;}
	;}
	
	@@END_PROC: ;{
		POP DX
		POP CX
		POP AX
		RET
	;}
;}
ENDP G_GETPOSDIR

;************************************************************************
;************************************************************************

PROC CLEAR_MOVE
;{
	;INTPUT: X, Y
	;OUTPUT: CF (1 = CLEAR, 0 = NOT CLEAR), BH = 1; BL = 1;
	
	;PARAMS {
		PX_X EQU [WORD PTR BP + 6]
		PX_Y EQU [WORD PTR BP + 4]
	;}
	
	;PUSH & BASEPOINTER {
		PUSH BP
		MOV  BP, SP
		
		PUSH AX
	;}
	
	;GET COLOR {
		ADD PX_X, 4
		ADD PX_Y, 4
	
		PUSH PX_X
		PUSH PX_Y
		CALL GRAPHICS_GETCOLOR
		
		CMP AL, blue
		JZ  @@NOT_CLEAR
		
		@@CLEAR:
		STC	;CF = 1
		JMP @@END_PROC
		
		@@NOT_CLEAR:
		CLC	;CF = 0
		
	;}
	
	@@END_PROC:
	;POP {
		POP AX
		POP BP
		RET 4
	;}
	
;}
ENDP CLEAR_MOVE

;*****************************************************************************
;*****************************************************************************

;************************************************************************
;************************************************************************
PROC G_NORMAL_AI
;{
	;DETERMINE'S THE GHOST'S DIRECTION BASED ON THE TILES AVAILEBLE
	
	;PUSH REGS {
		PUSH AX
		PUSH DI
	;}
	
	;CODE {
		;AH = TARGET.X, AL = TARGET.Y
		MOV AL, [BYTE PTR G_TARY]
		MOV AH, [BYTE PTR G_TARX]
		XOR DI, DI
		
		@@DIST_LOOP:
		;{
			CMP [WORD PTR G_PDIR + DI], LOC_N 
			JZ  @@END_DIST
			
			;IF TILE IS CLEAR, THEN DIST(TILE, TRAGET);
			PUSH AX
			PUSH [G_PDIR + DI]
			CALL MATH_DIST	
			
			POP  [G_PDIR + DI];REPLACES TILE LOCATION WITH DIST TO TARGET
			
			@@END_DIST: ;{
				ADD DI, 2
				CMP DI, 8
				JNZ @@DIST_LOOP
			;}
		;}
		
		;CHOOSE DIRECTION: {
			MOV DI, BX
			ADD DI, 16
			
			PUSH 4
			PUSH DI
			CALL FINDMIN_W	;FIND THE MIN DIST AND RETURN IT'S INDEX
			POP DI			;DI = INDEX
			
			;INDEX = RIGHT?
				CMP DI, IDIR_R
				JZ  @@RIGHT
			;}	
			
			;INDEX = DOWN? {
				CMP DI, IDIR_D
				JZ  @@DOWN
			;}
			
			;INDEX = LEFT? {
				CMP DI, IDIR_L
				JZ  @@LEFT
			;}
			
		;======================
		;SET DIRECTION:
			@@UP:	;{
				MOV [WORD PTR G_DIR], DIR_U
				JMP @@END_PROC
			;}
			
			@@DOWN: ;{
				MOV [WORD PTR G_DIR], DIR_D
				JMP @@END_PROC
			;}
			
			@@LEFT:	;{
				MOV [WORD PTR G_DIR], DIR_L
				JMP @@END_PROC
			;}
			
			@@RIGHT:;{
				MOV [WORD PTR G_DIR], DIR_R
			;}
		;}
	;}
	@@END_PROC: ;{
		POP DI
		POP AX
		RET
	;}
;}
ENDP G_NORMAL_AI
;************************************************************************
;************************************************************************
PROC G_FRIGH_AI
;{
	;DOES THE SAME THING AS G_NORMAL_AI, BUT FOR WHEN THE GHOSTS
	;ARE FRIGHTENED.
	;PUSH REGS {
		PUSH AX
		PUSH DI
	;}
	
	;CODE {
		MOV AL, [BYTE PTR PACY]
		MOV AH, [BYTE PTR PACX]
		XOR DI, DI

		@@DIST_LOOP:
		;{
			CMP [WORD PTR G_PDIR + DI], LOC_N
			JZ  @@END_DIST
			
			;IF TILE IS CLEAR, THEN DIST(PACMAN, TILE)
			PUSH AX
			PUSH [G_PDIR + DI]
			CALL MATH_DIST
			
			POP  [G_PDIR + DI];REPLACES TILE WITH DIST.
			
			@@END_DIST: ;{
				ADD DI, 2
				CMP DI, 8
				JNZ @@DIST_LOOP
			;}
		;}
		
		;CHOOSE DIRECTION: {
			MOV DI, BX
			ADD DI, 16
			
			;FIND MAX INDEX {
				PUSH 4
				PUSH DI
				CALL FINDMAX_W
				POP DI
			;}
			
			;MAX_INEDX = RIGHT? {
				CMP DI, IDIR_R
				JZ  @@RIGHT
			;}	
			
			;MAX_INEDX = DOWN? {
				CMP DI, IDIR_D
				JZ  @@DOWN
			;}
			
			;MAX_INEDX = LEFT? {
				CMP DI, IDIR_L
				JZ  @@LEFT
			;}
			
			;ELSE, MAX_INEDX = UP.
		;======================
			;SET DIRECTION {
				@@UP:	;{
					MOV [WORD PTR G_DIR], DIR_U
					JMP @@END_PROC
				;}
				
				@@DOWN: ;{
					MOV [WORD PTR G_DIR], DIR_D
					JMP @@END_PROC
				;}
				
				@@LEFT:	;{
					MOV [WORD PTR G_DIR], DIR_L
					JMP @@END_PROC
				;}
				
				@@RIGHT:;{
					MOV [WORD PTR G_DIR], DIR_R
				;}
			;}
	;}
	
	@@END_PROC: ;{
		POP DI
		POP AX
		RET
	;}
;}
ENDP G_FRIGH_AI

;************************************************************************
;************************************************************************

PROC G_MOVE
;{
	;PUSH REGS {
		PUSH BX
		PUSH CX
		PUSH DX
	;}
	
	;CLEAR THE GHOSTS {
		MOV BX, OFFSET GHOSTS
		@@CLEAR_LOOP: ;{
			CALL G_CLEAR
			@@END_CLEAR: ;{
				ADD BX, [ARR_JMP]
				CMP BX, [ARR_END]
				JNZ @@CLEAR_LOOP
			;}
		;}
	;}
	
	;MOVE THE GHOSTS {
		MOV BX, OFFSET GHOSTS
		
		@@MOVE_LOOP:
		;{
			;IS THE GHOST ENABLED? {
				CMP [WORD PTR G_ENABLED], FALSE
				JZ  @@END_MOVE
			;}
			
			;IF ENABLED: {
				CALL G_GETPOSDIR
		
				;ARE THE GHOSTS FIRGHTENED?
				CMP [IS_FRIGH], TRUE
				JZ  @@FRIGH_AI
					
				;IF NOT, USE NORMAL AI
				CALL G_NORMAL_AI
				JMP @@MOVE_GHOST
				
				
				@@FRIGH_AI: ;IF YES, USE SPECIEL AI
				CALL G_FRIGH_AI
			;}
			
			@@MOVE_GHOST:
			;SET CX & DX {
				MOV CX, [G_X]
				MOV DX, [G_Y]
			;}
			
			;LITTLE ENDIAN {
				ADD CL, [BYTE PTR G_DIR + 1]
				ADD DL, [BYTE PTR G_DIR]
			;}
			
			;HANDLE OVERFLOW: {	
				CMP CL, 0F7h
				JZ  @@OVERFLOW_L
				
				CMP CX, 207
				JZ  @@OVERFLOW_R
				JMP @@TEST_OBJ
				
				@@OVERFLOW_L:
				MOV CX, 198
				JMP @@TEST_OBJ
				
				@@OVERFLOW_R:
				MOV CX, 0
			;}
			
			@@TEST_OBJ: ;{		
				PUSH CX
				PUSH DX
				CALL G_FINDOBJ	
				POP  [G_OBJ];[G_OBJ] OBJECT IN THE DESTENATION TILE 
			;}
			
			;UPDATE X & Y{
				MOV [G_X], CX
				MOV [G_Y], DX
			;}
	
			@@END_MOVE: ;{
				ADD BX, [ARR_JMP]
				CMP BX, [ARR_END]
				JNZ @@MOVE_LOOP
			;}
		;}
	;}
	
	;PRINT THE GHOSTS {
		MOV BX, OFFSET GHOSTS
		@@PRINT_LOOP: ;{
			CALL G_PRINT
			@@END_PRINT: ;{
				ADD BX, [ARR_JMP]
				CMP BX, [ARR_END]
				JNZ @@PRINT_LOOP
			;}
		;}
	;}
	
	@@END_PROC: ;{
		POP DX
		POP CX
		POP BX
		RET
	;}
;}
ENDP G_MOVE
;************************************************************************
;************************************************************************

PROC G_FINDOBJ
;{
	;INTPUT: X, Y
	;OUTPUT: OBJECT AT THAT TILE;
	
	;PARAMS {
		PX_X EQU [WORD PTR BP + 6]
		PX_Y EQU [WORD PTR BP + 4]
	;}
	
	;PUSH & BASEPOINTER {
		PUSH BP
		MOV  BP, SP
		
		PUSH AX
		PUSH BX
	;}
	
	;GET COLOR {
	
		ADD PX_X, 4
		ADD PX_Y, 4
	
		PUSH PX_X
		PUSH PX_Y
		CALL GRAPHICS_GETCOLOR
		
		;WALL? {
			CMP AL, BLUE
			JZ  @@WALL
		;}
		
		;DOT? {
			CMP AL, WHITE
			JZ  @@DOT
		;}
		
		;PP? {
			CMP AL, PP_PINK
			JZ  @@PP
		;}
		
		;VOID? {
			CMP AL, BLACK
			JZ  @@VOID
		;}
		
		;ELSE, ANOTHER GHOST {
			;TRACE THAT GHOST {
				SUB  PX_X, 4
				SUB  PX_Y, 4
				
				PUSH PX_X
				PUSH PX_Y
				CALL G_TRACE
				POP BX			;BX = THE GHOST'S BASE ADDRESS
				
				CMP BX, [ARR_END]
				JZ  @@VOID
			;}
			
			PUSH [G_OBJ]
			POP  PX_X 
			JMP  @@END_PROC
		;}
		
		@@WALL: ;{
			MOV PX_X, OBJ_WALL
			JMP @@END_PROC
		;}
		
		@@DOT: ;{
			MOV PX_X, OBJ_DOT
			JMP @@END_PROC
		;}
		
		@@PP: ;{
			MOV PX_X, OBJ_PP
			JMP @@END_PROC
		;}
		
		@@VOID: ;{
			MOV PX_X, OBJ_VOID
		;}
	
	@@END_PROC: ;{
		POP BX
		POP AX
		POP BP
	;}
	
	RET 2
;}
ENDP G_FINDOBJ

;************************************************************************
;************************************************************************
PROC G_INIT
;{
	MOV BX, OFFSET GHOSTS

	;INIT BLINKY(RED) {
		MOV [WORD PTR G_MINDOTS], 0
		MOV [WORD PTR G_COLOR], RED
	;}
	
	ADD BX, [ARR_JMP]
	
	;INIT PINKY(PINK) {		
		MOV [WORD PTR G_MINDOTS], 5
		MOV [WORD PTR G_COLOR], PINK
	;}
	
	ADD BX, [ARR_JMP]
	
	;INIT INKY(LIGHT_BLUE) {
		MOV [WORD PTR G_MINDOTS], 20
		MOV [WORD PTR G_COLOR], light_cyan
	;}
	
	ADD BX, [ARR_JMP] 
	
	;INIT CLYDE(ORANGE) {
		MOV [WORD PTR G_MINDOTS], 60
		MOV [WORD PTR G_COLOR], orange
	;}
	RET
;}
ENDP G_INIT
;************************************************************************
;************************************************************************
PROC G_ENABLE
;{
	;ENABLES A GHOST.
	
	MOV  [WORD PTR G_ENABLED], TRUE
	MOV  [WORD PTR G_X], 99
	MOV  [WORD PTR G_Y], 72
	CALL G_PRINT
	RET
;}
ENDP G_ENABLE
;************************************************************************
;************************************************************************
PROC G_CHECK_DOTS
;{
	;CHECKS IF ENOUGH DOTS WERE EATEN TO ENABLE SOME GHOSTS.
	
	PUSH BX
	MOV  BX, OFFSET GHOSTS
	@@LOOP: ;{
		CMP [WORD PTR G_ENABLED], TRUE	;IS THE GHOST ENABLED?
		JZ  @@END_LOOP					;IF YES.
		
		;IF NO:
		CMP [WORD PTR G_MODE], MODE_DEAD ;IS THE GHOST DEAD?
		JZ  @@END_LOOP					 ;IF YES.
		
		;IF NO:
		MOV AX, [CNT_DOTS_TEMP]
		CMP AX, [G_MINDOTS]		;WERE ENOUGH DOTS EATEN TO ENABLE THE GHOST?
		JB  @@END_LOOP			;IF NO
		
		CALL G_ENABLE		;IF YES, ENABLE THE GHOST
		
		@@END_LOOP:
		ADD BX, [ARR_JMP]
		CMP BX, [ARR_END]
		JNZ  @@LOOP
	;}
	
	POP BX
	RET
;}
ENDP G_CHECK_DOTS
;************************************************************************
;************************************************************************
;Description: Gets X & Y, and returns the base index of the ghost at that X & Y
PROC G_TRACE
;{
	;START_PROC {
		PUSH BP
		MOV  BP, SP
		
		PX_X EQU [BP + 6]
		PX_Y EQU [BP + 4]
		
		PUSH BX
		PUSH CX
		PUSH DX
	;}
	
	;CODE {
		MOV BX, OFFSET GHOSTS
		
		MOV CX, PX_X
		MOV DX, PX_Y
		
		@@TRACE_LOOP: ;{
			CMP [G_X], CX
			JZ  @@TRUE
			
			@@TRUE:
			CMP [G_Y], DX
			JNZ @@END_TRACE
			
			;TRACED GHOST {
				JMP @@END_PROC
			;}	
			
			@@END_TRACE: ;{
				ADD BX, [ARR_JMP]
				CMP BX, [ARR_END]
				JNZ @@TRACE_LOOP
			;}
		;}
	;}
	
	@@END_PROC: ;{
		MOV PX_X, BX
		
		POP DX
		POP CX
		POP BX
		POP BP
		RET 2
	;}
;}
ENDP G_TRACE
;************************************************************************
;************************************************************************
PROC G_ZERO
;{
	;START_PROC {
		PUSH BX
		PUSH CX
	;}
	
	;ZERO ARRAY {
		MOV BX, OFFSET GHOSTS
		MOV CX, 56
		@@ZERO_LOOP: ;{
			MOV [WORD PTR BX], 0
			ADD BX, 2
			LOOP @@ZERO_LOOP
		;}
	;}
	
	@@END_PROC: ;{
		POP CX
		POP BX
		RET
	;}
;}
ENDP G_ZERO