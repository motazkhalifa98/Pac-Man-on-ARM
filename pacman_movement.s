; PacMan moves based off input in the UART0 Handler
; Movement keys are w, a, s, d
  .data
direction:	.string "0", 0
score_number:      .string "0000",0

  .text
ptr_to_direction:	.word direction
ptr_to_score_number: .word score

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
