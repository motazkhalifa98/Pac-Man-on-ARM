; PacMan moves based off input in the UART0 Handler
; Movement keys are w, a, s, d
  .data
direction:	.string "0", 0
led_status: .string "3",0 ; 3,2,1 - lives, 4-power pellet
level_number: .string "1",0
score_number: .string "0000",0


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

  .text
  	; in lab7.s
    .global lab_7
    .global UART0_Handler
    .global TimerPacman_Handler
    .global initial_print
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


U0LSR:  .equ 0x18			; UART0 Line Status Register

lab_7:
	   STMFD SP!,{r0-r12,lr}    ; Store register lr on stack

		BL uart_init
	   	BL uart_interrupt_init
	   	BL timer_init
	 ;  BL RGB_LED_init
	 ;  BL push_button_init

		BL initial_print

handler_start:
		B		handler_end ; this goes into an infinite loop

handler_end:
		BL illuminate_RGB_LED
		;; check condition to quit (if the amount of life is 0?)
		;; if condition is met
		BEQ exitprogram
		B handler_start
exitprogram:
		BL output_newline

		LDR r4, ptr_to_gameover
		BL output_string
		BL output_newline

		LDMFD SP!, {r0-r12,lr}
		MOV pc, lr
		.end


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
    	CMP     r0, #112      ;cmp with p >> pause
    	BEQ 		pause
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

		STMFD SP!,{r0-r12,lr}   ;save all except r0 and r9

		; this clears the interrupt in timer A for Pacman
		BL timerA_interrupt_clear

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
    ADD		r7,	r0,	#29				;r7 contains the NEW ADDRESS
    LDRB	r11, [r4, r7]			;r4 is ptr to board, with offset of new address
          ; r11 holds the character in the new index
    B check_character
goleft:
    SUB		r7,	r0,	#29				;r7 contains the NEW ADDRESS
    LDRB	r11, [r4, r7]			;r4 is ptr to board, with offset of new address
          ; r11 holds the character in the new index
    B check_character

check_character:

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

normalpellet:
    MOV   r11, #60          ; update r11 to hold character <
		LDR		r5,	ptr_to_location
		STRH	r7,	[r5]				 ;update the location with r7, the NEW ADDRESS
		STRB	r11, [r4, r7]		 ;update new location with <

    MOV   r11, #32
    STRB	r11, [r4, r0]		 ;update old location with space

    ; put code for increasing score here

    B con

powerpellet:
    MOV   r11, #60
    LDR		r5,	ptr_to_location
		STRH	r7,	[r5]				 ;update the location with r7, the NEW ADDRESS
		STRB	r11, [r4, r7]		 ;update new location with <

    MOV   r11, #32
    STRB	r11, [r4, r0]		 ;update old location with space

    ; put code for changing hostile ghosts to afraid ghosts
      ; switch timer speeds
    ; set counter for 8 seconds
    ; put code for increasing score here

    B con

blankspace:
    MOV   r11, #60
    LDR		r5,	ptr_to_location
    STRH	r7,	[r5]				 ;update the location with r7, the NEW ADDRESS
    STRB	r11, [r4, r7]		 ;update new location with <

    MOV   r11, #32
    STRB	r11, [r4, r0]		 ;update old location with space

    ; DO NOT increase score

    B con

hostileghost:
    MOV   r11, #60
    LDR		r5,	ptr_to_location
    STRH	r7,	[r5]				 ;update the location with r7, the NEW ADDRESS
    STRB	r11, [r4, r7]		 ;update new location with <

    ; put code for decreasing amount of lives by 1
        ; if there would be no life left, game is over
        ; change the RGB LEDs
    ; PacMan should be moved to the center/starting position
    ; Ghosts should be moved back to the box
    ; Keep the amount of pellets and power pellets the same


    B con

afraidghost:
    MOV   r11, #60
    LDR		r5,	ptr_to_location
    STRH	r7,	[r5]				 ;update the location with r7, the NEW ADDRESS
    STRB	r11, [r4, r7]		 ;update new location with <

    ; Ghosts should be put back into the box
    ; Ghosts should not exit the box until the 8 seconds

    B con




con:

		BL		print_update

		LDMFD sp!, {r0-r12,lr}
		BX lr

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

initial_print: ; this subroutines prints out the first version of the board
 	STMFD SP!, {r0-r12,lr}

	MOV		r0,	#12						;print carriage return
	BL		output_character

	LDR r4, ptr_to_sixteen_spaces
	BL output_string

	LDR r4, ptr_to_level_word
	BL output_string

	******
	LDR r4, ptr_to_level_number
	BL output_string

	BL output_newline

	LDR r4, ptr_to_sixteen_spaces
	BL output_string

	LDR r4, ptr_to_score_word
	BL output_string

	******
	LDR r4, ptr_to_score_number
	BL output_string

	BL output_newline

	LDR r4, ptr_to_boardstring
	BL output_string


	LDMFD SP!, {r0-r12,lr}
    MOV pc, lr
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
illuminate_RGB_LED:
	  STMFD 	SP!, {r0-r12,lr}

	  ; GPIO Port F's data register: 0x400253FC
	  MOV r8, #0x53FC
	  MOVT r8, #0x4002

	  LDR r9, [r8]

	  LDR r4 ptr_to_led_status
	  CMP r4, 4; check if status is power pellet
	  BEQ powerpellet

	  CMP r4, 3; check if status is 3 lives
	  BEQ threelives

	  CMP r4, 2; check if status is 2 lives
	  BEQ twolives

	  CMP r4, 1; check if status is 1 life
	  BEQ onelife

	  ; GPIO colors
	  ; pins 3, 2, 1
	  ; green, blue, red

powerpellet: ; turn to blue
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
