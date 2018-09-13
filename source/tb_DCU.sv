// File name:   tb_DCU.sv
// Created:     4/24/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test bench for the Decryption Controller Unit of AES Core block
`timescale 1ns / 100ps

module tb_DCU ();

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
logic [127:0] tb_plaintext_data;
logic tb_start_key_exp;
logic tb_dec_done;
logic [127:0] tb_d_data;
logic [127:0] tb_d_key;

DCU TEST_DCU
(
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
	.plaintext_data(tb_plaintext_data),
	.start_key_exp(tb_start_key_exp),
	.dec_done(tb_dec_done),
	.d_data(tb_d_data),
	.d_key(tb_d_key)
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

	tb_data_in = 128'h29C3505F571420F6402299B31A02D73A;
	tb_key_in = 128'h97049427aad9b15464867349d2da88aa;
	tb_mk_key = 128'habababababababababababababababab;

	tb_start_op = 1'b1;
	tb_ed_sel = 1'b1;
	@(posedge tb_clk);
	@(negedge tb_clk);
	// MK_KEY STATE
	tb_start_op = 1'b0;
	tb_ed_sel = 1'b0;
	
	@(posedge tb_clk);
	@(negedge tb_clk);
	// KEY_EXP state
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

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_key_expanded = 1'b1;
	@(posedge tb_clk);
	@(negedge tb_clk);
	// WAIT 1 STATE
	if(tb_start_key_exp == 1'b0) begin
		$info("start_key_exp is correctly deasserted");
	end else begin
		$info("Wrong 3");
	end

	if((tb_d_key == tb_mk_key) && (tb_d_data == tb_key_in)) begin
		$info("key and data lines assigned correctly in KEY_EXP STATE and remain right in next state.");
	end else begin
		$info("Wrong 4");
	end

	tb_key_expanded = 1'b0;

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);

	tb_plaintext_data = 128'h5468617473206D79204B756E67204675;
	@(posedge tb_clk);
	@(negedge tb_clk);
	// AUX_KEY STATE
	if((tb_d_key == tb_plaintext_data) && (tb_d_data == tb_data_in)) begin
		$info("key and data lines assigned correctly in AUX KEY");
	end else begin
		$info("Wrong 5");
	end

	@(posedge tb_clk);
	@(negedge tb_clk);
	// KEY_EXP_2 STATE
	if(tb_start_key_exp == 1'b1) begin
		$info("start_key_exp is correct in KEY_EXP2.");
	end else begin
		$info("Wrong 6");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_r_ready = 1'b1;
	@(posedge tb_clk);
	@(negedge tb_clk);
	// WAIT11 STATE
	if(tb_start_key_exp == 1'b0) begin
		$info("start_key_exp is correct in WAIT11 STATE.");
	end else begin
		$info("Wrong 7");
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
	// WAIT20 STATE
	if(tb_dec_done == 1'b1) begin
		$info("dec_done is correctly asserted.");
	end else begin
		$info("Wrong 8");
	end

end

endmodule
