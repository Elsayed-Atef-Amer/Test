   .MODEL SMALL
 .STACK 100H
.code


;void QuickSort(void *pArray, int nItems);
QuickSort PROC

    ;These registers must be restored at the end
    push BP
    mov BP, SP
    push BX
    push SI
    push DI
   
    ;BP + 8    is the array
    ;BP + 12   is the number of items in the array
   
    mov SI, [BP+8]    ;ESI is the array
   
    ;setting CX to the number of items
    ;we multiply by 4 (size of the element) in order to put CX
    ;at the last address of the array
    mov AX, [BP+12]
    mov CX, 4
    mul CX
    mov CX, AX
   
    ;AX will be our 'low index', we initially set it to 0
    xor AX, AX
   
    ;BX will be our 'high index', we initially set it to
    ;the last element of the array (currently stored in CX)
    mov BX, CX
   
    ;We now call our recursive function that will sort the array
    call QuickRecursive
       
    ;Restoring the registers
    pop DI
    pop SI
    pop BX
    pop BP

    RET
QuickSort ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Recursive QuickSort function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
QuickRecursive:
   
    ;if lowIndex >= highIndex, we exit the function
    cmp AX, BX
    jge PostIf
   
    push AX    ;saving our low index, now AX is 'i'
    push BX    ;saving our high index, now BX is 'j'
    add BX, 4  ;j = high + 1
   
    ;DI is our pivot
    ;pivot = array[lowIndex];
    mov DI,[SI+AX]
   
    MainLoop:

        iIncreaseLoop:
           
            ;i++
            add AX, 4
           
            ;If i >= j, exit this loop
            cmp AX, BX
            jge End_iIncreaseLoop
           
            ;If array[i] >= pivot, exit this loop
            cmp [SI+AX], DI
            jge End_iIncreaseLoop
           
            ;Go back to the top of this loop
            jmp iIncreaseLoop

        End_iIncreaseLoop:
       
        jDecreaseLoop:
       
            ;j--
            sub BX, 4
           
            ;If array[j] <= pivot, exit this loop
            cmp [SI+BX], DI
            jle End_jDecreaseLoop
           
            ;Go back to the top of this loop
            jmp jDecreaseLoop

        End_jDecreaseLoop:
       
        ;If i >= j, then don't swap and end the main loop
        cmp AX, BX
        jge EndMainLoop
       
        ;Else, swap array[i] with array [j]
        push [SI+AX]
        push [SI+BX]
       
        pop [SI+AX]
        pop [SI+BX]
       
        ;Go back to the top of the main loop
        jmp MainLoop
       
    EndMainLoop:       
   
    ;Restore the high index into DI
    pop DI
   
    ;Restore the low index into CX
    pop CX
   
    ;If low index == j, don't swap
    cmp CX, BX
    je EndSwap
   
    ;Else, swap array[low index] with array[j]
    push [SI+CX]
    push [SI+BX]
       
    pop [SI+CX]
    pop [SI+BX]
       
    EndSwap:

    ;Setting AX back to the low index
    mov AX, CX
   
    push DI    ;Saving the high Index
    push BX    ;Saving j
   
    sub BX, 4  ;Setting EBX to j-1
   
    ;QuickSort(array, low index, j-1)
    call QuickRecursive
   
    ;Restore 'j' into AX
    pop AX
    add AX, 4  ;setting AX to j+1
   
    ;Restore the high index into BX
    pop BX
   
    ;QuickSort(array, j+1, high index)
    call QuickRecursive
   
    PostIf:

RET

END   