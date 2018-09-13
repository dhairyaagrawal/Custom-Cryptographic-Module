// File name:   encryptionFull.sv
// Created:     4/18/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Full AES-128 Encryption module
`timescale 1ns / 100ps

module encryptionFull
(
	input wire clk,
	input logic n_rst,
	input logic [1407:0] key,
	input logic [128:0] data,
	output logic [128:0] cipherData
);

logic [128:0] round0;
logic [128:0] next_round1, round1;
logic [128:0] next_round2, round2;
logic [128:0] next_round3, round3;
logic [128:0] next_round4, round4;
logic [128:0] next_round5, round5;
logic [128:0] next_round6, round6;
logic [128:0] next_round7, round7;
logic [128:0] next_round8, round8;
logic [128:0] next_round9, round9;
logic [128:0] next_round10;

keyAdd ROUND0
(
	.key(key[1407:1280]),
	.dataIn(data[127:0]),
	.dataOut(round0[127:0])
);

assign round0[128] = data[128];

encryptionRound ROUND1
(
	.key(key[1279:1152]),
	.data(round0),
	.enRound(next_round1)
);

encryptionRound ROUND2
(
	.key(key[1151:1024]),
	.data(round1),
	.enRound(next_round2)
);

encryptionRound ROUND3
(
	.key(key[1023:896]),
	.data(round2),
	.enRound(next_round3)
);

encryptionRound ROUND4
(
	.key(key[895:768]),
	.data(round3),
	.enRound(next_round4)
);

encryptionRound ROUND5
(
	.key(key[767:640]),
	.data(round4),
	.enRound(next_round5)
);

encryptionRound ROUND6
(
	.key(key[639:512]),
	.data(round5),
	.enRound(next_round6)
);

encryptionRound ROUND7
(
	.key(key[511:384]),
	.data(round6),
	.enRound(next_round7)
);

encryptionRound ROUND8
(
	.key(key[383:256]),
	.data(round7),
	.enRound(next_round8)
);

encryptionRound ROUND9
(
	.key(key[255:128]),
	.data(round8),
	.enRound(next_round9)
);

round10 ROUND10
(
	.key(key[127:0]),
	.data(round9),
	.enRound(next_round10)
);

always_ff @ (posedge clk, negedge n_rst) begin
	if(n_rst == 1'b0) begin
		round1 <= '0;
		round2 <= '0;
		round3 <= '0;
		round4 <= '0;
		round5 <= '0;
		round6 <= '0;
		round7 <= '0;
		round8 <= '0;
		round9 <= '0;
		cipherData <= '0;
	end
	else begin
		round1 <= next_round1;
		round2 <= next_round2;
		round3 <= next_round3;
		round4 <= next_round4;
		round5 <= next_round5;
		round6 <= next_round6;
		round7 <= next_round7;
		round8 <= next_round8;
		round9 <= next_round9;
		cipherData <= next_round10;
	end
end

endmodule
