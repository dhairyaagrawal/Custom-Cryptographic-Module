// File name:   multiply.sv
// Created:     4/12/2018
// Author:      Samuale Yigrem
// Version:     1.0  Initial Design Entry
// Description: Multiplies and corrects by 02 in the MixColumns operation of AES.
`timescale 1ns / 100ps

module multiply2
(
	input logic [7:0] mixColByte,
	output logic [7:0] mulBy2
);

assign mulBy2 = {mixColByte[6:4], mixColByte[3] ^ mixColByte[7], mixColByte[2] ^ mixColByte[7], mixColByte[1], mixColByte[0] ^ mixColByte[7], mixColByte[7]};

endmodule
