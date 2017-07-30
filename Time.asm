;*****************************************************************************
;*****************************************************************************
	
	PROC Clock
	;{
		;CHECK CLOCK ;{
			CALL getMill
			SUB  DL, [CLOCK_BASE]
			CMP  DL, 1
			JAE  @@Clock
			JMP  @@END_PROC
		;}
		
		@@CLOCK: 
		;{
			CALL TMR_MOVE
			CALL PAC_ANIMATION
			CALL TMR_GMODE
			CALL TMR_FRIGH
			CALL TMR_GMOVE
		;}
		
		;SetBase {
			CALL getMill
			XCHG [Clock_Base], DL
		;}
		
		@@END_PROC:
		RET
	;}
	ENDP CLOCK
	
	;=========================================

	PROC getMill
	;{
		;PUSH REGS
		;{
			PUSH AX
			PUSH BX
			PUSH CX
		;}
		
		;GET TIME {
			MOV AH, 2CH
			INT 21H
			XOR DH, DH
		;}
		
		;POP REGS
		;{
			POP AX
			POP BX
			POP CX
		;}
		RET
	;}
	ENDP getMill
;************************************************************************************************************************************	
;************************************************************************************************************************************
	;Description: Waits _CX:_DX milliseconds
		
		PROC DELAY
		;{
			;START_PROC ;{
				_CX EQU [BP + 6]
				_DX EQU [BP + 4]
				
				PUSH BP
				MOV  BP, SP
				
				PUSH AX
				PUSH CX
				PUSH DX
			;}
			
			;CODE {
				MOV CX, _CX
				MOV DX, _DX
				MOV AH, 86h
				INT 15h
			;}
			
			@@END_PROC: ;{
				POP DX
				POP CX
				POP AX
				POP BP
				RET 4
			;}
		;}
		ENDP DELAY
		
	
;************************************************************************************************************************************	
;************************************************************************************************************************************
	