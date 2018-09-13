// File name:   invShiftRows.sv
// Created:     4/21/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Performs the Inverse Shift Rows operation of AES-128
`timescale 1ns / 100ps

module invShiftRows
(
	input logic [127:0] packet,
	output logic [127:0] invShifted
);

assign invShifted[127:96] = {packet[127:120], packet[23:16], packet[47:40], packet[71:64]};
assign invShifted[95:64] = {packet[95:88], packet[119:112], packet[15:8], packet[39:32]};
assign invShifted[63:32] = {packet[63:56], packet[87:80], packet[111:104], packet[7:0]};
assign invShifted[31:0] = {packet[31:24], packet[55:48], packet[79:72], packet[103:96]};

endmodule
