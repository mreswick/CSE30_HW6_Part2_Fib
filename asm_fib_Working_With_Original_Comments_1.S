	.arch armv6
	.cpu cortex-a53
	.text
	.global asm_fib

	.equ 	FP_OFFSET, 12 //TODO: fill in with appropriate value -> (# of saved regs - 1) * 4
	//TODO: Define more offsets for storing stack variables here
	
	.equ	R4_OFFSET, -8
	.equ	R0_OFFSET, -12
	.equ	i_OLDER4_OFFSET, -16
	.equ	PAD_OFFSET, -20
	.equ 	LOCAL_VAR_SPACE, 8		// 4 bytes for i, 4 bytes for padding
	

// TODO: Write fibonacci code here

asm_fib:
		push {r0, r4, fp, lr}
		add fp, sp, #FP_OFFSET
		
		sub sp, sp, #LOCAL_VAR_SPACE
		
		cmp r0, #1
		bgt RECURS
		mov r0, #1
		
		add sp, sp, #LOCAL_VAR_SPACE	// deallocate local variables (i and padding space)
		
		add sp, sp, #8		// get rid of r0 and r4 in memory
		pop {fp, lr}		// really just want to pop fp, but need to pass an even number of registers
		bx lr
		
	RECURS:
		
		sub r0, r0, #1
		bl asm_fib
		
		str r0, [fp, #i_OLDER4_OFFSET]	// save returned value of first call to fib() in R4 (fp holds base address of lr)
		// pop {r0, r4, fp, lr}			// r0 now what it was before 1st fib() call, and r4 holds return val of 1st fib() call
		ldr r0, [fp, #R0_OFFSET]		// r0 now what it was before 1st fib() call
	/*?*/	ldr r4, [fp, #i_OLDER4_OFFSET]		// r4 now holds return value of 1st fib() call
		
		
		sub r0, r0, #2
		bl asm_fib
		
		ldr r4, [fp, #i_OLDER4_OFFSET]	// get return val in r1 after 1st call to fib()
		add r0, r0, r4				// r0 = fib1() + fib2() // (r0 in sum holds return val after 2nd call to fib())
		add sp, sp, #LOCAL_VAR_SPACE		// get rid of i and padding space
		ldr r4, [fp, #R4_OFFSET]	// load R4 back to what it was in caller
		add sp, sp, #8				// get rid of r0 and r4 in memory (without changing r0, which currently holds needed return value)
		pop {fp, lr}				// de-allocate the rest of it
		
		bx lr						// return
	END:
