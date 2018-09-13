// File name:   mixCol32.sv
// Created:     4/13/2018
// Author:      Samuale Yigrem
// Version:     1.0  Initial Design Entry
// Description: Performs the mixColumns operation of AES on a word (32 bits).
`timescale 1ns / 100ps

module mixCol32
(
	input logic [31:0] wordByte,
	output logic [31:0] mixCol32 
);

logic [31:0] multipliedBy2;

multiply2 X3 (
	.mixColByte(wordByte[31:24]), 
	.mulBy2(multipliedBy2[31:24])
);

multiply2 X2 (
	.mixColByte(wordByte[23:16]), 
	.mulBy2(multipliedBy2[23:16])
);

multiply2 X1 (
	.mixColByte(wordByte[15:8]), 
	.mulBy2(multipliedBy2[15:8])
);

multiply2 X0 (
	.mixColByte(wordByte[7:0]), 
	.mulBy2(multipliedBy2[7:0])
);

assign mixCol32[31:24] = (multipliedBy2[31:24] ^ (multipliedBy2[23:16] ^ wordByte[23:16])) ^ (wordByte[7:0] ^ wordByte[15:8]);
assign mixCol32[23:16] = (multipliedBy2[23:16] ^ (multipliedBy2[15:8] ^ wordByte[15:8])) ^ (wordByte[7:0] ^ wordByte[31:24]);
assign mixCol32[15:8] = (multipliedBy2[15:8] ^ (multipliedBy2[7:0] ^ wordByte[7:0])) ^ (wordByte[23:16] ^ wordByte[31:24]);
assign mixCol32[7:0] = (multipliedBy2[7:0] ^ (multipliedBy2[31:24] ^ wordByte[31:24])) ^ (wordByte[15:8] ^ wordByte[23:16]);

endmodule
