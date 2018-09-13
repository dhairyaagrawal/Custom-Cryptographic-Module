// $Id: $
// File name:   tb_ccu.sv
// Created:     4/26/2018
// Author:      Ryan Devlin
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test Bench for Cryptographic Controller Unit.

`timescale 1ns / 100ps

module tb_ccu ();

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
logic tb_key_op;
logic tb_key_expanded;
logic tb_enable;
logic tb_irq_resp;
logic tb_e_or_d;
logic tb_aes_done;
logic tb_data_done;
logic tb_irq;
logic tb_read;
logic tb_ready;

// Portmap
ccu CCU_TEST
(
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.enable(tb_enable),
	.irq_resp(tb_irq_resp),
	.e_or_d(tb_e_or_d),
	.read(tb_read),
	.data_done(tb_data_done),
	.key_expanded(tb_key_expanded),
	.aes_done(tb_aes_done),
	.ed_sel(tb_ed_sel),
	.start_op(tb_start_op),
	.irq(tb_irq),
	.key_op(tb_key_op),
	.ready(tb_ready)
);

initial begin
	// Reset Device and Initialize
	//tb_start_op = 1'b0;
	//tb_ed_sel = 1'b0;
	//tb_key_op = 1'b0;
	tb_key_expanded = 1'b0;
	tb_enable = 1'b0;
	tb_irq_resp = 1'b0;
	tb_e_or_d = 1'b0;
	tb_aes_done = 1'b0;
	tb_data_done = 1'b0;
	//tb_irq = 1'b0;
	tb_read = 1'b0;
	//tb_ready = 1'b0;

	tb_n_rst = 1;
	@(posedge tb_clk);
	tb_n_rst = 0;
	@(posedge tb_clk);
	tb_n_rst = 1;
	@(posedge tb_clk);

	//enable encryption
	tb_e_or_d = 1'b1;
	tb_enable = 1'b1;

	@(posedge tb_clk);
	@(negedge tb_clk);
	//key_wait1
	if(tb_ed_sel == 1'b1) begin
		$info("ed_sel correctly asserted.");
	end else begin
		$info("Wrong 0");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	
	tb_read = 1'b1;

	@(posedge tb_clk);
	tb_read = 1'b0;
	@(negedge tb_clk);
	//Start_e
	if(tb_start_op == 1'b1) begin
		$info("start_op correctly asserted.");
	end else begin
		$info("Wrong 1");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_key_expanded = 1'b1;
	
	@(posedge tb_clk);
	tb_key_expanded = 1'b0;
	@(negedge tb_clk);
	//IRQ_E
	if(tb_irq == 1'b1) begin
		$info("irq correctly asserted.");
	end else begin
		$info("Wrong 2");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_irq_resp = 1'b1;
	
	@(posedge tb_clk);
	tb_irq_resp = 1'b0;
	//SERVICED_E
	@(negedge tb_clk);
	if(tb_irq == 1'b0) begin
		$info("irq correctly deasserted.");
	end else begin
		$info("Wrong 3");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_data_done = 1'b1;

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
	@(posedge tb_clk); //12 cycles

	@(negedge tb_clk);
	if(tb_key_op == 1'b1) begin
		$info("key_op correctly asserted.");
	end else begin
		$info("Wrong 4");
	end

	@(posedge tb_clk);
	@(negedge tb_clk);
	if(tb_key_op == 1'b0) begin
		$info("key_op correctly deasserted.");
	end else begin
		$info("Wrong 5");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);

	tb_aes_done = 1'b1;

	@(posedge tb_clk);
	@(negedge tb_clk);
	if(tb_ready == 1'b1) begin
		$info("ready correctly asserted.");
	end else begin
		$info("Wrong 6");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);

	tb_enable = 1'b0;
	@(posedge tb_clk);
	@(negedge tb_clk);
	if(tb_ready == 1'b1) begin
		$info("ready correctly asserted again.");
	end else begin
		$info("Wrong 7");
	end

//START DECRYPTION/////////////////////////////////////////////////////////////////////////////////////////////

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);

	//enable encryption
	tb_e_or_d = 1'b0;
	tb_enable = 1'b1;

	@(posedge tb_clk);
	@(negedge tb_clk);
	//key_wait1
	if(tb_ed_sel == 1'b0 && tb_ready == 1'b0) begin
		$info("ed_sel correctly asserted in decryption.");
	end else begin
		$info("Wrong d0");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	
	tb_read = 1'b1;

	@(posedge tb_clk);
	tb_read = 1'b0;
	@(negedge tb_clk);
	//Start_e
	if(tb_start_op == 1'b1) begin
		$info("start_op correctly asserted in decryption.");
	end else begin
		$info("Wrong d1");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_key_expanded = 1'b1;
	
	@(posedge tb_clk);
	tb_key_expanded = 1'b0;
	@(negedge tb_clk);

	if(tb_start_op == 1'b0) begin
		$info("start_op correctly deasserted in decryption.");
	end else begin
		$info("Wrong d2");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_key_expanded = 1'b1;
	
	@(posedge tb_clk);
	tb_key_expanded = 1'b0;
	@(negedge tb_clk);

	//IRQ_E
	if(tb_irq == 1'b1) begin
		$info("irq correctly asserted in decryption.");
	end else begin
		$info("Wrong d3");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_irq_resp = 1'b1;
	
	@(posedge tb_clk);
	tb_irq_resp = 1'b0;
	//RESP
	@(negedge tb_clk);
	if(tb_irq == 1'b0) begin
		$info("irq correctly deasserted in decryption.");
	end else begin
		$info("Wrong d4");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_data_done = 1'b1;

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
	@(posedge tb_clk); //11 cycles

	@(posedge tb_clk);
	@(negedge tb_clk);
	if(tb_key_op == 1'b0) begin
		$info("key_op correctly deasserted at end of decryption.");
	end else begin
		$info("Wrong d5");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);

	tb_enable = 1'b0;
	@(posedge tb_clk);
	@(negedge tb_clk);
	if(tb_ready == 1'b1) begin
		$info("ready correctly asserted again.");
	end else begin
		$info("Wrong d6");
	end

end
endmodule