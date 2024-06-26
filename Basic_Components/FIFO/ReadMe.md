### fifo:

## Activities description

 This module contain an array of data word can write in and read out.

 User can synchronically write a data word pointed by **w_ptr_reg** *each time the clock is rising* when the signal **wr** is active and the array is not full.

 User can anytime read a data word pointed by **r_ptr_reg** when the signal **rd** is active and the array is not empty.

## Pointers signal description

 **w_ptr_reg** (**r_ptr_reg**) is synchronically updated *each time the clock is rising*. 
 
 If the **wr** (**rd**) signal is active and *the array is not full* (*the array is not empty*), **w_ptr_reg** (**r_ptr_reg**) increase 1 unit. Else, it remain its value.

## Full and empty signal description

 The array is full if the **w_ptr_next** =**r_ptr_reg**

 The array is empty if the **r_ptr_next** =**w_ptr_reg**