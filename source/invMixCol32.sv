// File name:   invMixCol32.sv
// Created:     4/21/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Performs the Inverse Mix Columns operation on 32 bits
`timescale 1ns / 100ps

module invMixCol32
(
	input logic [31:0] word,
	output logic [31:0] mixed32
);

logic [31:0] firstMul;
logic [31:0] mul8s;
logic [31:0] mulCs;
logic [31:0] secMul;

logic [31:0] word31rows;
logic [31:0] word20rows;

mixCol32 U1
(
	.wordByte(word),
	.mixCol32(firstMul)
);

multiply8 U2
(
	.invMixColByte(word[31:24]),
	.mulBy8(mul8s[31:24])
);

multiply8 U3
(
	.invMixColByte(word[23:16]),
	.mulBy8(mul8s[23:16])
);

multiply8 U4
(
	.invMixColByte(word[15:8]),
	.mulBy8(mul8s[15:8])
);

multiply8 U5
(
	.invMixColByte(word[7:0]),
	.mulBy8(mul8s[7:0])
);

multiplyC U6
(
	.invMixColByte(word[31:24]),
	.mulByC(mulCs[31:24])
);

multiplyC U7
(
	.invMixColByte(word[23:16]),
	.mulByC(mulCs[23:16])
);

multiplyC U8
(
	.invMixColByte(word[15:8]),
	.mulByC(mulCs[15:8])
);

multiplyC U9
(
	.invMixColByte(word[7:0]),
	.mulByC(mulCs[7:0])
);

assign word31rows = mulCs[31:24] ^ mul8s[23:16] ^ mulCs[15:8] ^ mul8s[7:0];
assign word20rows = mul8s[31:24] ^ mulCs[23:16] ^ mul8s[15:8] ^ mulCs[7:0];

assign secMul[31:24] = word31rows;
assign secMul[23:16] = word20rows;
assign secMul[15:8] = word31rows;
assign secMul[7:0] = word20rows;

assign mixed32 = firstMul ^ secMul;

endmodule
