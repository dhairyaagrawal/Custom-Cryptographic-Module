// File name:   shiftRows.sv
// Created:     4/16/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Performs the Shift Rows operation on 128 bits of data for AES Encryption
`timescale 1ns / 100ps

module shiftRows
(
	input logic [127:0] afterSub,
	output logic [127:0] shifted
);

assign shifted[127:96] = {afterSub[127:120], afterSub[87:80], afterSub[47:40], afterSub[7:0]};
assign shifted[95:64] = {afterSub[95:88], afterSub[55:48], afterSub[15:8], afterSub[103:96]};
assign shifted[63:32] = {afterSub[63:56], afterSub[23:16], afterSub[111:104], afterSub[71:64]};
assign shifted[31:0] = {afterSub[31:24], afterSub[119:112], afterSub[79:72], afterSub[39:32]};

endmodule
