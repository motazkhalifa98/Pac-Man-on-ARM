  .data
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

		; blinky in memory
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

		; pinky in memory
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

		; inky in memory
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

		; clyde in memory
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



;PUT LOCATION OF GHOST IN r0
;PUT PELLET FLAG IN r1
;PUT DIRECTION IN r2
move_ghost_hostile:

	STMFD SP! {r0-r12,lr}
	BL	look_for_pacman
	
	LDMFD SP!, {r0-r12,lr}
	MOV	  pc, lr


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;PUT LOCATION OF GHOST IN r0
;PUT PELLET FLAG IN r1
look_for_pacman:

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
	BL	check_direction
	B	quit_checking
goleft:
	MOV		r9,	#2			;store in r9
	BL	check_direction
	B	quit_checking
goup:
	MOV		r9,	#3			;store in r9
	BL	check_direction
	B	quit_checking
godown:
	MOV		r9,	#4			;store in r9
	BL	check_direction
	B	quit_checking
	
old_direction:
//FETCH OLD DIRECTION
	BL	random_movement

quit_checking:
		
	
	
	
	LDMFD SP!, {r2-r12,lr}
	MOV	  pc, lr


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
get_random_num:
	STMFD SP! {r0-r8,r10-r12,lr}
	;;return number in r9
	LDMFD SP!, {r0-r8,r10-r12,lr}
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
	MOV		r9,	#1			;store in r9
	B		converted
leftcheck:
	CMP		r9,	#2			;left
	BNE		upcheck
	MOV		r9,	#0			;store in r9
	SUB		r9,	#1
	B		converted
upcheck:
	CMP		r9,	#3			;up
	BNE		downcheck
	MOV		r9,	#29			;store in r9
	B		converted
downcheck:						
	CMP		r9,	#4			;down
	MOV		r9,	#0			;store in r9
	SUB		r9,	#29
	
	
converted:
	
	ADD		r9,	r0,	r9				;r9 contains offset of new address after going right
	LDRB	r11,[r4, r9]			;r4 is ptr to board, with offset of new address
		
    CMP   	r9,  #138        		;Check if it is box entrance
	BNE		check_left
    MOV		r5,	 #3
	B		checked_content
check_left:	
    CMP   	r9,  #155        		;Check if it is left exit
	BNE		check_right
    MOV		r5,	 #3
	B		checked_content
check_right:
    CMP   	r9,  #183        		;Check if it is right exit 
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
	BL		random_movement


switch:
	;switch everything
	
	LDMFD SP!, {r0-r12,lr}
	MOV	  pc, lr
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
random_movement:
	STMFD SP! {r0-r8,r10-r12,lr}
	;fetch direction from memory, put into r9
	CMP		r9,	#0
	BNE		goingright
	;generate random number
	BL		checking_direction
	B		donerandom
	
	
	CMP		
	;check if both up and down are blocks, if they are, go right
	BL		checking_direction

	
	
	
	
donerandom:
	;;return number in r9
	LDMFD SP!, {r0-r8,r10-r12,lr}
	MOV	  pc, lr
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
