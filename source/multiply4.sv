// File name:   multiply4.sv
// Created:     4/21/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Multiply by 4 in Galois Field for Inverse Mix Columns operation of AES
`timescale 1ns / 100ps

module multiply4
(
	input logic [7:0] invMixColByte,
	output logic [7:0] mulBy4
);

logic [7:0] temp;

multiply2 A1
(
	.mixColByte(invMixColByte),
	.mulBy2(temp)
);

multiply2 A2
(
	.mixColByte(temp),
	.mulBy2(mulBy4)
);	

endmodule
