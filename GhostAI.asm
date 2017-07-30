PROC RED_AI
;{	
	;AI: PACMAN IS HIS TARGET TILE.
	
	;PUSH REGS {
		PUSH BX
	;}
	
	;CODE {
		;BX = BLINKY.BASE {
			MOV BX, OFFSET GHOSTS
		;}
		
		PUSH [PACX]
		POP  [G_TARX]
		
		PUSH [PACY]
		POP  [G_TARY]

	;}
	
	@@END_PROC: ;{
		POP BX
		RET
	;}
;}
ENDP RED_AI

;*********************************
;*********************************

PROC PINK_AI
;{
	;AI: TRIES TO GET INFORNT OF PACMAN. HIS TARGET TILE IS 3 BLOCKS 
	;FORWORD IN PACMAN'S CURRENT DIRECTION
	
	;PUSH REGS {
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
	;}
	
	;CODE {
		;BX = PINKY.BASE {
			MOV BX, OFFSET GHOSTS
			ADD BX, [ARR_JMP]
		;}
		
		MOV AX, [PACX]
		MOV DX, [PACY]
		MOV CX, 3
		
		@@TILE_LOOP: ;{
			;LITTLE ENDIAN
			ADD AL, [BYTE PTR DIR + 1]
			ADD DL, [BYTE PTR DIR]
				
			;HANDLE OVERFLOW: {
				
				CMP AL, 0F7h
				JZ  @@OVERFLOW_L
				
				CMP AX, 207
				JZ  @@OVERFLOW_R
				JMP @@END_TILE
				
				
				@@OVERFLOW_L:
				MOV AX, 198
				JMP @@END_TILE
				
				@@OVERFLOW_R:
				MOV AX, 0
				JMP @@END_TILE
			;}
			
			@@END_TILE:
			LOOP @@TILE_LOOP
		;}
		
		MOV [G_TARX], AX
		MOV [G_TARY], DX
	;}
	
	@@END_PROC: ;{
		POP DX
		POP CX
		POP BX
		POP AX
		RET
	;}
;}
ENDP PINK_AI

;*********************************
;*********************************

PROC BLUE_AI
;{
	;AI: CALCS THE DISTANCE FROM BLINKY(RED GHOST) TO PACMAN, AND DOUBLES IT.
	;THE TILE IT POINTS TO AFTER DOUBLING THE DISTANCE IS INKY'S TARGET TILE.
	
	;PUSH REGS {
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
	;}
	
	;CODE {
		MOV BX, OFFSET GHOSTS; BX = BLINKY.BASE
	
		;CX = DIST.X, DX = DIST.Y {
			MOV CX, [PACX]
			MOV DX, [PACY]
			
			SUB CX, [G_X]
			SUB DX, [G_Y]
		;}
		
		;BX = INKY.BASE {
			ADD BX, [ARR_JMP] 
			ADD BX, [ARR_JMP]
		;}
		
		;TARGET.X = PACMAN.X + DIST.X {
			MOV AX, [PACX]
			ADD AX, CX
			MOV [G_TARX], AX
		;}
		
		;TARGET.Y = PACMAN.Y + DIST.Y {
			MOV AX, [PACY]
			ADD AX, DX
			MOV [G_TARY], AX
		;}
	;}
	
	@@END_PROC: ;{
		POP DX
		POP CX
		POP BX
		POP AX
		RET
	;}
;}
ENDP BLUE_AI

;*********************************
;*********************************

PROC ORANGE_AI
;{
	;AI: GOES FOR PACMAN. CHECKS IF PACMAN IS IN 6 TILES RANGE OF HIM,
	;	 AND IF HE IS THAN CLYDE GOES BACK TO HIS SCATTER MODE TARGET.
	
	;PUSH REGS {
		PUSH AX
		PUSH BX
		PUSH CX
	;}
	
	;CODE {
		;BX = CLYDE'S BASE ADDRESS {
			MOV BX, OFFSET GHOSTS
			ADD BX, [ARR_JMP]
			ADD BX, [ARR_JMP]
			ADD BX, [ARR_JMP]
		;}
		
		
		;CALC DIST FROM CLYDE TO PACMAN {
			MOV AL, [BYTE PTR PACX]
			MOV AH, [BYTE PTR PACY]
			
			MOV CL, [BYTE PTR G_X]
			MOV CH, [BYTE PTR G_Y]
			
			PUSH AX
			PUSH CX
			CALL MATH_DIST	
			POP AX
		;}
		
		;DIST <= 6?
		CMP AX, 6
		JBE @@FALLBACK
		
		;IF NOT, TARGET = PACMAN {
			PUSH [PACX]
			POP  [G_TARX]
			
			PUSH [PACY]
			POP  [G_TARY]
			JMP  @@END_PROC
		;}
		
		@@FALLBACK:	;IF YES, FALLBACK. {
			MOV [WORD PTR G_TARX], 198
			MOV [WORD PTR G_TARY], 189
		;}
		
	;}
	
	@@END_PROC: ;{
		POP CX
		POP BX
		POP AX
		RET
	;}
;}
ENDP ORANGE_AI

;********************************
;********************************