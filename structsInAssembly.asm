

																		//create strings to be printed out
prnt_initial:		.string "Initial pyramid values:\n"
prnt_pyramid:		.string "Pyramid %s\n\tCenter = (%d, %d)\n\tBase width = %d Base length = %d\n\tHeight = %d\n\tVolume = %d\n\n"
prnt_new:			.string "\nNew pyramid values:\n"
prnt_khafre:		.string "khafre"
prnt_cheops:		.string "cheops"

					fp .req x29											//use register equate to define fp
					lr .req x30											//use register equate to define lr

					FALSE = 0											//define the FALSE constant
					TRUE = 1											//define the TRUE constant

																		//define offsets for coord struct attributes
					rec_x = 0											//offset for the x attribute
					rec_y = 4											//offset for the y attribute

																		//define offsets for size struct attributes
					rec_width = 0										//offset for the width attribute
					rec_length = 4										//offset for the height attribute

																		//define offsets for the pyramid struct attributes
					rec_center = 0										//offset for the center attribute
					rec_center_x = rec_center + rec_x					//offset for the center.x attribute
					rec_center_y = rec_center + rec_y					//offset for the center.y attribute
					rec_base = 8										//offset for the base attribute
					rec_base_width = rec_base + rec_width				//offset for the base.width attribute
					rec_base_length = rec_base + rec_length				//offset for the base.length attribute
					rec_height = 16										//offset for the height attribute
					rec_volume = 20										//offset for the volume attribute

																		//define sizes of local variables in main
					khafre_size = 24									//define size of the khafre pyramid struct instance
					cheops_size = 24									//define size of the cheops pyramid struct instance

					alloc = -(16 + khafre_size + cheops_size) & -16		//define the amount of memory to allocate for the frame record and local variables
					dealloc = -alloc									//define the amount of memory to deallocate on return from the main function

					khafre_s = 16										//memory offset from the fp to reach the khafre pyramid struct instance
					cheops_s = 16 + khafre_size							//memory offset from the fp to reach the cheops pyramid struct instance

					.balign 4											//alligns the instructions we write to make sure they are divisible by 4
					.global main										//pseudo op which sets the start label to main, it will make sure that the main label is picked by the linker

																		//main function starts here
main:				stp	fp, lr, [sp, alloc]!							//creates a frame record and allocates memory for our local variables on the stack
					mov	fp, sp											//moves the fp to the current sp location

																		//create the khafre pyramid object
					add	x8, fp, khafre_s								//set the indirect result location register to the address of kharfe pyramid object
					mov	w0, 10											//set the 1st word length argument to 10
					mov	w1, 10											//set the 2nd word length argument to 10
					mov	w2, 9											//set the 3rd word length argument to 9
					bl	newPyramid										//branch and link to a function that initializes a pyramid struct with passed values

																		//create the cheops pyramid object
					add	x8, fp, cheops_s								//set the indirect result location register to the address of cheops pyramid object
					mov	w0, 15											//set the 1st word length argument to 15
					mov	w1, 15											//set the 2nd word length argument to 15
					mov	w2, 18											//set the 3rd word length argument to 18
					bl	newPyramid										//branch and link to a function that initializes a pyramid struct with passed values
bp1:																	//label for break point 1

																		//print the initiali pyramid values
					adrp	x0, prnt_initial							//set the first argument to address of the prnt_initial string
					add	x0, x0, :lo12:prnt_initial						//complete the address location of the x0 register
					bl	printf											//branch and link to the standard library printf function

																		//print the initial values of the khafre pyramid struct
					adrp	x0, prnt_khafre								//set the first argument to address of the prnt_khafre string
					add	x0, x0, :lo12:prnt_khafre						//complete the address location of the x0 register
					add	x1, fp, khafre_s								//set the second argument to the address of the kharfe struct start
					bl	printPyramid									//branch and link to the printPyramid function

																		//print the initial values of the cheops pyramid struct
					adrp	x0, prnt_cheops								//set the first argument to address of the prnt_cheops string
					add	x0, x0, :lo12:prnt_cheops						//complete the address location of the x0 register
					add	x1, fp, cheops_s								//set the second argument to the address of the cheops struct start
					bl	printPyramid									//branch and link to the printPyramid function

																		//compare pyramid sizes with equalSize function
					add	x0, fp, khafre_s								//set the first argument to address of p1
					add	x1, fp, cheops_s								//set the second argument to address of p2
					bl	equalSize										//branch and link to the equalSize function

					cmp	w0, 1											//check if w0 = 1
					b.eq	print_new									//goto print_new label

																		//expand and relocate if needed
																		//expand the cheops pyramid
					add	x0, fp, cheops_s								//store the address of cheops pyramid struct in x0
					mov	w1, 9											//store the value 9 in the 2nd word length argument register
					bl	expand											//branch and link to the expand function
bp2:																	//label for break point 2

																		//relocate the cheops pyramid
					add	x0, fp, cheops_s								//store the address of cheops pyramid struct in x0
					mov	w1, 27											//store the value 27 in the 2nd word length argument register
					mov	w2, -10											//store the value -10 in the 3rd word length artument register
					bl	relocate										//branch and link to the relocate function

																		//relocate the khafre pyramid
					add	x0, fp, khafre_s								//store the address of khafre pyramid struct in x0
					mov	w1, -23											//store the value -23 in the 2nd word length argument register
					mov	w2, 17											//store the value 17 in the 3rd word length argument register
					bl	relocate										//branch and link to the relocate function
bp3:																	//label for break point 3

																		//print new pyramid values
print_new:			adrp	x0, prnt_new								//set the first argument to address of the prnt_new string
					add	x0, x0, :lo12:prnt_new							//complete the address locatin of the x0 register
					bl	printf											//branch and link to the standard library printf function

																		//print the values of the khafre pyramid struct
					adrp	x0, prnt_khafre								//set the first argument to address of the prnt_khafre string
					add	x0, x0, :lo12:prnt_khafre						//complete the address location of the x0 register
					add	x1, fp, khafre_s								//set the second argument to the address of the khafre struct start
					bl	printPyramid									//pranch and link to the printPyramid function

																		//print the values of the cheops pyramid struct
					adrp	x0, prnt_cheops								//set the first argument to address of the prnt_cheops string
					add	x0, x0, :lo12:prnt_cheops						//complete the addresss location of the x0 register
					add	x1, fp, cheops_s								//set the secong argument to the address of the cheops struct start
					bl	printPyramid									//branch and link to the printPyramid function

end_of_main:		ldp	fp, lr, [sp], dealloc 							//we end main by deallocation of stack memory
					ret													//return control to the calling code

																		//the newPyramid function starts here
					define(p_base_r, x9)								//create a macro for register x9 to be p_base_r
					p_size = 24											//define the size of struct p
					alloc = -(16 + p_size) & -16						//define the amount of stack memory to allocate for the frame record and local variables
					dealloc = -alloc									//define the amount of stack memory to deallocate on returm from the main function
					p_s = 16											//define the momeory offset from fp to reach the p struct

newPyramid:			stp	fp, lr, [sp, alloc]!							//creates a frame record and allocates memory for our local variables on the stack for the newPyramid function
					mov	fp, sp											//moves the fp to the current sp location

					add 	p_base_r, fp, p_s							//calculate the p struct base address

					str	wzr, [p_base_r, rec_center_x]					//p.center.x = 0
					str	wzr, [p_base_r, rec_center_y]					//p.center.y = 0
					str	w0, [p_base_r, rec_base_width]					//p.base.width = width
					str	w1, [p_base_r, rec_base_length]					//p.base.length = length
					str	w2, [p_base_r, rec_height]						//p.height = height
																		//compute the volume
					mov	w10, 3											//w10 = 3
					mul	w0, w0, w1										//w0 = width*length
					mul	w0, w0, w2										//w0 = width*length*height
					udiv	w10, w0, w10								//w10 = width*length*height/3
					str	w10, [p_base_r, rec_volume]						//p.volume = w10

					ldr	w10, [p_base_r, rec_center_x]					//load x coordinate to register w10
					str	w10, [x8, rec_center_x]							//store the x coordinate to the pyramid struct referenced by the x8 register
					ldr	w10, [p_base_r, rec_center_y]					//load the y coordinate to register w10
					str	w10, [x8, rec_center_y]							//store the y coordinate to the pyramid struct referenced by the x8 register
					ldr	w10, [p_base_r, rec_base_width]					//load width to register w10
					str	w10, [x8, rec_base_width]						//store the width to the pyramid struct referenced by the x8 register
					ldr	w10, [p_base_r, rec_base_length]				//load length to register w10
					str	w10, [x8, rec_base_length]						//store the length to the pyramid struct referenced by the x8 register
					ldr	w10, [p_base_r, rec_height]						//load height to register w10
					str	w10, [x8, rec_height]							//store the height to the pyramid struct referenced by the x8 register
					ldr	w10, [p_base_r, rec_volume]						//load volume to register w10
					str	w10, [x8, rec_volume]							//store the volume to the pyramid struct referenced by the x8 register

					ldp	fp, lr, [sp], dealloc							//we end newPyramid function by deallocation of stack memory
					ret													//return control to the calling code

																		//the printPyramid function starts here
printPyramid:		stp	fp, lr, [sp, -16]!								//create a frame record on the stack
					mov	fp, sp											//move fp to the current sp location

					mov	x9, x0											//store the address of the pyramid's name string in register x9
					mov	x10, x1											//store the address of the passed pyramid in register x10

					adrp	x0, prnt_pyramid							//set the first argument to address of the prnt_pyramid string
					add	x0, x0, :lo12:prnt_pyramid						//complete the address location of the x0 register
					mov	x1, x9											//store the address of the pyramid's name string in register x1
					ldr	w2, [x10, rec_center_x]							//store the center.x attribute in register w2
					ldr	w3, [x10, rec_center_y]							//store the center.y attribute in register w3
					ldr	w4, [x10, rec_base_width]						//store the base.width attribute in register w4
					ldr	w5, [x10, rec_base_length]						//store the base.length attribute in register w5
					ldr	w6, [x10, rec_height]							//store the height attribute in register w6
					ldr	w7, [x10, rec_volume]							//store the volume attribute in register w7
					bl	printf

					ldp	fp, lr, [sp], 16								//restores the state of the fp and lr registers to the state before this function was called
					ret													//returns control to the calling code

																		//the relocate function starts here
relocate:			stp	fp, lr, [sp, -16]!								//create a frame record on the stack
					mov	fp, sp											//move fp to the current sp location

																		//first we shift the x coordinate
					ldr	w10, [x0, rec_center_x]							//w10 = p->center.x
					add	w10, w10, w1									//w10 = p->center.x + deltaX
					str	w10, [x0, rec_center_x]							//p->center.x = p->center.x + deltaX

																		//next we shift the y coordinate
					ldr	w10, [x0, rec_center_y]							//w10 = p->center.y
					add	w10, w10, w2									//w10 = p->center.y + deltaY
					str	w10, [x0, rec_center_y]							//p->center.y = p->center.y + deltaY

					ldp	fp, lr, [sp], 16								//restores the state of the fp and lr registers to the state before this function was called
					ret													//returns control to the calling code

																		//the expand function starts here
expand:				stp	fp, lr, [sp, -16]!								//create a frame record of the stack
					mov	fp, sp											//move fp to the current sp location

					ldr	w9, [x0, rec_base_width]						//w9 = p->base.width
					mul	w9, w9, w1										//w9 = p->base.width * factor
					str	w9, [x0, rec_base_width]						//p->base.width = p->base.width * factor

					ldr	w10, [x0, rec_base_length]						//w10 = p->base.length
					mul	w10, w10, w1									//w10 = p->base.length * factor
					str	w10, [x0, rec_base_length]						//p->base.length = p->base.length * factor

					ldr	w11, [x0, rec_height]							//w11 = p->height
					mul	w11, w11, w1									//w11 = p->height * factor
					str	w11, [x0, rec_height]							//p->height = p->height * factor

					mul	w9, w9, w10										//w9 = p->base.width * p->base.length
					mul 	w9, w9, w11									//w9 = p->base.width * p->base.length * p->height
					mov	w10, 3											//w10 = 3
					udiv	w9, w9, w10									//w9 = (p->base.width * p->base.length * p->height)/3
					str	w9, [x0, rec_volume]							//p->volume = (p->base.width * p->base.length * p->height)/3

					ldp	fp, lr, [sp], 16								//restores the state of the fp and lr registers to the state berofe this function was called
					ret													//returns control to the calling code

																		//the equalSize function starts here
equalSize:			stp	fp, lr, [sp, -16]!								//creat a frame record of the stack
					mov	fp, sp											//move fp to the current sp location

					ldr	w9, [x0, rec_base_width]						//w9 = p1->base.width
					ldr	w10, [x1, rec_base_width]						//w10 = p2->base.width
					cmp	w9, w10											//p1->base.width == p2->base.width
					b.ne	equalSize_false								//branch to equalSize_false label if p1->base.width != p2->base.width

					ldr	w9, [x0, rec_base_length]						//w9 = p1->base.length
					ldr	w10, [x1, rec_base_length]						//w10 = p2->base.length
					cmp	w9, w10											//p1->base.length == p2->base.length
					b.ne	equalSize_false								//branch to equalSize_false label if p1->base.length != p2->base.length

					ldr	w9, [x0, rec_height]							//w9 = p1->height
					ldr	w10, [x1, rec_height]							//w10 = p2->height
					cmp	w9, w10											//p1->height == p2->height
					b.ne	equalSize_false								//branch to equalSize_false label if p1->height != p2->height

					mov	w0, TRUE										//set w0 to TRUE
					b	equalSize_exit									//go to the equalSize_exit label

equalSize_false:	mov	w0, FALSE										//w0 = FALSE

equalSize_exit:		ldp	fp, lr, [sp], 16								//restores the state of the fp and lr registers to the state before this function was called
					ret													//returns control to the calling code
