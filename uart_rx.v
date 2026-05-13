`timescale 1ns / 1ps
module uart_rx(
input clk,
input rst,
input tick,
input rx,
output reg[7:0] data_out,
output reg done,
output reg parity_error,
output reg framing_error
    );
	 
	 reg [2:0] state;
	 reg [2:0] bit_count;
	 reg start_detected;
	 reg parity_bit;
	 parameter IDLE =2'b000;
	 parameter START =2'b001;
	 parameter DATA =2'b010;
	 parameter PARITY = 3'b011;
	 parameter STOP =2'b100;
	 wire expected_parity;
	 assign expected_parity = ^data_out;
	 
	 always @(posedge clk)
	 begin
	 if(rst)
	 begin
	 done <= 0;
	 state <= IDLE;
	 bit_count <= 0;
	 data_out <= 0;
	 start_detected <= 0;
	 parity_error <= 0;
	 framing_error <= 0;
	 end
	 else
	 begin
	 case(state)
	 
	 //IDLE STATE
	 IDLE:
	 begin
	 done <= 0;
	 if(rx==0 && start_detected == 0)
	 begin
	 start_detected <= 1;
	 state <= START;
	 end
	 else if(rx == 1)
	 start_detected <= 0;
	 end
	 
	 //START STATE
	 START:
	 begin
	 if(tick)
	 begin
	 bit_count = 0;
	 state <= DATA;
	 end
	 end
	 
	 //DATA STATE
	 DATA:
	 begin
	 if(tick)
	 begin
	 data_out <= {rx,data_out[7:1]};
	 if(bit_count == 7)
	 state <= PARITY;
	 else
	 bit_count <= bit_count + 1;
	 end
	 end
	 
	 //PARITY STATE
	 PARITY:
	 begin
	 if(tick)
	 begin
	   parity_bit <= rx;
		state <= STOP;
		end
		end
	 
	 //STOP STATE
	 STOP:
	 begin
	 if(tick)
	 begin
	 if(rx != 1)
	 framing_error <= 1;
	 else
	 framing_error <= 0;
	 if(parity_bit != expected_parity)
	 parity_error <= 1;
	 else
	 parity_error <= 0;
	 done <= 1;
	 bit_count <= 0;
	 state <= IDLE;
	 end
	 end
	 endcase
	 end
	 end
endmodule


