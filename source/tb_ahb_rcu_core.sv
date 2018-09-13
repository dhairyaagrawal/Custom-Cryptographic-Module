// File name:   tb_ahb_rcu_core.sv
// Created:     4/26/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test bench for RCU, AHB Slave and AES Core modules
`timescale 1ns / 100ps

module tb_ahb_rcu_core ();

localparam CLK_PERIOD = 10;
reg tb_clk;
always begin
	tb_clk = 1'b0;
	#(CLK_PERIOD/2.0);
	tb_clk = 1'b1;
	#(CLK_PERIOD/2.0);
end

logic tb_n_rst;
logic [1:0] tb_HTRANS;
logic tb_HWRITE;
logic tb_HSELx;
logic tb_HREADY;
logic [127:0] tb_HWDATA;
logic tb_enable;
logic tb_irq_resp;
logic tb_e_or_d;
logic tb_data_done;
logic tb_HRESP;
logic tb_HREADYOUT;
logic [31:0] tb_sram_addr;
logic tb_read_addr;
logic tb_last_packet;
logic tb_aes_done;
logic [128:0] tb_data_out;
logic tb_irq;
logic tb_ready;

ahb_rcu_core PHASE1
(
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.HTRANS(tb_HTRANS),
	.HWRITE(tb_HWRITE),
	.HSELx(tb_HSELx),
	.HREADY(tb_HREADY),
	.HWDATA(tb_HWDATA),
	.enable(tb_enable), 
	.irq_resp(tb_irq_resp), 
	.e_or_d(tb_e_or_d), 
	.data_done(tb_data_done), 
	.HRESP(tb_HRESP),
	.HREADYOUT(tb_HREADYOUT),
	.sram_addr(tb_sram_addr),
	.read_addr(tb_read_addr),
	.last_packet(tb_last_packet),
	.aes_done(tb_aes_done),
	.data_out(tb_data_out),
	.irq(tb_irq), 
	.ready(tb_ready) 
);

initial begin
	// Device Initialization
	tb_HTRANS = '0;
	tb_HWRITE = 1'b0;
	tb_HSELx = 1'b0;
	tb_HREADY = 1'b0;
	tb_HWDATA = '0;
	tb_enable = 1'b0;
	tb_e_or_d = 1'b0;
	tb_irq_resp = 1'b0;
	tb_e_or_d = 1'b0;
	tb_data_done = 1'b0;

	// Device Reset
	tb_n_rst = 1;
	@(posedge tb_clk);
	tb_n_rst = 0;
	@(posedge tb_clk);
	tb_n_rst = 1;

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	if(tb_ready == 1'b1) begin
		$info("Ready to start.");
	end else begin
		$info("Wrong 0");
	end

	//Enable CCM
	tb_enable = 1'b1;
	tb_e_or_d = 1'b1;	
	
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	// IDLE STATE
	tb_HWRITE = 1'b1;
	tb_HSELx = 1'b1;
	tb_HREADY = 1'b1;
	tb_HTRANS = 2'h2;

	@(posedge tb_clk);
	tb_HWDATA = 128'h5468617473206D79204B756E67204675;
	// KEY STATE
	tb_HSELx = 1'b0; // our device has been deselected

	@(posedge tb_clk);
	// WAIT STATE
	//tb_start_op = 1'b1;

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
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(negedge tb_clk);
	$info("KEY EXPANDED HERE");
	
	@(posedge tb_clk);
	@(negedge tb_clk);
	if(tb_irq == 1'b1) begin
		$info("IRQ correctly asserted.");
	end else begin
		$info("Wrong IRQ");
	end
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk); //waiting for irq_resp
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_irq_resp = 1'b1;

	@(posedge tb_clk);
	tb_irq_resp = 1'b0;

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_HSELx = 1'b1; // irq has been serviced

	@(posedge tb_clk);
	// ADDR STATE AND DATA PHASE OF SRAM ADDRESS
	tb_HWDATA = 128'h0000000000000000000000000001111; // SRAM ADDRESS
	tb_HTRANS = 2'h3;
	@(negedge tb_clk);
	if(tb_sram_addr == 32'h00001111 && tb_read_addr == 1'b1) begin
		$info("ADDR state operation is correct.");
	end else begin
		$info("Wrong 1");
	end

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 128'h54776F204F6E65204E696E652054776F; // FIRST DATA
	
	@(negedge tb_clk);
	if(tb_read_addr == 1'b0) begin
		$info("DATAVALID state operation is correct.");
	end else begin
		$info("Wrong 1");
	end

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 128'h00112233445566778899AABBCCDDEEFF; // 2ND DATA
	
	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = '0; // 3RD DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = '1; // 4TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 128'h12345678912345678912345678912345; // 5TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 128'h4278b840fb44aaa757c1bf04acbe1a3e; // 6TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 128'h98765432198765432197865432198765; // 7TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 128'hA0B0C566D0F6F0A0C0E0E0F0A0B0D0E0; // 8TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 128'h156953b2feab2a04ae0180d8335bbed6; // 9TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 128'ha02600ecb8ea77625bba6641ed5f5920; // 10TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 128'h8d2e60365f17c7df1040d7501b4a7b5a; // 11TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE and DATA_DONE
	tb_HWDATA = 128'h2e586692e647f5028ec6fa47a55a2aab; // 12TH DATA
	//tb_data_done = 1'b1;

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 128'hfe586692e647f5028ec6fa47a55a2aab; // 13TH DATA
	tb_data_done = 1'b1;

	@(posedge tb_clk);
	tb_data_done = 1'b0;

	#400
	//tb_enable = 1'b0;

	if(tb_ready == 1'b1) begin
		$info("tb_ready correctly assertd.");
		tb_enable = 1'b0;
	end

// SETUP FOR DECRYPTION	
	tb_HWRITE = 1'b1;
	tb_HSELx = 1'b0;
	tb_HREADY = 1'b1;
	tb_HTRANS = 2'h2;

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	if(tb_ready == 1'b1) begin
		$info("Ready to start decryption.");
	end else begin
		$info("Wrong d0");
	end

	//Enable CCM
	tb_enable = 1'b1;
	tb_e_or_d = 1'b0;	
	
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	// IDLE STATE
	tb_HWRITE = 1'b1;
	tb_HSELx = 1'b1;
	tb_HREADY = 1'b1;
	tb_HTRANS = 2'h2;

	@(posedge tb_clk);
	tb_HWDATA = 128'he63915a859a456689463fa95aae196c2;
	// KEY STATE
	tb_HSELx = 1'b0; // our device has been deselected

	@(posedge tb_clk);
	// WAIT STATE
	//tb_start_op = 1'b1;

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
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(negedge tb_clk);
	$info("MASTER KEY EXPANDED HERE");	
	
	@(posedge tb_clk);
	// WAIT STATE
	//tb_start_op = 1'b1;

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
	@(posedge tb_clk);
	@(negedge tb_clk);
	$info("AUX KEY EXPANDED HERE");

	if(tb_irq == 1'b1) begin
		$info("IRQ correctly asserted.");
	end else begin
		$info("Wrong IRQ");
	end

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk); //waiting for irq_resp
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_irq_resp = 1'b1; // RESPOND

	@(posedge tb_clk);
	tb_irq_resp = 1'b0;

	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	@(posedge tb_clk);
	tb_HSELx = 1'b1; // irq has been serviced

	@(posedge tb_clk);
	// ADDR STATE AND DATA PHASE OF SRAM ADDRESS
	tb_HWDATA = 128'h0000000000000000000000000001111; // SRAM ADDRESS
	tb_HTRANS = 2'h3;
	@(negedge tb_clk);
	if(tb_sram_addr == 32'h00001111 && tb_read_addr == 1'b1) begin
		$info("ADDR state operation is correct.");
	end else begin
		$info("Wrong 1");
	end

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 129'h029c3505f571420f6402299b31a02d73a; // 2ND DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 129'h0e2d1ae4680bff46b8c787e0c2c6045a2; // 4TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 129'h0e552860c7dc16c93751251ea8eea8d95; // 5TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 129'h14fdfbc5d440a8ab4e0077627edb6d13e; // 6TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 129'h00bd1b01d1dc9079321468b6b6dc27a98; // 7TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 129'h0b4ee6359e7006f1baf13b16c26f95c45; // 8TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 129'h0863718bcf7c16845b92dbeab978b63b3; // 9TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 129'h06ea77d59c592a39142f0eaa70dce5b92; // 10TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 129'h039c2527ee5074856bbb2b719796a988d; // 11TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 129'h0f0f3d553a579210d8c4e0fcd221dd5de; // 12TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 129'h0da67c0cdf3c28c5a01063a1c0a117eee; // 13TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 129'h04592c207df80d3a57d716d45422888e7; // 14TH DATA

	@(posedge tb_clk);
	// DATAVALID STATE
	tb_HWDATA = 129'h09f9cd3d2cbf015dc447a32dd7a200fbf; // 15TH DATA*/
	tb_data_done = 1'b1;

	@(posedge tb_clk);
	tb_data_done = 1'b0;

	#400
	//tb_enable = 1'b0;

	if(tb_ready == 1'b1) begin
		$info("tb_ready correctly assertd.");
		tb_enable = 1'b0;
	end

end
endmodule
