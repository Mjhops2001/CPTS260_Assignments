.data
    result: .word 0        # Memory location to store the result

.text
    .globl main

main:
    li $a0, 30             # Change this value to compute Fibonacci for n
    jal fibonacci          # Call the Fibonacci function
    sw $v0, result         # Store the result in the result variable
    # Exit program
    li $v0, 10             # syscall code for exit
    syscall

# Fibonacci function
fibonacci:
    # Base case: if n == 0
    beq $a0, $zero, fib_zero

    # Base case: if n == 1
    li $t0, 1              # Load immediate value 1
    beq $a0, $t0, fib_one

    # Recursive case: n > 1
    # Store the current n
    addi $sp, $sp, -8      # Make space on the stack
    sw $a0, 4($sp)        # Save n on stack

    # Calculate fibonacci(n - 1)
    addi $a0, $a0, -1      # n - 1
    jal fibonacci          # Recursive call
    move $t1, $v0          # Store fibonacci(n - 1) in $t1

    # Load n back from stack
    lw $a0, 4($sp)         # Load n from stack
    addi $a0, $a0, -2      # n - 2
    jal fibonacci          # Recursive call

    # Add fibonacci(n - 1) and fibonacci(n - 2)
    add $v0, $v0, $t1      # $v0 = fibonacci(n) = fibonacci(n - 1) + fibonacci(n - 2)

    # Clean up the stack
    addi $sp, $sp, 8       # Free stack space
    jr $ra                  # Return to the caller

fib_zero:
    li $v0, 0              # Return 0 for fibonacci(0)
    jr $ra                  # Return to the caller

fib_one:
    li $v0, 1              # Return 1 for fibonacci(1)
    jr $ra                  # Return to the caller