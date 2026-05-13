`timescale 1ns / 1ps
module uart_top(
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    output [7:0] data_out,
    output done_tx,
    output done_rx,
    output tx,
	 output tick,
	 output busy,
	 output parity_error,
	 output framing_error
    );
	 
	 
	 baurd_generator bg(
	  .clk(clk),
	  .rst(rst),
	  .tick(tick)
	 );
	 
	 uart_tx transmitter(
	  .clk(clk),
	  .rst(rst),
	  .tick(tick),
	  .start(start),
	  .data_in(data_in),
	  .tx(tx),
	  .done(done_tx),
	  .busy(busy)
	 );

	 uart_rx receiver(
	  .clk(clk),
	  .rst(rst),
	  .tick(tick),
	  .rx(tx),
	  .data_out(data_out),
	  .done(done_rx),
	  .parity_error(parity_error),
	  .framing_error(framing_error)
	 );	 
endmodule
