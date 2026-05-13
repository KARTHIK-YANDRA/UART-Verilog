`timescale 1ns / 1ps
module uart_tx(
input clk,
input rst,
input tick,
input start,
input [7:0] data_in,
output reg tx,
output reg done,
output reg busy
    );
	 reg [2:0] state;
	 reg [7:0] data;
	 reg [2:0] bit_count;
	 reg parity_bit;
	 
	 parameter IDLE = 3'b000;
	 parameter START = 3'b01;
	 parameter DATA = 3'b10;
	 parameter PARITY = 3'b011;
	 parameter STOP = 3'b100;
	 
	 
	 always @(posedge clk)
	 begin
	 if(rst)
	 begin
	 state <= IDLE;
	 tx <= 1;
	 done <= 0;
	 bit_count <= 0;
	 busy <= 0;
	 end
	 else
	 begin
	 done <= 0;
	 case(state)
	 IDLE:
	 begin
	 tx <= 1;
	 done <= 0;
	 busy <= 0;
	 if(start)
	 begin
	 data <= data_in;
	 parity_bit <= ^data_in;
	 state <= START;
	 busy <= 1;
	 end
	 end
	 
	 //START STATE
	 START:
	 begin
	 if(tick)
	 begin
	 tx <= 0;
	 state <= DATA;
	 bit_count <= 0;
	 end
	 end
	 
	 //DATA STATE
	 DATA:
	 begin
	 if(tick)
	 begin
	 tx <= data[bit_count];
	 if(bit_count == 7)
	 begin
	 state <= PARITY;
	 end
	 else
	 begin
	 bit_count <= bit_count + 1;
	 end
	 end
	 end
	 
	 //PARITY STATE
	 
	 PARITY:
	 begin
	  if(tick)
	  begin
	    tx <= parity_bit;
		 state <= STOP;
		 end
		 end
		 
	 //STOP STATE
	 STOP:
	 begin
	 if(tick)
	 begin
	 tx <= 1;
	 done <= 1;
	 state <= IDLE;
	 busy <= 0;
	 end
	 end
	 endcase
	 end
	 end
endmodule

