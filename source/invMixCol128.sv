// File name:   invMixCol128.sv
// Created:     4/21/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Performs Inverse Mix Columns operation on 128 bits
`timescale 1ns / 100ps

module invMixCol128
(
	input logic [127:0] packet,
	output logic [127:0] invMixPacket
);

invMixCol32 X1
(
	.word(packet[127:96]),
	.mixed32(invMixPacket[127:96])
);

invMixCol32 X2
(
	.word(packet[95:64]),
	.mixed32(invMixPacket[95:64])
);

invMixCol32 X3
(
	.word(packet[63:32]),
	.mixed32(invMixPacket[63:32])
);

invMixCol32 X4
(
	.word(packet[31:0]),
	.mixed32(invMixPacket[31:0])
);

endmodule
