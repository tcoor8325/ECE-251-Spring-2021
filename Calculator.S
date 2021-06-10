.data

.balign 4
return: .word 0

.balign 4
string_format: .asciz "%s\n"

.balign 4
scan_format: .asciz "%lf"

.balign 4
float_format: .asciz "%lf\n"

.balign 4
float_str: .skip 250

.balign 4
postfix: .skip 250

.balign 4
input: .word 250

.balign 4
infix: .skip 250

.balign 4
infix_parallel: .skip 250

.balign 4
float: .space 20

.text
.global main
main:					//scans the user input into 'input'
	ldr r3, =return
	str lr, [r3]	
	ldr r1, [r1, #4] 
	ldr r2, addr_of_input
	str r1,[r2]
	mov r2, #0 			//input counter
	ldr r10, addr_of_infix
	ldr r9, addr_of_input
	ldr r9, [r9]
	mov r1, #0 			//operator flag
	mov r8, #0 			//operator counter
	mov r3, #1			//holds 1st value of string
	mov r5, #0 			//parenthesis counter
	mov r6, #0 			//operator counter

load_infix:				//prep the process_infix loop
	ldrb r4, [r9], #1

process_infix:				//converts raw input to readable infix
	mov r0, #0

	cmp r4, #0
	addeq r2, #1
	beq infix_postfix_init		//if we have reached the end of the input, begin converting to postfix

	cmp r4, #43 			//'+'
	addeq r8, #1			//in this section, we are checking if the currently selected value of 'input' is an operate
	addeq r6, #1			//increment these counters to check against next characters or conditions	
	moveq r0, #1

	cmp r4, #42 			// '*'
	addeq r8, #1
	addeq r6, #1
	moveq r0, #1
	
	cmp r4, #40 			// '('
	addeq r5, #1
	streq r4, [r10,r2]
	addeq r2, #1
	beq paren_comp

	cmp r4, #45 			// '-'
	bleq minus_format		//this can mean either subtraction or negation, requires additional processing

	cmp r4, #47 			// '/'		
	addeq r8, #1
	addeq r6, #1
	moveq r0, #1

	cmp r4, #94 			// '^'
	addeq r8, #1
	addeq r6, #1
	moveq r0, #1

	cmp r4, #41 			// ')'
	subeq r5, #1			// unflag the parenthesis flag

	cmp r3, r8
	addne r3, #2			

	cmp r0, #1
	movne r8, #0			//reset the operator counter

	str r4, [r10,r2]		//store the currently selected character into the infix string
	add r2,#1			//increment our infix counter to move to the next index

	b load_infix			//loop to beginning

infix_postfix_init:			//prep registers and strings for continuing on to infix-postfix conversion
	cmp r2, #0
	ldreq r9, addr_of_infix
	ldreq r3, addr_of_infix_parallel	
	addeq r9, #4
	streq r9, [r3]
	ldreq r9, addr_of_infix
	ldreq r9,[r9]
	moveq r3, #95 			//underscore
	moveq r5, #0 
	moveq r6, #0 
	ldreq r10,addr_of_postfix
	beq numbers_to_string

	ldrb r4, [r9],#-1
	sub r2, #1
	b infix_postfix_init

paren_comp:				//checks to see if parentheses are open
	ldrb r4, [r9], #1
	cmp r4, #48
	blt process_infix

	cmp r4, #57
	b process_infix

minus_format:				//evaluate difference between subtraction and negation
	cmp r8, #1
	addlt r8, #1
	addlt r6, #1
	movlt r0, #1
	movge r4, #32
	cmp r3, r8
	subeq r8, #1
	subeq r6, #1
	moveq r0, #0
	moveq r4, #32

	str r4,[r10,r2]			//places a 'space' character into the infix string if the dash is interpreted as a minus (at the start of a string or after an operator)
	add r2,#1
	cmp r4, #32
	beq process_infix_loop
	
	b load_infix

process_infix_loop:			//reload input string and loop to top
	ldrb r4,[r9],#1
	b process_infix

precedence:				//every operator has a corresponding precedence compared to each other
	cmp r5, #40 	//'('		this branch finds the precedence of the left adjacent stack value
	moveq r5, #2
	cmp r5, #41 	//')'
	moveq r5, #1
	cmp r5, #42 	//'*'
	moveq r5, #4
	cmp r5, #43 	//'+'
	moveq r5, #5
	cmp r5, #45 	//'-'
	moveq r5, #5
	cmp r5, #47 	//'/'
	moveq r5, #4
	cmp r5, #94 	//'^'
	moveq r5, #3

	bx lr                                 

current_precedence:			//precedence of currently selected operator		
	cmp r8, #40 
	moveq r0, #2
	cmp r8, #41 
	moveq r0, #1
	cmp r8, #42 
	moveq r0, #4
	cmp r8, #43 
	moveq r0, #5                   	
	cmp r8, #45 
	moveq r0, #5
	cmp r8, #47 
	moveq r0, #4
	cmp r8, #94 
	moveq r0, #3

	bx lr   

stack_precedence:			//not duplicate; used when precedence of open paren needs to be highest during popping
	cmp r5, #40 @ is open paren
	moveq r5, #8
	cmp r5, #41 @is close paren
	moveq r5, #1
	cmp r5, #42 @ is mult
	moveq r5, #4
	cmp r5, #43 @ is add
	moveq r5, #5
	cmp r5, #45 @is minus
	moveq r5, #5
	cmp r5, #47 @is div
	moveq r5, #4
	cmp r5, #94 @ is exp
	moveq r5, #3

	bx lr                          

	cmp r8, #40 @ is open paren
	moveq r0, #8
	cmp r8, #41 @is close paren
	moveq r0, #1
	cmp r8, #42 @ is mult
	moveq r0, #4
	cmp r8, #43 @ is add
	moveq r0, #5
	cmp r8, #45 @is minus
	moveq r0, #5
	cmp r8, #47 @is div
	moveq r0, #4                                          
	cmp r8, #94 @ is exp
	moveq r0, #3

	bx lr   

push_pop:			//when the left adjacent operator is of lower precedence it must be popped to the postfix and the new value pushed in
	cmp r5, #8
	streq r4, [sp,#-4]!
	beq numbers_to_string

	str r4, [r10,r2]
	add r2, #1
	sub r6, #1

pop:				//pop until an operator of greater precedence is reached
	cmp r6, #0
	streq r8, [sp, #-4]!
	addeq r6,#1
	beq numbers_to_string
	ldr r4, [sp], #4
	mov r5, r4
	bl stack_precedence
	cmp r0,r5
	bge push_pop
	str r4, [sp, #-4]!
	str r8, [sp, #-4]!
	add r6,#1
	b numbers_to_string

paren_check:			//when we reach a close paren, pop until open paren is reached
	ldr r5, [sp], #4
	mov r4, r5
	sub r6, #1
	bl stack_precedence
	cmp r5,#8
	beq numbers_to_string
	str r4,[r10,r2]
	add r2,#1
	b paren_check

last_val:			//checks if we are at the last value of the postfix
	push {r3}
	ldr r9, addr_of_infix_parallel
	ldr r9, [r9]
	add r9,#4
	ldr r3, addr_of_infix_parallel
	str r9,[r3]
	sub r9, #4
	pop {r3}
	ldr r9, [r9]
	cmp r9, #0
	beq end_init
	and r4,r9,#0xFF		//if the registers have values in them
	mov r9, r9, LSR #8
	cmp r4, #40 @is open parenthesis
	beq nexus
	cmp r4, #41 @is close parenthesis
	beq nexus                 
	cmp r4, #42 @is mult
	beq nexus
	cmp r4, #43 @is add
	beq nexus                 
	cmp r4, #45 @is minus
	beq nexus
	cmp r4, #47 @is division
	beq nexus                 
	cmp r4, #94 @is exp
	beq nexus
	str r4, [r10,r2]
	add r2,#1
	mov r1,#0
	b numbers_to_string

nexus:					//yggdrasil
	cmp r1, #0
	streq r3, [r10,r2]		//determines what next move is required for every read-in
	addeq r2,#1
	mov r1,#1

	mov r5, r4
	bl precedence

	cmp r5,#1 @2
	beq paren_check
	cmp r6, #0
	streq r4, [sp, #-4]!
	addeq r6,#1
	beq numbers_to_string

	mov r8, r4
	ldr r4, [sp], #4 
	mov r5, r4
	bl stack_precedence
	bl current_precedence
	cmp r0,r5
	str r4, [sp, #-4]! 
	bge pop
	mov r5,r8
	str r5, [sp, #-4]! 		//push
	add r6,#1

numbers_to_string:			//check the value of the operator, if it is an operator, jump to the nexus
	and r4,r9,#255
	mov r9, r9, LSR #8
	cmp r4,#0
	beq last_val

	cmp r4, #40 
	beq nexus
	cmp r4, #41 
	beq nexus                 
	cmp r4, #42 
	beq nexus
	cmp r4, #43 
	beq nexus                
	cmp r4, #45 
	beq nexus
	cmp r4, #47 
	beq nexus                 
	cmp r4, #94 
	beq nexus
	str r4, [r10,r2]	//stores infix[index] into negativeString[index]
	add r2,#1
	mov r1,#0
	b numbers_to_string

end_init:			
	cmp r1, #0
	streq r3,[r10,r2]
	addeq r2,#1

end_loop:			//very last part of postfix conversion
	cmp r6, #0
	beq evaluate_postfix
	ldr r5, [sp], #4
	
	str r5,[r10,r2]
	add r2,#1
	sub r6,#1
	b end_loop

evaluate_postfix:			//start of evaluation phase; load strings to registers
	ldr r0,addr_of_string_format
	ldr r1,addr_of_postfix
	ldr r9, addr_of_float_str
	mov r2, #0
	mov r5, #0

float_holder_init: 			//make sure we aren't at the end of the infix	
	ldrb r4,[r10],#1
	cmp r4, #0 
	beq exit

float_holder_loop:			//store ints of the same number into string for conversion
	cmp r4, #95
	beq str_to_float
	cmp r4, #32
	moveq r4, #45
	addeq r5, #1
	str r4,[r9, r2]
	add r2, #1
	b float_holder_init

str_to_float:				//use sscanf to convert a list of string numbers into a float
	mov r5, #0
	ldr r0, addr_of_float_str
	ldr r1, addr_of_scan_format
	ldr r2, addr_of_float
	bl sscanf

	ldr r1, addr_of_float
	vldr d0,[r1]			//immediately push the float back onto the stack
	vpush {d0}
	mov r2,#0

check_empty:				//checks if r4 is empty (meaning we've reached the end) or if not, finds which operator it contains and jumps to perform that operation
	ldrb r4,[r10],#1
	cmp r4, #0
	beq exit

	cmp r4, #93
	beq float_holder_init
	cmp r4, #42 @is mult
	beq multiplication
	cmp r4, #43 @is add
	beq addition
	cmp r4, #45 @is minus
	beq subtraction
	cmp r4, #47 @is division
	beq division
	cmp r4, #94 @is exp
	beq exponentiation
	b float_holder_loop

pop_pop:				//pop two adjacent floats from the stack for convoluting with operate
	vpop {d0,d1}
	bx lr

multiplication:
	bl pop_pop
	vmul.f64 d0, d0, d1		//the v-series of operations are used for evaluating floats
	vpush {d0}
	b check_empty

addition:
	bl pop_pop
	vadd.f64 d0, d0, d1
	vpush {d0}
	b check_empty

subtraction:
	bl pop_pop
	vsub.f64 d0, d1, d0
	vpush.f64 {d0}
	b check_empty

division:
	bl pop_pop
	vdiv.f64 d0, d1, d0
	vpush {d0}
	b check_empty

exponentiation:
	bl pop_pop
	vmov r2, r3, d0
	vmov r0, r1, d1
	bl pow
	vmov d0, r0, r1
	vpush {d0}
	b check_empty

exit:					//pop the only remaining value in the stack and print it; this is our answer
	vpop {d0}
	vmov r2, r3, d0
	ldr r0,addr_of_float_format
	bl printf

	ldr lr,=return
	ldr lr,[lr]
	bx lr

addr_of_string_format: .word string_format
addr_of_scan_format: .word scan_format
addr_of_float_format: .word float_format
addr_of_float_str: .word float_str
addr_of_postfix: .word postfix
addr_of_input: .word input
addr_of_infix: .word infix
addr_of_infix_parallel: .word infix_parallel
addr_of_float: .word float

.global printf
.global sscanf
.global pow
	









                                         
