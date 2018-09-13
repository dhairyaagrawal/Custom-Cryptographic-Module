// File name:   tb_RCU.sv
// Created:     4/26/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: test bench for the Receiver Control Unit
`timescale 1ns / 100ps

module tb_RCU ();

localparam CLK_PERIOD = 10;
logic tb_clk;

// Create Clock
always begin
	tb_clk = 1'b0;
	#(CLK_PERIOD/2.0);
	tb_clk = 1'b1;
	#(CLK_PERIOD/2.0);
end

logic tb_n_rst;
logic tb_read;
logic [128:0] tb_data_in;
logic [127:0] tb_key;
logic [128:0] tb_data;
logic tb_r_ready;

RCU Receiver
(
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.read(tb_read),
	.data_in(tb_data_in),
	.key(tb_key),
	.data(tb_data),
	.r_ready(tb_r_ready)
);

initial begin
	// Reset Device and Initialize
	tb_read = 1'b0;
	tb_data_in = 1'b0;
	tb_n_rst = 1;
	@(posedge tb_clk);
	tb_n_rst = 0;
	@(posedge tb_clk);
	tb_n_rst = 1;

	@(posedge tb_clk);
	// IDLE STATE
	tb_read = 1'b1;
	tb_data_in = 129'h000112233445566778899AABBCCDDEEFF;
	@(negedge tb_clk);
	if(tb_r_ready == 1'b0) begin
		$info("r_ready flag correctly deasserted");
	end else begin
		$info("Wrong 0");
	end

	@(posedge tb_clk);
	tb_data_in = 129'h0A0B0C566D0F6F0A0C0E0E0F0A0B0D0E0;
	// KEY STATE	
	@(negedge tb_clk);
	if(tb_r_ready == 1'b0 && tb_key == 128'h00112233445566778899AABBCCDDEEFF) begin
		$info("r_ready flag correctly asserted and key correctly assigned");
	end else begin
		$info("Wrong 1");
	end

	@(posedge tb_clk);
	tb_data_in = 129'h04278b840fb44aaa757c1bf04acbe1a3e;
	// DATA STATE	
	@(negedge tb_clk);
	if(tb_r_ready == 1'b1 && tb_data == 129'h0A0B0C566D0F6F0A0C0E0E0F0A0B0D0E0) begin
		$info("r_ready flag correctly asserted and data correctly assigned");
	end else begin
		$info("Wrong 2");
	end

	@(posedge tb_clk);
	tb_read = 1'b0;
	// DATA STATE	
	@(negedge tb_clk);
	if(tb_r_ready == 1'b1 && tb_data == 129'h04278b840fb44aaa757c1bf04acbe1a3e) begin
		$info("r_ready flag correctly asserted and data correctly assigned");
	end else begin
		$info("Wrong 3");
	end

	@(posedge tb_clk);
	// DATA STATE
	@(negedge tb_clk);
	if(tb_r_ready == 1'b0) begin
		$info("r_ready flag correctly deasserted");
	end else begin
		$info("Wrong 4");
	end
end

endmodule
