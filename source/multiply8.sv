// File name:   multiply8.sv
// Created:     4/21/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Multiply by 8 in Galois Field for Inverse mix Columns op
`timescale 1ns / 100ps

module multiply8
(
	input logic [7:0] invMixColByte,
	output logic [7:0] mulBy8
);

logic [7:0] temp;

multiply2 A1
(
	.mixColByte(invMixColByte),
	.mulBy2(temp)
);

multiply4 A2
(
	.invMixColByte(temp),
	.mulBy4(mulBy8)
);

endmodule
