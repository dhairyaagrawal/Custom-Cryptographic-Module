// $Id: $
// File name:   aes_core.sv
// Created:     4/24/2018
// Author:      Ryan Devlin
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: The top level module for the AES encryption block.
`timescale 1ns / 100ps

module aes_core(
	input wire clk,
	input logic n_rst,
	input logic [128:0] data,
	input logic [127:0] key,
	input logic key_op,
	input logic r_ready,
	input logic ed_sel,
	input logic start_op,
	output logic key_expanded,
	output logic aes_done,
	output logic [128:0] data_out	
);
// -- Variable Declarations -- //
	logic [127:0] master_key;
	logic [127:0] current_key;
	logic [127:0] e_key;
	logic [127:0] d_key;
	logic [128:0] e_data;
	logic [128:0] d_data;
	logic [128:0] cipher_data;
	logic [128:0] plaintext_data;
	logic e_start_key_exp;
	logic d_start_key_exp;
	logic en_done;
	logic dec_done;
	logic start_key_exp;
	logic [1407:0] exp_key;

// -- Generate Portmaps -- //
	assign master_key = 128'h6265657062656570606574747563652e;

	ECU ACTUAL_ECU(
		.clk(clk),
		.n_rst(n_rst),
		.start_op(start_op),
		.ed_sel(ed_sel),
		.r_ready(r_ready),
		.key_op(key_op),
		.key_expanded(key_expanded),
		.data_in(data),
		.key_in(key),
		.mk_key(master_key),
		.e_data(e_data),
		.e_key(e_key),
		.start_key_exp(e_start_key_exp),
		.en_done(en_done)
	);

	DCU ACTUAL_DCU(
		.clk(clk),
		.n_rst(n_rst),
		.start_op(start_op),
		.ed_sel(ed_sel),
		.r_ready(r_ready),
		.key_op(key_op),
		.key_expanded(key_expanded),
		.data_in(data),
		.key_in(key),
		.mk_key(master_key),
		.plaintext_data(plaintext_data),
		.start_key_exp(d_start_key_exp),
		.dec_done(dec_done),
		.d_data(d_data),
		.d_key(d_key)
	);

	assign current_key = (ed_sel == 1'b1) ? e_key : d_key;
	assign start_key_exp = (ed_sel == 1'b1) ? e_start_key_exp : d_start_key_exp;

	key_expansion KEY_EXPANSION
	(
		.clk(clk),
		.n_rst(n_rst),
		.start_key_exp(start_key_exp),
		.key(current_key),
		.key_expanded(key_expanded),
		.exp_key(exp_key)
	);


	encryptionFull ENCRYPTIONFULL
	(
		.clk(clk),
		.n_rst(n_rst),
		.key(exp_key),
		.data(e_data),
		.cipherData(cipher_data)
	);

	decryptionFull DECRYPTIONFULL
	(
		.clk(clk),
		.n_rst(n_rst),
		.key(exp_key),
		.data(d_data),
		.plainText(plaintext_data)
	);
	
	logic ed_sel_reg;

	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0) begin
			ed_sel_reg <= 1'b0;
		end else begin
			ed_sel_reg <= ed_sel;
		end
	end

	assign data_out = (ed_sel_reg == 1'b1) ? cipher_data : plaintext_data;
	assign aes_done = en_done ^ dec_done;

endmodule
	
