// $Id: $
// File name:   rcon.sv
// Created:     4/21/2018
// Author:      Dhairya Agrawal
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Round constant LUT for key scheduling (core)

module rcon
(
	input logic [3:0] roundNumber,
	output logic [7:0] out
);

	wire [7:0] rcon_table [9:0];

	assign rcon_table[4'h0] = 8'h01;
	assign rcon_table[4'h1] = 8'h02;
	assign rcon_table[4'h2] = 8'h04;
	assign rcon_table[4'h3] = 8'h08;
	assign rcon_table[4'h4] = 8'h10;
	assign rcon_table[4'h5] = 8'h20;
	assign rcon_table[4'h6] = 8'h40;
	assign rcon_table[4'h7] = 8'h80;
	assign rcon_table[4'h8] = 8'h1B;
	assign rcon_table[4'h9] = 8'h36;

	assign out = rcon_table[roundNumber];

endmodule
