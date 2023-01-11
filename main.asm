##############################################################
#Dynamic array
##############################################################
#   4 Bytes - Capacity
#	4 Bytes - Size
#   4 Bytes - Address of the Elements
##############################################################

##############################################################
#Song
##############################################################
#   4 Bytes - Address of the Name (name itself is 64 bytes)
#   4 Bytes - Duration
##############################################################


.data
space: .asciiz " "
newLine: .asciiz "\n"
tab: .asciiz "\t"
menu: .asciiz "\n● To add a song to the list-> \t\t enter 1\n● To delete a song from the list-> \t enter 2\n● To list all the songs-> \t\t enter 3\n● To exit-> \t\t\t enter 4\n"
menuWarn: .asciiz "Please enter a valid input!\n"
name: .asciiz "Enter the name of the song: "
duration: .asciiz "Enter the duration: "
name2: .asciiz "Song name: "
duration2: .asciiz "Song duration: "
emptyList: .asciiz "List is empty!\n"
noSong: .asciiz "\nSong not found!\n"
songAdded: .asciiz "\nSong added.\n"
songDeleted: .asciiz "\nSong deleted.\n"

copmStr: .space 64

sReg: .word 3, 7, 1, 2, 9, 4, 6, 5
songListAddress: .word 0 #the address of the song list stored here!

.text 
main:

	jal initDynamicArray
	sw $v0, songListAddress
	
	la $t0, sReg
	lw $s0, 0($t0)
	lw $s1, 4($t0)
	lw $s2, 8($t0)
	lw $s3, 12($t0)
	lw $s4, 16($t0)
	lw $s5, 20($t0)
	lw $s6, 24($t0)
	lw $s7, 28($t0)

menuStart:
	la $a0, menu    
    li $v0, 4
    syscall

	li $v0,  5
    syscall
	li $t0, 1
	beq $v0, $t0, addSong
	li $t0, 2
	beq $v0, $t0, deleteSong
	li $t0, 3
	beq $v0, $t0, listSongs
	li $t0, 4
	beq $v0, $t0, terminate
	
	la $a0, menuWarn    
    li $v0, 4
    syscall
	b menuStart
	
addSong:
	jal createSong
	lw $a0, songListAddress
	move $a1, $v0
	jal putElement
	b menuStart
	
deleteSong:
	lw $a0, songListAddress
	jal findSong
	lw $a0, songListAddress
	move $a1, $v0
	jal removeElement
	b menuStart
	
listSongs:
	lw $a0, songListAddress
	jal listElements
	b menuStart
	
terminate:
	la $a0, newLine		
	li $v0, 4
	syscall
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	move $a0, $s1
	syscall
	move $a0, $s2
	syscall
	move $a0, $s3
	syscall
	move $a0, $s4
	syscall
	move $a0, $s5
	syscall
	move $a0, $s6
	syscall
	move $a0, $s7
	syscall
	
	li $v0, 10
	syscall


initDynamicArray:
	li $t0, 2 # capacity
	li $t1, 0 # size

	# elements heap
	li $v0, 9 
	li $a0, 8 
	syscall
	move $t2, $v0

	# dynamic array
	li $v0, 9
	li $a0, 12
	syscall

	sw $t0, 0($v0)
	sw $t1, 4($v0)
	sw $t2, 8($v0)	
	jr $ra


putElement:
    move $t0, $a0 # address of the dynamic array
    move $t1, $a1 # address of the song

    lw $t2, 0($t0) # capacity
    lw $t3, 4($t0) # size
    lw $t4, 8($t0) # address of elements array

	addi $t5, $t3, 1 
	beq $t5, $t2, reached 
    
	notReached:
        sll $t5, $t3, 2
        add $t5, $t4, $t5

        sw $a1, 0($t5) # address of the song saved

		addi $t3, $t3, 1
		sw $t3, 4($t0)

		j exitNotReached
    
    reached:
		# initialize new capacity
		# capacity * 2 * 2 * 2 (byte addressing multiplies 4)
		sll $t5, $t2, 3 

		li $v0, 9 
		move $a0, $t5
		syscall

		sll $t5, $t2, 1 # new capacity in decimal
		li $t6, 0 # i
        zeroLoop: # assign zero to all elements
			slt $t7, $t6, $t5 # i < capacity(new one)
			beq $t7, $zero, initializer

			sll $t7, $t6, 2
			add $t7, $t7, $v0
			sw $zero, 0($v0)
			addi $t6, $t6, 1
			j zeroLoop
		
		initializer:
			li $t6, 0 # i
			exitZeroLoop:
				# $t4 old address of elements array
				# $v0 new address of elements array
				# $t2 old capacity
				slt $t7, $t6, $t2 # i < capacity(old one)
				beq $t7, $zero, exitReached
				
				sll $t7, $t6, 2   # i * 2
				add $t8, $t7, $t4 # old address + i * 2			
				lw $t8, 0($t8) # load

				add $t7, $t7, $v0 # new adress + i * 2
				sw $t8, 0($t7) # save
				addi $t6, $t6, 1
				j exitZeroLoop

	exitNotReached:	
		li $v0, 4
		la $a0, songAdded
		syscall
		jr $ra

	exitReached:
		sw $v0, 8($t0)
		sw $t5, 0($t0)
		
		sll $t5, $t3, 2 	
        add $t5, $v0, $t5

        sw $a1, 0($t5) # address of the song saved

		addi $t3, $t3, 1
		sw $t3, 4($t0)
		
		li $v0, 4
		la $a0, songAdded
		syscall

		jr $ra



removeElement:
	# $a0 dynamic array address
	# $a1 song index
	bne $a1, -1, checkCapacity

	li $v0, 4
	la $a0, noSong
	syscall

	jr $ra

    checkCapacity:
    lw $t0, 0($a0) # capacity
    lw $t1, 4($a0) # size
    lw $t2, 8($a0) # elements address

    beq $t0, 2, noDropDown
    # Capacity > 2
    # Decide to dropdown or dont

    srl $t3, $t0, 1
    sub $t3, $t3, 1 # (capacity / 2) - 1

    sub $t4, $t1, 1 # size - 1
    beq $t4, $t3, dropDown

    noDropDown:
        # Delete element
        sll $t3, $a1, 2
        add $t3, $t3, $t2
        sw $zero 0($t3)

        # Shift elements
        move $t3, $a1
        shiftLoop:
            slt $t4, $t3, $t1
            beq $t4, $zero, shiftLoopExit

            addi $t4, $t3, 1
            sll $t4, $t4, 2
            add $t4, $t4, $t2
            lw $t4, 0($t4)

            sll $t5, $t3, 2
            add $t5, $t5, $t2
            sw $t4, 0($t5)

            addi $t3, $t3, 1
            j shiftLoop


        # Save new size
        shiftLoopExit:
        sub $t1, $t1, 1
        sw $t1, 4($a0)

        li $v0, 4
        la $a0, songDeleted
        syscall

        jr $ra

    dropDown:
        # Delete element
        sll $t3, $a1, 2
        add $t3, $t3, $t2
        sw $zero 0($t3)

        # Shift elements
        move $t3, $a1
        shiftLoopDropDown:
            slt $t4, $t3, $t1
            beq $t4, $zero, shiftLoopExit

            addi $t4, $t3, 1
            sll $t4, $t4, 2
            add $t4, $t4, $t2
            lw $t4, 0($t4)

            sll $t5, $t3, 2
            add $t5, $t5, $t2
            sw $t4, 0($t5)

            addi $t3, $t3, 1
            j shiftLoopDropDown

        # Create new heap
        # $t0 capacity
        # $t1 size
        # $t2 elements address

        move $t3, $a0       # dynamic array address
        srl $t4, $t0, 1

        li $v0, 9
        move $a0, $t4
        syscall

        # Copy elements from old to new
        sub $t4, $t1, 1
        li $t5, 0
        copyLoop:
            slt $t6, $t5, $t4
            beq $t6, $zero, copyExit

            sll $t6, $t5, 2     # i * 4
            add $t7, $t6, $t2   
            lw $t7, 0($t7)

            add $t8, $t6, $v0
            sw $t7, 0($t8)
            
            addi $t5, $t5, 1
            j copyLoop

        # Save size, capacity, heap address
        copyExit:
        sub $t4, $t1, 1
        sw $t4, 0($t3)

        srl $t4, $t0, 1
        sw $t4, 4($t3)

        sw $v0, 8($t3)

        li $v0, 4
        la $a0, songDeleted
        syscall

        jr $ra



listElements:
	sub $sp, $sp, 4 # we will call subroutine
	sw $ra, 0($sp)

	lw $t0, 4($a0) # size
	lw $t1, 8($a0) # address of elements
	
	beq $t0, $zero, emptyCase

	li $t2, 0
	loopListElements:
		slt $t3, $t2, $t0
		beq $t3, $zero, exitListElements
		
		sll $t3, $t2, 2
		add $t3, $t3, $t1   # offset + address of elements 
		lw $t3, 0($t3) 		# address of the song
		
		move $a0, $t3
		jal printElement

		addi $t2, $t2, 1
		j loopListElements


	emptyCase:
		li $v0, 4 
		la $a0, emptyList
		syscall
	
	exitListElements:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra


compareString:
	li $t5, 0

    compareLoop:
        slt $t6, $t5, $a2
        beq $t6, $zero, equal

        add $t6, $t5, $a0
        lb $t6, 0($t6)

        add $t7, $t5, $a1
        lb $t7, 0($t7)

        bne $t7, $t6, notEqual
        addi $t5, $t5, 1
        j compareLoop
    
    equal:
        li $v0, 1
        jr $ra

    notEqual:
        li $v0, 0
        jr $ra
	
	
printElement:
	sub $sp, $sp, 8 # we will call subroutine
	sw $ra, 0($sp)
	sw $a0, 4($sp)

	jal printSong

	lw $ra, 0($sp)
	lw $v0, 4($sp)
	addi $sp, $sp, 8
	jr $ra

createSong:
	li $v0,9
    li $a0,8
    syscall
    
    move $t0, $v0  # song address "name add + duration"

    li $v0,9
    li $a0,64
    syscall
    
    move $t1, $v0  # heap for name

    la $a0, name    # Load and print string asking for string
    li $v0, 4
    syscall

    li $v0, 8       # take in input
    move $a0, $t1   
    li $a1, 64      
    syscall

    sw $t1, 0($t0)
    
    la $a0, duration    # Load and print string asking for string
    li $v0, 4
    syscall

    li $v0,5
    syscall

    sw $v0, 4($t0)
	move $v0, $t0
	jr $ra


findSong:
    sub $sp, $sp, 4
    sw $ra, 0($sp)

	move $t0, $a0 # address of the dynamic array

    li $v0, 4
    la $a0, name    # Load and print string asking for string
    syscall

	li $v0, 8       # take in input
    la $a0, copmStr  # load byte space into address
    li $a1, 64      # allot the byte space for string
    syscall
	
	la $t1, copmStr
    move $a0, $t1
    li $a2, 64

    lw $t2, 4($t0) # size
    lw $t3, 8($t0) # elements address
    li $t4, 0
    findLoop:
        slt $t5, $t4, $t2
        beq $t5, $zero, findLoopExit

        sll $t5, $t4, 2
        add $t5, $t5, $t3

        lw $t5, 0($t5) # song
        lw $t5, 0($t5) # name

        move $a1, $t5
        jal compareString

        beq $v0, 1, found
        addi $t4, $t4, 1
        j findLoop
    
    findLoopExit:
        li $v0, -1

        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra

    found:
        move $v0, $t4

        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra


	

printSong:
    move $t7, $a0
	
	li $v0, 4
    la $a0, newLine
    syscall

    li $v0, 4
    la $a0, name2
    syscall

    li $v0, 4
    lw $a0, 0($t7)
    syscall

    
    li $v0, 4
    la $a0, duration2
    syscall

    li $v0, 1
    lw $a0, 4($t7)
    syscall

	jr $ra

additionalSubroutines: