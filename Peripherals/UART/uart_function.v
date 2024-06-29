module uart_function #(
    parameter EVEN_ODD = 1 // Êven = 1, Odd = 0
);
    function parity;
        input [7:0] data;
        reg sum;
        integer i;
        begin
            //parity = data[0] + data[1] + data[2] + data[3] + data[4] + data[5] + data[6] + data[7];
            sum = 0;
            for (i = 0; i<=7 ;i=i+1 ) begin
               sum = sum + data[i]; 
            end
                parity = (EVEN_ODD) ? ~sum : sum;
        end
    endfunction
endmodule
