PROC FILE_OPEN
;{	
	;START_PROC {
		PUSH BP
		MOV  BP, SP
		
		_NAME  EQU [WORD PTR BP + 6] 
		HANDLE EQU [WORD PTR BP + 4]
		
		PUSH AX BX DX
	;}
	
	;CODE{
		MOV DX, _NAME
		
		MOV AH, 3Dh
		MOV AL, READ&WRITE
		
		INT 21h
		JC  @@END_PROC
		
		MOV BX, HANDLE
		MOV [BX], AX 
	;}
	
	@@END_PROC: ;{
		POP DX BX AX
		POP BP
		RET 4
	;}
;}
ENDP FILE_OPEN

;*********************************************************************************
;*********************************************************************************

PROC FILE_READ_OR_WRITE
;{
	;INPUT: READ OR WRITE, FILE HANDLE, BUFFER OFFSET, NUBMER OF BYTES TO READ
	
	;START PROC {
		PUSH BP
		MOV  BP, SP
		
		ACTION	  EQU [WORD PTR BP + 10]
		BUFFER    EQU [WORD PTR BP + 8]
		NUM_BYTES EQU [WORD PTR BP + 6]
		HANDLE    EQU [WORD PTR BP + 4]
		
		
		PUSH AX BX CX DX
	;}
	
	;SET UP PARAMS {
		MOV BX, HANDLE
		MOV CX, NUM_BYTES
		MOV DX, BUFFER
		
		CMP ACTION, WRITE
		JZ  @@WRITE
	;}
	
	@@READ: ;{
		MOV AX, 3F00h
		INT 21h
		JMP @@END_PROC
	;}
	
	@@WRITE: ;{
		MOV AX, 4000h
		INT 21h 
	;}
	
	@@END_PROC: ;{
		POP DX CX BX AX
		POP BP
		RET 8
	;}
;}
ENDP FILE_READ_OR_WRITE

;*********************************************************************************
;*********************************************************************************

PROC FILE_CLOSE
;{
	;START PROC {
		PUSH BP
		MOV  BP, SP
		HANDLE EQU [BP + 4]
		
		PUSH AX BX
	;}
	
	;CODE {
		MOV AH, 3Eh
		MOV BX, HANDLE
		INT 21h
	;}
	
	@@END_PROC: ;{
		POP BX AX
		POP BP
		RET 2
	;}
;}
ENDP FILE_CLOSE

;*********************************************************************************
;*********************************************************************************

PROC FILE_UPDATE_POINTER
;{
	;START PROC {
		PUSH BP
		MOV  BP, SP
		
		RELATIVE_TO EQU [BP + 10]
		NUM_BYTES_1 EQU [BP + 8]
		NUM_BYTES 	EQU [BP + 6]
		HANDLE 		EQU [BP + 4]
		
		PUSH AX BX CX DX
	;}
	
	;CODE {
		MOV AX, RELATIVE_TO
		MOV AH, 42h
		MOV BX, HANDLE
		MOV CX, NUM_BYTES_1
		MOV DX, NUM_BYTES
		INT 21h		
	;}
	
	@@END_PROC: ;{
		POP DX CX BX AX
		POP BP
		RET 8
	;}
;}
ENDP FILE_UPDATE_POINTER