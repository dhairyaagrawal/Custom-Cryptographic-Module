// File name:   top_level.sv
// Created:     4/26/2018
// Author:      Dhairya Agrawal
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: top level file for CCM

`timescale 1ns / 100ps

module top_level
(
	input logic clk,
	input logic n_rst,
	
	input logic [1:0] HTRANS_SLAVE,
	input logic HWRITE_SLAVE,
	input logic HSELx,
	input logic HREADY_SLAVE,
	input logic [127:0] HWDATA_SLAVE,
	
	input logic enable,
	input logic irq_resp,
	input logic e_or_d,
	input logic data_done,
	
	//output logic HRESP,
	//output logic HREADYOUT,

	output logic irq,
	output logic ready,

	output logic HWRITE_MASTER,
	output logic [2:0] HBURST_MASTER,
	output logic [1:0] HTRANS_MASTER,
	output logic [31:0] HADDR,
	output logic [127:0] HWDATA_MASTER
);
	
	logic [128:0] data_in;
	logic read;
	logic [128:0] data;
	logic [127:0] key;
	logic r_ready;
	logic ed_sel;
	logic start_op;
	logic key_op;
	logic key_expanded;
	logic [31:0] sram_addr;
	logic read_addr;
	logic last_packet;
	logic aes_done;
	logic [128:0] data_out;

	ccu CCU
	(
		.clk(clk),
		.n_rst(n_rst),
		.enable(enable),
		.irq_resp(irq_resp),
		.e_or_d(e_or_d),
		.read(read),
		.data_done(data_done),
		.key_expanded(key_expanded),
		.aes_done(aes_done),
		.ed_sel(ed_sel),
		.start_op(start_op),
		.irq(irq),
		.key_op(key_op),
		.ready(ready)
	);
	
	AHB_slave SLAVE
	(
		.clk(clk),
		.n_rst(n_rst),
		.HTRANS(HTRANS_SLAVE),
		.HWRITE(HWRITE_SLAVE),
		.HSELx(HSELx),
		.HREADY(HREADY_SLAVE),
		.HWDATA(HWDATA_SLAVE),
		//.HRESP(HRESP),
		//.HREADYOUT(HREADYOUT),
		.data_in(data_in),
		.read(read),
		.sram_addr(sram_addr),
		.read_addr(read_addr),
		.last_packet(last_packet)
	);

	RCU RECEIVER
	(
		.clk(clk),
		.n_rst(n_rst),
		.read(read),
		.data_in(data_in),
		.key(key),
		.data(data),
		.r_ready(r_ready)
	);
	
	aes_core AESCORE
	(
		.clk(clk),
		.n_rst(n_rst),
		.data(data),
		.key(key),
		.key_op(key_op),
		.r_ready(r_ready),
		.ed_sel(ed_sel),
		.start_op(start_op),
		.key_expanded(key_expanded),
		.aes_done(aes_done),
		.data_out(data_out)
	);

	AHB_master DUT(
		.clk(clk),
		.n_rst(n_rst),
		.ed_sel(ed_sel),
		.aes_done(aes_done),
		.last_packet(last_packet),
		.read_addr(read_addr),
		.sram_addr(sram_addr),
		.data_out(data_out),
		.HWRITE(HWRITE_MASTER),
		.HBURST(HBURST_MASTER),
		.HTRANS(HTRANS_MASTER),
		.HADDR(HADDR),
		.HWDATA(HWDATA_MASTER)
	);

endmodule
