`timescale 1ns / 1ps
module uart_tb;

	// Inputs
	reg clk;
	reg rst;
	reg start;
	reg [7:0] data_in;

	// Outputs
	wire [7:0] data_out;
	wire done_tx;
	wire done_rx;
	wire tx;
	wire parity_error;
	wire framing_error;

	// Instantiate the Unit Under Test (UUT)
	uart_top uut (
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.data_in(data_in), 
		.data_out(data_out), 
		.done_tx(done_tx), 
		.done_rx(done_rx), 
		.tx(tx),
		.tick(tick),
		.busy(busy),
		.parity_error(parity_error),
		.framing_error(framing_error)
	);
   always #5 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		start = 0;
		data_in = 8'b10101010;

		// Wait 100 ns for global reset to finish
		#50;
      rst = 0;
		#50;
		start = 1;
		#10;
		start = 0;
		#5000;
		$stop;
		// Add stimulus here

	end
      
endmodule

