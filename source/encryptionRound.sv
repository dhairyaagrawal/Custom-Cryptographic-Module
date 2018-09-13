// File name:   encryptionRound.sv
// Created:     4/17/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Standard Round of AES-128 encryption
`timescale 1ns / 100ps

module encryptionRound
(
	input logic [127:0] key,
	input logic [128:0] data,
	output logic [128:0] enRound
);

logic [127:0] sboxMapped;
logic [127:0] shifted;
logic [127:0] mixed;

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

mixCol128 U3
(
	.packet(shifted),
	.mixPacket(mixed)
);

keyAdd U4
(
	.key(key),
	.dataIn(mixed),
	.dataOut(enRound[127:0])
);

assign enRound[128] = data[128]; 

endmodule
