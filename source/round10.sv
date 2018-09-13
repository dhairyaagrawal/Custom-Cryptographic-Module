// File name:   round10.sv
// Created:     4/18/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Round 10 of AES-128
`timescale 1ns / 100ps

module round10
(
	input logic [127:0] key,
	input logic [128:0] data,
	output logic [128:0] enRound
);

logic [127:0] sboxMapped;
logic [127:0] shifted;

s_box_16 U1
(
	.in_data(data[127:0]),
	.out_data(sboxMapped)
);

shiftRows U2
(
	.afterSub(sboxMapped),
	.shifted(shifted)
);

keyAdd U3
(
	.key(key),
	.dataIn(shifted),
	.dataOut(enRound[127:0])
);

assign enRound[128] = data[128];

endmodule
