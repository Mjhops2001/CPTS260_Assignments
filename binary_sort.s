.data
    # array initializer: 
    array: .word 5, 10, 15, 20, 25
    arraySize: .word 5

    # string initializers: 
    prompt: .asciiz "Enter search target: "
    target: .asciiz "target: "
    result0: .asciiz "Search Success | Found: "  
    result1: .asciiz "Search Failed | Target: "
    _array: .asciiz "Array Elements: "
    _space: .asciiz " "
    _newline: .asciiz "\n"
    _inputline: .asciiz ">>"
.text 

    .globl main

main: 
    # get search target:
    li $v0, 4
    la $a0, prompt
    syscall

    # newline 
    li $v0, 4
    la $a0, _newline
    syscall

    # >>
    li $v0, 4
    la $a0, _inputline
    syscall

    # grab input and move it into $a0
    li $v0, 5
    syscall
    move $s0, $v0

    # run thru binary search
    jal binary_search

    #newline
    li $v0, 4
    la $a0, _newline
    syscall

    # print array
    jal print_array


    # leap to exit
    j exit

binary_search:
    la $t0, array # get array location
    li $t1, 0 # minimum bounds
    li $t2, 5 # size of array
    addi $t3, $t2, -1 # maximum bounds

    #newline
    li $v0, 4
    la $a0, _newline
    syscall

    #target
    li $v0, 4
    la $a0, target
    syscall

    # actual number target
    li $v0, 1
    move $a0, $s0
    syscall

    #newline
    li $v0, 4
    la $a0, _newline
    syscall

binary_search_loop:
    bgt $t1, $t3, target_not_found	# if $t0 == $t1 then goto target

    #calculate middle index: 
    add $t4, $t1, $t3 # add min & max
    srl $t4, $t4, 1 # divide by 2

    # 
    sll $t6, $t4, 2
    lw $t5, 0($t0)
    addi $t0, $t0, 4

    beq $t5, $s0, target_found # target was found -- end search
    blt $s0, $t5, update_max # target is less than middle index
    bgt $t5, $s0, update_min # target is greater than middle index

# update the current maximum
update_max: 
    addi $t3, $t4, -1
    j binary_search_loop

# update the current minimum
update_min:
    move $t1, $t4
    j binary_search_loop

# target was found 
target_found: 
    li $v0, 4
    la $a0, result0
    syscall

    li $v0, 1
    move $a0, $s0
    syscall

    li $v0, 4
    la $a0, _newline
    syscall

    j end_loop

# target wasn't found
target_not_found: 
    li $v0, 4
    la $a0, result1
    syscall

    li $v0, 1
    move $a0, $s0
    syscall

    li $v0, 4
    la $a0, _newline
    syscall

    j end_loop

end_loop:
   jr $ra


print_array:
    la $t0, array          # Load the base address of the array
    li $t1, 0              # Initialize the iterator (index)
    li $t2, 5              # Size of the array (5 elements)

    # Print array elements header
    li $v0, 4
    la $a0, _array         # Load the string label for "Array Elements: "
    syscall

    # Loop to print each element
print_loop:
    bge $t1, $t2, end_print  # If index >= size, exit loop

    lw $t3, 0($t0)           # Load the element from the array
    li $v0, 1                # Syscall for print integer
    move $a0, $t3            # Move the element into $a0
    syscall                   # Print the integer

    # Print a space after each element
    li $v0, 4
    la $a0, _space           # Load the space string
    syscall

    addi $t0, $t0, 4         # Move to the next element (4 bytes)
    addi $t1, $t1, 1         # Increment the iterator
    j print_loop             # Repeat the loop

end_print:
    # Print newline after the array is printed
    li $v0, 4
    la $a0, _newline         # Load newline string
    syscall

    jr $ra            

exit: 
    li $v0, 10
    syscall