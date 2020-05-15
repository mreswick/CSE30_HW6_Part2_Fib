	.arch armv6
	.cpu cortex-a53
	.text
	.global asm_fib

	.equ 	FP_OFFSET, 12 					//TODO: fill in with appropriate value -> (# of saved regs - 1) * 4
	//TODO: Define more offsets for storing stack variables here
	
	.equ	R4_OFFSET, -8					
	.equ	R0_OFFSET, -12
	.equ	i_OLDER4_OFFSET, -16
	.equ	PAD_OFFSET, -20					// 4 bytes of padding beneath 4 bytes for i
	.equ 	LOCAL_VAR_SPACE, 8				// 4 bytes for i, 4 bytes for padding
	

// TODO: Write fibonacci code here
											// r0 = n, r4 = fib(n - 1)
											// *r0 = r0 on stack, *r4 = r4 on stack;
											// local var i on stack
asm_fib:									// asm_fib(int r0/n)
											// {
		push {r0, r4, fp, lr}				// 	save 4 registers
		add fp, sp, #FP_OFFSET				// 	bring fp to bottom of stack frame
		sub sp, sp, #LOCAL_VAR_SPACE		//	allocate for local vars
											//
		cmp r0, #1							// 	if(r0/n <=1 )
		bgt RECURS							// 	{
		mov r0, #1							//		r0/n = 1;
											//
		add sp, sp, #LOCAL_VAR_SPACE		// 		deallocate local vars
											//
		add sp, sp, #8						// 		deallocate r0/n, r4
		pop {fp, lr}						// 		deallocate/pop rest of stack frame
		bx lr								//		return r0/n;
											//	}
	RECURS:									//	else
											// 	{
		sub r0, r0, #1						//		r0/n = r0/n - 1;
		bl asm_fib							//		fib(r0/n);
											//
		str r0, [fp, #i_OLDER4_OFFSET]		// 		i = r0/n;
		ldr r0, [fp, #R0_OFFSET]			// 		r0/n = *r0 (what it was before fib(n-1) call)
											//				
		sub r0, r0, #2						//		r0/n = r0/n - 2;
		bl asm_fib							//		fib(r0/n);
											//
		ldr r4, [fp, #i_OLDER4_OFFSET]		// 		r4 = i;
		add r0, r0, r4						// 		r0/n = r4/fib(n-1) + r0/fib2(n - 2)
		add sp, sp, #LOCAL_VAR_SPACE		// 		deallocate local vars
		ldr r4, [fp, #R4_OFFSET]			// 		restore r4 for caller
		add sp, sp, #8						// 		deallocate r0/n, r4
		pop {fp, lr}						//		deallocate/pop rest of stack frame
											//	
		bx lr								// 		return r0/n;
	END:									// }
