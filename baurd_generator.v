`timescale 1ns / 1ps

module baurd_generator(
    input clk,
    input rst,
    output reg tick
    );

reg [13:0] count ;
always @(posedge clk)
begin
if(rst)
begin
count <= 0;
tick <=0;
end
else if (count == 7)
begin
count <=0;
tick <=1;
end
else
begin
count <= count+1;
tick <=0;
end
end
endmodule 
