  .data
random_no:	.string	"0000",	0
ghost_id:	.string	"0",	0
blinky:		.string "000",	0
blinky_p:	.string	"0",0
blinky_d:	.string	"0",0
pinky:		.string "000",	0
pinky_p:	.string	"0",0
pinky_d:	.string	"0",0
inky:		.string "000",	0
inky_p:		.string	"0",0
inky_d:		.string	"0",0
clyde:		.string	"000",	0
clyde_p:	.string	"0",0
clyde_d:	.string	"0",0

  .text
ptr_to_random_no:	.word	random_no
ptr_to_ghost_id:	.word	ghost_id
ptr_to_blinky:		.word	blinky
ptr_to_blinky_p:	.word   blinky_p
ptr_to_blinky_d:	.word   blinky_d
ptr_to_pinky:		.word   pinky
ptr_to_pinky_p:		.word   pinky_p
ptr_to_pinky_d:		.word   pinky_d
ptr_to_inky:		.word   inky:	
ptr_to_inky_p:		.word   inky_p
ptr_to_inky_d:		.word   inky_d
ptr_to_clyde:		.word   clyde
ptr_to_clyde_p:		.word   clyde_p
ptr_to_clyde_d:		.word   clyde_d





;;initialize random number to be 5431



	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
move_ghosts_hostile:
	STMFD SP! {r0-r12,lr}
		;;;;;;;;;;;;;;;;;;;;;;;;;;
		; move blinky
		MOV		r0,	#0
		MOV		r1,	#0
		MOV		r2,	#0
		; blinky location in memory
		LDR		r5,	ptr_to_blinky ; load blinky location from memory into r0
		LDRH	r0,	[r5]

		; blinky_p in memory
		LDR		r5,	ptr_to_blinky_p ; load blinky previous pellet from memory into r1
		LDRB	r1,	[r5]

		; blinky direction in memory
		LDR		r5,	ptr_to_blinky_d ; load blinky prev direction from memory into r2
		LDRB	r2,	[r5]
		
		;set ghost_id
		LDR		r5,	ptr_to_ghost_id
		MOV		r11,	#1
		STRB	r11,	[r5] ; set ghost to 1
		
		BL	move_ghost_hostile
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;
		; move pinky
		MOV		r0,	#0
		MOV		r1,	#0
		MOV		r2,	#0
		; pinky location in memory
		LDR		r5,	ptr_to_pinky ; load pinky location from memory into r0
		LDRH	r0,	[r5]

		; pinky_p in memory
		LDR		r5,	ptr_to_pinky_p ; load pinky previous pellet from memory into r1
		LDRB	r1,	[r5]

		; pinky direction in memory
		LDR		r5,	ptr_to_pinky_d ; load pinky prev direction from memory into r2
		LDRB	r2,	[r5]
		
		;set ghost_id
		LDR		r5,	ptr_to_ghost_id
		MOV		r11,	#2
		STRB	r11,	[r5] ; set ghost to 2
		
		BL	move_ghost_hostile
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;
		; move inky
		MOV		r0,	#0
		MOV		r1,	#0
		MOV		r2,	#0
		; inky location in memory
		LDR		r5,	ptr_to_inky ; load inky location from memory into r0
		LDRH	r0,	[r5]

		; inky_p in memory
		LDR		r5,	ptr_to_inky_p ; load inky previous pellet from memory into r1
		LDRB	r1,	[r5]

		; inky direction in memory
		LDR		r5,	ptr_to_inky_d ; load inky prev direction from memory into r2
		LDRB	r2,	[r5]
		
		;set ghost_id
		LDR		r5,	ptr_to_ghost_id
		MOV		r11,	#3
		STRB	r11,	[r5] ; set ghost to 3
		
		BL	move_ghost_hostile
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;
		;move clyde
		MOV		r0,	#0
		MOV		r1,	#0
		MOV		r2,	#0
		; clyde location in memory
		LDR		r5,	ptr_to_clyde ; load clyde location from memory into r0
		LDRH	r0,	[r5]

		; clyde_p in memory
		LDR		r5,	ptr_to_clyde_p ; load clyde previous pellet from memory into r1
		LDRB	r1,	[r5]

		; clyde direction in memory
		LDR		r5,	ptr_to_clyde_d ; load clyde prev direction from memory into r2
		LDRB	r2,	[r5]
		
		;set ghost_id
		LDR		r5,	ptr_to_ghost_id
		MOV		r11,	#4
		STRB	r11,	[r5] ; set ghost to 4
		
		BL	move_ghost_hostile


	
	
	
	LDMFD SP!, {r0-r12,lr}
	MOV	  pc, lr
	
	
	
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;PUT LOCATION OF GHOST IN r0
;PUT PELLET FLAG IN r1
;PUT DIRECTION IN r2
move_ghost_hostile:

	STMFD SP! {r2-r12,lr}
	LDR		r4,	ptr_to_boardstring ; load board from memory into r4
	
	;checking right side
	ADD		r7,	r0,	#1				;r7 contains offset of new address after going right
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	dosmth
	ADD		r7,	r0,	#2				;r7 contains offset of new address after going right
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	goright
	ADD		r7,	r0,	#3				;r7 contains offset of new address after going right
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	goright
	ADD		r7,	r0,	#4				;r7 contains offset of new address after going right
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	goright
	
	;checking left side
	SUB		r7,	r0,	#1				;r7 contains offset of new address after going left
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	dosmth
	SUB		r7,	r0,	#2				;r7 contains offset of new address after going left
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	goleft
	SUB		r7,	r0,	#3				;r7 contains offset of new address after going left
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	goleft
	SUB		r7,	r0,	#4				;r7 contains offset of new address after going left
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	goleft
	
	;checking up
	ADD		r7,	r0,	#29				;r7 contains offset of new address after going up
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	dosmth
	ADD		r7,	r0,	#58				;r7 contains offset of new address after going up
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	goup
	ADD		r7,	r0,	#87				;r7 contains offset of new address after going up
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	goup
	ADD		r7,	r0,	#116				;r7 contains offset of new address after going up
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	goup
	
	;checking down
	SUB		r7,	r0,	#29				;r7 contains offset of new address after going down
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	dosmth
	SUB		r7,	r0,	#58				;r7 contains offset of new address after going down
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	godown
	SUB		r7,	r0,	#87				;r7 contains offset of new address after going down
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	godown
	SUB		r7,	r0,	#116				;r7 contains offset of new address after going down
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman	
	BEQ 	godown	
	B		old_direction
	

goright:
	MOV		r9,	#1			;store in r9
	MOV		r10, #1			;says that its chasing pacman
	BL	check_direction
	B	quit_checking
goleft:
	MOV		r9,	#2			;store in r9
	MOV		r10, #1			;says that its chasing pacman
	BL	check_direction
	B	quit_checking
goup:
	MOV		r9,	#3			;store in r9
	MOV		r10, #1			;says that its chasing pacman
	BL	check_direction
	B	quit_checking
godown:
	MOV		r9,	#4			;store in r9
	MOV		r10, #1			;says that its chasing pacman
	BL	check_direction
	B	quit_checking
	
old_direction:
//FETCH OLD DIRECTION
	MOV		r9, r2
	MOV		r10, #0			;says that its NOT chasing pacman
	BL		random_movement

quit_checking:
		
	
	
	
	LDMFD SP!, {r2-r12,lr}
	MOV	  pc, lr


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
get_random_num:
	STMFD SP! {r0-r8,r10-r12,lr}
	
	LDR		r5,	ptr_to_random_no; load random number from memory into r0
	LDRH	r0,	[r5]
	UMUL	r8,	r7,	r0,	r0		;multiply it by self, store lower half at r8
	UBFX	r9,	r8,	#4,	#13		;get 3 hex digits and 1 binary from middle
	MOV		r0,	r9				;set dividend to r6
	MOV		r1,	#4				;set divisor to 4
	BL		div_and_mod			;returns quotient in r0, remainder in r1, remainder = direction
	ADD		r9,	r0				;add quotient to 4 digits number, more randomness
	LDR		r5,	ptr_to_random_no; store 4 digits number back
	STRH	r9,	[r5]
	MOV		r9,	r1			;move remainder to r6		
	CMP		r9,	#0			;if r6 is 0, 0 isn't direction, change to 4
	BNE		randomnum
	MOV		r9,	#4
randomnum:

	;;return number in r9
	STMFD SP! {r0-r8,r10-r12,lr}
	MOV	  pc, lr
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
ghost_id_checker:
	STMFD SP! {r0-r8,r10-r12,lr}
	
	LDR		r5,	ptr_to_ghost_id ; load id from memory into r9
	LDRB	r9,	[r5]
	;;return number in r9
	LDMFD SP!, {r0-r8,r10-r12,lr}
	MOV	  pc, lr
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
check_direction:
	;r9 has direction to check
	STMFD SP! {r2-r12,lr}
	
	
	CMP		r9,	#1			;checking if its right
	BNE     leftcheck
	MOV		r8,	#1			;store in r8
	B		converted
leftcheck:
	CMP		r9,	#2			;left
	BNE		upcheck
	MOV		r8,	#0			;store in r8
	SUB		r8,	#1
	B		converted
upcheck:
	CMP		r9,	#3			;up
	BNE		downcheck
	MOV		r8,	#29			;store in r8
	B		converted
downcheck:						
	CMP		r9,	#4			;down
	MOV		r8,	#0			;store in r8
	SUB		r8,	#29
	
	
converted:
	
	ADD		r8,	r0,	r8				;r8 contains offset of new address after going right
	LDRB	r11,[r4, r8]			;r4 is ptr to board, with offset of new address
		
    CMP   	r8,  #138        		;Check if it is box entrance
	BNE		check_left
    MOV		r5,	 #3					;set flag to 3
	B		checked_content
check_left:	
    CMP   	r8,  #155        		;Check if it is left exit
	BNE		check_right
    MOV		r5,	 #3
	B		checked_content
check_right:
    CMP   	r8,  #183        		;Check if it is right exit 
	BNE		check_empty
    MOV		r5,	 #3
	B		checked_content
check_empty:
	CMP		r11, #32				;Check if character is empty
	BNE		check_pellet
    MOV		r5,  #0					;empty flag	
	B		checked_content
check_pellet:
	CMP		r11, #46				;Check if character is normal pellet
	BNE		check_power
    MOV		r5,  #1					;pellet flag
	B		checked_content	
check_power:
    CMP   	r11, #79        		;Check if character is power pellet
	BNE		border
    MOV		r5,  #2					;power flag	
	B		checked_content
border:
	MOV		r5,	#3
checked_content:

	CMP		r5,	#3
	BNE		switch
	;prev dir = 0 or same
	;in case it couldn't go in that direction, obstacle
	CMP		r10, #0			;checking whether or not it was originally chasing pacman
	BNE		nopac
	MOV		r9,	#0			;if pacman isn't chased, change dir to 0
nopac:
	BL		random_movement	;otherwise use old direction stored in r9


switch:
	;switch everything
	
	LDMFD SP!, {r2-r12,lr}
	MOV	  pc, lr
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;uses r9 as prev direction
random_movement:
	STMFD SP! {r0-r12,lr}

goagain:
	CMP		r9,	#0
	BNE		goingright
	;generate random number, store in r9
	BL		get_random_num
	MOV		r10, #0				;it isn't chasing pacman
	BL		checking_direction
	B		donerandom
goingright:	
	CMP		r9, #1
	BNE		goingleft
	
	;check if both up and down are blocks, if they are, go right
	MOV		r8,	#29					;store in r8, check up	
	BL		check_blocks
	CMP		r5,	#3
	BNE		recurse
	MOV		r8,	#0					;store in r8, check down
	SUB		r8,	#29
	CMP		r5,	#3
	BNE		recurse
	BL		check_direction			;it is sandwiched, check direction
	B		donerandom
	
goingleft:
	CMP		r9,	#2
	BNE		goingup
	
	;check if both up and down are blocks, if they are, go left
	MOV		r8,	#29					;store in r8, check up	
	BL		check_blocks
	CMP		r5,	#3
	BNE		recurse
	MOV		r8,	#0					;store in r8, check down
	SUB		r8,	#29
	CMP		r5,	#3
	BNE		recurse
	BL		check_direction			;it is sandwiched, check direction
	B		donerandom
	
	
	BL		checking_direction
	B		donerandom
goingup:
	CMP		r9,	#3
	BNE		goingdown
	
	;check if both left and are are blocks, if they are, go up
	MOV		r8,	#1					;store in r8, check right	
	BL		check_blocks
	CMP		r5,	#3
	BNE		recurse
	MOV		r8,	#0					;store in r8, check left
	SUB		r8,	#1
	CMP		r5,	#3
	BNE		recurse
	BL		check_direction			;it is sandwiched, check direction
	B		donerandom
	
	
	BL		check_direction
	B		donerandom
goingdown:
	CMP		r9,	#4
	BNE		donerandom
	
	;check if both left and are are blocks, if they are, go down
	MOV		r8,	#1					;store in r8, check right	
	BL		check_blocks
	CMP		r5,	#3
	BNE		recurse
	MOV		r8,	#0					;store in r8, check left
	SUB		r8,	#1
	CMP		r5,	#3
	BNE		recurse
	BL		check_direction			;it is sandwiched, check direction
	B		donerandom
	
	
	BL		check_direction
	B		donerandom

recurse:
	MOV		r9,	#0					;junctioned, get random number
	B		goagain

donerandom:
	LDMFD SP!, {r0-r12,lr}
	MOV	  pc, lr
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_blocks:		;gets offset in r8, returns flag in r5
	STMFD	SP!, {r0-r4,r6-r12,lr}
	
	ADD		r8,	r0,	r8				;r8 contains offset of new address after going right
	LDRB	r11,[r4, r8]			;r4 is ptr to board, with offset of new address	
	
    CMP   	r8,  #138        		;Check if it is box entrance
	BNE		check_l
    MOV		r5,	 #3					;set flag to 3
	B		checked_c
check_l:	
    CMP   	r8,  #155        		;Check if it is left exit
	BNE		check_r
    MOV		r5,	 #3
	B		checked_c
check_r:
    CMP   	r8,  #183        		;Check if it is right exit 
	BNE		check_e
    MOV		r5,	 #3
	B		checked_c
check_empty:
	CMP		r11, #32				;Check if character is empty
	BNE		check_p
    MOV		r5,  #0					;empty flag	
	B		checked_c
check_p:
	CMP		r11, #46				;Check if character is normal pellet
	BNE		check_po
    MOV		r5,  #0					;empty flag
	B		checked_c	
check_po:
    CMP   	r11, #79        		;Check if character is power pellet
	BNE		bo
    MOV		r5,  #0					;empty flag	
	B		checked_c
bo:
	MOV		r5,	#3
checked_c:

	LDMFD SP!, {r0-r4,r6-r12,lr}
	MOV	  pc, lr

	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


