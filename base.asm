.286
IDEAL
MODEL small
stack 600h
DATASEG
;{
	;UI {
		printNumArr 	DB 0,0,0,0,'$' 
		Print_Dec		DB 0,0,0,0,0,'$'
		ARR_DEC			DB 0,0,0,0,0
		SCORE			DW 0
		HP_FLAG			DB FALSE
		STR_GAMEOVER	DB 'GAME OVER!$'
		STR_SCORE		DB 'SCORE:$'
		STR_PAUSED		DB 'PAUSED$'
		STR_PAUSED_1	DB 27h,'E', 27h, ' = EXIT$'
		STR_PAUSED_2	DB 27h, 'R', 27h, ' = RESUME$'
		
	;}
	
	;PacMan Vars {
		PACX			DW 99
		PACY			DW 144 
		DIR				DW DIR_N
		NEXTDIR			DW DIR_N
		LIVES			DW 4
	;}
	
	;Layout & Dots {
		CNT_DOTS 		DW 174 ;TOTAL DOTS = 180dots + 4pps
		CNT_DOTS_TEMP	DW 0
	;}

	;Clock & Timers {
		CLOCK_BASE 	DB 0
	
		INT_MOV		DW 3
		CNT_MOV		DW 0 
		
		INT_GMOV	DW 3
		CNT_GMOV	DW 0
		
		INT_MODE	DW 180
		CNT_MODE	DW 0
		INT_CHASE	DW 126
		INT_SCAT	DW 72
		
		INT_FRI		DW 126
		CNT_FRI		DW 0
		
		INT_BLINK	DW 5
		CNT_BLINK	DW 0
	;}
	
	;Ghosts {
		Ghosts 		DW 56 dup (0)
		ARR_END 	DW 0
		ARR_JMP		DW 28
		IS_FRIGH	DB FALSE
		EATGHOST	DW 200
		PREV_MODE	DW MODE_SCAT
		G_BLINK		DW -1
		G_FRI_COL	DW 86h, 44h, WHITE_1, RED
	;}
	
	;Images & Animations {
		INCLUDE "Images.asm"
		PAC_ANI_U	DW 8 DUP (0)
		PAC_ANI_D	DW 8 DUP (0)
		PAC_ANI_L	DW 8 DUP (0)
		PAC_ANI_R	DW 8 DUP (0)		
		PAC_FP		DW 0	

		LOSE_ANI	DW 6 DUP (0)
	;}

	;Genearl (Levels and difficulty) {
		SPEED   		DW 4
		DUR_1ST_SCAT	DW 108
		DUR_CHASE		DW 540
		DUR_SCAT		DW 72
		DUR_FRI			DW 54
		LEVEL			DW 0
	;}
	
	;MAIN MENU {
		MENU_PTR	DB 0
		STR_PLAY	DB "PLAY$"
		STR_HELP	DB "HELP$"
		STR_EXIT	DB "EXIT$"
		STR_INST_1	DB "ARROWS = MOVE$"
		STR_INST_3	DB " DOTS = EAT$"
		STR_INST_2	DB "GHOSTS = BAD$"
	
		MENU_TXT_OFF	DW 0,0,0
		MENU_TXT_COL	DW 0,0,0
	;}
	
;}


	;CONSTANTS {
		INCLUDE "Colors.asm" ;(All the constants are in "Colors.asm")
	;}
	
	
;=======================================================================================
;=======================================================================================


CODESEG
;{
	;PROCEDURES
	;{	
		INCLUDE "Time.asm"
		INCLUDE "Timers.asm"
		
		INCLUDE "Text.asm"
		INCLUDE "Graphics.asm"
		INCLUDE "Game.asm"
		
		INCLUDE "Pacman.asm"
		INCLUDE "Ghost.asm"
		INCLUDE "GhostAI.asm"
		INCLUDE "LAYOUT.asm"
		INCLUDE "Diff.asm"
		INCLUDE "Math.asm"
		INCLUDE "MainMenu.asm"
	;}

	
;=============================================================
;=============================================================

	;CODE:
		Start:
		
		;INIT{ 
			;Data:
			MOV AX, @data
			MOV DS, AX
		
			call graphics_Mode

		;}
		
		;INIT SPEED AND ARR_END {
			MOV [ARR_END], OFFSET GHOSTS
			ADD [WORD PTR ARR_END], 112		
		;}

		;INIT PACMAN Animation (MOVES THE OFFSET OF THE IMAGES TO AN ARRAY) {
			
			;UP { 
				MOV BX, OFFSET PAC_ANI_U
				
				MOV [WORD PTR BX], 	   	OFFSET PACMAN_0
				MOV [WORD PTR BX + 2], 	OFFSET PACMAN_U_1
				MOV [WORD PTR BX + 4], 	OFFSET PACMAN_U_2
				MOV [WORD PTR BX + 6], 	OFFSET PACMAN_U_3
				                                      
				MOV [WORD PTR BX + 8],  OFFSET PACMAN_U_3
				MOV [WORD PTR BX + 10], OFFSET PACMAN_U_2
				MOV [WORD PTR BX + 12], OFFSET PACMAN_U_1
				MOV [WORD PTR BX + 14], OFFSET PACMAN_0
			;}
			
			;DOWN {
				MOV BX, OFFSET PAC_ANI_D
				
				MOV [WORD PTR BX], 	   	OFFSET PACMAN_0
				MOV [WORD PTR BX + 2], 	OFFSET PACMAN_D_1
				MOV [WORD PTR BX + 4], 	OFFSET PACMAN_D_2
				MOV [WORD PTR BX + 6], 	OFFSET PACMAN_D_3
				                                      
				MOV [WORD PTR BX + 8],  OFFSET PACMAN_D_3
				MOV [WORD PTR BX + 10], OFFSET PACMAN_D_2
				MOV [WORD PTR BX + 12], OFFSET PACMAN_D_1
				MOV [WORD PTR BX + 14], OFFSET PACMAN_0
			;}
			
			;LEFT {
				MOV BX, OFFSET PAC_ANI_L
				
				MOV [WORD PTR BX], 	   	OFFSET PACMAN_0
				MOV [WORD PTR BX + 2], 	OFFSET PACMAN_L_1
				MOV [WORD PTR BX + 4], 	OFFSET PACMAN_L_2
				MOV [WORD PTR BX + 6], 	OFFSET PACMAN_L_3
				
				MOV [WORD PTR BX + 8],  OFFSET PACMAN_L_3
				MOV [WORD PTR BX + 10], OFFSET PACMAN_L_2
				MOV [WORD PTR BX + 12], OFFSET PACMAN_L_1
				MOV [WORD PTR BX + 14], OFFSET PACMAN_0
			;}
			
			;RIGHT {
				MOV BX, OFFSET PAC_ANI_R
				
				MOV [WORD PTR BX], 	   	OFFSET PACMAN_0
				MOV [WORD PTR BX + 2], 	OFFSET PACMAN_R_1
				MOV [WORD PTR BX + 4], 	OFFSET PACMAN_R_2
				MOV [WORD PTR BX + 6], 	OFFSET PACMAN_R_3
				
				MOV [WORD PTR BX + 8],  OFFSET PACMAN_R_3
				MOV [WORD PTR BX + 10], OFFSET PACMAN_R_2
				MOV [WORD PTR BX + 12], OFFSET PACMAN_R_1
				MOV [WORD PTR BX + 14], OFFSET PACMAN_0
			;}
			
			;INIT LOSE ANIMATION {
				MOV BX, OFFSET LOSE_ANI
				
				MOV [WORD PTR BX],      OFFSET PAC_LOSE_1
				MOV [WORD PTR BX + 2],  OFFSET PAC_LOSE_2
				MOV [WORD PTR BX + 4],  OFFSET PAC_LOSE_3
				MOV [WORD PTR BX + 6],  OFFSET PAC_LOSE_4
				MOV [WORD PTR BX + 8],  OFFSET PAC_LOSE_5
				MOV [WORD PTR BX + 10], OFFSET PAC_LOSE_6
			;}
		;}
		
		CALL MAINMENU
		
		;WAITS UNTIL YOU CHOOSE A DIRECTION {
			GetFirstDir:
			CALL GAME_INPUT
			CMP [DIR], DIR_N
			JZ  GetFirstDir
		;}
		
		
		Update:
		;{
			CALL GAME_INPUT	

			CALL G_CHECK_DOTS	;check if enough dots have been eaten
								;to "enable" a ghost.
			CALL CLOCK
		;}
		JMP  Update			
	
		Exit:
		call text_Mode
		
		MOV AX, 4C00H
		INT 21H
		
	END Start
	
