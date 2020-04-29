
Switches_Handler:
    STMFD sp!,{r0-r12,lr}




    ; this is taken from lab 5
    ; this is to clear gpio interrupt
		MOV r10, #0x7000
		MOVT r10, #0x4000
		LDR r11, [r10, #0x41C] ; with offset, (GPIOICR) GPIO Interrupt Clear
		ORR r11, r11, #0xF ; clears pins 3, 2, 1, 0
		STR r11, [r10, #0x41C]


    LDMFD sp!,{r0-r12,lr}
    BX lr
