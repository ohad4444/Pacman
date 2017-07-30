	;Colors ;{
		black 			EQU 0000b
		
		blue 			EQU 0001b
		green 			EQU 0010b
		cyan			EQU 0011b
		red				EQU 0100b
		magenta			EQU 0101b
		brown			EQU 0110b
		yellow			EQU 2Ch
		
		army_green		EQU 74h
		
		light_gray		EQU 0111b
		dark_gray		EQU 1000b
		
		light_blue		EQU 1001b
		light_green		EQU 1010b
		light_cyan		EQU 1011b
		light_red		EQU 1100b
		pink			EQU 1101b
		light_brown		EQU 1110b
		orange			EQU 2Ah
		white			EQU 1111b
		
		clear_black		EQU 10h
		
		dark_red		EQU 70h
		pp_pink			EQU 59h
		
		dark_yellow		EQU 2Bh
		orange			EQU 2Ah
		white_1			EQU 1Fh
	;}
	
	
	;Scan Codes {
		ARR_U 			EQU 48h
		ARR_D 			EQU 50h
		ARR_L 			EQU 4Bh
		ARR_R 			EQU 4Dh
		
		SC_SPACE		EQU 39h
		SC_ENTER		EQU 1Ch
		SC_RSHFT		EQU 36h
	;}
	
	;Directions {
		;DIRECTIONS:
		DIR_U			EQU 00F7h
		DIR_D			EQU 0009h
		DIR_L			EQU 0F700h
		DIR_R			EQU 0900h
		DIR_N			EQU 0000h
		
		;DIRECTION INDEXS:
		IDIR_U			EQU 0
		IDIR_D			EQU 1
		IDIR_L			EQU 2
		IDIR_R			EQU 3
		IDIR_N			EQU 4
		
		;LOCATIONS:
		LOC_N			EQU 0FFFFh
	;}
	
	;Objects {
		OBJ_VOID		EQU 0
		OBJ_WALL		EQU 1
		OBJ_DOT			EQU 2
		OBJ_PP			EQU 3
	;}
	
	;GHOST ARRAY {
		G_X				EQU BX
		G_Y				EQU BX + 2
			
		G_TARX			EQU BX + 4
		G_TARY			EQU BX + 6
		
		G_DIR			EQU BX + 8
		G_OBJ			EQU BX + 10
		G_COLOR			EQU BX + 12
		G_MODE			EQU BX + 14
		
		G_PDIR			EQU BX + 16
		G_PDIR_U		EQU BX + 16
		G_PDIR_D		EQU BX + 18
		G_PDIR_L		EQU BX + 20
		G_PDIR_R		EQU BX + 22
		
		G_MINDOTS		EQU BX + 24
		G_ENABLED		EQU BX + 26
			
		;GHOST MODES:
		MODE_SCAT		EQU 0
		MODE_CHASE		EQU 1
		MODE_FRIGH		EQU 2
		MODE_DEAD		EQU 3
		
		;BX = GHOSTS.OFFSET + 24*ID
		;X|Y|T.X|T.Y|DIR|OBJ|COLOR|MODE|PDIR_U,D,L,R|
		;GHOSTS : |RED|PINK|BLUE|ORANGE|
	;}
	
	; MAIN_MENU {
		BTN_PLAY EQU 0
		BTN_HELP EQU 1
		BTN_EXIT EQU 2
	;}
	
	; Boolean Values {
		TRUE 	EQU 1
		FALSE 	EQU 0
	;}
	
	;FILES {
		READ  		EQU 0
		WRITE 		EQU 1
		READ&WRITE 	EQU 2
		
		SOF			EQU 0
		CURRENT		EQU 1
		EOF			EQU 2
	;}
	
	;CLOCK {
		CLOCK_ADDRESS EQU WORD PTR ES:6Ch		
	;}