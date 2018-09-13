// $Id: $
// File name:   tb_AHB_master.sv
// Created:     4/25/2018
// Author:      Dhairya Agrawal
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test bench for SRAM AHB Master.
`timescale 1ns / 100ps

module tb_AHB_master();

	localparam CLK_PERIOD = 10;
	reg tb_clk;
	always begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	logic tb_n_rst;
	logic tb_ed_sel;
	logic tb_aes_done;
	logic tb_last_packet;
	logic tb_read_addr;
	logic [31:0] tb_sram_addr;
	logic [128:0] tb_data_out;

	logic tb_HWRITE;
	logic [2:0] tb_HBURST;
	logic [1:0] tb_HTRANS;
	logic [31:0] tb_HADDR;
	logic [127:0] tb_HWDATA;

	AHB_master DUT(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.ed_sel(tb_ed_sel),
		.aes_done(tb_aes_done),
		.last_packet(tb_last_packet),
		.read_addr(tb_read_addr),
		.sram_addr(tb_sram_addr),
		.data_out(tb_data_out),
		
		.HWRITE(tb_HWRITE),
		.HBURST(tb_HBURST),
		.HTRANS(tb_HTRANS),
		.HADDR(tb_HADDR),
		.HWDATA(tb_HWDATA)
	);

	initial begin
	// Device initialization
	tb_ed_sel = 0;
	tb_aes_done = 1'b0;
	tb_last_packet = 1'b1;
	tb_read_addr = 1'b0;
	tb_sram_addr = '0;
	tb_data_out = '0;
	
	// Device Under Test reset
	tb_n_rst = 1;
	@(posedge tb_clk);
	tb_n_rst = 0;
	@(posedge tb_clk);
	tb_n_rst = 1;
	@(posedge tb_clk);

	@(posedge tb_clk);
	tb_ed_sel = 1'b1;
	@(posedge tb_clk);
	if(tb_HTRANS == 0) begin
		$info("FSM correctly still in IDLE state");
	end else begin
		$info("Wrong1");
	end
	
	tb_read_addr = 1'b1;
	tb_sram_addr = 32'h00001111;
	@(posedge tb_clk);
	tb_read_addr = 1'b0;
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	if(tb_HTRANS == 0) begin
		$info("FSM correctly still in ADDR state");
	end else begin
		$info("Wrong2");
	end

	tb_aes_done = 1'b1;
	tb_data_out = 129'h1ffffffffffffffffffffffffffffffff;
	@(posedge tb_clk);
	@(negedge tb_clk);
	if(tb_HTRANS == 0) begin
		$info("FSM correctly in WAIT1 state");
	end else begin
		$info("Wrong3");
	end

	@(posedge tb_clk);
	tb_data_out = 129'h011111111111111111111111111111111;

	@(posedge tb_clk);
	tb_data_out = 129'h0ffffffffffffffffffffffffffffffff;
	@(negedge tb_clk);
	if(tb_HTRANS == 2 && tb_HBURST == 1 && tb_HADDR == tb_sram_addr) begin
		$info("FSM Correctly transitioned to OUT state with correct sram address");
	end else begin
		$info("Wrong4");
	end

	@(posedge tb_clk);
	tb_data_out = 129'h0a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1;	
	@(negedge tb_clk);
	if(tb_HTRANS == 3 && tb_HBURST == 1 && tb_HADDR == tb_sram_addr + 16) begin
		$info("FSM Correctly transitioned to LOOP1 state with correct sram address");
	end else begin
		$info("Wrong5a");
	end
	if(tb_HWDATA == 128'h11111111111111111111111111111111) begin
		$info("First Correct data on AHB Bus");
	end else begin
		$info("Wrong5b");
	end

	@(posedge tb_clk);
	tb_data_out = 129'h1bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb;
	@(negedge tb_clk);
	if(tb_HTRANS == 3 && tb_HBURST == 1 && tb_HADDR == tb_sram_addr + 32) begin
		$info("FSM Correctly transitioned to LOOP2 state with correct sram address");
	end else begin
		$info("Wrong6a");
	end
	if(tb_HWDATA == 128'hffffffffffffffffffffffffffffffff) begin
		$info("Second Correct data on AHB Bus");
	end else begin
		$info("Wrong6b");
	end


	@(posedge tb_clk);
	tb_data_out = 129'h1cccccccccccccccccccccccccccccccc;
	@(negedge tb_clk);
	if(tb_HTRANS == 0 && tb_HBURST == 0 && tb_HADDR == tb_sram_addr + 32) begin
		$info("FSM Correctly transitioned to LAST1 state with correct sram address");
	end else begin
		$info("Wrong7a");
	end
	if(tb_HWDATA == 128'ha1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1) begin
		$info("Third Correct data on AHB Bus");
	end else begin
		$info("Wrong7b");
	end

	@(posedge tb_clk);
	tb_data_out = 129'h069696969696969696969696969696969;
	@(negedge tb_clk);
	if(tb_HTRANS == 0 && tb_HBURST == 0 && tb_HADDR == tb_sram_addr + 32) begin
		$info("FSM Correctly still in LAST1 state with correct sram address");
	end else begin
		$info("Wrong8");
	end
	
	@(posedge tb_clk);
	tb_aes_done = 1'b0;
	@(negedge tb_clk);
	if(tb_HTRANS == 2 && tb_HBURST == 1 && tb_HADDR == tb_sram_addr + 48) begin
		$info("FSM Correctly in OUT state with correct sram address");
	end else begin
		$info("Wrong9");
	end

	@(posedge tb_clk);
	@(negedge tb_clk);
	if(tb_HTRANS == 0 && tb_HBURST == 0 && tb_HADDR == tb_sram_addr + 48) begin
		$info("FSM Correctly transitioned to LAST1 state with correct sram address");
	end else begin
		$info("Wrong10a");
	end
	if(tb_HWDATA == 128'h69696969696969696969696969696969) begin
		$info("Fourth Correct data on AHB Bus");
	end else begin
		$info("Wrong10b");
	end

	@(posedge tb_clk);
	@(negedge tb_clk);
	if(tb_HTRANS == 0 && tb_HBURST == 0 && tb_HADDR == tb_sram_addr + 48) begin
		$info("FSM Correctly transitioned to WAIT state with correct sram address");
	end else begin
		$info("Wrong11");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	if(tb_HTRANS == 0 && tb_HBURST == 0 && tb_HADDR == tb_sram_addr + 48) begin
		$info("FSM Correctly stil in to WAIT state with correct sram address");
	end else begin
		$info("Wrong12");
	end
	
	tb_aes_done = 1'b1;
	tb_data_out = 129'h066666666666666666666666666666666;
	@(posedge tb_clk);
	@(negedge tb_clk);
	if(tb_HTRANS == 2 && tb_HBURST == 0 && tb_HADDR == tb_sram_addr + 64) begin
		$info("FSM Correctly in KEYOUT1 state with correct sram address");
	end else begin
		$info("Wrong13");
	end
	
	@(posedge tb_clk);
	@(negedge tb_clk);
	if(tb_HWDATA == 128'h066666666666666666666666666666666) begin
		$info("Correct Key on AHB Bus at KEYOUT2 state");
	end else begin
		$info("Wrong14");
	end
	end
endmodule
