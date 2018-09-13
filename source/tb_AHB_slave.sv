// File name:   tb_AHB_slave.sv
// Created:     4/25/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: test bench for AHB_slave module
`timescale 1ns / 100ps

module tb_AHB_slave ();

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
logic tb_HRESP;
logic tb_HREADYOUT;
logic [128:0] tb_data_in;
logic tb_read;
logic [31:0] tb_sram_addr;
logic tb_read_addr;
logic tb_last_packet;

AHB_slave DUT
(
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.HTRANS(tb_HTRANS),
	.HWRITE(tb_HWRITE),
	.HSELx(tb_HSELx),
	.HREADY(tb_HREADY),
	.HWDATA(tb_HWDATA),
	.HRESP(tb_HRESP),
	.HREADYOUT(tb_HREADYOUT),
	.data_in(tb_data_in),
	.read(tb_read),
	.sram_addr(tb_sram_addr),
	.read_addr(tb_read_addr),
	.last_packet(tb_last_packet)
);

initial begin
	// Device initialization
	tb_HTRANS = '0;
	tb_HWRITE = 1'b0;
	tb_HSELx = 1'b0;
	tb_HREADY = 1'b0;
	tb_HWDATA = 128'h5468617473206D79204B756E67204675;

	// Device Under Test reset
	tb_n_rst = 1;
	@(posedge tb_clk);
	tb_n_rst = 0;
	@(posedge tb_clk);
	tb_n_rst = 1;
	@(posedge tb_clk);

	tb_HWRITE = 1'b1;
	tb_HSELx = 1'b1;
	tb_HREADY = 1'b1;
	tb_HTRANS = 2'h2;
	@(posedge tb_clk);
	@(negedge tb_clk);
	
	// KEY STATE
	if(tb_data_in == {1'b0, tb_HWDATA} && tb_read == 1'b1) begin
		$info("KEY state operation is correct.");
	end else begin
		$info("Wrong 0");
	end
	
	@(posedge tb_clk);
	@(negedge tb_clk);

	// WAIT STATE
	if(tb_read == 1'b0) begin
		$info("read signal is correctly deasserted");
	end else begin
		$info("Wrong 1");
	end
	
	tb_HWDATA = 128'h0000000000000000000000000000ffff;
	@(posedge tb_clk);
	@(negedge tb_clk);

	// ADDR STATE
	if(tb_sram_addr == tb_HWDATA[31:0] && tb_read_addr == 1'b1) begin
		$info("ADDR state operation is correct.");
	end else begin
		$info("Wrong 2");
	end

	tb_HTRANS = 2'h3;
	tb_HWDATA = 128'h54776F204F6E65204E696E652054776F;
	@(posedge tb_clk);
	@(negedge tb_clk);

	// DATAVALID STATE
	if(tb_data_in == {1'b0, tb_HWDATA} && tb_read == 1'b1 && tb_read_addr == 1'b0) begin
		$info("DATAVALID state operation is correct.");
	end else begin
		$info("Wrong 3");
	end
	
	tb_HTRANS = 2'h1;
	tb_HWDATA = 128'h00112233445566778899AABBCCDDEEFF;
	@(posedge tb_clk);
	@(negedge tb_clk);

	// BUSY STATE
	if(tb_data_in == {1'b1, tb_HWDATA} && tb_read == 1'b1 && tb_read_addr == 1'b0) begin
		$info("BUSY state operation is correct.");
	end else begin
		$info("Wrong 4");
	end
	
	tb_HTRANS = 2'h3;
	tb_HWDATA = 128'h12345678912345678912345678912345;
	@(posedge tb_clk);
	@(negedge tb_clk);

	// DATAVALID STATE
	if(tb_data_in == {1'b0, tb_HWDATA} && tb_read == 1'b1 && tb_read_addr == 1'b0) begin
		$info("DATAVALID state operation is correct.");
	end else begin
		$info("Wrong 5");
	end

	tb_HSELx = 1'b0;
	@(posedge tb_clk);
	@(negedge tb_clk);

	// IDLE STATE
	if(tb_last_packet == 1'b1 && tb_read == 1'b0 && tb_read_addr == 1'b0) begin
		$info("IDLE state operation is correct.");
	end else begin
		$info("Wrong 6");
	end

	tb_HWRITE = 1'b1;
	tb_HSELx = 1'b1;
	tb_HREADY = 1'b1;
	tb_HTRANS = 2'h2;
	tb_HWDATA = 128'h5468617473206D79204B756E67204675;
	@(posedge tb_clk);
	@(negedge tb_clk);
	
	// KEY STATE
	if(tb_data_in == {1'b0, tb_HWDATA} && tb_read == 1'b1 && tb_last_packet == 1'b0) begin
		$info("KEY state operation is correct.");
	end else begin
		$info("Wrong 7");
	end
	
	@(posedge tb_clk);
	@(negedge tb_clk);

	// WAIT STATE
	if(tb_read == 1'b0) begin
		$info("read signal is correctly deasserted");
	end else begin
		$info("Wrong 8");
	end

	tb_HWDATA = 128'h000000000000000000000000000027da;
	@(posedge tb_clk);
	@(negedge tb_clk);

	// ADDR STATE
	if(tb_sram_addr == tb_HWDATA[31:0] && tb_read_addr == 1'b1) begin
		$info("ADDR state operation is correct.");
	end else begin
		$info("Wrong 9");
	end

	tb_HWDATA = '1;
	tb_HTRANS = 2'h1;
	@(posedge tb_clk);
	@(negedge tb_clk);
	
	// BUSY STATE
	if(tb_data_in == {1'b1, tb_HWDATA} && tb_read == 1'b1 && tb_read_addr == 1'b0) begin
		$info("BUSY state operation is correct.");
	end else begin
		$info("Wrong 10");
	end
	
	tb_HWDATA = 128'h8d2e60365f17c7df1040d7501b4a7b5a;
	tb_HTRANS = 2'h3;
	@(posedge tb_clk);
	@(negedge tb_clk);
	
	// DATAVALID STATE
	if(tb_data_in == {1'b0, tb_HWDATA} && tb_read == 1'b1 && tb_read_addr == 1'b0) begin
		$info("DATAVALID state operation is correct.");
	end else begin
		$info("Wrong 11");
	end

	tb_HWDATA = 128'h8d2e60365f17c7df1040d7501b4a7b5a;
	tb_HWRITE = 1'b0;
	@(posedge tb_clk);
	@(negedge tb_clk);
	
	// IDLE STATE
	if(tb_last_packet == 1'b1 && tb_read == 1'b0 && tb_read_addr == 1'b0) begin
		$info("IDLE state operation is correct.");
	end else begin
		$info("Wrong 12");
	end		
end

endmodule
 
