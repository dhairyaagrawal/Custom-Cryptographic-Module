// $Id: $
// File name:   tb_ECU.sv
// Created:     4/23/2018
// Author:      Ryan Devlin
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test bench for ECU.
`timescale 1ns / 100ps

module tb_ECU ();

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
logic tb_start_op;
logic tb_ed_sel;
logic tb_r_ready;
logic tb_key_op;
logic tb_key_expanded;
logic [127:0] tb_data_in;
logic [127:0] tb_key_in;
logic [127:0] tb_mk_key;
logic [127:0] tb_e_data;
logic [127:0] tb_e_key;
logic tb_start_key_exp;
logic tb_en_done;

// Portmap
ECU TEST_ECU(
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.start_op(tb_start_op),
	.ed_sel(tb_ed_sel),
	.r_ready(tb_r_ready),
	.key_op(tb_key_op),
	.key_expanded(tb_key_expanded),
	.data_in(tb_data_in),
	.key_in(tb_key_in),
	.mk_key(tb_mk_key),
	.e_data(tb_e_data),
	.e_key(tb_e_key),
	.start_key_exp(tb_start_key_exp),
	.en_done(tb_en_done)
);

initial begin
	// Reset Device and Initialize
	tb_start_op = 1'b0;
	tb_ed_sel = 1'b0;
	tb_r_ready = 1'b0;
	tb_key_op = 1'b0;
	tb_key_expanded = 1'b0;
	tb_n_rst = 1;
	@(posedge tb_clk);
	tb_n_rst = 0;
	@(posedge tb_clk);
	tb_n_rst = 1;
	@(posedge tb_clk);

	@(negedge tb_clk);
	//tb_data_in = '0;
	tb_data_in = 128'h54776F204F6E65204E696E652054776F;
	tb_key_in = 128'h5468617473206D79204B756E67204675;
	tb_mk_key = 128'habababababababababababababababab;

	tb_start_op = 1'b1;
	tb_ed_sel = 1'b1;
	@(posedge tb_clk);
	// DATA_OP state
	tb_start_op = 1'b0;
	tb_ed_sel = 1'b0;

	@(posedge tb_clk);
	// KEY_EXP state
	@(negedge tb_clk);
	if(tb_start_key_exp == 1'b1) begin
		$info("start_key_exp correct.");
	end else begin
		$info("Wrong 1");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);

	if(tb_start_key_exp == 1'b1) begin
		$info("start_key_exp is still correct.");
	end else begin
		$info("Wrong 2");
	end

	//tb_data_in = 128'h54776F204F6E65204E696E652054776F;
	tb_data_in = '0;
	tb_r_ready = 1'b1;
	@(posedge tb_clk);
	tb_r_ready = 1'b0;
	@(negedge tb_clk);
	if(tb_start_key_exp == 1'b0) begin
		$info("start_key_exp correctly deasserted.");
	end else begin
		$info("Wrong 3");
	end
	if((tb_e_data == tb_data_in) && (tb_e_key == tb_key_in)) begin
		$info("Key and Data correctly assigned in WAIT1");
	end else begin
		$info("Wrong 4");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);

	@(negedge tb_clk);
	if(tb_en_done == 1'b1) begin
		$info("tb_en_done correct in WAIT10.");
	end else begin
		$info("Wrong 5");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);

	tb_key_op = 1'b1;
	@(posedge tb_clk);
	@(negedge tb_clk);

	if((tb_e_data == tb_key_in) && (tb_e_key == tb_mk_key)) begin
		$info("Key and master_key correctly assigned in KEY_OP");
	end else begin
		$info("Wrong 6");
	end

	@(posedge tb_clk);
	@(negedge tb_clk);
	
	if(tb_start_key_exp == 1'b1) begin
		$info("start_key_exp is correct in MK_EXP.");
	end else begin
		$info("Wrong 7");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	
	tb_key_expanded = 1'b1;
	
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);

	@(negedge tb_clk);
	if(tb_en_done == 1'b1) begin
		$info("Encryption correctly completed");
	end else begin
		$info("Wrong 8");
	end

	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_en_done == 1'b0) begin
		$info("Everything worked lol no way");
	end else begin
		$info("Wrong 9");
	end

end
endmodule
	