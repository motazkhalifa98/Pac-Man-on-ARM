	.data

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


U0LSR:  .equ 0x18			; UART0 Line Status Register


uart_init:
    STMFD SP!, {r0-r12,lr}

    ;#0x400FE618
    MOV 	r1, #0xE618
    MOVT 	r1, #0x400F
    LDR 	r2, [r1]
    ORR 	r3, r2, #1
    STR 	r3, [r1]
    ;#0x400FE608
    MOV 	r1, #0xE608
    MOVT 	r1, #0x400F
    LDR 	r2, [r1]
    ORR 	r3, r2, #1
    STR 	r3, [r1]
    ;#0x4000C030
    MOV 	r1, #0xC030
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    ORR 	r3, r2, #0
    STR 	r3, [r1]
    ;#0x4000C024
    MOV 	r1, #0xC024
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    ORR 	r3, r2, #8
    STR 	r3, [r1]
    ;#0x4000C028
    MOV 	r1, #0xC028
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    ORR 	r3, r2, #44
    STR 	r3, [r1]
    ;#0x4000CFC8
    MOV 	r1, #0xCFC8
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    ORR 	r3, r2, #0
    STR 	r3, [r1]
    ;#0x4000C02C
    MOV 	r1, #0xC02C
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    MOV 	r3, #0x60
    ORR 	r4, r2, r3
    STR 	r4, [r1]
    ;#0x4000C030
    MOV 	r1, #0xC030
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    MOV 	r3, #0x301
    ORR 	r4, r2, r3
    STR 	r4, [r1]
    ;#0x4000451C
    MOV 	r1, #0x451C
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    MOV 	r3, #0x03
    ORR 	r4, r2, r3
    STR 	r4, [r1]
    ;#0x40004420
    MOV 	r1, #0x4420
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    MOV 	r3, #0x03
    ORR 	r4, r2, r3
    STR 	r4, [r1]
    ;#0x4000452C
    MOV 	r1, #0x452C
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    MOV 	r3, #0x11
    ORR 	r4, r2, r3
    STR 	r4, [r1]

    LDMFD 	SP!, {r0-r12,lr}
    MOV 	pc, lr

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

uart_interrupt_init:
	STMFD SP!,{r0-r12,lr}   ; Store register lr on stack

	; UART NVIC initialization
	MOV r8, #0xE100
	MOVT r8, #0xE000
	LDR r9, [r8]
	ORR r9, r9, #0x20 ; bit 5 in the register
	STR r9, [r8]

	; Initialize UART Interrupt Mask Register
	MOV r8, #0xC038 ; UART Interrupt Mask Register
	MOVT r8, #0x4000 ; UART Interrupt Mask Register
	LDR r9, [r8]
	ORR r9, r9, #0x40 ; writes a 1 to bit 6, RTIM
	STR r9, [r8]

	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

timer_init:
	STMFD SP!,{r0-r12,lr}   ; Store register lr on stack

	; connect clock to timer
	; Connects T0 to clock by writing a 1 to bit 0 for TimerA
  ;                                     to bit 8 for TimerB
	MOV r8, #0xE604
	MOVT r8, #0x400F
	LDR r9, [r8]
	ORR r9, r9, #0x1
	STR r9, [r8]

	; disable timer; setup/configure while timer is disabled
	; disable timer A; write a 0 to TAEN (bit 0)
  ; disable timer B; write a 0 to TBEN (bit 8)
	MOV r8, #0x000C
	MOVT r8, #0x4003
	LDR r9, [r8]
	BIC r9, r9, #0x100
	BIC r9, r9, #0x001
	STR r9, [r8]

	; set up timer for 32-bit mode
	; write a 0 to GPTMCFG (bits 2:0)
	MOV r8, #0x0000
	MOVT r8, #0x4003
	LDR r9, [r8]
	BIC r9, r9, #0x7
	STR r9, [r8]

	; put TimerA into periodic mode
	; write a 2 to GPTMTAMR (bits 1:0)
	MOV r8, #0x0004
	MOVT r8, #0x4003
	LDR r9, [r8]
	ORR r9, r9, #0x2 ; ensure bit 1 = 1
	BIC r9, r9, #0x1 ; ensure bit 0 = 0
	STR r9, [r8]

  ; put TimerB into periodic mode
	; write a 2 to GPTMTAMR (bits 1:0)
	MOV r8, #0x0008
	MOVT r8, #0x4003
	LDR r9, [r8]
	ORR r9, r9, #0x2 ; ensure bit 1 = 1
	BIC r9, r9, #0x1 ; ensure bit 0 = 0
	STR r9, [r8]

	; set up interrupt interval for timerA GPTMTAILR
	; 2 times/second = 16mil/2 = 8mil -> 0x007A 1200
	MOV r8, #0x0028
	MOVT r8, #0x4003
	MOV r9, #0x1200
	MOVT r9, #0x007A
	STR r9, [r8]

  ; set up interrupt interval for timerBB GPTMTBBILR
	; 3 times/second = 16mil/3 ~ 5,333,333 -> 0x0051 6155
	MOV r8, #0x002C
	MOVT r8, #0x4003
	MOV r9, #0x6155
	MOVT r9, #0x0051
	STR r9, [r8]

	; set timer0 to interrupt when top limit of timer is reached GPTMIMR
	; write 1 (enable) to TATOIM (bit 0) for timerA
  ; write 1 (enable) to TBTOIM (bit 8) for timerB
	MOV r8, #0x0018
	MOVT r8, #0x4003
	LDR r9, [r8]
	ORR r9, r9, #0x100
	ORR r9, r9, #0x001
	STR r9, [r8]

	; enable NVIC Interrupt timer0
	; set bit 19 of EN0
	MOV r8, #0xE100
	MOVT r8, #0xE000
	LDR r9, [r8]
	MOV r10, #0x0000
	MOVT r10, #0x0008 ; bit 19
	ORR r9, r9, r10
	STR r9, [r8]

	; enable timer A and B now since configuration is done
	; write 1 to TAEN (bit 0) for timerA
  ; write 1 to TBEN (bit 0) for timerB
	MOV r8, #0x000C
	MOVT r8, #0x4003
	LDR r9, [r8]
	ORR r9, r9, #0x100
	ORR r9, r9, #0x001

	STR r9, [r8]


	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; TimerA clear
timerA_interrupt_clear:
	STMFD SP!,{r0-r12,lr}

	; clear the timer interrupt
	; write 1 to Timer A Timeout Raw Interrupt (TATOCINT) bit (bit 0)
	MOV r8, #0x0024
	MOVT r8, #0x4003
	LDR r9, [r8]
	ORR r9, r9, #0x1
	STR r9, [r8]

	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TimerB clear
timerB_interrupt_clear:
	STMFD SP!,{r0-r12,lr}

	; clear the timer interrupt GPTMICR
	; write 1 to Timer B Timeout Interrupt (TBTOCINT) bit (bit 8)
	MOV r8, #0x0024
	MOVT r8, #0x4003
	LDR r9, [r8]
	ORR r9, r9, #0x100
	STR r9, [r8]

	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RGB_LED_init:
			STMFD 	SP!, {r0-r12,lr}
			;enable only port F in clock register
			MOV 	r8, #0xE000
			MOVT 	r8, #0x400F
			LDR 	r9, [r8, #0x608]
			ORR 	r9, r9, #0x20
			STR 	r9, [r8, #0x608]
			;move address of Port F to r8
			MOV 	r8, #0x5000
			MOVT 	r8, #0x4002
			;Set direction to output
			;Digital Register, Port F, pins 3 2 1, to 1
			LDR r9, [r8, #0x400]
			ORR r9, r9, #0xE
			STR 	r9, [r8, #0x400]
			;Set type to Digital/Enable
			;Digital Register, Port F, pins 3 2 1, to 1
			LDR 	r9, [r8, #0x51C]
			ORR 	r9, r9, #0xE
			STR 	r9, [r8, #0x51C]

			LDMFD 	SP!, {r0-r12,lr}
			MOV 	pc, lr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
push_button_init:
	STMFD SP!,{r0-r12,lr}


	; enable Port D in clock Register, write a 1 to bit 3 / 0x8
	MOV r8, #0xE000
	MOVT r8, #0x400F
	LDR r9, [r8]
	ORR r9, r9, #0x8
	STR r9, [r8]

	; base address Port D 0x40007000
	MOV r8, #0x7000
	MOVT r8, #0x4000
	; Direction register - input (0), pins 3,2,1,0 (offset 0x400)
	LDR r9, [r8, #0x400]
	BIC r9, r9, #0xF
	STR r9, [r8, #0x400]

	; Digital register - digital (1), pins 3,2,1,0 (offset 0x51C)
	LDR r9, [r8, #0x51C]
	ORR r9, r9, #0xF
	STR r9, [r8, #0x51C]


	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

output_character: 						;this outputs whatever is in r0
    STMFD 	SP!, {r0-r12,lr}
    MOV  	r3, #0
    MOV  	r6, #0xC000      			;store address of UARTDR
    MOVT 	r6, #0x4000     		    ;second half
CHECKOUTPUT: LDRB 	r1, [r6, #U0LSR] 			;load address from memory with added offset (UARTFR)
    AND  	r2, r1, #0x20   			;AND with 00100000
    CMP  	r2, r3 					;Compare with 0
    BNE  	CHECKOUTPUT             	;If != 0, repeat
    STRB 	r0, [r6]        		 	;store result in memory address r0
    LDMFD 	SP!, {r0-r12,lr}
    MOV 	pc, lr



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


output_string:
    STMFD 	SP!, {r1-r12,lr}
NEXTLETTER: LDRB 	r5, [r4] 			 ;r5 holds the actual E
    CMP 	r5, #0 				 ;see if the character is null
    BEQ 	RETURNBACK 			 ;if it is null, exit this subfunction
    MOV 	r0, r5 				 ;r0 now holds the character we want to output
    BL 		output_character 	 ;this subroutine outputs r0
    ADD 	r4 ,r4, #1 			 ;increment memory
    B 		NEXTLETTER 			 ;output the next letter
RETURNBACK:	LDMFD 	SP!, {r1-r12,lr}
    MOV 	pc, lr


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


output_newline:
    STMFD 	SP!, {r0-r12,lr}
    MOV 	r0, #10
    BL 		output_character
    MOV 	r0, #13
    BL 		output_character
    LDMFD 	SP!, {r0-r12,lr}
    MOV 	pc, lr


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


div_and_mod:
    STMFD SP!, {r2-r12, lr}
    MOV r3, #0      		 ;zero register
    MOV r4, #0      		 ;sign indicator for dividend initialized to positive = 0
    MOV r8, #0      		 ;sign indicator for divisor initialized to positive = 0
    CMP r0, r3      		 ;checking dividend if positive
    BGT POSDIV      		 ;positive dividend, skip to line 13
    SUB r0, r3, r0  		 ;if negative flip sign
    MOV r4, #1      		 ;flip sign indicator to 1
POSDIV: 	CMP r1, r3      		 ;checking if divisor is positive
    BGT POSDIVS     		 ;positive divisor, skip to line 17
    SUB r1, r3, r1  		 ;if negative flip sign
    MOV r8, #1      		 ;flip sign indicator to 1
POSDIVS:	MOV r5, #16     		 ;counter initialized to 16
    MOV r6, #0       		 ;quotient initialized to 0
    LSL r1, r1, #16 		 ;logical shift divisor 16 places
    MOV r7, r0      		 ;initialize remainder to dividend
    B firstloop      		 ;skip the first decremental of counter (jump to line 23)
PosCounter: SUB r5, r5, #1  		 ;counter is positive, loop and decrement
firstloop:	SUB r7, r7, r1   		 ;remainder = remainder - Divisor
    CMP r7, r3      		 ;check sign of remainder
    BGE PRemainder  		 ;if remainder is positive OR = 0, branch to PRemainder
    ADD r7, r7, r1  		 ;remainder is negative, remainder = remainder + divisor
    LSL r6, r6, #1  		 ;left shift quotient
    B NRemainder    		 ;remainder is negative, so jump to NRemainder
PRemainder: LSL r6, r6, #1  		 ;remainder is positive, shift left
    ADD r6, r6, #1  		 ;add 1
NRemainder: LSR r1, r1, #1  		 ;right shift divisor
    CMP r5, r3      		 ;check sign of counter
    BGT PosCounter			 ;positive counter, repeat
    MOV r0, r6      		 ;moving quotient to r0
    MOV r1, r7      		 ;moving remainder to r1
    CMP r4, r8      		 ;checking if dividend and divisor were same sign
    BEQ PQuotient   		 ;if same sign, branch
    SUB r0, r3, r0  		 ;switching quotient back to negative
PQuotient:
    LDMFD SP!, {r2-r12, lr}
    MOV pc, lr

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

convert_to_ASCII_updated: ; this changes counter number from Integer to ASCII
    STMFD SP!, {r0-r12,lr}
    ;converts num stored in r2 to string starting from r4
    MOV r0, r2  				 ;move difference to dividend
    MOV r1, #10 				 ;divisor ,set divisor as 10
    BL div_and_mod
    ADD r1, #48 				 ;add 48 to remainder which is the last number, converting it to ASCII
    STRB r1, [r4, #2]			 ;store it at the end of differencenum
    MOV r1, #10					 ;reset r1 to 10
    ;r0 will be holding the new quotient now
    BL div_and_mod				 ;repeat process
    ADD r1, #48
    STRB r1, [r4, #1]			 ;store it at the middle of differencenum
    MOV r1, #10					 ;reset r1 to 10
    ;r0 will be the new quotient now
    BL div_and_mod
    ADD r1, #48
    STRB r1, [r4]				 ;store it as the first number in differencenum

    LDMFD SP!, {r0-r12,lr}
    MOV pc, lr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

convert_to_ASCII_updated_2: ; this changes 7 DIGITS number from Integer to ASCII
    STMFD SP!, {r0-r12,lr}
    ;converts num stored in r2 to string starting from r4
    MOV r0, r2  				 ;move difference to dividend

    MOV r1, #10 				 ;divisor ,set divisor as 10
    BL div_and_mod
    ADD r1, #48 				 ;add 48 to remainder which is the last number, converting it to ASCII
    STRB r1, [r4, #6]			 ;store it at the end

    MOV r1, #10					 ;reset r1 to 10
    ;r0 will be holding the new quotient now
    BL div_and_mod				 ;repeat process
    ADD r1, #48
    STRB r1, [r4, #5]			 ;store it at the sixth

    MOV r1, #10					 ;reset r1 to 10
    ;r0 will be holding the new quotient now
    BL div_and_mod				 ;repeat process
    ADD r1, #48
    STRB r1, [r4, #4]			 ;store it at the fifth

    MOV r1, #10					 ;reset r1 to 10
    ;r0 will be holding the new quotient now
    BL div_and_mod				 ;repeat process
    ADD r1, #48
    STRB r1, [r4, #3]			 ;store it at the fourth

     MOV r1, #10					 ;reset r1 to 10
    ;r0 will be holding the new quotient now
    BL div_and_mod				 ;repeat process
    ADD r1, #48
    STRB r1, [r4, #2]			 ;store it at the third

    MOV r1, #10					 ;reset r1 to 10
    ;r0 will be holding the new quotient now
    BL div_and_mod				 ;repeat process
    ADD r1, #48
    STRB r1, [r4, #1]			 ;store it at the second

    MOV r1, #10					 ;reset r1 to 10
    ;r0 will be the new quotient now
    BL div_and_mod
    ADD r1, #48
    STRB r1, [r4]				 ;store it as the first number in differencenum

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
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;PUT LOCATION OF GHOST IN r0
;PUT PELLET FLAG IN r1
;PUT DIRECTION IN r2
move_ghost_hostile:

	STMFD SP!, {r0-r12,lr}

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

old_direction:			;FETCH OLD DIRECTION
	MOV		r9, r2		;not inside box, use old direction from mem

THISBRANCH:				;inside box, use direction from check_box
	MOV		r10, #0			;says that its NOT chasing pacman
	BL		random_movement
	B		quit_checking

dosmth:	;do something here
	BL		lose_life


quit_checking:



	LDMFD SP!, {r0-r12,lr}
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


random_movement:
	STMFD SP!, {r0-r12,lr}

	; uses r9 as prev direction

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
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


check_cornered_by_pac:		;gets base in r0, offset to r8, returns flag in r5
	STMFD	SP!, {r0-r4,r6-r12,lr}

	CMP		r11, #1
	BEQ		pacisright
	CMP		r11, #2
	BEQ		pacisleft
	CMP		r11, #3
	BEQ		pacisup
	CMP		r11, #4
	BEQ		pacisdown

pacisright:
	MOV		r8,	#0					;store in r8, check up
	SUB		r8,	#31
	MOV		r7,	#0					;consider it not a block, since checking up
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayoutpac					;not =3, there's a way out

	MOV		r8,	#31					;store in r8, check down
	MOV		r7,	#1					;consider it a block
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayoutpac					;not =3, there's a way out

	MOV		r8,	#0					;store in r8, check left
	SUB		r8,	#1
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayoutpac					;not =3, there's a way out

	B		trappedpac

pacisleft:
	MOV		r8,	#0					;store in r8, check up
	SUB		r8,	#31
	MOV		r7,	#0					;consider it not a block, since checking up
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayoutpac					;not =3, there's a way out

	MOV		r8,	#31					;store in r8, check down
	MOV		r7,	#1					;consider it a block
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayoutpac					;not =3, there's a way out

	MOV		r8,	#1					;store in r8, check right
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayoutpac					;not =3, there's a way out

	B		trappedpac

pacisup:
	MOV		r8,	#31					;store in r8, check down
	MOV		r7,	#1					;consider it a block
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayoutpac					;not =3, there's a way out

	MOV		r8,	#1					;store in r8, check right
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayoutpac					;not =3, there's a way out

	MOV		r8,	#0					;store in r8, check left
	SUB		r8,	#1
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayoutpac					;not =3, there's a way out

	B		trappedpac

pacisdown:
	MOV		r8,	#0					;store in r8, check up
	SUB		r8,	#31
	MOV		r7,	#0					;consider it not a block, since checking up
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayoutpac					;not =3, there's a way out

	MOV		r8,	#1					;store in r8, check right
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayoutpac					;not =3, there's a way out

	MOV		r8,	#0					;store in r8, check left
	SUB		r8,	#1
	BL		check_blocks
	CMP		r5,	#3
	BNE		wayoutpac					;not =3, there's a way out

	B		trappedpac


wayoutpac:
	MOV		r5,	#1					;one of them is not = 3, change to 1
trappedpac:							;trapped, r5 = 3

	LDMFD SP!, {r0-r4,r6-r12,lr}
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

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.end
