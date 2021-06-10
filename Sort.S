.data

.balign 4
	filename: .asciz "fileToBeRead.txt"
.balign 4
	filenameWrite: .asciz "NewWrittenFile.txt"
.balign 4
	readmode: .asciz "r"
.balign 4
	writemode: .asciz "w+"
.balign 4
	filereadpattern: .asciz "\n%d\n"
.balign 4
	scannednum: .skip 4
.balign 4
	readarr: .skip 128
.balign 4
	holder: .skip 4
.balign 4
	return: .word 0
.balign 4
	main_msg: .asciz "Now entering main\n\n"
.balign 4
	main_leave_msg: .asciz "at the bottom of main\n\n"
.balign 4
	debug1_msg: .asciz "Now entering debug1\n\n"
.balign 4
	load_readarray_loop_msg: .asciz "Now entering load_readarray_loop\n\n"
.balign 4
	sort_prep_msg: .asciz "Now entering sort_prep\n\n"
.balign 4
	bubble_sort_outer_loop_msg: .asciz "Now entering bubble_sort_outer_loop\n\n"
.balign 4
	bubble_sort_inner_loop_msg: .asciz "Now entering bubble_sort_inner_loop\n\n"
.balign 4
	check_if_next_num_is_smaller_msg: .asciz "Now entering check_if_next_num_is_smaller\n\n"
.balign 4
	load_write_file_msg: .asciz "Now entering load_write_file\n\n"
.balign 4
	write_file_loop_msg: .asciz "Now entering write_file_loop\n\n"
.balign 4
	close_write_file_msg: .asciz "Now entering close_write_file\n\n"
.balign 4
	end_msg: .asciz "Now entering end\n\n"
.text

.global main

main:
	ldr r3,addr_of_return
	str lr,[r3]
	/*
	push {r0}
	ldr r0,addr_of_main_msg
	bl printf
	pop {r0}
	*/
	ldr r0,addr_of_filename
	ldr r1,addr_of_readmode
	bl fopen
	cmp r0,#0x00
	beq end
	mov r7,r0
	mov r6,#0

	/*	
	push {r0}
	ldr r0,addr_of_main_leave_msg
	bl printf
	pop {r0}

debug1:
	push {r0}
	ldr r0,addr_of_debug1_msg
	bl printf
	pop {r0}
	
	push {r0}
	push {r1}
	push {r2}
	push {r3}
	push {r4}

	ldr r4,addr_of_debug_holder
	mov r3,#0
	str r6,[r4,r3,LSL #2]
	ldr r0,addr_of_filereadpattern
	ldr r1,[r4,r3,LSL #2]
	bl printf

	pop {r0}
	pop {r1}
	pop {r2}
	pop {r3}
	pop {r4}
*/
load_readarray_loop:
	/*
	push {r0}
	ldr r0,addr_of_load_readarray_loop_msg
	bl printf
	pop {r0}
	*/

	mov r0,r7
	ldr r1,addr_of_filereadpattern
	ldr r2,addr_of_scannednum
	bl fscanf
	cmp r0,#1
	bne sort_prep
	
	ldr r0,addr_of_scannednum
	ldr r0,[r0]
	ldr r1,addr_of_readarr
	str r0, [r1,r6,LSL #2]
	mov r4,r1
	ldr r0,addr_of_filereadpattern
	ldr r1,[r4,r6,LSL #2]
//	bl printf
	add r6,r6,#1
	cmp r6,#33
	beq sort_prep
	b load_readarray_loop

sort_prep:
	/*
	push {r0}
	ldr r0,addr_of_sort_prep_msg
	bl printf
	pop {r0}
	*/

	mov r0,r7	
	bl fclose
	mov r4,#-1	//outer loop counter
	mov r5,#0	//inner loop counter
	mov r8,#0	//checked indices counter	
	mov r9,#0	//hold value of the left adjacent index; r5

bubble_sort_outer_loop:
	/*
	push {r0}
	ldr r0,addr_of_bubble_sort_outer_loop_msg
	bl printf
	pop {r0}
	*/

	add r4,r4,#1
	cmp r4,r6
	beq load_write_file
	mov r5,#0
	mov r9,#0	
bubble_sort_inner_loop:
	/*
	push {r0}
	ldr r0,addr_of_bubble_sort_inner_loop_msg
	bl printf
	pop {r0}
	*/

	add r5,r5,#1
	sub r8,r6,r4
//	sub r8,r8,#1
	cmp r5,r8
	beq bubble_sort_outer_loop

check_if_next_num_is_smaller:
	/*
	push {r0}
	ldr r0,addr_of_check_if_next_num_is_smaller_msg
	bl printf
	pop {r0}
	*/	

	ldr r1,addr_of_readarr
	sub r9,r5,#1
	ldr r2,[r1,r9,LSL #2]
	ldr r10,[r1,r5,LSL #2]
	
//	str r2,[r1,r5,LSL #2]
//	str r10,[r1,r9,LSL #2]

/*	push {r0}
	push {r1}
	ldr r0,addr_of_filereadpattern
	mov r1,r2
	bl printf
	ldr r0,addr_of_filereadpattern
	mov r1,r10
	bl printf
	pop {r1}
	pop {r0}
*/	cmp r10,r2	
	ble bubble_sort_inner_loop	//if left value is less than right value, go back to inner
	
	str r2,[r1,r5,LSL #2]
	str r10,[r1,r9,LSL #2]

	/*	
	push {r0}
	ldr r0,addr_of_check_if_next_num_is_smaller_msg
	bl printf
	pop {r0}
	*/	
//	push {r0}
//	push {r4}
//	push {r3}

//	mov r3,#0
//	ldr r4,addr_of_holder	//r4 points to holder address
//	ldr r0,[r1,r5,LSL#2]	//right value into r0
//	str r0,[r4,r3, LSL #2]	//r0 into holder
	
//	ldr r0,[r1,r9,LSL #2]	//left value into r0 
//	str r0,[r1,r5,LSL #2]	//r0 into right value

//	ldr r0,[r4,r3,LSL #2]	//holder into r0
//	str r0,[r1,r9,LSL #2]	//r0 into left value
	
//	pop {r0}
//	pop {r4}
//	pop {r3}

//	push {r0}
//	ldr r0,addr_of_check_if_next_num_is_smaller_msg
//	bl printf
//	pop {r0}

	b bubble_sort_inner_loop

load_write_file:
	/*
	push {r0}
	ldr r0,addr_of_load_write_file_msg
	bl printf
	pop {r0}
	*/

	ldr r4,addr_of_readarr
	ldr r0,addr_of_filenameWrite
	ldr r1,addr_of_writemode
	bl fopen
	mov r7,r0
	mov r5,#0

write_file_loop:
//	push {r0}
//	ldr r0,addr_of_write_file_loop_msg
//	bl printf
//	pop {r0}

//	mov r0,r7
//	push {r0}
//	push {r1}
	ldr r0,addr_of_filereadpattern
	ldr r1,[r4,r5,LSL #2]
	bl printf
//	pop {r1}
//	pop {r0}

//	push {r0}
//	push {r1}
//	push {r2}

//	ldr r0,[r4,r5,LSL #2]
//	ldr r1,addr_of_filenameWrite
//	bl fputc
	ldr r10,addr_of_readarr
	mov r0,r7
	ldr r1,addr_of_filereadpattern
	ldr r2,[r4,r5,LSL #2]
	bl fprintf

//	pop {r2}
//	pop {r1}
//	pop {r0}

//	mov r7,r0
	add r5,r5,#1
	cmp r5,r6
//	beq end	
	beq close_write_file

	b write_file_loop

close_write_file:
	/*
	push {r0}
	ldr r0,addr_of_close_write_file_msg
	bl printf
	pop {r0}
	*/	

//	push {r0}
	mov r0,r7
//	ldr r0,addr_of_filenameWrite
	bl fclose
//	pop {r0}
	
end:	
	/*
	push {r0}
	ldr r0,addr_of_end_msg
	bl printf
	pop {r0}
	*/

	ldr lr, addr_of_return
	ldr lr,[lr]
	bx lr

addr_of_filename: .word filename

addr_of_filenameWrite: .word filenameWrite

addr_of_readmode: .word readmode

addr_of_writemode: .word writemode

addr_of_filereadpattern: .word filereadpattern

addr_of_scannednum: .word scannednum

addr_of_readarr: .word readarr

addr_of_holder: .word holder

//addr_of_debug_holder: .word debug_holder

addr_of_return: .word return

addr_of_main_msg: .word main_msg

addr_of_main_leave_msg: .word main_leave_msg

addr_of_debug1_msg: .word debug1_msg

addr_of_load_readarray_loop_msg: .word load_readarray_loop_msg

addr_of_sort_prep_msg: .word sort_prep_msg

addr_of_bubble_sort_outer_loop_msg: .word bubble_sort_outer_loop_msg

addr_of_bubble_sort_inner_loop_msg: .word bubble_sort_inner_loop_msg

addr_of_check_if_next_num_is_smaller_msg: .word check_if_next_num_is_smaller_msg

addr_of_load_write_file_msg: .word load_write_file_msg

addr_of_write_file_loop_msg: .word write_file_loop_msg

addr_of_close_write_file_msg: .word close_write_file_msg

addr_of_end_msg: .word end_msg

.global fopen
.global fclose
.global fscanf
.global fprintf
.global fprint
.global fputc
