PROC TMR_MOVE
;{
	;ON_TICK: MOVE PACMAN AND THE GHOSTS. ALSO CHECKS IF PACMAN IS LOSING.
	PUSH AX
	
	;INCREMENT COUNTER {
		INC [WORD PTR CNT_MOV]
	;}
	
	;CHECK COUNTER & INTERVAL {
		MOV AX, [INT_MOV]
		CMP AX, [CNT_MOV]
		JZ 	@@TICK
		JMP @@END_PROC
	;}
	
	@@TICK:
	;{
		MOV [WORD PTR CNT_MOV], 0
		CALL PAC_MOVE
		CALL TESTWIN
		CALL TESTLOSE
	;}
	
	@@END_PROC:
	POP AX
	RET
;}
ENDP TMR_MOVE

;;***********************************************************************
;;***********************************************************************
PROC TMR_GMODE
;{
	;ON_TICK: SWAPS THE GHOSTS' MODES. IF SCATTER THEN SWITCH TO CHASE,
	;		  IF CHASE THEN SWITCH TO SCATTER.
	PUSH AX
	PUSH BX
	
	;INCREMENT COUNTER {
		;IF (IS_FRIGH = 1) {DON'T INC}, IF (IS_FRIGH = 0) {INC COUNT}
		MOV AL, [IS_FRIGH]
		DEC AL
		NEG AL
		XOR AH, AH
		ADD [CNT_MODE], AX
	;}
	
	;CHECK COUNTER & INTERVAL {
		MOV AX, [INT_MODE]
		CMP AX, [CNT_MODE]
		JZ 	@@TICK
		JMP @@END_PROC
	;}
	
	@@TICK:
	;{
		MOV [WORD PTR CNT_MODE], 0
		MOV BX, OFFSET GHOSTS
		
		;MODE = SCATTER? {
			CMP [WORD PTR PREV_MODE], MODE_SCAT
			JZ  @@CHASE	;IF YES, SWITCH TO CHASE.
		;}
		
		;IF NO, SWITCH TO SCATTER {
			PUSH [INT_SCAT]
			POP  [INT_MODE]
			
			MOV AX, MODE_SCAT
			MOV [PREV_MODE], AX 
			
			JMP @@MODE_LOOP
		;}
		
		@@CHASE: ;{
			PUSH [INT_CHASE]
			POP  [INT_MODE]
			
			MOV AX, MODE_CHASE
			MOV [PREV_MODE], AX
		;}
		
		@@MODE_LOOP: ;{
			PUSH AX
			MOV [G_MODE], AX
			
			;180 DEGREES TURN {
				MOV AX, [G_DIR]
				NEG AL
				NEG AH
				MOV [G_DIR], AX
			;}
			
			POP AX
			
			ADD BX, [ARR_JMP]
			CMP BX, [ARR_END]
			JNZ @@MODE_LOOP
		;}
		
	;}
	
	@@END_PROC:
	POP BX
	POP AX
	RET
;}
ENDP TMR_GMODE
;***********************************************************************
;***********************************************************************
PROC TMR_FRIGH
;{
	;ON_TICK: TURNS OFF FRIGHTEND MODE AND REVIVES DEAD GHOSTS.
	
	PUSH AX
	PUSH BX
	
	;INCREMENT COUNTER {
		;IF (IS_FRIGH = 1) {INC COUNT}, IF (IS_FRIGH = 0) {DON'T INC}
		MOV AL, [IS_FRIGH]
		XOR AH, AH
		ADD [CNT_FRI], AX
	;}
	
	;CHECK COUNTER & INTERVAL {
		MOV AX, [INT_FRI]
		SUB AX, [CNT_FRI]
		CMP AX, 20
		JA  @@DONT_BLINK
		
		;BLINK {
			CALL TMR_BLINK
		;}
		
		@@DONT_BLINK: ;{
			MOV AX, [INT_FRI]
			CMP AX, [CNT_FRI]
			JZ 	@@TICK
			JMP @@END_PROC
		;}
	;}
	
	@@TICK:
	;{
			
		MOV [WORD PTR EATGHOST], 200
		MOV [WORD PTR CNT_FRI],  0
		MOV [BYTE PTR IS_FRIGH], 0
		MOV [WORD PTR G_BLINK],  -1
		
		PUSH [SPEED]
		POP  [INT_GMOV]
		
		MOV BX, OFFSET GHOSTS
		
		@@DEAD_LOOP: ;{
			;IS THIS GHOST DEAD? {
				CMP [WORD PTR G_MODE], MODE_DEAD
				JNZ  @@DEAD_END	;IF NO, JMP TO THE END OF THE LOOP.
			;}
			
			;IF YES, REVIVE THE GHOST {
				PUSH [PREV_MODE]
				POP  [G_MODE]
			;}
			
			@@DEAD_END: ;{
				ADD BX, [ARR_JMP]
				CMP BX, [ARR_END]
				JNZ @@DEAD_LOOP
			;}
		;}
	;}
	
	@@END_PROC:
	POP BX
	POP AX
	RET
;}
ENDP TMR_FRIGH
;***********************************************************************
;***********************************************************************
PROC TMR_GMOVE
;{
	;ON_TICK: MOVES THE GHOSTS. ALSO CHECKS IF PACMAN IS LOSING.
	PUSH AX
	
	;INCREMENT COUNTER {
		INC [WORD PTR CNT_GMOV]
	;}
	
	;CHECK COUNTER & INTERVAL {
		MOV AX, [INT_GMOV]
		CMP AX, [CNT_GMOV]
		JBE @@TICK
		JMP @@END_PROC
	;}
	
	@@TICK:
	;{
		CALL TESTLOSE
		MOV [WORD PTR CNT_GMOV], 0
		CALL G_TARGET
		CALL G_MOVE
		CALL TESTLOSE
	;}
	
	@@END_PROC:
	POP AX
	RET
;}
ENDP TMR_GMOVE

;***********************************************************************
;***********************************************************************
PROC TMR_BLINK
;{
	;ON_TICK: MAKE THE GHOSTS BLINK.
	PUSH AX
	PUSH BX
	
	;INCREMENT COUNTER {
		INC [WORD PTR CNT_BLINK]
	;}
	
	;CHECK COUNTER & INTERVAL {
		MOV AX, [INT_BLINK]
		CMP AX, [CNT_BLINK]
		JBE @@TICK
		JMP @@END_PROC
	;}
	
	@@TICK:
	;{
		MOV  [WORD PTR CNT_BLINK], 0
		NEG  [WORD PTR G_BLINK]
		
		MOV BX, OFFSET GHOSTS
		@@PRINT_LOOP: ;{
			CALL G_PRINT
			ADD BX, [ARR_JMP]
			CMP BX, [ARR_END]
			JNZ @@PRINT_LOOP
		;}
	;}
	
	@@END_PROC:
	POP BX
	POP AX
	RET
;}
ENDP TMR_BLINK

;***********************************************************************
;***********************************************************************
