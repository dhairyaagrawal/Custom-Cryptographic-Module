// File name:   decryptionRound.sv
// Created:     4/22/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Standard Round for AES-128 decryption
`timescale 1ns / 100ps

module decryptionRound
(
	input logic [127:0] key,
	input logic [128:0] data,
	output logic [128:0] decRound
);

logic [127:0] invShifted;
logic [127:0] invMix;
logic [127:0] invKeyAdd;

keyAdd X1
(
	.key(key),
	.dataIn(data[127:0]),
	.dataOut(invKeyAdd)
);

invMixCol128 X2
(
	.packet(invKeyAdd),
	.invMixPacket(invMix)
);

invShiftRows X3
(
	.packet(invMix),
	.invShifted(invShifted)
);

inv_s_box_16 X4
(
	.in_data(invShifted),
	.out_data(decRound[127:0])
);

assign decRound[128] = data[128];

/*
invShiftRows X1
(
	.packet(data),
	.invShifted(invShifted)
);

inv_s_box_16 X2
(
	.in_data(invShifted),
	.out_data(invByteSub)
);

keyAdd X3
(
	.key(key),
	.dataIn(invByteSub),
	.dataOut(invKeyAdd)
);

invMixCol128 X4
(
	.packet(invKeyAdd),
	.invMixPacket(decRound)
);
*/

endmodule
