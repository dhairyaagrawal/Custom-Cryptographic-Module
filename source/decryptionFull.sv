// File name:   decryptionFull.sv
// Created:     4/22/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Full Decryption rounds for AES-128
`timescale 1ns / 100ps

module decryptionFull
(
	input wire clk,
	input logic n_rst,
	input logic [1407:0] key,
	input logic [128:0] data,
	output logic [128:0] plainText
);

logic [128:0] next_round0, round0;
logic [128:0] next_round1, round1;
logic [128:0] next_round2, round2;
logic [128:0] next_round3, round3;
logic [128:0] next_round4, round4;
logic [128:0] next_round5, round5;
logic [128:0] next_round6, round6;
logic [128:0] next_round7, round7;
logic [128:0] next_round8, round8;
logic [128:0] round9;
logic [128:0] next_plain_text;

round0 ROUND0
(
	.key(key[127:0]),
	.data(data),
	.decRound(next_round0)
);

decryptionRound ROUND1
(
	.key(key[255:128]),
	.data(round0),
	.decRound(next_round1)
);

decryptionRound ROUND2
(
	.key(key[383:256]),
	.data(round1),
	.decRound(next_round2)
);

decryptionRound ROUND3
(
	.key(key[511:384]),
	.data(round2),
	.decRound(next_round3)
);

decryptionRound ROUND4
(
	.key(key[639:512]),
	.data(round3),
	.decRound(next_round4)
);

decryptionRound ROUND5
(
	.key(key[767:640]),
	.data(round4),
	.decRound(next_round5)
);

decryptionRound ROUND6
(
	.key(key[895:768]),
	.data(round5),
	.decRound(next_round6)
);

decryptionRound ROUND7
(
	.key(key[1023:896]),
	.data(round6),
	.decRound(next_round7)
);

decryptionRound ROUND8
(
	.key(key[1151:1024]),
	.data(round7),
	.decRound(next_round8)
);

decryptionRound ROUND9
(
	.key(key[1279:1152]),
	.data(round8),
	.decRound(round9)
);

keyAdd DECRYPT
(
	.key(key[1407:1280]),
	.dataIn(round9[127:0]),
	.dataOut(next_plain_text[127:0])
);

assign next_plain_text[128] = round9[128];

always_ff @ (posedge clk, negedge n_rst) begin
	if(n_rst == 0) begin
		round0 <= '0;
		round1 <= '0;
		round2 <= '0;
		round3 <= '0;
		round4 <= '0;
		round5 <= '0;
		round6 <= '0;
		round7 <= '0;
		round8 <= '0;
		plainText <= '0;
	end
	else begin
		round0 <= next_round0;
		round1 <= next_round1;
		round2 <= next_round2;
		round3 <= next_round3;
		round4 <= next_round4;
		round5 <= next_round5;
		round6 <= next_round6;
		round7 <= next_round7;
		round8 <= next_round8;
		plainText <= next_plain_text;
	end
end

endmodule
