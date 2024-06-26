## counter:

* Describe a counter update synchronous each posedge of clk
* It will increase 1 unit if ctrl_inc is active 
* Or remain its value if ctrl_inc isn't active
* The counter register can reset to 0 when a synchronous reset signal activated

## counter_continuous
* Almost be the same as the "counter" module, the only diffirent is:
* It will "reset to 0" instead of "remain its value" if ctrl_inc isn't active  