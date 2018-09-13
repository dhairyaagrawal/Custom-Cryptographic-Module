// $Id: $
// File name:   rom.sv
// Created:     4/24/2018
// Author:      Ryan Devlin
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: ROM to hold the Master Private Key.
`timescale 1ns / 100ps

module rom(
	output wire [127 : 0] mk_key
);
	assign mk_key = 128'h6265657062656570606574747563652e;
	//assign mk_key = 128'h000102030405060708090a0b0c0d0e0f;
endmodule
