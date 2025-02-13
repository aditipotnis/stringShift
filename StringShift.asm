.data
	buffer1: .space 31
	buffer2: .space 31
	shiftAmount: .space 9
	start: .asciiz "Input a string 30 characters or less: "
	shiftPrompt: .asciiz "Input an integer greater than 0: "
	answer: .asciiz "Shifted String = "
	errorString: .asciiz "No input. Run again."
	.align 2
	errorInt: .asciiz "Wrong input. Run again"
	.align 2
	newLine: .ascii "\n"
	.align 2
	openBracket: .ascii "["
	.align 2
	closeBracket: .ascii "]"


.text
.globl main 
	main:
		la $a0, start #load start into a0
		li $v0, 4  #to print
    		syscall
    		
    		li $v0, 8  #change to read mode to take user input

    		la $a0, buffer1 
    		li $a1, 32  
    		syscall
    
    	    	lw $t0, newLine	#load the newline character into t0
    		lw $t1, buffer1	#load the input from user into t1
    		
    		beq $t0, $t1, exitString  #case for if the input is newline character 
    		
    		la $a0, shiftPrompt #load shiftPrompt into a0
		li $v0, 4	#print string at a0
    		syscall
    		
    		li $v0, 8  #set mode to read string
    		la $a0, shiftAmount
    		li $a1, 9
    		syscall   #store the user input in $v0
    		
    		la $s1, shiftAmount
    		
    	goToEndOfShiftString:
    		addi $s1, $s1, 1  #increment address to move to next character in string
    		lb $s0, 0($s1)  #load character from string in s0 register
    		beq $s0, $t0, continue  #if there is a newline character exit loop
    		bne $s0, $0, goToEndOfShiftString  #continue iterating through loop until end of string
    	
    	continue:
    		la $s2, shiftAmount #load shift amount into s2 register
    		li $s3, 1  #initialize counters
    		li $t2, 0
    		
    	toInt:
    		subi $s1, $s1, 1 #move backward through the string
    		lb $s0, 0($s1) #load character at cur address into s0
    		subi $s0, $s0, 48 #convert to integer value
    		blt $s0, $0, exitInt  #if value less than 0 exit loop
    		mult $s0, $s3  
    		mflo $t4
    		add $t2, $t2, $t4  #holds integer values of digits 
    		li $t4, 10
    		mult $s3, $t4
    		mflo $s3
    		bgt $s1, $s2, toInt  #looping
    		ble $t2, $0, exitInt #if our shift number is less than or equal to 0 then we exit program
    		li $s7, -1 #init length counter into s7. account for newline character
    		
    	findLengthInputStr: #{
    	    	addi $s7, $s7, 1  #increment counter
    	    	la $s1, buffer1   #find base address of array and load into buffer1
    	    	add $s1, $s1, $s7 #add current legnth to offset address
    	    	lb $s2, 0($s1) 	  #load the current char into s2 by indexing the offset we had last time.
    		bne $s2, $t0, findLengthInputStr #looping
    		div $t2, $s7  
    		mfhi $t2  
    		sub $t2, $s7, $t2	
   		li $s0, 0  #start index counter 
   		
    	shiftingProcess: 	
		la $s1, buffer1   #load base address of buffer1 into s1
    	    	add $s1, $s1, $s0  #move address to next char in original string
    	    	lb $s2, 0($s1) 	   #load byte at s1 address into s2
   
    		add $t3, $s0, $t2  #target index for shifted char
    		div $t3, $s7		
    		mfhi $t4 	#remainder new index after shifting
    		
      		la $s3, buffer2   #load base address of shifted string into s3
      		
		add $s3, $s3, $t4   #add the calulated target index to the address in s3
    	    	sb $s2, 0($s3)	  #store current char from original string into buffer2 at calculated address
		
		addi $s0, $s0, 1   #increment 	
		blt $s0, $s7, shiftingProcess	#loop back to shifting if index counter <= length of string

		la $a0, answer 	
		li $v0, 4  #print string at a0
    		syscall
    		    
    		la $a0, openBracket   #add left bracket to output
		li $v0, 4	#print string
    		syscall	
		
		la $a0, buffer2   #load base address of buffer2 into a0
		li $v0, 4	#to print
    		syscall
    		
    		la $a0, closeBracket   #add the right bracket
		li $v0, 4	
    		syscall	
    		    		
		li $v0, 10 
		syscall
    		
    	exitString:
    		la $a0, errorString 
		li $v0, 4	
    		syscall
    		
		li $v0, 10 
		syscall
		    		
    	exitInt:
    		la $a0, errorInt 
		li $v0, 4	
    		syscall
    		
		li $v0, 10 
		syscall
