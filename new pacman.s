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
pinky:		.string "000",	0
pinky_p:	.string	"0",0
pinky_d:	.string	"0",0
inky:		.string "000",	0
inky_p:		.string	"0",0
inky_d:		.string	"0",0
clyde:		.string	"000",	0
clyde_p:	.string	"0",0
clyde_d:	.string	"0",0


level_word: .string 27,"[31;1mLevel: ",0
score_word: .string 27,"[34;1mScore: ",0


sixteen_spaces: .string "               ",0
gameover: .string 27,"[31;1mGame Over! Thanks for playing!",0


boardstring: .string "+---------------------------+",13,10
			.string "|O.....|.........M...|.....O|",13,10
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
    .global initial_print
    .global illuminate_RGB_LED
    .global print_update
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
   	.global convert_to_ASCII_updated_2


	.global TimerGhost_Handler

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

ptr_to_activepowerpellet: .word activepowerpellet

ptr_to_random_no:	.word	random_no
ptr_to_ghost_id:	.word	ghost_id
ptr_to_blinky:		.word	blinky
ptr_to_blinky_p:	.word   blinky_p
ptr_to_blinky_d:	.word   blinky_d
ptr_to_pinky:		.word   pinky
ptr_to_pinky_p:		.word   pinky_p
ptr_to_pinky_d:		.word   pinky_d
ptr_to_inky:		.word   inky
ptr_to_inky_p:		.word   inky_p
ptr_to_inky_d:		.word   inky_d
ptr_to_clyde:		.word   clyde
ptr_to_clyde_p:		.word   clyde_p
ptr_to_clyde_d:		.word   clyde_d


U0LSR:  .equ 0x18			; UART0 Line Status Register

lab_7:
	   STMFD SP!,{r0-r12,lr}    ; Store register lr on stack


		; initialize power pellet to 0
		LDR		r5,		ptr_to_activepowerpellet
		MOV		r11,	#0
		STRB	r11,	[r5]

		; initialize lives to 3
		LDR		r5,		ptr_to_led_status
		MOV		r11,	#3   ; initialize lives to 3
		STRB	r11,	[r5]

		; new level counter in memory
		LDR		r5,		ptr_to_new_level_counter
		MOV		r11,	#000   ; initialize level counter to 0
		STRH	r11,	[r5]
		; new level counter in memory
		LDR		r5,		ptr_to_level_number
		MOV		r11,	#001   ; initialize level  to 1
		STRH	r11,	[r5]
		; Score number in memory
		LDR		r5,		ptr_to_score_number
		MOV		r11,	#0000000   ; initialize score to 0
		STR		r11,	[r5]

		; Current location in memory
		LDR		r5,	ptr_to_location
		MOV		r11,	#231   ; initialize location to 370
		STRH	r11,	[r5]

		; Current direction in memory
		LDR		r5,	ptr_to_direction
		MOV		r11,	#1   ; initialize direction to 1
		STRB	r11,	[r5] ;

		; Current flag in memory
		LDR		r5,	ptr_to_flag
		MOV		r11,	#0   ; initialize direction to 1
		STRB	r11,	[r5] ;


		BL uart_init
	   	BL uart_interrupt_init
	   	BL timer_init
	    BL RGB_LED_init
	 ;  BL push_button_init

		BL initial_print

handler_start:
		B		handler_end ; this goes into an infinite loop




UART0_Handler:
		STMFD SP!,{r0-r12,lr}   ;save all except r9

		MOV			r3, #0xC000      		;store address of UARTDR
		MOVT		r3, #0x4000  		   	    ;second half
		LDRB		r0, [r3]				;Store key pressed inside r0

		CMP			r0, #100		  ;cmp with d >> go right
		BEQ			right
		CMP			r0,	#97			  ;cmp with a >> go left
		BEQ			left
		CMP			r0,	#119			;cmp with w >> go up
		BEQ			up
		CMP			r0,	#115			;cmp with s >> go down
		BEQ			down
    	CMP     	r0, #112      ;cmp with p >> pause
    	BEQ 		pause
		CMP 		r0, #113			; cmp with q >> quit
		BEQ 		quit
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TimerPacman_Handler:

		STMFD SP!,{r0-r12,lr}

		; this clears the interrupt in timer A for Pacman
		BL timerA_interrupt_clear

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
		BEQ	goright
		CMP	r9,	#2
		BEQ	goleft
		CMP	r9,	#3
		BEQ	goup
		CMP	r9,	#4
		BEQ	godown

; compare the character to:
;   .  (ASCII decimal: 46) pellet -> valid
;   O  (79) power pellet -> valid
;   |  (124)wall/corner -> invalid
;   +  (43) wall/corner -> invalid
;   -  (45) wall/corner -> invalid
;   M  (77) hostile ghost -> invalid
;   W  (87) afraid ghost -> valid
;  [space] (32) space -> valid

goright:
	ADD		r7,	r0,	#1				;r7 contains the NEW ADDRESS
	LDRB	r11, [r4, r7]			;r4 is ptr to board, with offset of new address
          ; r11 holds the character in the new index
    B check_character
goleft:
    SUB		r7,	r0,	#1				;r7 contains the NEW ADDRESS
    LDRB	r11, [r4, r7]			;r4 is ptr to board, with offset of new address
          ; r11 holds the character in the new index
    B check_character
goup:
    SUB		r7,	r0,	#31				;r7 contains the NEW ADDRESS
    LDRB	r11, [r4, r7]			;r4 is ptr to board, with offset of new address
          ; r11 holds the character in the new index
    B check_character
godown:
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
    BL		print_update
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
    BL		print_update
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
    ; switch timer speeds
    ; set counter for 8 seconds

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
    MOV   r11, #60
    LDR	r5,	ptr_to_location
    STRH	r7,	[r5]				 ;update the location with r7, the NEW ADDRESS
    STRB	r11, [r4, r7]		 ;update new location with <

    ; Ghosts should be put back into the box
    ; Ghosts should not exit the box until the 8 seconds

    B con




con:

		BL print_update

		LDMFD sp!, {r0-r12,lr}
		BX lr

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

initial_print: ; this subroutines prints out the first version of the board ;; THIS MAY BE UNNECESSARY
 	STMFD SP!, {r0-r12,lr}

	MOV		r0,	#12						;print new page
	BL		output_character

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


	LDMFD SP!, {r0-r12,lr}
    MOV pc, lr
    	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
		STRB		r2,	[r1, r3] ; increment score by 10
		ADD			r3, #1
		B			addchar

donecopy:



		BL initial_print

	LDMFD SP!, {r0-r12,lr}
    MOV pc, lr
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
	 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_update:
	STMFD SP!, {r0-r12,lr}

	MOV		r0,	#12						;print carriage return
	BL		output_character

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
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
	;STRB	r1, [r4, r0]			;update prev char in board

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
	;STRB	r1, [r4, r0]		;update prev char in board

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
	;STRB	r1, [r4, r0]			;update prev char in board

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
	;STRB	r1, [r4, r0]			;update prev char in board

	LDR		r5,		ptr_to_clyde
	MOV		r11,	#171
	STRH	r11,	[r5]
	LDR		r5,		ptr_to_clyde_p
	MOV		r11,	#32
	STRB	r11,	[r5]
	LDR		r5,		ptr_to_clyde_d
	MOV		r11,	#1
	STRB	r11,	[r5]
    ; Keep the amount of pellets and power pellets the same
endgame:
	;put code to endgame
	LDMFD SP!, {r0-r12,lr}
    MOV pc, lr
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

handler_end:
		;;BL illuminate_RGB_LED
		;; check condition to quit (if the amount of life is 0?)
		LDR		r5, 	ptr_to_flag
		LDRB	r11,	[r5]
		CMP		r11,	#1
		BNE 	handler_start
	;	BEQ 	exitprogram
	;	B handler_start
exitprogram:
		BL output_newline

		LDR r4, ptr_to_gameover
		BL output_string
		BL output_newline

		LDMFD SP!, {r0-r12,lr}
		MOV pc, lr
	 .end
