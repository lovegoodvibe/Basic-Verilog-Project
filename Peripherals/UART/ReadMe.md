### uart_transmitter:

# Parameter
* b: number of bit of (parity + data)    
* s: number of stop bit
* TIMER: relate to Baud Rate 

# Data path:
* dff_out: D flip_flop for the output tdo;
* Shift register with the lsb connect to the dff_out, this register contain one bit for start_bit and all data bit include parity_bit.
* The number of the stop bit can configure by changing the threshold value of the bit counter

# Control path:
* FSM with 2 state (IDLE and TX) control activities of time_counter (time for 1 bit to transmit) and bit_counter (check the number of transmitted bit)
* tx_tick: to confirm that all data bit had transmitted

### uart_tx_fifo:

## Activities description

# Special case:
 When transmitter is activated by input signal **start**, the module will transmitter all of the data in fifo until fifo is empty.

 This happen because the transmitter is auto activated by the signal **tx_tick** (activate each time the transmission is completed).

 In this case, when the fifo is empty, we have a special case which the activated transmitter signal **tx** is active in TX state of the transmitter. This makes **tx** is ignored and automatically stop the continuous transmission.   

# Input signal *start*
 
 This input signal must be configured by **single_cycle_tick_reverse** or **single_cycle_tick** module to get exacly 1 clock active signal, thereby, read pointer of fifo **r_ptr_reg**  increase only 1 unit each time user wait to rise **start**. 