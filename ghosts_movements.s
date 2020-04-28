; PacMan moves based off input in the UART0 Handler
; Movement keys are w, a, s, d
  .data
direction:	.string "0", 0
led_status: .string "3",0 ; 3,2,1 - lives, 4-power pellet
level_number: .string "1",0
score_number: .string "0000",0
random_no:	.string	"0000",	0
ghost_id:	.string	"0",	0
blinky:		.string "000",	0
blinky_p:	.string	"0",0
blinky_d:	.string	"0",0
blinky_character: .string "0",0
pinky:		.string "000",	0
pinky_p:	.string	"0",0
pinky_d:	.string	"0",0
pinky_character: .string "0", 0
inky:		.string "000",	0
inky_p:		.string	"0",0
inky_d:		.string	"0",0
inky_character: .string "0", 0
clyde:		.string	"000",	0
clyde_p:	.string	"0",0
clyde_d:	.string	"0",0
clyde_character: .string "0", 0

pacman_direction: .string "0",0


level_word: .string 27,"[31;1mLevel: ",0
score_word: .string 27,"[34;1mScore: ",0


sixteen_spaces: .string "               ",0
gameover: .string 27,"[31;1mGame Over! Thanks for playing!",0


boardstring: .string "+---------------------------+",13,10
			.string "|O.....|.............|.....O|",13,10
			.string "|.+--+.|.-----------.|.+--+.|",13,10
			.string "|.|  |.................|  |.|",13,10
			.string "|.+--+.|------ ------|.+--+.|",13,10
			.string " ......|    MM MM    |...... ",13,10
			.string "|.+--+.|-------------|.+--+.|",13,10
			.string "|.|  |........<........|  |.|",13,10
			.string "|.+--+.|.-----------.|.+--+.|",13,10
			.string "|O.....|.............|.....O|",13,10
			.string "+---------------------------+",0
SPACEFORSTACK1:	.string	"                                                                                                                                                               ",0
SPACEFORSTACK2:	.string	"                                                                                                                                                               ",0
SPACEFORSTACK3:	.string	"                                                                                                                                                               ",0
SPACEFORSTACK4:	.string	"                                                                                                                                                               ",0
SPACEFORSTACK5:	.string	"                                                                                                                                                               ",0
SPACEFORSTACK6:	.string	"                                                                                                                                                               ",0

  .text
  	; in lab7.s
    .global lab_7
    .global UART0_Handler
    .global TimerPacman_Handler
    .global print
    .global illuminate_RGB_LED
	; in lab7_library.s
  	.global uart_init
  	.global uart_interrupt_init
  	.global timer_init
  	.global timerA_interrupt_clear
  	.global timerB_interrupt_clear
  	.global RGB_LED_init
  	.global push_button_init
  	.global output_character
  	.global output_string
  	.global output_newline
  	.global div_and_mod
  	.global convert_to_ASCII_updated

	.global TimerGhost_Handler
ptr_to_direction: .word direction
ptr_to_led_status: .word led_status

ptr_to_level_word: .word level_word
ptr_to_level_number: .word level_number

ptr_to_score_word: .word score_word
ptr_to_score_number: .word score_number


ptr_to_sixteen_paces: .word sixteen_spaces
ptr_to_gameover: .word gameover


ptr_to_boardstring: .word boardstring

ptr_to_random_no:	.word	random_no
ptr_to_ghost_id:	.word	ghost_id
ptr_to_blinky:		.word	blinky
ptr_to_blinky_p:	.word   blinky_p
ptr_to_blinky_d:	.word   blinky_d
ptr_to_blinky_character: .word blinky_character
ptr_to_pinky:		.word   pinky
ptr_to_pinky_p:		.word   pinky_p
ptr_to_pinky_d:		.word   pinky_d
ptr_to_pinky_characater: .word pinky_character
ptr_to_inky:		.word   inky
ptr_to_inky_p:		.word   inky_p
ptr_to_inky_d:		.word   inky_d
ptr_to_inky_character: .word inky_character
ptr_to_clyde:		.word   clyde
ptr_to_clyde_p:		.word   clyde_p
ptr_to_clyde_d:		.word   clyde_d
ptr_to_clyde_character: .word clyde_character

ptr_to_pacman_direction:	.word .pacman_direction


U0LSR:  .equ 0x18			; UART0 Line Status Register

lab_7:
	   STMFD SP!,{r0-r12,lr}    ; Store register lr on stack

		BL uart_init
	   	BL uart_interrupt_init
	   	BL timer_init
	 ;  BL RGB_LED_init
	 ;  BL push_button_init

		BL 	print
		BL	initialize_ghosts

handler_start:
		B		handler_end ; this goes into an infinite loop

handler_end:

		B handler_start


		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TimerPacman_Handler:

		STMFD SP!,{r0-r12,lr}   ;save all except r0 and r9

		; this clears the interrupt in timer A for Pacman
		BL timerA_interrupt_clear

		BL	move_ghosts_afraid
		BL  move_ghosts_hostile



		LDMFD sp!, {r0-r12,lr}
		BX lr

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print: ; this subroutines prints out the first version of the board
 	STMFD SP!, {r0-r12,lr}

	MOV		r0,	#12						;print carriage return
	BL		output_character

	LDR r4, ptr_to_boardstring
	BL 		output_string


	LDMFD SP!, {r0-r12,lr}
    MOV pc, lr
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
initialize_ghosts:
	STMFD SP!, {r0-r12,lr}

	LDR		r5,		ptr_to_pacman_direction
	MOV		r11,	#0
	STRB	r11,	[r5]		;assume pacman isnt near


	LDR		r5,		ptr_to_random_no
	MOV		r11,	#5431
	STRH	r11,	[r5]

	LDR		r5,		ptr_to_blinky
	MOV		r11,	#168
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_blinky_p
	MOV		r11,	#32
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_blinky_d
	MOV		r11,	#2
	STRB	r11,	[r5]

	LDR		r5,		ptr_to_pinky
	MOV		r11,	#170
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_pinky_p
	MOV		r11,	#32
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_pinky_d
	MOV		r11,	#2
	STRB	r11,	[r5]

	LDR		r5,		ptr_to_inky
	MOV		r11,	#167
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_inky_p
	MOV		r11,	#32
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_inky_d
	MOV		r11,	#2
	STRB	r11,	[r5]

	LDR		r5,		ptr_to_clyde
	MOV		r11,	#171
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_clyde_p
	MOV		r11,	#32
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_clyde_d
	MOV		r11,	#1
	STRB	r11,	[r5]

	LDMFD SP!, {r0-r12,lr}
    MOV pc, lr

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_ghosts_hostile:
		STMFD SP!, {r0-r12,lr}

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

		LDR		r5,			ptr_to_inky_character
		MOV		r11,		#77
		STRB	r11,		[r5]		;set character

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

		LDR		r5,			ptr_to_clyde_character
		MOV		r11,		#77
		STRB	r11,		[r5]		;set character


		;set ghost_id
		LDR		r5,	ptr_to_ghost_id
		MOV		r11,	#4
		STRB	r11,	[r5] ; set ghost to 4

		BL	move_ghost_hostile


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

		LDR		r5,			ptr_to_blinky_character
		MOV		r11,		#77
		STRB	r11,		[r5]		;set character

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


		LDR		r5,			ptr_to_pinky_character
		MOV		r11,		#77
		STRB	r11,		[r5]		;set character

		;set ghost_id
		LDR		r5,	ptr_to_ghost_id
		MOV		r11,	#2
		STRB	r11,	[r5] ; set ghost to 2

		BL	move_ghost_hostile




		BL	print





	LDMFD SP!, {r0-r12,lr}
	MOV	  pc, lr



		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;PUT LOCATION OF GHOST IN r0
;PUT PELLET FLAG IN r1
;PUT DIRECTION IN r2
move_ghost_hostile:

	STMFD SP!, {r0-r12,lr}
	LDR		r4,	ptr_to_boardstring ; load board from memory into r4

	BL		check_prison			;if there is no way out for pellet, don't move it
	CMP		r5,	#3					;if it is trapped
	BEQ		quit_checking

	BL		check_inside_box	;change direction if it is still inside box
	CMP		r10, #2
	BEQ		quit_checking		;nowhere for ghost to go
	CMP		r10, #1				;if inside box, branch
	BEQ		THISBRANCH			;branch with new dir in r9

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
	SUB		r7,	r0,	#31				;r7 contains offset of new address after going up
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	dosmth
	SUB		r7,	r0,	#62				;r7 contains offset of new address after going up
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	goup
	SUB		r7,	r0,	#93				;r7 contains offset of new address after going up
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	goup
	SUB		r7,	r0,	#124				;r7 contains offset of new address after going up
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	goup

	;checking down
	ADD		r7,	r0,	#31				;r7 contains offset of new address after going down
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	dosmth
	ADD		r7,	r0,	#62				;r7 contains offset of new address after going down
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	godown
	ADD		r7,	r0,	#93				;r7 contains offset of new address after going down
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	godown
	ADD		r7,	r0,	#124				;r7 contains offset of new address after going down
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
;FETCH OLD DIRECTION
dosmth:

	MOV		r9, r2		;not inside box, use old direction from mem

THISBRANCH:				;inside box, use direction from check_box

	MOV		r10, #0			;says that its NOT chasing pacman
	BL		random_movement

quit_checking:




	LDMFD SP!, {r0-r12,lr}
	MOV	  pc, lr


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_ghosts_afraid:
		STMFD SP!, {r0-r12,lr}

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

		LDR		r5,			ptr_to_inky_character
		MOV		r11,		#87
		STRB	r11,		[r5]		;set character

		;set ghost_id
		LDR		r5,		ptr_to_ghost_id
		MOV		r11,	#3
		STRB	r11,	[r5] ; set ghost to 3

		BL	move_ghost_afraid

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

		LDR		r5,			ptr_to_clyde_character
		MOV		r11,		#87
		STRB	r11,		[r5]		;set character

		;set ghost_id
		LDR		r5,	ptr_to_ghost_id
		MOV		r11,	#4
		STRB	r11,	[r5] ; set ghost to 4

		BL	move_ghost_afraid


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

		LDR		r5,			ptr_to_blinky_character
		MOV		r11,		#87
		STRB	r11,		[r5]		;set character

		;set ghost_id
		LDR		r5,	ptr_to_ghost_id
		MOV		r11,	#1
		STRB	r11,	[r5] ; set ghost to 1

		BL	move_ghost_afraid


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

		LDR		r5,			ptr_to_pinky_character
		MOV		r11,		#87
		STRB	r11,		[r5]		;set character

		;set ghost_id
		LDR		r5,	ptr_to_ghost_id
		MOV		r11,	#2
		STRB	r11,	[r5] ; set ghost to 2

		BL	move_ghost_afraid




		BL	print





	LDMFD SP!, {r0-r12,lr}
	MOV	  pc, lr



		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;PUT LOCATION OF GHOST IN r0
;PUT PELLET FLAG IN r1
;PUT DIRECTION IN r2
move_ghost_afraid:

	STMFD SP!, {r0-r12,lr}
	LDR		r4,	ptr_to_boardstring ; load board from memory into r4

	;CHECK IF TIMER IS STILL OPERATIONAL
	;IF YES, QUIT (don't move ghost)

	LDR		r5,		ptr_to_pacman_direction
	MOV		r11,	#0
	STRB	r11,	[r5]		;assume pacman isnt near

	BL		check_prison			;if there is no way out for pellet, don't move it
	CMP		r5,	#3					;if it is trapped
	BEQ		Aquit_checking

	BL		check_inside_box	;change direction if it is still inside box
	CMP		r10, #2
	BEQ		Aquit_checking		;nowhere for ghost to go
	CMP		r10, #1				;if inside box, branch
	BEQ		ATHISBRANCH			;branch with new dir in r9

	;checking right side
	ADD		r7,	r0,	#1				;r7 contains offset of new address after going right
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Adosmth
	ADD		r7,	r0,	#2				;r7 contains offset of new address after going right
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Agoleft
	ADD		r7,	r0,	#3				;r7 contains offset of new address after going right
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Agoleft
	ADD		r7,	r0,	#4				;r7 contains offset of new address after going right
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Agoleft

	;checking left side
	SUB		r7,	r0,	#1				;r7 contains offset of new address after going left
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Adosmth
	SUB		r7,	r0,	#2				;r7 contains offset of new address after going left
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Agoright
	SUB		r7,	r0,	#3				;r7 contains offset of new address after going left
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Agoright
	SUB		r7,	r0,	#4				;r7 contains offset of new address after going left
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Agoright

	;checking up
	SUB		r7,	r0,	#31				;r7 contains offset of new address after going up
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Adosmth
	SUB		r7,	r0,	#62				;r7 contains offset of new address after going up
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Agodown
	SUB		r7,	r0,	#93				;r7 contains offset of new address after going up
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Agodown
	SUB		r7,	r0,	#124				;r7 contains offset of new address after going up
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Agodown

	;checking down
	ADD		r7,	r0,	#31				;r7 contains offset of new address after going down
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Adosmth
	ADD		r7,	r0,	#62				;r7 contains offset of new address after going down
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Agoup
	ADD		r7,	r0,	#93				;r7 contains offset of new address after going down
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Agoup
	ADD		r7,	r0,	#124				;r7 contains offset of new address after going down
	LDRB	r11,[r4, r7]			;r4 is ptr to board, with offset of new address
	CMP		r11, #60			;Check if equal pacman
	BEQ 	Agoup
	B		Aold_direction


Agoright:
	LDR		r5,		ptr_to_pacman_direction
	MOV		r11,	#2
	STRB	r11,	[r5]		;pacman is on the left

	MOV		r9,	#1			;store in r9
	MOV		r10, #1			;says that its chasing pacman
	BL	check_direction
	B	Aquit_checking
Agoleft:
	LDR		r5,		ptr_to_pacman_direction
	MOV		r11,	#1
	STRB	r11,	[r5]		;pacman is on the right

	MOV		r9,	#2			;store in r9
	MOV		r10, #1			;says that its chasing pacman
	BL	check_direction
	B	Aquit_checking
Agoup:
	LDR		r5,		ptr_to_pacman_direction
	MOV		r11,	#4
	STRB	r11,	[r5]		;pacman is down

	MOV		r9,	#3			;store in r9
	MOV		r10, #1			;says that its chasing pacman
	BL	check_direction
	B	Aquit_checking
Agodown:
	LDR		r5,		ptr_to_pacman_direction
	MOV		r11,	#3
	STRB	r11,	[r5]		;pacman is up

	MOV		r9,	#4			;store in r9
	MOV		r10, #1			;says that its chasing pacman
	BL	check_direction
	B	Aquit_checking

Aold_direction:
;FETCH OLD DIRECTION
Adosmth:

	MOV		r9, r2		;not inside box, use old direction from mem

ATHISBRANCH:				;inside box, use direction from check_box

	MOV		r10, #0			;says that its NOT chasing pacman
	BL		random_movement

Aquit_checking:




	LDMFD SP!, {r0-r12,lr}
	MOV	  pc, lr


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_random_num:
	STMFD SP!, {r0-r8,r10-r12,lr}

changenumber:
	LDR		r5,	ptr_to_random_no; load random number from memory into r0
	LDRH	r0,	[r5]
	UMULL	r8,	r7,	r0,	r0		;multiply it by self, store lower half at r8
	UBFX	r3, r8,	#4,	#13		;get 3 hex digits and 1 binary from middle
	MOV		r0,	r3				;set dividend to r6
	MOV		r1,	#4				;set divisor to 4
	BL		div_and_mod			;returns quotient in r0, remainder in r1, remainder = direction
	ADD		r3, r0				;add quotient to 4 digits number, more randomness
	MOV		r7,	#9999
	CMP		r3,	r7			;check if it is more than 4 digits number
	BLT		morethan
	SUB		r3,	#500			;subtract 500
morethan:
	LDR		r5,	ptr_to_random_no; store 4 digits number back
	STRH	r3,	[r5]
	MOV		r3,	r1			;move remainder to r9
	CMP		r3,	#0			;if r9 is 0, 0 isn't direction, change to 4
	BNE		randomnum
	MOV		r3,	#4
randomnum:
	CMP		r3,		r9
	BEQ		changenumber		;it got same direction, do it again
	LDR		r5,		ptr_to_pacman_direction
	LDRB	r11,	[r5]		;check direction of pacman
	CMP		r11,	#0			; if not chased, good to go
	BEQ		notchased
	CMP		r11,	r3
	BEQ		changenumber		;if same direction of pacman, repeat again
notchased:

	MOV		r9,	r3

	;;return number in r9
	LDMFD SP!, {r0-r8,r10-r12,lr}
	MOV	  pc, lr

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

id_getter:
	STMFD SP!, {r0-r6,r8-r12,lr}

	LDR		r5,	ptr_to_ghost_id ; load id from memory into r7
	LDRB	r7,	[r5]
	;;return number in r7
	LDMFD SP!, {r0-r6,r8-r12,lr}
	MOV	  pc, lr

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

perform_switch:
	STMFD SP!, {r0-r12,lr}
	;r11 contains new character, r9 contains direction, r8 contains new location
	;;get from memory id of current ghost, in r7
	BL	id_getter
	CMP	r7,	#1
	BEQ	blinky1
	CMP	r7,	#2
	BEQ	pinky2
	CMP	r7,	#3
	BEQ	inky3
	CMP	r7,	#4
	BEQ	clyde4
blinky1:

	;;get from memory location of ghost,

	LDR		r5,	ptr_to_blinky 	;load location from memory into r0
	LDRH	r0,	[r5]
	;;get from memory character of ghost,
	LDR		r5,	ptr_to_blinky_p ; load character from memory into r1
	LDRB	r1,	[r5]

	;;update in board erased character
	;r0 contains offset of old address
	STRB	r1, [r4, r0]			;update prev char in board
	;;update in board new character
	;r8 contains offset of new address, r7 ghost
	LDR		r5,		ptr_to_blinky_character
	LDRB	r7,		[r5]		;print current character
	STRB	r7, [r4, r8]			;update scared ghost in board
	;;update memlocation to new one
	LDR		r5,	ptr_to_blinky
	STRH	r8,	[r5] 				;update location from r8
	;;update memcharacter to new character
	LDR		r5,	ptr_to_blinky_p
	STRB	r11,	[r5]			;update character from r11
	;;update memdirection to new direction
	LDR		r5,	ptr_to_blinky_d
	STRB	r9,	[r5]			;update direction from r9
	B	switched




pinky2:

	;;get from memory location of ghost,
	LDR		r5,	ptr_to_pinky ; load location from memory into r0
	LDRH	r0,	[r5]
	;;get from memory character of ghost,
	LDR		r5,	ptr_to_pinky_p ; load character from memory into r1
	LDRB	r1,	[r5]

	;;update in board erased character
	;r0 contains offset of old address
	STRB	r1, [r4, r0]			;update prev char in board
	;;update in board new character
	;r8 contains offset of new address, r7 ghost
	LDR		r5,		ptr_to_pinky_character
	LDRB	r7,		[r5]		;print current character
	STRB	r7, [r4, r8]			;update scared ghost in board
	;;update memlocation to new one
	LDR		r5,	ptr_to_pinky
	STRH	r8,	[r5] 				;update location from r8
	;;update memcharacter to new character
	LDR		r5,	ptr_to_pinky_p
	STRB	r11,	[r5]			;update character from r11
	;;update memdirection to new direction
	LDR		r5,	ptr_to_pinky_d
	STRB	r9,	[r5]			;update direction from r9
	B	switched


inky3:

	;;get from memory location of ghost,
	LDR		r5,	ptr_to_inky ; load location from memory into r0
	LDRH	r0,	[r5]
	;;get from memory character of ghost,
	LDR		r5,	ptr_to_inky_p ; load character from memory into r1
	LDRB	r1,	[r5]
	;;update in board erased character
	;r0 contains offset of old address
	STRB	r1, [r4, r0]			;update prev char in board
	;;update in board new character
	;r8 contains offset of new address, r7 ghost
	LDR		r5,		ptr_to_inky_character
	LDRB	r7,		[r5]		;print current character
	STRB	r7, [r4, r8]			;update scared ghost in board
	;;update memlocation to new one
	LDR		r5,	ptr_to_inky
	STRH	r8,	[r5] 				;update location from r8
	;;update memcharacter to new character
	LDR		r5,	ptr_to_inky_p
	STRB	r11,	[r5]			;update character from r11
	;;update memdirection to new direction
	LDR		r5,	ptr_to_inky_d
	STRB	r9,	[r5]			;update direction from r9

	B	switched



clyde4:

	;;get from memory location of ghost,
	LDR		r5,	ptr_to_clyde ; load location from memory into r0
	LDRH	r0,	[r5]
	;;get from memory character of ghost,
	LDR		r5,	ptr_to_clyde_p ; load character from memory into r1
	LDRB	r1,	[r5]

	;;update in board erased character
	;r0 contains offset of old address
	STRB	r1, [r4, r0]			;update prev char in board
	;;update in board new character
	;r8 contains offset of new address, r7 ghost
	LDR		r5,		ptr_to_clyde_character
	LDRB	r7,		[r5]		;print current character
	STRB	r7, [r4, r8]			;update scared ghost in board
	;;update memlocation to new one
	LDR		r5,	ptr_to_clyde
	STRH	r8,	[r5] 				;update location from r8
	;;update memcharacter to new character
	LDR		r5,	ptr_to_clyde_p
	STRB	r11,	[r5]			;update character from r11
	;;update memdirection to new direction
	LDR		r5,	ptr_to_clyde_d
	STRB	r9,	[r5]			;update direction from r9




switched:
	BL	print




	LDMFD SP!, {r0-r12,lr}
	MOV	  pc, lr

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_inside_box:
	STMFD SP!, {r0-r8,r11-r12,lr}	;r9 returns direction, r10 if it is inside box

	MOV		r10, #0			;it is not inside box


	CMP		r0,	#169
	BNE		notbox1
	LDRB	r11,[r4, #138]			;make sure it can move
	CMP		r11, #77
	BEQ		goslow
	MOV		r9,	#3			;change direction to up if it is under entrance
	MOV		r10, #1
notbox1:
	CMP		r0,	#138
	BNE		notbox2
	LDRB	r11,[r4, #107]			;make sure it can move
	CMP		r11, #77
	BEQ		goslow
	MOV		r9,	#3			;change direction to up if it is AT entrance
	MOV		r10, #1
notbox2:


	CMP		r0,	#163
	BNE		notbox3
	LDRB	r11,[r4, #164]			;make sure it can move
	CMP		r11, #77
	BEQ		goslow
	MOV		r9,	#1			;change direction to right
	MOV		r10, #1
notbox3:
	CMP		r0,	#164
	BNE		notbox4
	LDRB	r11,[r4, #165]			;make sure it can move
	CMP		r11, #77
	BEQ		goslow
	MOV		r9,	#1			;change direction to right
	MOV		r10, #1
notbox4:
	CMP		r0,	#165
	BNE		notbox5
	LDRB	r11,[r4, #166]			;make sure it can move
	CMP		r11, #77
	BEQ		goslow
	MOV		r9,	#1			;change direction to right
	MOV		r10, #1
notbox5:
	CMP		r0,	#166
	BNE		notbox6
	LDRB	r11,[r4, #167]			;make sure it can move
	CMP		r11, #77
	BEQ		goslow
	MOV		r9,	#1			;change direction to right
	MOV		r10, #1
notbox6:
	CMP		r0,	#167
	BNE		notbox7
	LDRB	r11,[r4, #168]			;make sure it can move
	CMP		r11, #77
	BEQ		goslow
	MOV		r9,	#1			;change direction to right
	MOV		r10, #1
notbox7:
	CMP		r0,	#168
	BNE		notbox8
	LDRB	r11,[r4, #169]			;make sure it can move
	CMP		r11, #77
	BEQ		goslow
	MOV		r9,	#1
	MOV		r10, #1


notbox8:
	CMP		r0,	#170
	BNE		notbox9
	LDRB	r11,[r4, #169]			;make sure it can move
	CMP		r11, #77
	BEQ		goslow
	MOV		r9,	#2			;change direction to left
	MOV		r10, #1
notbox9:
	CMP		r0,	#171
	BNE		notbox10
	LDRB	r11,[r4, #170]			;make sure it can move
	CMP		r11, #77
	BEQ		goslow
	MOV		r9,	#2			;change direction to left
	MOV		r10, #1
notbox10:
	CMP		r0,	#172
	BNE		notbox11
	LDRB	r11,[r4, #171]			;make sure it can move
	CMP		r11, #77
	BEQ		goslow
	MOV		r9,	#2			;change direction to left
	MOV		r10, #1
notbox11:
	CMP		r0,	#173
	BNE		notbox12
	LDRB	r11,[r4, #172]			;make sure it can move
	CMP		r11, #77
	BEQ		goslow
	MOV		r9,	#2			;change direction to left
	MOV		r10, #1
notbox12:
	CMP		r0,	#174
	BNE		notbox13
	LDRB	r11,[r4, #173]			;make sure it can move
	CMP		r11, #77
	BEQ		goslow
	MOV		r9,	#2			;change direction to left
	MOV		r10, #1
notbox13:
	CMP		r0,	#175
	BNE		notbox14
	LDRB	r11,[r4, #174]			;make sure it can move
	CMP		r11, #77
	BEQ		goslow
	MOV		r9,	#2
	MOV		r10, #1
	B		notbox14

goslow:
	MOV	r10, #2

notbox14:				;It is not inside box




	LDMFD SP!, {r0-r8,r11-r12,lr}
	MOV	  pc, lr

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_direction:
	;r9 has direction to check
	STMFD SP!, {r0-r12,lr}



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
	MOV		r8,	#0
	SUB		r8,	#31			;store in r8
	B		converted
downcheck:
	CMP		r9,	#4			;down
	BNE		converted
	MOV		r8,	#31			;store in r8
	MOV		r7,	#1			;flag for going down, prevents ghost from re-entering box


converted:

	ADD		r8,	r0,	r8				;r8 contains offset of new address after going right
	LDRB	r11,[r4, r8]			;r4 is ptr to board, with offset of new address

    CMP   	r8,  #138        		;Check if it is box entrance
	BNE		check_left
	CMP		r7,	#1
	BNE		check_left				;if it is box entrance and direction is down, block it
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
	MOV		r6,	#1			;if pacman isn't chased, change blocked dir flag to 1
nopac:
	BL		random_movement	;otherwise use old direction stored in r9
	B		randomdone

switch:
	;r11 contains new character, r9 contains direction, r8 contains new location
	BL		perform_switch
	;switch everything
randomdone:

	LDMFD SP!, {r0-r12,lr}
	MOV	  pc, lr

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_prison:		;gets base in r0, offset to r8, returns flag in r5
	STMFD	SP!, {r0-r4,r6-r12,lr}

	MOV		r8,	#0					;store in r8, check up
	SUB		r8,	#31
	MOV		r7,	#0					;consider it not a block, since checking up
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayout					;not =3, there's a way out

	MOV		r8,	#31					;store in r8, check down
	MOV		r7,	#1					;consider it a block
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayout					;not =3, there's a way out

	MOV		r8,	#1					;store in r8, check right
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayout					;not =3, there's a way out

	MOV		r8,	#0					;store in r8, check left
	SUB		r8,	#1
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayout					;not =3, there's a way out
	B		trapped


wayout:
	MOV		r5,	#1					;one of them is not = 3, change to 1
trapped:							;trapped, r5 = 3

	LDMFD SP!, {r0-r4,r6-r12,lr}
	MOV	  pc, lr


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;uses r9 as prev direction
random_movement:
	STMFD SP!, {r0-r12,lr}

goagain:
	CMP		r6,	#1			;if direction is blocked
	BNE		goingright
	;generate random number, store in r9
	BL		get_random_num
	MOV		r10, #0				;it isn't chasing pacman
	BL		check_direction
	B		donerandom
goingright:
	CMP		r9, #1
	BNE		goingleft

	;check if both up and down are blocks, if they are, go right
	MOV		r8,	#0					;store in r8, check up
	SUB		r8,	#31
	MOV		r7,	#0					;consider it not a block
	BL		check_blocks
	CMP		r5,	#3
	BNE		recurse
	MOV		r8,	#31					;store in r8, check down
	MOV		r7,	#1					;consider it a block
	BL		check_blocks
	CMP		r5,	#3
	BNE		recurse
	BL		check_direction			;it is sandwiched, check direction
	B		donerandom

goingleft:
	CMP		r9,	#2
	BNE		goingup

	;check if both up and down are blocks, if they are, go left
	MOV		r8,	#0					;store in r8, check up
	SUB		r8,	#31
	MOV		r7,	#0					;consider it not a block
	BL		check_blocks
	CMP		r5,	#3
	BNE		recurse
	MOV		r8,	#31					;store in r8, check down
	MOV		r7,	#1					;consider it a block
	BL		check_blocks
	CMP		r5,	#3
	BNE		recurse
	BL		check_direction			;it is sandwiched, check direction
	B		donerandom


	BL		check_direction
	B		donerandom
goingup:
	CMP		r9,	#3
	BNE		goingdown
	CMP		r0,	#169
	BEQ		leaving_box
	;check if both left and are are blocks, if they are, go up
	MOV		r8,	#1					;store in r8, check right
	BL		check_blocks
	CMP		r5,	#3
	BNE		recurse
	MOV		r8,	#0					;store in r8, check left
	SUB		r8,	#1
	BL		check_blocks
	CMP		r5,	#3
	BNE		recurse
leaving_box:
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
	BL		check_blocks
	CMP		r5,	#3
	BNE		recurse
	BL		check_direction			;it is sandwiched, check direction
	B		donerandom


recurse:
	MOV		r6,	#1					;junctioned, get random number
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
	CMP		r7,	#1
	BNE		check_l					;making sure it is below it to be considered a block
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
check_e:
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





