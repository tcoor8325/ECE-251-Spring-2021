/*Franklin Cevallos, Nicole Joseph, Anna Konvicka, Thomas Coor: Group Project 1 ECE 251*/

.data 

.balign 4
message1: .asciz "Input string one: "

.balign 4
message2: .asciz "Input string two: "

.balign 4
null: .asciz "\n" /*Compared to the input strings to see if the typed string terminates before it reaches 13 characters*/

.balign 4
scanpattern: .asciz "%c" /*Used to store the characters as they are typed one by one*/

.balign 4
concatenatedstring: .asciz "Your concatenated string is: %s" /*Used to print final message and retrieve the resulting string*/

.balign 4
error: .asciz "Invalid string input\n" /*shows if either string surpasses the 12 character limit*/

.balign 4
string1: .skip 13 /*Though limit is 12 characters, we add an extra one to account for the null/terminating character*/ 

.balign 4
string2: .skip 13

.balign 4
result: .skip 25

.balign 4
return: .word 0


.text

.global main

main: 

	ldr r1, addr_of_return 
	str lr, [r1] /*ensures assembly will continue branching into the functions until the "return" value is called upon*/
	ldr r4, addr_of_null
	ldrb r4, [r4] /*compares \n to input string to see if reaches terminating character before reaching character limit*/
	ldr r0, addr_of_message1
	bl printf

	mov r5, #0 /*used in loop for string1 length*/
	mov r6, #0 /*used in loop2 for string2 length*/

loop:

	cmp r5, #13
	beq invalidstring1 /*if it surpasses the character limit, branch to this function*/

	ldr r0, addr_of_scanpattern
	ldr r1, addr_of_string1
	add r1, r1, r5
	bl scanf /*scans characters input in string1 and stores one by one*/

	ldr r1, addr_of_string1
	add r1, r1, r5
	ldrb r1, [r1]
	cmp r1, r4
	beq validstring1 /*if input to string1 reaches terminating character, then move onto this function*/

	add r5, r5, #1

	b loop

invalidstring1:

        ldr r0, addr_of_error
        bl printf /*error code*/

        mov r0, #7 /*return value of error of string1*/

        ldr lr, addr_of_return
        ldr lr, [lr]

        bx lr /*end of assembly*/

validstring1:

	ldr r0,addr_of_message2

	bl printf /*print message to input string2*/

loop2: /*same loop properties as the first loop, except now it applies for the second string*/

	cmp r6, #13
	beq invalidstring2

	ldr r0, addr_of_scanpattern
        ldr r1, addr_of_string2
        add r1,r1,r6
        bl scanf

	ldr r1, addr_of_string2
        add r1, r1, r6
	ldrb r1, [r1]
        cmp r1, r4
        beq validstring2

        add r6,r6,#1

        b loop2

invalidstring2:

	ldr r0, addr_of_error
        bl 

        mov r0, #8 /*return value of error of string2*/

        ldr lr, addr_of_return
        ldr lr, [lr]

        bx lr /*end of assembly*/

validstring2:

	mov r8, #0 /*iterator that indicates which index will be loaded and stored in the next function*/

	ldr r3, addr_of_string1
	ldr r1, addr_of_result

concatenate:

	ldrb r2, [r3, r8] /*load byte(char) from string1*/
	strb r2, [r1, r8] /*store into result*/
	cmp r5, r8
	beq next /*if length of r5 and r8 are equal we move onto next function*/

	add r8, r8, #1

	b concatenate

next:

	mov r8, #0 /*value of r8 is 0 and then looped again for loading*/ 
	add r9, r5, #0 /*iterator used for storing in next function starting with first index of string2*/

	ldr r1, addr_of_result
	ldr r3, addr_of_string2

concatenate_cont:

	ldrb r2, [r3,r8]
        strb r2, [r1,r9]
	add r9, r9, #1
        cmp r8, r6
        beq end

        add r8, r8, #1

        b concatenate_cont

end: 

	
	ldr r0, addr_of_concatenatedstring
	ldr r1, addr_of_result
	bl printf /*print the resulting string*/

	add r0,r5,r6 /*return the length of the concatenated string*/
	ldr lr, addr_of_return
	ldr lr, [lr]

	bx lr /*end of assembly*/



/*addresses of the variables*/
addr_of_message1: .word message1

addr_of_message2: .word message2

addr_of_scanpattern: .word scanpattern

addr_of_null: .word null

addr_of_concatenatedstring: .word concatenatedstring

addr_of_error: .word error

addr_of_string1: .word string1

addr_of_string2: .word string2

addr_of_result: .word result

addr_of_return: .word return



/*External*/
.global printf
.global scanf
