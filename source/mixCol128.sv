// File name:   mixCol128.sv
// Created:     4/13/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Performs mixCol operation on all 128 bits (1 packet).
`timescale 1ns / 100ps

module mixCol128
(
	input logic [127:0] packet,
	output logic [127:0] mixPacket
);

mixCol32 M3 (
	.wordByte(packet[127:96]),
	.mixCol32(mixPacket[127:96])
);

mixCol32 M2 (
	.wordByte(packet[95:64]),
	.mixCol32(mixPacket[95:64])	
);

mixCol32 M1 (
	.wordByte(packet[63:32]),
	.mixCol32(mixPacket[63:32])
);

mixCol32 M0 (
	.wordByte(packet[31:0]),
	.mixCol32(mixPacket[31:0])
);

endmodule
