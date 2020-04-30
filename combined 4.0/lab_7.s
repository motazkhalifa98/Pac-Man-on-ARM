; PacMan moves based off input in the UART0 Handler
; Movement keys are w, a, s, d
	.data
direction:	.string "0", 0
led_status: .string "0",0 ; 3,2,1 - lives, 4-power pellet
level_string: .string "001",0
level_number: .string "000",0
new_level_counter: .string "000",0
score_number: .string "0000000",0
score_string: .string "0000000",0
location: .string "000",0
flag: .string "0",0
activepowerpellet: .string "0",0


random_no:	.string	"0000",	0
ghost_id:	.string	"0",	0
blinky:		.string "000",	0
blinky_p:	.string	"0",0
blinky_d:	.string	"0",0
blinky_character: .string "0",0
blinky_prisoned: .string "0", 0
pinky:		.string "000",	0
pinky_p:	.string	"0",0
pinky_d:	.string	"0",0
pinky_character: .string "0", 0
pinky_prisoned: .string "0", 0
inky:		.string "000",	0
inky_p:		.string	"0",0
inky_d:		.string	"0",0
inky_character: .string "0", 0
inky_prisoned: .string "0", 0
clyde:		.string	"000",	0
clyde_p:	.string	"0",0
clyde_d:	.string	"0",0
clyde_character: .string "0", 0
clyde_prisoned: .string "0", 0

pacman_direction: .string "0",0


level_word: .string 27,"[31;1mLevel: ",0
score_word: .string 27,"[34;1mScore: ",0

start_prompt1:	.string "Welcome to Pac-Man!", 0
start_prompt2:	.string "Controls are: w,s,d,a for up, down, right and left respectively", 0
start_prompt3:	.string "Press b to begin the game, and p to pause.", 0
paused_prompt: .string "Press q to quit the game, r to resume, or t to restart.", 0
game_status: .string "0", 0
prev_game_status: .string "0", 0
eight_seconds:	.string "0", 0
ghosts_counter: .string "0", 0

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

untouched_boardstring: .string "+---------------------------+",13,10
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

paused_boardstring: .string "+---------------------------+",13,10
			.string "|O.....|.............|.....O|",13,10
			.string "|.+--+.|.-----------.|.+--+.|",13,10
			.string "|.|  |.................|  |.|",13,10
			.string "|.+--+.|------ ------|.+--+.|",13,10
			.string " ......| P A U S E D |...... ",13,10
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
	.global TimerGhost_Handler
	.global move_pacman

	; in lab_7_library.s
  	.global uart_init
  	.global uart_interrupt_init
  	.global timer_init
  	.global timerA_interrupt_clear
  	.global timerB_interrupt_clear
  	.global RGB_LED_init
  	.global output_character
  	.global output_string
  	.global output_newline
  	.global div_and_mod
  	.global convert_to_ASCII_updated
 	.global convert_to_ASCII_updated_2
	.global push_button_init

	; in lab_7_ghosts.s
	.global	move_ghosts_hostile
	.global move_ghost_hostile
	.global move_ghosts_afraid
	.global move_ghost_afraid
	.global check_direction
	.global random_movement
	.global check_prison
	.global check_inside_box
	.global check_blocks
	.global check_cornered_by_pac
	.global get_random_num
	.global id_getter
	.global perform_switch

	; in lab_7_board.s
	.global start_new_level
	.global illuminate_RGB_LED
	.global print
	.global lose_life
	.global initialize_board

ptr_to_location: .word location
ptr_to_flag: .word flag
ptr_to_direction: .word direction
ptr_to_led_status: .word led_status

ptr_to_level_word: .word level_word
ptr_to_level_string: .word level_string
ptr_to_level_number: .word level_number
ptr_to_new_level_counter: .word new_level_counter

ptr_to_score_word: .word score_word
ptr_to_score_number: .word score_number
ptr_to_score_string: .word score_string

ptr_to_sixteen_spaces: .word sixteen_spaces
ptr_to_gameover: .word gameover


ptr_to_boardstring: .word boardstring
ptr_to_untouched_boardstring: .word untouched_boardstring
ptr_to_paused_boardstring: .word paused_boardstring

ptr_to_activepowerpellet: .word activepowerpellet

ptr_to_random_no:	.word	random_no
ptr_to_ghost_id:	.word	ghost_id
ptr_to_blinky:		.word	blinky
ptr_to_blinky_p:	.word   blinky_p
ptr_to_blinky_d:	.word   blinky_d
ptr_to_blinky_character: .word blinky_character
ptr_to_blinky_prisoned: .word blinky_prisoned
ptr_to_pinky:		.word   pinky
ptr_to_pinky_p:		.word   pinky_p
ptr_to_pinky_d:		.word   pinky_d
ptr_to_pinky_character: .word pinky_character
ptr_to_pinky_prisoned: .word pinky_prisoned
ptr_to_inky:		.word   inky
ptr_to_inky_p:		.word   inky_p
ptr_to_inky_d:		.word   inky_d
ptr_to_inky_character: .word inky_character
ptr_to_inky_prisoned: .word inky_prisoned
ptr_to_clyde:		.word   clyde
ptr_to_clyde_p:		.word   clyde_p
ptr_to_clyde_d:		.word   clyde_d
ptr_to_clyde_character: .word clyde_character
ptr_to_clyde_prisoned: .word clyde_prisoned

ptr_to_pacman_direction:	.word pacman_direction

ptr_to_start_prompt1:	.word start_prompt1
ptr_to_start_prompt2:	.word start_prompt2
ptr_to_start_prompt3:	.word start_prompt3

ptr_to_paused_prompt:	.word paused_prompt
ptr_to_game_status:	.word game_status
ptr_to_prev_game_status:	.word prev_game_status
ptr_to_eight_seconds:	.word eight_seconds
ptr_to_ghosts_counter: .word ghosts_counter

U0LSR:  .equ 0x18			; UART0 Line Status Register

lab_7:
	   STMFD SP!,{r0-r12,lr}    ; Store register lr on stack



		BL uart_init
	   	BL uart_interrupt_init
	   	BL timer_init
	    BL RGB_LED_init

		BL initialize_board




handler_start:
		B		handler_end ; this goes into an infinite loop

handler_end:
		;;BL illuminate_RGB_LED
		;; check condition to quit (if the amount of life is 0?)
		LDR		r5, 	ptr_to_flag
		LDRB	r11,	[r5]
		CMP		r11,	#1
		BNE 	handler_start

		BL output_newline
		LDR r4, ptr_to_gameover
		BL output_string
		BL output_newline
		B		exitprogram


		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
initialize_board:
	STMFD SP!, {r0-r12,lr}

	;initialize ghosts to eat to 0
	LDR		r5,		ptr_to_ghosts_counter
	MOV		r11,	#0
	STRB	r11,	[r5]
	; initialize 8 seconds to 0
	LDR		r5,		ptr_to_eight_seconds
	MOV		r11,	#0
	STRB	r11,	[r5]

	; initialize game status to 0
	LDR		r5,		ptr_to_game_status
	MOV		r11,	#0
	STRB	r11,	[r5]
	; initialize prev game status to 0
	LDR		r5,		ptr_to_prev_game_status
	MOV		r11,	#0
	STRB	r11,	[r5]
	; initialize power pellet to 0
	LDR		r5,		ptr_to_activepowerpellet
	MOV		r11,	#0
	STRB	r11,	[r5]
	; initialize lives to 3
	LDR		r5,		ptr_to_led_status
	MOV		r11,	#3   						;initialize lives to 3
	STRB	r11,	[r5]
	; new level counter in memory
	LDR		r5,		ptr_to_new_level_counter
	MOV		r11,	#000   						;initialize level counter to 0
	STRH	r11,	[r5]
	; new level in memory
	LDR		r5,		ptr_to_level_number
	MOV		r11,	#001   						;initialize level  to 1
	STRH	r11,	[r5]
	MOV 	r2, 	r11								;move level to r2 because convert_to_ascii_updated uses r2 and r4
	LDR 	r4, 	ptr_to_level_string				;update level string as well
	BL 	 	convert_to_ASCII_updated			;this one does 3 digits
	; Score number in memory
	LDR		r5,		ptr_to_score_number
	MOV		r11,	#0000000   					;initialize score to 0
	STR		r11,	[r5]
	MOV 	r2, 	r11							;move score to r2 because convert_to_ascii_updated_2 uses r2 and r4
	LDR 	r4, 	ptr_to_score_string			;update score string as well
	BL 	 	convert_to_ASCII_updated_2
	; Current flag in memory
	LDR		r5,	ptr_to_flag
	MOV		r11,	#0   						;initialize flag to 0
	STRB	r11,	[r5] ;

	;initializing pacman
	; Current location in memory
	LDR		r5,	ptr_to_location
	MOV		r11,	#231   						;initialize location to 231
	STRH	r11,	[r5]
	; Current direction in memory
	LDR		r5,	ptr_to_direction
	MOV		r11,	#1   						;initialize direction to 1
	STRB	r11,	[r5] ;



	;initializng ghosts
	LDR		r5,		ptr_to_pacman_direction		;direction that pacman is attacking from
	MOV		r11,	#0
	STRB	r11,	[r5]						;assume pacman isnt near
	;initialize random number seed
	LDR		r5,		ptr_to_random_no
	MOV		r11,	#5431
	STRH	r11,	[r5]
	;initialize blinky
	LDR		r5,		ptr_to_blinky
	MOV		r11,	#168
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_blinky_p
	MOV		r11,	#32
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_blinky_d
	MOV		r11,	#2
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_blinky_prisoned
	MOV		r11,	#0
	STRB	r11,	[r5]
	;initialize pinky
	LDR		r5,		ptr_to_pinky
	MOV		r11,	#170
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_pinky_p
	MOV		r11,	#32
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_pinky_d
	MOV		r11,	#2
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_pinky_prisoned
	MOV		r11,	#0
	STRB	r11,	[r5]
	;initialize inky
	LDR		r5,		ptr_to_inky
	MOV		r11,	#167
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_inky_p
	MOV		r11,	#32
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_inky_d
	MOV		r11,	#2
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_inky_prisoned
	MOV		r11,	#0
	STRB	r11,	[r5]
	;initialize clyde
	LDR		r5,		ptr_to_clyde
	MOV		r11,	#171
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_clyde_p
	MOV		r11,	#32
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_clyde_d
	MOV		r11,	#1
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_clyde_prisoned
	MOV		r11,	#0
	STRB	r11,	[r5]


	LDR		r0,	ptr_to_untouched_boardstring		;cleaning board
	LDR		r1,	ptr_to_boardstring
	MOV		r3,	#0
cleanchars:
	LDRB		r2,	[r0, r3]
	CMP			r2,	#0
	BEQ			donecleaning
	STRB		r2,	[r1, r3] ; increment by 1
	ADD			r3, #1
	B			cleanchars
donecleaning:

	BL	print								;print board


	LDMFD SP!, {r0-r12,lr}
    MOV pc, lr

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;	#     #     #     #     #  ######   #        #######  ######    #####
		;	#     #    # #    ##    #  #     #  #        #        #     #  #     #
		;	#     #   #   #   # #   #  #     #  #        #        #     #  #
		;	#######  #     #  #  #  #  #     #  #        #####    ######    #####
		;	#     #  #######  #   # #  #     #  #        #        #   #          #
		;	#     #  #     #  #    ##  #     #  #        #        #    #   #     #
		;	#     #  #     #  #     #  ######   #######  #######  #     #   #####


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UART0_Handler:
		STMFD SP!,{r0-r12,lr}   ;save all except r9

		MOV			r3, #0xC000      		;store address of UARTDR
		MOVT		r3, #0x4000  		   	    ;second half
		LDRB		r0, [r3]				;Store key pressed inside r0

		LDR			r5,		ptr_to_game_status
		LDRB		r11,	[r5]
		CMP			r11,	#0
		BEQ			startbuttons
		CMP			r11, 	#3
		BEQ			pausebuttons	;if game paused, only check for pause buttons

    	CMP     	r0, #112      ;cmp with p >> pause
    	BEQ 		pause
		CMP			r0, #100		  ;cmp with d >> go right
		BEQ			right
		CMP			r0,	#97			  ;cmp with a >> go left
		BEQ			left
		CMP			r0,	#119			;cmp with w >> go up
		BEQ			up
		CMP			r0,	#115			;cmp with s >> go down
		BEQ			down
		B			continue
startbuttons:
		CMP			r0,	#98
		BNE			continue
		; set game status to 1
		LDR			r5,		ptr_to_game_status
		MOV			r11,	#1
		STRB		r11,	[r5]
		B			continue
pausebuttons:
		CMP 		r0, #114			; cmp with r >> resume
		BEQ 		resume
		CMP 		r0, #113			; cmp with q >> quit
		BEQ 		quit
		CMP			r0,	#116			; cmp with t >> restart
		BEQ			restart
		B			continue

right:
		MOV		r9,	#1				;set direction to 1
		LDR		r5,	ptr_to_direction	;update in memory
		STRB	r9,	[r5]
		B continue
left:
		MOV		r9,	#2				;set direction to 2
		LDR		r5,	ptr_to_direction	;update in memory
		STRB	r9,	[r5]
		B continue
up:
		MOV		r9,	#3				;set direction to 3
		LDR		r5,	ptr_to_direction	;update in memory
		STRB	r9,	[r5]
		B continue
down:
		MOV		r9,	#4				;set direction to 4
		LDR		r5,	ptr_to_direction	;update in memory
		STRB	r9,	[r5]
		B continue
pause:
		LDR			r5,		ptr_to_game_status
		LDRB		r11,	[r5]
		LDR			r5,		ptr_to_prev_game_status	;save game status to prev
		STRB		r11,	[r5]
		LDR			r5,		ptr_to_game_status	;change game mode to 3-->paused
		MOV			r11,	#3
		STRB		r11,	[r5]
		B continue
resume:
		LDR			r5,		ptr_to_prev_game_status
		LDRB		r11,	[r5]
		LDR			r5,		ptr_to_game_status	; get prev game status
		STRB		r11,	[r5]
		B continue
restart:
		BL initialize_board		;initialize everything
		B continue
quit:
		LDR 	r5, 	ptr_to_flag
		MOV 	r11, 	#1
		STRB	r11,	[r5] ; set flag to 1
		B continue

  ;; include code for what to do when user wants to pause


continue:

		; this clears the interrupt
		MOV r10, #0xC044
		MOVT r10, #0x4000
		LDR r11, [r10]
		ORR r11, r11, #0x10 ; this changes the RXIM bit (bit 4) in UARTICR register to 1
		STR r11, [r10]

		LDMFD sp!, {r0-r12,lr}
		BX lr

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TimerPacman_Handler:

		STMFD SP!,{r0-r12,lr}

		; this clears the interrupt in timer A for Pacman
		BL timerA_interrupt_clear

		LDR			r5,		ptr_to_game_status
		LDRB		r11,	[r5]
		CMP			r11,	#0
		BEQ			handled		;don't do anything, game isn't up yet
		CMP			r11, 	#1
		BEQ			normalmode
		CMP			r11,	#2
		BEQ			notnormalmode
		CMP			r11,	#3
		BLEQ		print_pause

		B	handled

normalmode:
		LDR		r5,		ptr_to_activepowerpellet
		MOV		r11,	#0		;turn off powerpellet rgb_led
		STRB	r11,	[r5]
		LDR		r5,		ptr_to_game_status	;turn back on game status to 1
		MOV		r11,	#1
		STRB	r11,	[r5]


		BL	move_ghosts_hostile
		BL	move_pacman
		B 	handled
notnormalmode:

		LDR		r5,		ptr_to_eight_seconds
		LDRB	r11,	[r5]
		CMP		r11,	#0
		BEQ		normalmode
		SUB		r11,	#1
		STRB	r11,	[r5]

		BL	move_ghosts_afraid
		BL	move_pacman
		B	handled

handled:
		LDMFD sp!, {r0-r12,lr}
		BX lr


		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


TimerGhost_Handler:
    STMFD sp!,{r0-r12,lr}

    BL timerB_interrupt_clear
	BL	move_ghosts_hostile

    LDMFD sp!,{r0-r12,lr}
    BX lr


		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


		;	######      #      #####   #     #     #     #     #
		;	#     #    # #    #     #  ##   ##    # #    ##    #
		;	#     #   #   #   #        # # # #   #   #   # #   #
		;	######   #     #  #        #  #  #  #     #  #  #  #
		;	#        #######  #        #     #  #######  #   # #
		;	#        #     #  #     #  #     #  #     #  #    ##
		;	#        #     #   #####   #     #  #     #  #     #

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_pacman: ; this subroutine moves pacman
 	STMFD SP!, {r0-r12,lr}


		BL illuminate_RGB_LED		;show colors


		LDR		r5,	ptr_to_new_level_counter ; load new level counter from memory
		LDRH		r11,	[r5]
		CMP		r11,	#119					;	Check if = 117, all pellets eaten
		BNE		keepgoing
		BL		start_new_level

keepgoing:
		LDR		r4,	ptr_to_boardstring ; load board from memory into r4

		LDR		r5,	ptr_to_direction ; load direction from memory into r9
		LDRB	r9,	[r5]

		LDR		r5,	ptr_to_location ; load location from memory into r0
		LDRH	r0,	[r5]
    ; r0 holds the index of the current location of PacMan

		CMP	r9,	#1
		BEQ	gorightpac
		CMP	r9,	#2
		BEQ	goleftpac
		CMP	r9,	#3
		BEQ	gouppac
		CMP	r9,	#4
		BEQ	godownpac

; compare the character to:


gorightpac:
	ADD		r7,	r0,	#1				;r7 contains the NEW ADDRESS
	LDRB	r11, [r4, r7]			;r4 is ptr to board, with offset of new address
          ; r11 holds the character in the new index
    B check_character
goleftpac:
    SUB		r7,	r0,	#1				;r7 contains the NEW ADDRESS
    LDRB	r11, [r4, r7]			;r4 is ptr to board, with offset of new address
          ; r11 holds the character in the new index
    B check_character
gouppac:
    SUB		r7,	r0,	#31				;r7 contains the NEW ADDRESS
    LDRB	r11, [r4, r7]			;r4 is ptr to board, with offset of new address
          ; r11 holds the character in the new index
    B check_character
godownpac:
    ADD		r7,	r0,	#31				;r7 contains the NEW ADDRESS
    LDRB	r11, [r4, r7]			;r4 is ptr to board, with offset of new address
          ; r11 holds the character in the new index
    B check_character

check_character:
	CMP		r7,	#155				;check if left exit
	BNE		checkrexit
	CMP		r9,	#2
	BEQ		exitleft
checkrexit:
	CMP		r7,	#183
	BNE		valuecheck				;skip to check values
	CMP		r9,	#1
	BEQ		exitright				;check if right exit

valuecheck:
	CMP		r7,	#138
	BEQ		con						;if box entrance, do not go inside

	CMP		r11, #46				;Check if character is normal pellet
    BEQ normalpellet
    CMP   r11, #79        ;Check if character is power pellet
    BEQ powerpellet
    CMP   r11, #32        ;Check if character is a space
    BEQ blankspace
    CMP   r11, #77        ;Check if character is hostile ghost
    BEQ hostileghost
    CMP   r11, #87        ;Check if character is afraid ghost
    BEQ afraidghost

    ; the only other options are | + - which are all boundaries/walls
    ; the code underneath is if PacMan runs into walls

    ; location does not need to be updated
    B con


exitleft:
	MOV   	r11, #60
    STRB	r11, [r4, r7]		 ;update new location with <
    BL		print
	MOV   	r11, #32
    STRB	r11, [r4, r7]		 ;update new location with space
    LDR	 	r5, ptr_to_location
    MOV		r7,	#183			;update location to right exit
    STRH	r7,	[r5]				 ;update the location with r7, the NEW ADDRESS

    MOV   	r11, #32
    STRB	r11, [r4, r0]		 ;update old location with space
	B con


exitright:
	MOV   	r11, #60
    STRB	r11, [r4, r7]		 ;update new location with <
    BL		print
	MOV   	r11, #32
    STRB	r11, [r4, r7]		 ;update new location with space
    LDR	 	r5, ptr_to_location
    MOV		r7,	#155			;update location to left exit
    STRH	r7,	[r5]				 ;update the location with r7, the NEW ADDRESS

    MOV   	r11, #32
    STRB	r11, [r4, r0]		 ;update old location with space
	B con


normalpellet:
    MOV   r11, #60          ; update r11 to hold character <
		LDR		r5,	ptr_to_location
		STRH	r7,	[r5]				 ;update the location with r7, the NEW ADDRESS
		STRB	r11, [r4, r7]		 ;update new location with <

    MOV   r11, #32
    STRB	r11, [r4, r0]		 ;update old location with space


	LDR		r5,	ptr_to_new_level_counter ; load new level counter from memory
	LDRH		r11,	[r5]
	CMP		r11,	#115
	BNE		nfreeze

	MOV		r11,	r11
nfreeze:

	ADD		r11,	#1					;	add 1

	LDR		r5,	ptr_to_new_level_counter
	STRH		r11,	[r5]

    ; put code for increasing score here

	LDR		r5,	ptr_to_score_number ; load score from memory into r5
	LDR		r11,	[r5]

	ADD		r11,	#10

	LDR		r5,	ptr_to_score_number
	STR		r11,	[r5] ; increment score by 10

	MOV 	r2, r11		;move score to r2 because convert_to_ascii_updated uses r2 and r4
	LDR 	r4, ptr_to_score_string
	BL 	 	convert_to_ASCII_updated_2

    B con

powerpellet:
    MOV   	r11, 	#60
    LDR		r5, 	ptr_to_location
	STRH	r7,		[r5]				 ;update the location with r7, the NEW ADDRESS
	STRB	r11, 	[r4, r7]		 ;update new location with <
    MOV   	r11,	#32
    STRB	r11,	[r4, r0]		 ;update old location with space

    LDR		r5,		ptr_to_new_level_counter ; load new level counter from memory
	LDRH	r11,	[r5]
	ADD		r11,	#1					;	add 1
	LDR		r5,		ptr_to_new_level_counter
	STRH	r11,	[r5]
    ; put code for increasing score here

	LDR		r5,		ptr_to_score_number ; load score from memory into r5
	LDR		r11,	[r5]
	ADD		r11,	#50
	LDR		r5,		ptr_to_score_number
	STR		r11,	[r5] ; increment score by 10

	MOV 	r2, 	r11		;move score to r2 because convert_to_ascii_updated uses r2 and r4
	LDR 	r4, 	ptr_to_score_string
	BL 	 	convert_to_ASCII_updated_2

	LDR		r5,		ptr_to_activepowerpellet
	MOV		r11,	#1		;light up rgb_led
	STRB	r11,	[r5]
    BL		illuminate_RGB_LED


    ; put code for changing hostile ghosts to afraid ghosts
	LDR			r5,		ptr_to_game_status	;change game mode to 2-->eat ghosts
	MOV			r11,	#2
	STRB		r11,	[r5]
    ; set counter for 8 seconds
	LDR		r5,		ptr_to_eight_seconds	;countdown eight seconds
	MOV		r11,	#16
	STRB	r11,	[r5]

	LDR		r5,		ptr_to_ghosts_counter
	MOV		r11,	#4						;set ghosts to eat to 4
	STRB	r11,	[r5]


    B 		con

blankspace:
    MOV   r11, #60
    LDR	 r5, ptr_to_location
    STRH	r7,	[r5]				 ;update the location with r7, the NEW ADDRESS
    STRB	r11, [r4, r7]		 ;update new location with <

    MOV   r11, #32
    STRB	r11, [r4, r0]		 ;update old location with space

    ; DO NOT increase score

    B con

hostileghost:
	BL	lose_life



    B con

afraidghost:


	MOV		r0, r7	; store new location of ghost in r0
	BL		throw_in_box

    ; Ghosts should be put back into the box
    ; Ghosts should not exit the box until the 8 seconds

    B con




con:

		BL print



	LDMFD SP!, {r0-r12,lr}
    MOV pc, lr

    	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;	######   #######     #     ######   ######
		;	#     #  #     #    # #    #     #  #     #
		;	#     #  #     #   #   #   #     #  #     #
		;	######   #     #  #     #  ######   #     #
		;	#     #  #     #  #######  #   #    #     #
		;	#     #  #     #  #     #  #    #   #     #
		;	######   #######  #     #  #     #  ######

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


start_new_level: ; this subroutines starts new level
 	STMFD SP!, {r0-r12,lr}

		; new level counter in memory
		LDR		r5,		ptr_to_new_level_counter
		MOV		r11,	#000   ; reset level counter to 0
		STRH	r11,	[r5]
		; increment level

		LDR		r5,	ptr_to_level_number ; load level from memory into r5
		LDRH		r11,	[r5]

		ADD		r11,	#1

		LDR		r5,	ptr_to_level_number
		STRH		r11,	[r5] ; increment level by 1

		MOV 	r2, r11		;move level to r2 because convert_to_ascii_updated uses r2 and r4
		LDR 	r4, ptr_to_level_string
		BL 	 	convert_to_ASCII_updated	;this one does 3 digits

		; Reset Current location in memory
		LDR		r5,	ptr_to_location
		MOV		r11,	#231   ; reset location to 231
		STRH	r11,	[r5]

		; Reset Current direction in memory
		LDR		r5,	ptr_to_direction
		MOV		r11,	#1   ; reset direction to 1
		STRB	r11,	[r5] ;


		LDR		r0,	ptr_to_untouched_boardstring
		LDR		r1,	ptr_to_boardstring
		MOV		r3,	#0

addchar:

		LDRB		r2,	[r0, r3]
		CMP			r2,	#0
		BEQ			donecopy
		STRB		r2,	[r1, r3] ; increment location by 1
		ADD			r3, #1
		B			addchar

donecopy:



		BL print

	LDMFD SP!, {r0-r12,lr}
    MOV pc, lr


		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


print_pause: ; this subroutines starts new level
 	STMFD SP!, {r0-r12,lr}


		LDR		r0,	ptr_to_boardstring
		LDR		r1,	ptr_to_paused_boardstring
		MOV		r3,	#0

addcharpause:
		CMP			r3,	#162
		BEQ			spaceforpause
		LDRB		r2,	[r0, r3]
		CMP			r2,	#0
		BEQ			donecopypause
		STRB		r2,	[r1, r3] ; increment score by 10
		ADD			r3, #1
		B			addcharpause
spaceforpause:
		ADD			r3,	#15		; create space for PAUSED
		B			addcharpause

donecopypause:



	MOV		r0,	#12						;print carriage return
	BL		output_character
	LDR r4,		ptr_to_start_prompt1		;printing prompts
	BL output_string
	BL output_newline
	LDR r4,		ptr_to_start_prompt2
	BL output_string
	BL output_newline
	LDR r4,		ptr_to_start_prompt3
	BL output_string
	BL output_newline
	LDR r4, ptr_to_sixteen_spaces
	BL output_string
	LDR r4, ptr_to_level_word
	BL output_string
	;;;;;;
	LDR r4, ptr_to_level_string
	BL output_string
	BL output_newline
	LDR r4, ptr_to_sixteen_spaces
	BL output_string
	LDR r4, ptr_to_score_word
	BL output_string
	;;;;;;
	LDR r4, ptr_to_score_string
	BL output_string
	BL output_newline
	LDR r4, ptr_to_paused_boardstring
	BL output_string
	BL output_newline
	LDR	r4, ptr_to_paused_prompt
	BL	output_string
	BL	output_newline

	LDMFD SP!, {r0-r12,lr}
    MOV pc, lr


		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


illuminate_RGB_LED:
	  STMFD 	SP!, {r0-r12,lr}

	  ; GPIO Port F's data register: 0x400253FC
	  MOV r8, #0x53FC
	  MOVT r8, #0x4002

	  LDR r9, [r8]
	  LDR		r11, ptr_to_activepowerpellet
	  LDRB		r4,	[r11]
	  CMP		r4, #1
	  BEQ		powerpellet2		;if power pellet is on


	  LDR 		r11, ptr_to_led_status	;else, check lives left
	  LDRB		r4, [r11]



	  CMP r4, #3; check if status is 3 lives
	  BEQ threelives

	  CMP r4, #2; check if status is 2 lives
	  BEQ twolives

	  CMP r4, #1; check if status is 1 life
	  BEQ onelife

	  ; GPIO colors
	  ; pins 3, 2, 1
	  ; green, blue, red

powerpellet2: ; turn to blue
	    ORR r9, r9, #0x4 ; turns blue on
	    BIC r9, r9, #0xA ; turns green and red off
	  B continueled

threelives: ; turn to green
	    ORR r9, r9, #0x8 ; turns green on
	    BIC r9, r9, #0x6 ; turns blue and red off
	  B continueled

twolives: ; turn to yellow
	    ORR r9, r9, #0xA ; turns red and green on
	    BIC r9, r9, #0x4 ; turns blue off
	  B continueled

onelife: ; turn to red
	    ORR r9, r9, #0x2 ; turns red on
	    BIC r9, r9, #0xC ; turns blue and green off
	  B continueled

continueled:

	    STR r9, [r8]

	 LDMFD sp!, {r0-r12,lr}
	 MOV pc, lr


		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


print:
	STMFD SP!, {r0-r12,lr}

	MOV		r0,	#12						;print carriage return
	BL		output_character

	LDR r4,		ptr_to_start_prompt1		;printing prompts
	BL output_string
	BL output_newline
	LDR r4,		ptr_to_start_prompt2
	BL output_string
	BL output_newline
	LDR r4,		ptr_to_start_prompt3
	BL output_string
	BL output_newline

	LDR r4, ptr_to_sixteen_spaces
	BL output_string

	LDR r4, ptr_to_level_word
	BL output_string

	;;;;;;
	LDR r4, ptr_to_level_string
	BL output_string

	BL output_newline

	LDR r4, ptr_to_sixteen_spaces
	BL output_string

	LDR r4, ptr_to_score_word
	BL output_string

	;;;;;;
	LDR r4, ptr_to_score_string
	BL output_string

	BL output_newline

	LDR r4, ptr_to_boardstring
	BL output_string

	BL output_newline


	LDMFD SP!, {r0-r12,lr}
    MOV pc, lr


		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


lose_life:
	STMFD SP!, {r0-r12,lr}

    ; put code for decreasing amount of lives by 1
        ; if there would be no life left, game is over

    LDR		r5,	ptr_to_led_status ; load lives into r5
	LDRB	r11,	[r5]
	CMP		r11,	#1
	BEQ		endgame
	SUB		r11,	#1		; decrement lives by 1
	LDR		r5,	ptr_to_led_status
	STRB	r11,	[r5]
    ; change the RGB LEDs
    BL		illuminate_RGB_LED
    ; PacMan should be moved to the center/starting position
		; Current location in memory
	LDR		r5,		ptr_to_location
	LDRH	r6,		[r5]
    MOV   	r11,	#32
    STRB	r11,	[r4, r6]		 ;update old location with space
	MOV		r11,	#231   		 ;reset location to 231
	STRH	r11,	[r5]

	; Current direction in memory
	LDR		r5,	ptr_to_direction
	MOV		r11,	#1   ; initialize direction to 1
	STRB	r11,	[r5] ;



    ; Ghosts should be moved back to the box


	LDR		r4,	ptr_to_boardstring ; load board from memory into r4


	LDR		r5,	ptr_to_blinky 	;load location from memory into r0
	LDRH	r0,	[r5]
	LDR		r5,	ptr_to_blinky_p ; load character from memory into r1
	LDRB	r1,	[r5]
	STRB	r1, [r4, r0]			;update prev char in board

	LDR		r5,		ptr_to_blinky
	MOV		r11,	#168
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_blinky_p
	MOV		r11,	#32
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_blinky_d
	MOV		r11,	#2
	STRB	r11,	[r5]


	LDR		r5,	ptr_to_pinky 	;load location from memory into r0
	LDRH	r0,	[r5]
	LDR		r5,	ptr_to_pinky_p ; load character from memory into r1
	LDRB	r1,	[r5]
	STRB	r1, [r4, r0]		;update prev char in board

	LDR		r5,		ptr_to_pinky
	MOV		r11,	#170
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_pinky_p
	MOV		r11,	#32
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_pinky_d
	MOV		r11,	#2
	STRB	r11,	[r5]


	LDR		r5,	ptr_to_inky 	;load location from memory into r0
	LDRH	r0,	[r5]
	LDR		r5,	ptr_to_inky_p ; load character from memory into r1
	LDRB	r1,	[r5]
	STRB	r1, [r4, r0]			;update prev char in board

	LDR		r5,		ptr_to_inky
	MOV		r11,	#167
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_inky_p
	MOV		r11,	#32
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_inky_d
	MOV		r11,	#2
	STRB	r11,	[r5]


	LDR		r5,	ptr_to_clyde 	;load location from memory into r0
	LDRH	r0,	[r5]
	LDR		r5,	ptr_to_clyde_p ; load character from memory into r1
	LDRB	r1,	[r5]
	STRB	r1, [r4, r0]			;update prev char in board

	LDR		r5,		ptr_to_clyde
	MOV		r11,	#171
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_clyde_p
	MOV		r11,	#32
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_clyde_d
	MOV		r11,	#1
	STRB	r11,	[r5]
	B		dontend
    ; Keep the amount of pellets and power pellets the same
endgame:

	LDR 	r5, 	ptr_to_flag
	MOV 	r11, 	#1
	STRB	r11,	[r5] ; set flag to 1 to quit game
	;put code to endgame
dontend:
	LDMFD SP!, {r0-r12,lr}
    MOV pc, lr

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;	   	 #####                                               #####
		;		#     #  #    #   ####    ####   #####   ####       #     #   ####   #####   ######
		;		#        #    #  #    #  #         #    #           #        #    #  #    #  #
		;		#  ####  ######  #    #   ####     #     ####       #        #    #  #    #  #####
		;		#     #  #    #  #    #       #    #         #      #        #    #  #    #  #
		;		#     #  #    #  #    #  #    #    #    #    #      #     #  #    #  #    #  #
		;		 #####   #    #   ####    ####     #     ####        #####    ####   #####   ######


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	; GHOSTS CODE
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_ghosts_hostile:
		STMFD SP!, {r0-r12,lr}

		LDR		r4,	ptr_to_boardstring ; load board from memory into r4

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

		LDR		r5,		ptr_to_inky_prisoned
		LDRB	r11,	[r5]
		CMP		r11,	#1
		BEQ		inkyisprisoned


		BL	move_ghost_afraid

inkyisprisoned:
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

		LDR		r5,		ptr_to_clyde_prisoned
		LDRB	r11,	[r5]
		CMP		r11,	#1
		BEQ		clydeisprisoned


		BL	move_ghost_afraid

clydeisprisoned:
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

		LDR		r5,		ptr_to_blinky_prisoned
		LDRB	r11,	[r5]
		CMP		r11,	#1
		BEQ		blinkyisprisoned


		BL	move_ghost_afraid

blinkyisprisoned:
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

		LDR		r5,		ptr_to_pinky_prisoned
		LDRB	r11,	[r5]
		CMP		r11,	#1
		BEQ		pinkyisprisoned


		BL	move_ghost_afraid

pinkyisprisoned:

		BL	print





	LDMFD SP!, {r0-r12,lr}
	MOV	  pc, lr


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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

	BL		check_cornered_by_pac			;if no way out, give uppp
	CMP		r5,	#3					;if it is trapped
	BEQ		Aquit_checking

	MOV		r9,	#1			;store in r9
	MOV		r10, #1			;says that its escaping pacman
	BL	check_direction
	B	Aquit_checking
Agoleft:
	LDR		r5,		ptr_to_pacman_direction
	MOV		r11,	#1
	STRB	r11,	[r5]		;pacman is on the right

	BL		check_cornered_by_pac			;if no way out, give uppp
	CMP		r5,	#3					;if it is trapped
	BEQ		Aquit_checking

	MOV		r9,	#2			;store in r9
	MOV		r10, #1			;says that its escaping pacman
	BL	check_direction
	B	Aquit_checking
Agoup:
	LDR		r5,		ptr_to_pacman_direction
	MOV		r11,	#4
	STRB	r11,	[r5]		;pacman is down

	BL		check_cornered_by_pac			;if no way out, give uppp
	CMP		r5,	#3					;if it is trapped
	BEQ		Aquit_checking

	MOV		r9,	#3			;store in r9
	MOV		r10, #1			;says that its escaping pacman
	BL	check_direction
	B	Aquit_checking
Agodown:
	LDR		r5,		ptr_to_pacman_direction
	MOV		r11,	#3
	STRB	r11,	[r5]		;pacman is up

	BL		check_cornered_by_pac			;if no way out, give uppp
	CMP		r5,	#3					;if it is trapped
	BEQ		Aquit_checking

	MOV		r9,	#4			;store in r9
	MOV		r10, #1			;says that its escaping pacman
	BL	check_direction
	B	Aquit_checking

Aold_direction:
	MOV		r9, r2		;not inside box, use old direction from mem

ATHISBRANCH:				;inside box, use direction from check_box
	MOV		r10, #0			;says that its NOT chasing pacman
	BL		random_movement
	B		Aquit_checking

Adosmth:	;do something here
	BL		throw_in_box


Aquit_checking:




	LDMFD SP!, {r0-r12,lr}
	MOV	  pc, lr


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

throw_in_box:
	STMFD SP!, {r0-r12,lr}
	;r0 contains location of ghost in move_afraid

	;code for increasing score
	LDR		r5,		ptr_to_ghosts_counter
	LDRB	r11,	[r5]			;get ghosts counter
	CMP		r11,	#4
	BEQ		firstghost
	CMP		r11,	#3
	BEQ		secondghost
	CMP		r11,	#2
	BEQ		thirdghost
	CMP		r11,	#1
	BEQ		fourthghost

firstghost:
	MOV		r10,	#100	;add 100
	SUB		r11,	#1	;decrease by 1
	STRB	r11,	[r5]
	B		finalscore
secondghost:
	MOV		r10,	#200
	SUB		r11,	#1	;decrease by 1
	STRB	r11,	[r5]
	B		finalscore
thirdghost:
	MOV		r10,	#400
	SUB		r11,	#1	;decrease by 1
	STRB	r11,	[r5]
	B		finalscore
fourthghost:
	MOV		r10,	#800
	B		finalscore

finalscore:
	LDR		r5,		ptr_to_score_number ; load score from memory into r5
	LDR		r11,	[r5]
	ADD		r11,	r10
	LDR		r5,		ptr_to_score_number
	STR		r11,	[r5] ; increment score by 10
	MOV 	r2, 	r11		;move score to r2 because convert_to_ascii_updated uses r2 and r4
	LDR 	r4, 	ptr_to_score_string
	BL 	 	convert_to_ASCII_updated_2

	;code for dealing with ghost
	LDR		r4,	ptr_to_boardstring
    LDR		r5,	ptr_to_blinky
    LDRH	r7,	[r5]				 ;check if it was blinky
    CMP		r0, r7
    BEQ		prisonblinky
    LDR		r5,	ptr_to_pinky
    LDRH	r7,	[r5]				 ;check if it was pinky
    CMP		r0,	r7
    BEQ		prisonpinky
    LDR		r5,	ptr_to_inky
    LDRH	r7,	[r5]				;check if it was inky
    CMP		r0,	r7
    BEQ		prisoninky
    LDR		r5,	ptr_to_clyde
    LDRH	r7,	[r5]				;check if it was clyde
    CMP		r0,	r7
    BEQ		prisonclyde

    B		prisoned


prisonblinky:

    LDR	 	r5,  	ptr_to_location
    LDRH	r7,		[r5]						;store location of pacman
    STRH	r0,	 	[r5]						;update the location with r0, the NEW ADDRESS
   	MOV   	r11, 	#60
    STRB	r11, 	[r4, r0]		 			;update ghost "W" location with pacman "<"
    MOV   	r11, 	#32
    STRB	r11, 	[r4, r7]		 			;update old pacman location with space
	LDR		r5,		ptr_to_blinky				;reset blinky location
	MOV		r11,	#168
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_blinky_p
	MOV		r11,	#32							;reset prev character
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_blinky_d
	MOV		r11,	#2							;reset direction
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_blinky_prisoned		;make sure its prisoned
	MOV		r11,	#1
	STRB	r11,	[r5]

	MOV		r11, #87
	STRB	r11, [r4, #168]						;update scared ghost in board


	B	prisoned


prisonpinky:

   LDR	 	r5,  	ptr_to_location
    LDRH	r7,		[r5]						;store location of pacman
    STRH	r0,	 	[r5]						;update the location with r0, the NEW ADDRESS
   	MOV   	r11, 	#60
    STRB	r11, 	[r4, r0]		 			;update ghost "W" location with pacman "<"
    MOV   	r11, 	#32
    STRB	r11, 	[r4, r7]		 			;update old pacman location with space
	LDR		r5,		ptr_to_pinky				;reset pinky location
	MOV		r11,	#170
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_pinky_p
	MOV		r11,	#32							;reset prev character
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_pinky_d
	MOV		r11,	#2							;reset direction
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_pinky_prisoned		;make sure its prisoned
	MOV		r11,	#1
	STRB	r11,	[r5]

	MOV		r11, #87
	STRB	r11, [r4, #170]						;update scared ghost in board

	B	prisoned


prisoninky:

   LDR	 	r5,  	ptr_to_location
    LDRH	r7,		[r5]						;store location of pacman
    STRH	r0,	 	[r5]						;update the location with r0, the NEW ADDRESS
   	MOV   	r11, 	#60
    STRB	r11, 	[r4, r0]		 			;update ghost "W" location with pacman "<"
    MOV   	r11, 	#32
    STRB	r11, 	[r4, r7]		 			;update old pacman location with space
	LDR		r5,		ptr_to_inky					;reset inky location
	MOV		r11,	#167
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_inky_p
	MOV		r11,	#32							;reset prev character
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_inky_d
	MOV		r11,	#2							;reset direction
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_inky_prisoned		;make sure its prisoned
	MOV		r11,	#1
	STRB	r11,	[r5]

	MOV		r11, #87
	STRB	r11, [r4, #167]						;update scared ghost in board

	B	prisoned



prisonclyde:
   LDR	 	r5,  	ptr_to_location
    LDRH	r7,		[r5]						;store location of pacman
    STRH	r0,	 	[r5]						;update the location with r0, the NEW ADDRESS
   	MOV   	r11, 	#60
    STRB	r11, 	[r4, r0]		 			;update ghost "W" location with pacman "<"
    MOV   	r11, 	#32
    STRB	r11, 	[r4, r7]		 			;update old pacman location with space
	LDR		r5,		ptr_to_clyde				;reset clyde location
	MOV		r11,	#171
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_clyde_p
	MOV		r11,	#32							;reset prev character
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_clyde_d
	MOV		r11,	#1							;reset direction
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_blinky_prisoned		;make sure its prisoned
	MOV		r11,	#1
	STRB	r11,	[r5]

	MOV		r11, 	#87
	STRB	r11, 	[r4, #171]						;update scared ghost in board




prisoned:
	BL	print


	LDMFD SP!, {r0-r12,lr}
	MOV	  pc, lr


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;









    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


exitprogram:


		LDMFD SP!, {r0-r12,lr}
		MOV pc, lr
	 .end
