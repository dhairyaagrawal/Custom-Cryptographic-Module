// File name:   multiplyC.sv
// Created:     4/21/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Multiplication by C (12) in Galois Field for Inverse Mix Columns operation
`timescale 1ns / 100ps

module multiplyC
(
	input logic [7:0] invMixColByte,
	output logic [7:0] mulByC
);

logic [7:0] mul4;
logic [7:0] mul8;

multiply4 B1
(
	.invMixColByte(invMixColByte),
	.mulBy4(mul4)
);

multiply8 B2
(
	.invMixColByte(invMixColByte),
	.mulBy8(mul8)
);

assign mulByC = mul4 ^ mul8;

endmodule
