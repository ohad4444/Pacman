PROC SET_DIFFICULTY_0
;{
	MOV [WORD PTR SPEED],        4  
	MOV [WORD PTR DUR_1ST_SCAT], 216 ; = 12s * 18
	MOV [WORD PTR DUR_CHASE],    270 ; = 15s * 18
	MOV [WORD PTR DUR_SCAT],     126 ; =  7s * 18
	MOV [WORD PTR DUR_FRI],      108 ; =  6s * 18
	RET
;}
ENDP SET_DIFFICULTY_0

;*************************************************************
;*************************************************************

PROC SET_DIFFICULTY_1
;{
	MOV [WORD PTR SPEED],        3  
	MOV [WORD PTR DUR_1ST_SCAT], 180 ; = 10s * 18
	MOV [WORD PTR DUR_CHASE],    450 ; = 25s * 18
	MOV [WORD PTR DUR_SCAT],     90  ; = 5s  * 18
	MOV [WORD PTR DUR_FRI],      90  ; = 5s  * 18
	RET
;}
ENDP SET_DIFFICULTY_1

;*************************************************************
;*************************************************************

PROC SET_DIFFICULTY_2
;{
	MOV [WORD PTR SPEED],        3  
	MOV [WORD PTR DUR_1ST_SCAT], 144 ; = 8s   * 18
	MOV [WORD PTR DUR_CHASE],    720 ; = 40s  * 18
	MOV [WORD PTR DUR_SCAT],     63  ; = 3.5s * 18
	MOV [WORD PTR DUR_FRI],      72  ; = 4s   * 18
	RET
;}
ENDP SET_DIFFICULTY_2

;*************************************************************
;*************************************************************

PROC SET_DIFFICULTY_3
;{
	MOV [WORD PTR SPEED],        2  
	MOV [WORD PTR DUR_1ST_SCAT], 90   ; = 5s  * 18
	MOV [WORD PTR DUR_CHASE],    1080 ; = 60s * 18
	MOV [WORD PTR DUR_SCAT],     18   ; = 1s  * 18
	MOV [WORD PTR DUR_FRI],      54   ; = 3s  * 18
	RET
;}
ENDP SET_DIFFICULTY_3

;*************************************************************
;*************************************************************

PROC SET_DIFFICULTY_4
;{
	MOV [WORD PTR SPEED],        2  
	MOV [WORD PTR DUR_1ST_SCAT], 54   ; = 3s   * 18
	MOV [WORD PTR DUR_CHASE],    5400 ; = 300s * 18
	MOV [WORD PTR DUR_SCAT],     9    ; = 0.5s * 18
	MOV [WORD PTR DUR_FRI],      45   ; = 2.5s * 18
	RET
;}
ENDP SET_DIFFICULTY_4

;*************************************************************
;*************************************************************

PROC SET_DIFFICULTY_5
;{
	MOV [WORD PTR SPEED],        2  
	MOV [WORD PTR DUR_1ST_SCAT], 18     ; = 1s      * 18
	MOV [WORD PTR DUR_CHASE],    0FFFFh ; = FFFFs   * 18
	MOV [WORD PTR DUR_SCAT],     1      ; = (1/18)s * 18
	MOV [WORD PTR DUR_FRI],      18     ; = 1s      * 18
	RET
;}
ENDP SET_DIFFICULTY_5

;*************************************************************
;*************************************************************

PROC SET_DIFFICULTY_6
;{
	MOV [WORD PTR SPEED],        2  
	MOV [WORD PTR DUR_1ST_SCAT], 1      ; = (1/18)s * 18
	MOV [WORD PTR DUR_CHASE],    0FFFFh ; = FFFFs   * 18
	MOV [WORD PTR DUR_SCAT],     1      ; = (1/18)s * 18
	MOV [WORD PTR DUR_FRI],      18     ; = 1s      * 18
	RET
;}
ENDP SET_DIFFICULTY_6

;*************************************************************
;*************************************************************
