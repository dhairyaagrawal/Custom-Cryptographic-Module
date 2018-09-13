// File name:   round0.sv
// Created:     4/22/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: First round of Decryption: Special Round
`timescale 1ns / 100ps

module round0
(
	input logic [127:0] key,
	input logic [128:0] data,
	output logic [128:0] decRound
);

logic [127:0] invKeyAdd;
logic [127:0] invShifted;

keyAdd U1
(
	.key(key),
	.dataIn(data[127:0]),
	.dataOut(invKeyAdd)
);

invShiftRows U2
(
	.packet(invKeyAdd),
	.invShifted(invShifted)
);

inv_s_box_16 U3
(
	.in_data(invShifted),
	.out_data(decRound[127:0])
);

assign decRound[128] = data[128];

endmodule
