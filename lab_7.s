	.data

Boardstring: .string "+---------------------------+",13,10
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


	.global lab_7
	.global uart_init
	.global output_character
	.global output_string
	.global output_newline
	.global div_and_mod
	.global convert_to_ASCII_updated


U0LSR:  .equ 0x18			; UART0 Line Status Register


ptr_to_boardstring: .word Boardstring



lab_7:
	STMFD SP!,{r0-r12,lr}    ; Store register lr on stack




	BL uart_init
	BL output_newline
	BL output_newline
	BL output_newline
	BL output_newline
	LDR r4, ptr_to_boardstring
	BL output_string



	LDMFD SP!, {r0-r12,lr}
	MOV pc, lr
	.end
