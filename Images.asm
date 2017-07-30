;THIS FILE CONTAINS 9X9 IMAGES: 0 = DONT PRINT, 1 = PRINT. 

;PACMAN FRAMES {
	PACMAN_0 	DB 3Eh, 7Fh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 7Fh, 3Eh, 3Eh, 0
	
	;LEFT {
		PACMAN_L_1 	DB 3Eh, 7Fh, 0FFh, 0Fh, 7h, 0Fh, 0FFh, 7Fh, 3Eh, 3Eh, 0
		PACMAN_L_2 	DB 3Eh, 7Fh, 1Fh, 7h, 3h, 7h, 1Fh, 7Fh, 3Eh, 3Eh, 0
		PACMAN_L_3 	DB 3Eh, 1Fh, 07h, 03h, 01h, 03h, 07h, 1Fh, 3Eh, 3Eh, 0
	;}
	
	;RIGHT {
		PACMAN_R_1 	DB 3Eh, 7Fh, 0FFh, 0F0h, 0E0h, 0F0h, 0FFh, 7Fh, 3Eh, 22h, 0
		PACMAN_R_2 	DB 3Eh, 7Fh, 0F8h, 0E0h, 0C0h, 0E0h, 0F8h, 7Fh, 3Eh, 0, 0
		PACMAN_R_3 	DB 3Eh, 7Ch, 0F0h, 0E0h, 0C0h, 0E0h, 0F0h, 7Ch, 3Eh, 0, 0
	;}
	
	;UP {
		PACMAN_U_1 	DB 22h, 63h, 0E3h, 0E3h, 0F7h, 0FFh, 0FFh, 7Fh, 3Eh, 3Eh, 0
		PACMAN_U_2 	DB 00h, 41h, 0C1h, 0E3h, 0E3h, 0F7h, 0FFh, 7Fh, 3Eh, 3Eh, 0
		PACMAN_U_3 	DB 00h, 00h, 80h, 0C1h, 0C1h, 0E3h, 0F7h, 7Fh, 3Eh, 3Eh, 0
	;}
	
	;DOWN {
		PACMAN_D_1 	DB 3Eh, 7Fh, 0FFh, 0FFh, 0F7h, 0E3h, 0E3h, 63h, 22h, 3Eh, 0
		PACMAN_D_2 	DB 3Eh, 7Fh, 0FFh, 0FFh, 0E3h, 0E3h, 0C1h, 41h, 0, 3Eh, 0
		PACMAN_D_3 	DB 3Eh, 7Fh, 0F7h, 0E3h, 0C1h, 0C1h, 80h, 0, 0, 3Eh, 0
	;}
;}

;PACMAN LOSE ANIMATION {
	PAC_LOSE_1 DB 00, 1Ch, 3Eh, 7Fh, 7Fh, 7Fh, 3Eh, 1Ch, 00, 00, 0
	PAC_LOSE_2 DB 00, 00, 1Ch, 3Eh, 3Eh, 3Eh, 1Ch, 00, 00, 00, 0
	PAC_LOSE_3 DB 00, 00, 00, 08, 1Ch, 08, 00, 00, 00, 00, 0
	PAC_LOSE_4 DB 00, 00, 00, 00, 08, 00, 00, 00, 00, 00, 0
	PAC_LOSE_5 DB 00, 49h, 2Ah, 00, 63h, 00, 2Ah, 49h, 00, 00, 0
	PAC_LOSE_6 DB 00, 49h, 00, 00, 41h, 00, 00, 49h, 00, 00, 0
;}

;LETTERS {
	LETTER_P	DB 0FCh, 0FEh, 0E7h, 0E7h, 0FFh, 0FFh, 0FEh, 0F0h, 0F0h, 0, 0
	LETTER_A	DB 08h, 1Ch, 36h, 36h, 77h, 7Fh, 63h, 0C1h, 0C1h, 1, 1
	LETTER_M	DB 80h, 0C1h, 0E3h, 0F7h, 0FFh, 0FEh, 0FEh, 0F8h, 0FFh, 0FFh, 1
	LETTER_N	DB 87h, 0C7h, 0E7h, 0F7h, 0FFh, 0FDh, 0FDh, 0F1h, 0FFh, 0, 0
;}

;GHOSTS {
	GHOST_0		DB 3Eh, 7Fh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0DDh, 3Fh, 1
	FRIGH_EYES	DB 00, 00, 36h, 36h, 00, 2Ah, 55h, 00, 00, 00, 0
;}