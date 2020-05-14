	.arch armv6
	.cpu cortex-a53
	.text
	.global asm_fib

	.equ 	FP_OFFSET, 12 //TODO: fill in with appropriate value -> (# of saved regs - 1) * 4
	//TODO: Define more offsets for storing stack variables here
	
	.equ	R4_OFFSET, -8

// TODO: Write fibonacci code here

asm_fib:

		push {r0, r4, fp, lr}
		add fp, sp, #FP_OFFSET
		
		cmp r0, #1
		bgt RECURS
		mov r0, #1
		
		add sp, sp, #8		// get rid of r0 and r1 in memory
		pop {fp, lr}		// really just want to pop fp, but need to pass an even number of registers
		bx lr
		
	RECURS:
		
		sub r0, r0, #1
		bl asm_fib
		
		str r0, [fp, #R4_OFFSET]	// save returned value of first call to fib() in R1 (fp holds base address of lr)
		pop {r0, r4, fp, lr}			// r0 now what it was before 1st fib() call, and r1 holds return val of 1st fib() call
		
		sub r0, r0, #2
		bl asm_fib
		
		ldr r4, [fp, #R4_OFFSET]	// get return val in r1 after 1st call to fib()
		add r0, r0, r4				// r0 = fib1() + fib2() // (r0 in sum holds return val after 2nd call to fib())
		add sp, sp, #8				// get rid of r0 and r1 in memory (without changing r0, which currently holds needed return value)
		pop {fp, lr}				// de-allocate the rest of it
		bx lr						// return
