// File name:   ahb_rcu_core.sv
// Created:     4/26/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: top level file for testing rcu aes core and ahb slave
`timescale 1ns / 100ps

module ahb_rcu_core
(
	input logic clk,
	input logic n_rst,
	input logic [1:0] HTRANS,
	input logic HWRITE,
	input logic HSELx,
	input logic HREADY,
	input logic [127:0] HWDATA,
	input logic enable,
	input logic irq_resp,
	input logic e_or_d,
	input logic data_done,
	output logic HRESP,
	output logic HREADYOUT,
	output logic [31:0] sram_addr,
	output logic read_addr,
	output logic last_packet,
	output logic aes_done,
	output logic [128:0] data_out,
	output logic irq,
	output logic ready
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
	.HTRANS(HTRANS),
	.HWRITE(HWRITE),
	.HSELx(HSELx),
	.HREADY(HREADY),
	.HWDATA(HWDATA),
	.HRESP(HRESP),
	.HREADYOUT(HREADYOUT),
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

endmodule
