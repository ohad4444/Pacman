PROC MATH_SQUARE
;{
	;PARAMS & BP {
		PUSH BP
		MOV  BP, SP
		Number EQU [BP + 4]
		PUSH AX
		PUSH BX
	;}
	
	;CODE {
		MOV  AX, Number
		MOV  BX, Number
		IMUL BX
		MOV  Number, AX  
	;}
	
	@@END_PROC: ;{
		POP BX
		POP AX
		POP BP
		RET
	;}
;}
ENDP MATH_SQUARE

;*****************************************************************************
;*****************************************************************************
	
PROC MATH_DIST
;INPUT  = P0{Xb, Yb}, P1{Xb, Yb}
;OUTPUT = DIST BETWEEN THESE POINTS.
 
;{
	;BP & PARAMS & REGS {
		PUSH BP
		MOV  BP, SP
		
		P0 EQU [BP + 6]
		P1 EQU [BP + 4]
		
		PUSH AX
		PUSH BX
		PUSH CX
	;}
	

	;DIVIDE ALL LOCATIONS BY 9, SINCE
	;ALL THE TILES ARE 9X9, EVERY X & Y IS DEVISABLE BY 9 
	;{
		MOV  AX, P0
		XCHG AH, AL
		XOR  AH, AH
		MOV  BL, 9
		DIV  BL
		MOV  CH, AL
		
		MOV  AX, P0
		XOR  AH, AH
		DIV  BL
		MOV  CL, AL
		MOV  P0, CX
		
		MOV  AX, P1
		XCHG AH, AL
		XOR  AH, AH
		DIV  BL
		MOV  CH, AL
		
		MOV  AX, P1
		XOR  AH, AH
		DIV  BL
		MOV  CL, AL
		MOV  P1, CX
	;}
;====================================	

		;AX = P0.X
		MOV  AX, P0
		XCHG AH, AL
		XOR  AH, AH
		
		;AX = P0.X - P1.X
		MOV  BX, P1
		XCHG BH, BL
		XOR  BH, BH
		SUB  AX, BX

		;AX = AX*AX
		PUSH AX
		CALL MATH_SQUARE
		POP  AX
		
;=============================
		
		;BX = P0.Y
		MOV  BX, P0
		XOR  BH, BH
		
		;BX = P0.Y - P1.Y
		MOV  CX, P1
		XOR  CH, CH
		SUB  BX, CX

		;P0 = BX * BX
		PUSH BX
		CALL MATH_SQUARE
		POP  P0
		
;=============================
		
		;P0 = (P0.X - P1.X)^2 + (P0.Y - P1.Y)^2
		ADD P0, AX
		
	;}
	
	@@END_PROC: ;{
		POP CX
		POP BX
		POP AX
		POP BP
		RET 2
	;}
;}
ENDP MATH_DIST

;*****************************************************************************
;*****************************************************************************
	
PROC FINDNREP_W
;INPUT  - FIND, REPLACE, LENGTH, OFFSET
;OUTPUT - IF IT FINDS [FIND] IN THE ARRAY, IT REPLACES IT WITH [REPLACE].
;{
	;REGS, PARAMS, LOCAL VARS & BP {
		PUSH BP
		MOV  BP, SP
		
		FIND 	EQU [BP + 10]
		REPLACE	EQU [BP + 8]
		
		ARR_LEN	EQU [BP + 6]
		ARR_OFF EQU [BP + 4]
		
		PUSH AX
		PUSH CX
		PUSH DI
	;}
	
	;CODE {
		PUSH DS
		POP  ES	
		
		@@REP_LOOP:
		;{
			MOV CX, ARR_LEN
			INC CX
			MOV AX, FIND
			MOV DI, ARR_OFF
			
			REPNZ SCASW
			
			CMP CX, 0
			JZ  @@END_PROC
			
			SUB DI, 2
			MOV AX, REPLACE
			STOSW
			JMP @@REP_LOOP
		;}
	;}
	
	@@END_PROC: ;{
		
		POP DI
		POP CX
		POP AX
		
		POP BP
		RET 8
	;}
;}
ENDP FINDNREP_W
	
;*****************************************************************************
;*****************************************************************************
	
PROC FINDMIN_W
;INPUT  - LENGTH, OFFSET
;OUTPUT - MIN INDEX
;{
	;REGS, PARAMS, LOCAL VARS & BP {
		PUSH BP
		MOV  BP, SP
		
		ARR_LEN	EQU [WORD PTR BP + 6]
		ARR_OFF EQU [WORD PTR BP + 4]
		
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH SI
	;}
	
	;CODE {
		SHL ARR_LEN, 1	;LENGTH IN ELEMENTS(WORDS) * 2 = LENGTH IN BYTES.
		MOV SI, ARR_OFF
		XOR BX, BX		;SI = BASE, BX = INDEX
		
		;MOV BX, ARR_OFF
		MOV AX, [SI + BX]
		ADD BX, 2
		XOR CX, CX
		
		@@MIN_LOOP:
		;{
			CMP [SI + BX], AX
			JAE @@FALSE
			
			MOV AX, [SI + BX]
			MOV CX, BX
			
			@@FALSE:
			ADD BX, 2
			CMP BX, ARR_LEN
			JNZ @@MIN_LOOP
		;}
		
		SHR CX, 1	;INDEX IN WORDS.
		MOV ARR_LEN, CX
	;}
	
	@@END_PROC: ;{
		POP SI
		POP CX
		POP BX 
		POP AX
		
		POP BP
		RET 2
	;}
;}
ENDP FINDMIN_W
	
;*****************************************************************************
;*****************************************************************************

PROC HEX2DEC
;{
	;input: array offset (length = 5 bytes), number(word)
	;START_PROC: {
		PUSH BP
		MOV  BP, SP
		
		DEC_OFF EQU [WORD PTR BP + 6]
		NUMBER 	EQU [WORD PTR BP + 4]
		
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
	;}
	
	;CODE {
		;BX = LAST ELEMENT IN ARR_DEC
		MOV BX, DEC_OFF
		MOV CX, 5
		
		@@ZERO_LOOP: ;{
			MOV [BYTE PTR BX], 0
			INC BX
			LOOP @@ZERO_LOOP
		;}
		
		DEC BX
		DEC DEC_OFF
		
		MOV AX, NUMBER
		MOV CX, 10
		XOR DX, DX
		
		@@DIV_LOOP:
		;{
			DIV  CX
			XCHG [BX], DL
			
			CMP AX, 0
			JZ  @@END_PROC
			
			@@EXIT_DIV: ;{
				DEC BX
				CMP BX, DEC_OFF
				JNZ @@DIV_LOOP
			;}
		;}
		
	;}
	
	@@END_PROC: ;{
		POP DX
		POP CX
		POP BX
		POP AX
		POP BP
		RET 4
	;}
;}
ENDP HEX2DEC
	
;*****************************************************************************
;*****************************************************************************
	
PROC FINDMAX_W
;INPUT  - LENGTH, OFFSET
;OUTPUT - MAX INDEX
;{
	;REGS, PARAMS, LOCAL VARS & BP {
		PUSH BP
		MOV  BP, SP
		
		ARR_LEN	EQU [WORD PTR BP + 6]
		ARR_OFF EQU [WORD PTR BP + 4]
		
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH SI
	;}
	
	;CODE {
		SHL ARR_LEN, 1 ;LENGTH IN WORDS
		MOV SI, ARR_OFF
		XOR BX, BX
		
		@@INIT_LOOP: ;{
			CMP [WORD PTR SI + BX], LOC_N
			JZ  @@INIT_AGAIN
			
			MOV AX, [SI + BX]
			MOV CX, BX
			JMP @@MAX_LOOP
			
			@@INIT_AGAIN: ;{
				ADD BX, 2
				JMP @@INIT_LOOP
			;}
		;}
		
		@@MAX_LOOP:
		;{
			CMP [WORD PTR SI + BX], LOC_N
			JZ  @@FALSE
			
			CMP [SI + BX], AX
			JB  @@FALSE
			
			MOV AX, [SI + BX]
			MOV CX, BX
			
			@@FALSE:
			ADD BX, 2
			CMP BX, ARR_LEN
			JNZ @@MAX_LOOP
		;}
		
		SHR CX, 1	;INDEX IN WORDS
		MOV ARR_LEN, CX
	;}
	
	@@END_PROC: ;{
		POP SI
		POP CX
		POP BX 
		POP AX
		
		POP BP
		RET 2
	;}
;}
ENDP FINDMAX_W
	
;*****************************************************************************
;*****************************************************************************
