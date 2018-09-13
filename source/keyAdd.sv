// File name:   keyAdd.sv
// Created:     4/17/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Key Addition for AES-128
`timescale 1ns / 100ps

module keyAdd
(
	input logic [127:0] key,
	input logic [127:0] dataIn,
	output logic [127:0] dataOut	
);

assign dataOut = key ^ dataIn;
//assign dataOut[128] = dataIn[128];

endmodule
