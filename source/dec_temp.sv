// File name:   decryptionFull.sv
// Created:     4/22/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Full Decryption rounds for AES-128
`timescale 1ns / 100ps

module decryptionFull
(
	input logic [1407:0] key,
	input logic [127:0] data,
	output logic [127:0] plainText
);

logic [127:0] round0;
logic [127:0] round1;
logic [127:0] round2;
logic [127:0] round3;
logic [127:0] round4;
logic [127:0] round5;
logic [127:0] round6;
logic [127:0] round7;
logic [127:0] round8;
logic [127:0] round9;

round0 ROUND0
(
	.key(key[127:0]),
	.data(data),
	.decRound(round0)
);

decryptionRound ROUND1
(
	.key(key[255:128]),
	.data(round0),
	.decRound(round1)
);

decryptionRound ROUND2
(
	.key(key[383:256]),
	.data(round1),
	.decRound(round2)
);

decryptionRound ROUND3
(
	.key(key[511:384]),
	.data(round2),
	.decRound(round3)
);

decryptionRound ROUND4
(
	.key(key[639:512]),
	.data(round3),
	.decRound(round4)
);

decryptionRound ROUND5
(
	.key(key[767:640]),
	.data(round4),
	.decRound(round5)
);

decryptionRound ROUND6
(
	.key(key[895:768]),
	.data(round5),
	.decRound(round6)
);

decryptionRound ROUND7
(
	.key(key[1023:896]),
	.data(round6),
	.decRound(round7)
);

decryptionRound ROUND8
(
	.key(key[1151:1024]),
	.data(round7),
	.decRound(round8)
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
	.dataIn(round9),
	.dataOut(plainText)
); 

endmodule
