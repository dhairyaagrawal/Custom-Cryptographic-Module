// File name:   tb_aes_core.sv
// Created:     4/24/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test bench for AES Core
`timescale 1ns / 100ps

module tb_aes_core ();

//localparam CLK_PERIOD = 10;
localparam CLK_PERIOD = 5;
logic tb_clk;

// Create Clock
always begin
	tb_clk = 1'b0;
	#(CLK_PERIOD/2.0);
	tb_clk = 1'b1;
	#(CLK_PERIOD/2.0);
end

logic tb_n_rst;
logic [128:0] tb_data;
logic [127:0] tb_key;
logic tb_key_op;
logic tb_r_ready;
logic tb_ed_sel;
logic tb_start_op;
logic tb_key_expanded;
logic tb_aes_done;
logic [128:0] tb_data_out;

aes_core DUT
(
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.data(tb_data),
	.key(tb_key),
	.key_op(tb_key_op),
	.r_ready(tb_r_ready),
	.ed_sel(tb_ed_sel),
	.start_op(tb_start_op),
	.key_expanded(tb_key_expanded),
	.aes_done(tb_aes_done),
	.data_out(tb_data_out)
);

initial begin
	// Reset Device and Initialize
	tb_key_op = 1'b0;
	tb_r_ready = 1'b0;
	tb_ed_sel = 1'b0;
	tb_start_op = 1'b0;
	tb_n_rst = 1;
	@(posedge tb_clk);
	tb_n_rst = 0;
	@(posedge tb_clk);
	tb_n_rst = 1;
	@(posedge tb_clk);
	@(negedge tb_clk);

	// Encryption run through of AES
	tb_data = '0;
	tb_key = 128'h5468617473206D79204B756E67204675;
	
	tb_start_op = 1'b1;
	tb_ed_sel = 1'b1;
	@(posedge tb_clk);
	// DATA_OP state
	tb_start_op = 1'b0;
	
	@(posedge tb_clk);
	// KEY_EXP state
	@(negedge tb_clk);
	
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
	@(posedge tb_clk);
	@(negedge tb_clk);
	if(tb_key_expanded == 1'b1) begin
		$info("key_expanded signal correctly asserted 1st time");
	end else begin
		$info("Wrong 0");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	
	tb_r_ready = 1'b1;

	tb_data = 129'h054776F204F6E65204E696E652054776F;
	@(posedge tb_clk);

	tb_data = 129'h000112233445566778899AABBCCDDEEFF;
	@(posedge tb_clk);
	
	tb_data = '0;
	@(posedge tb_clk);
	
	tb_data = '1;
	@(posedge tb_clk);	
	
	tb_data = 129'h012345678912345678912345678912345;
	@(posedge tb_clk);
	
	tb_data = 129'h04278b840fb44aaa757c1bf04acbe1a3e;
	@(posedge tb_clk);
	
	tb_data = 129'h098765432198765432197865432198765;
	@(posedge tb_clk);
	
	tb_data = 129'h0A0B0C566D0F6F0A0C0E0E0F0A0B0D0E0;
	@(posedge tb_clk);
	
	tb_data = 129'h0156953b2feab2a04ae0180d8335bbed6;
	@(posedge tb_clk);
	
	tb_data = 129'h0a02600ecb8ea77625bba6641ed5f5920;
	@(posedge tb_clk);
	
	tb_data = 129'h08d2e60365f17c7df1040d7501b4a7b5a;
	@(negedge tb_clk);

	// WAIT10 STATE
	if(tb_aes_done == 1'b1) begin
		$info("aes_done correctly asserted");
	end else begin
		$info("Wrong 1");
	end
	
	if(tb_data_out == 129'h029c3505f571420f6402299b31a02d73a) begin
		$info("Key and Data correctly assigned in WAIT10");
	end else begin
		$info("Wrong 2");
	end

	//@(posedge tb_clk);
	//tb_data = 128'h8d2e60365f17c7df1040d7501b4a7b5a;
	@(posedge tb_clk);
	tb_data = 129'h02e586692e647f5028ec6fa47a55a2aab;
	@(negedge tb_clk);

	if(tb_data_out == 129'h0e2d1ae4680bff46b8c787e0c2c6045a2) begin
		$info("Key and Data correctly assigned in WAIT10");
	end else begin
		$info("Wrong 2a");
	end
	
	//@(posedge tb_clk);
	//tb_data = 128'h2e586692e647f5028ec6fa47a55a2aab;
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h0e552860c7dc16c93751251ea8eea8d95) begin
		$info("Key and Data correctly assigned in WAIT10");
	end else begin
		$info("Wrong 2b");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h14fdfbc5d440a8ab4e0077627edb6d13e) begin
		$info("Key and Data correctly assigned in WAIT10");
	end else begin
		$info("Wrong 2c");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h00bd1b01d1dc9079321468b6b6dc27a98) begin
		$info("Key and Data correctly assigned in WAIT10");
	end else begin
		$info("Wrong 2d");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h0b4ee6359e7006f1baf13b16c26f95c45) begin
		$info("Key and Data correctly assigned in WAIT10");
	end else begin
		$info("Wrong 2e");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h0863718bcf7c16845b92dbeab978b63b3) begin
		$info("Key and Data correctly assigned in WAIT10");
	end else begin
		$info("Wrong 2f");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h06ea77d59c592a39142f0eaa70dce5b92) begin
		$info("Key and Data correctly assigned in WAIT10");
	end else begin
		$info("Wrong 2g");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h039c2527ee5074856bbb2b719796a988d) begin
		$info("Key and Data correctly assigned in WAIT10");
	end else begin
		$info("Wrong 2h");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h0f0f3d553a579210d8c4e0fcd221dd5de) begin
		$info("Key and Data correctly assigned in WAIT10");
	end else begin
		$info("Wrong 2i");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h0da67c0cdf3c28c5a01063a1c0a117eee) begin
		$info("Key and Data correctly assigned in WAIT10");
	end else begin
		$info("Wrong 2j");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h04592c207df80d3a57d716d45422888e7) begin
		$info("Key and Data correctly assigned in WAIT10");
	end else begin
		$info("Wrong 2k");
	end

	tb_r_ready = 1'b0;
	@(posedge tb_clk);
	
	tb_key_op = 1'b1;
	@(posedge tb_clk);
	
	// KEY_OP STATE
	tb_key_op = 1'b0;
	@(posedge tb_clk);
	
	// MK_EXP STATE
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
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_key_expanded == 1'b1) begin
		$info("key_expanded signal correctly asserted");
	end else begin
		$info("Wrong 3");
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

	if((tb_aes_done == 1'b1) && (tb_data_out == 129'h0e63915a859a456689463fa95aae196c2)) begin
		$info("aes_done correct and auxiliary key encrypted correctly");
	end else begin
		$info("Wrong 4");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);

	// Decryption run through of AES
	tb_key = 129'h0e63915a859a456689463fa95aae196c2;

	@(posedge tb_clk);
	@(posedge tb_clk);

	tb_start_op = 1'b1;
	tb_ed_sel = 1'b0;
	@(posedge tb_clk);
	// MK_KEY state
	tb_start_op = 1'b0;

	@(posedge tb_clk);
	// KEY_EXP state
	@(negedge tb_clk);

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
	@(posedge tb_clk);
	@(negedge tb_clk);
	if(tb_key_expanded == 1'b1) begin
		$info("key_expanded signal correctly asserted 1st time");
	end else begin
		$info("Wrong 5");
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
	// WAIT10 STATE

	tb_data = 129'h029c3505f571420f6402299b31a02d73a;
	@(posedge tb_clk);
	@(negedge tb_clk);
	// AUX_KEY STATE

	if(tb_data_out == 129'h05468617473206D79204B756E67204675) begin
		$info("auxiliary key decrypted correctly using master key");
	end else begin
		$info("Wrong 6");
	end	

	@(posedge tb_clk);
	// KEY_EXP2
	
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
	@(posedge tb_clk);
	@(negedge tb_clk);
	if(tb_key_expanded == 1'b1) begin
		$info("key_expanded signal correctly asserted 1st time");
	end else begin
		$info("Wrong 7");
	end

	@(posedge tb_clk);
	tb_r_ready = 1'b1;

	@(posedge tb_clk);
	// WAIT 11 STATE
	
	tb_data = 129'h0e2d1ae4680bff46b8c787e0c2c6045a2;

	@(posedge tb_clk);
	tb_data = 129'h0e552860c7dc16c93751251ea8eea8d95;

	@(posedge tb_clk);
	tb_data = 129'h14fdfbc5d440a8ab4e0077627edb6d13e;

	@(posedge tb_clk);
	tb_data = 129'h00bd1b01d1dc9079321468b6b6dc27a98;

	@(posedge tb_clk);
	tb_data = 129'h0b4ee6359e7006f1baf13b16c26f95c45;
	@(posedge tb_clk);

	tb_data = 129'h0863718bcf7c16845b92dbeab978b63b3;
	@(posedge tb_clk);

	tb_data = 129'h06ea77d59c592a39142f0eaa70dce5b92;
	@(posedge tb_clk);

	tb_data = 129'h039c2527ee5074856bbb2b719796a988d;
	@(posedge tb_clk);

	tb_data = 129'h0f0f3d553a579210d8c4e0fcd221dd5de;

	@(posedge tb_clk);
	tb_data = 129'h0da67c0cdf3c28c5a01063a1c0a117eee;
	@(negedge tb_clk);

	// WAIT20 STATE
	if(tb_aes_done == 1'b1) begin
		$info("aes_done correctly asserted");
	end else begin
		$info("Wrong 8");
	end
	
	if(tb_data_out == 129'h054776F204F6E65204E696E652054776F) begin
		$info("Key and Data correctly assigned in WAIT20");
	end else begin
		$info("Wrong 9");
	end

	//tb_data = 128'hda67c0cdf3c28c5a01063a1c0a117eee;
	@(posedge tb_clk);
	tb_data = 129'h04592c207df80d3a57d716d45422888e7;
	@(negedge tb_clk);

	if(tb_data_out == 129'h000112233445566778899AABBCCDDEEFF) begin
		$info("Key and Data correctly assigned in WAIT20");
	end else begin
		$info("Wrong 9a");
	end
	
	@(posedge tb_clk);
	//tb_data = 128'h4592c207df80d3a57d716d45422888e7;
	//@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == '0) begin
		$info("Key and Data correctly assigned in WAIT20");
	end else begin
		$info("Wrong 9b");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == '1) begin
		$info("Key and Data correctly assigned in WAIT20");
	end else begin
		$info("Wrong 9c");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h012345678912345678912345678912345) begin
		$info("Key and Data correctly assigned in WAIT20");
	end else begin
		$info("Wrong 9d");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h04278b840fb44aaa757c1bf04acbe1a3e) begin
		$info("Key and Data correctly assigned in WAIT20");
	end else begin
		$info("Wrong 9e");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h098765432198765432197865432198765) begin
		$info("Key and Data correctly assigned in WAIT20");
	end else begin
		$info("Wrong 9f");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h0A0B0C566D0F6F0A0C0E0E0F0A0B0D0E0) begin
		$info("Key and Data correctly assigned in WAIT20");
	end else begin
		$info("Wrong 9g");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h0156953b2feab2a04ae0180d8335bbed6) begin
		$info("Key and Data correctly assigned in WAIT20");
	end else begin
		$info("Wrong 9h");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h0a02600ecb8ea77625bba6641ed5f5920) begin
		$info("Key and Data correctly assigned in WAIT20");
	end else begin
		$info("Wrong 9i");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h08d2e60365f17c7df1040d7501b4a7b5a) begin
		$info("Key and Data correctly assigned in WAIT20");
	end else begin
		$info("Wrong 9j");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	if(tb_data_out == 129'h02e586692e647f5028ec6fa47a55a2aab) begin
		$info("Key and Data correctly assigned in WAIT20");
	end else begin
		$info("Wrong 9k");
	end
	@(posedge tb_clk);
	@(negedge tb_clk);

	// TAKES DCU TO IDLE
	tb_key_op = 1'b1;
	@(posedge tb_clk);
	@(negedge tb_clk);
end

endmodule
