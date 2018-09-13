// File name:   encryptionFull.sv
// Created:     4/18/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Full AES-128 Encryption module
`timescale 1ns / 100ps

module encryptionTemp
(
	input logic [1407:0] key,
	input logic [127:0] data,
	output logic [127:0] cipherData
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

keyAdd ROUND0
(
	.key(key[1407:1280]),
	.dataIn(data),
	.dataOut(round0)
);

encryptionRound ROUND1
(
	.key(key[1279:1152]),
	.data(round0),
	.enRound(round1)
);

encryptionRound ROUND2
(
	.key(key[1151:1024]),
	.data(round1),
	.enRound(round2)
);

encryptionRound ROUND3
(
	.key(key[1023:896]),
	.data(round2),
	.enRound(round3)
);

encryptionRound ROUND4
(
	.key(key[895:768]),
	.data(round3),
	.enRound(round4)
);

encryptionRound ROUND5
(
	.key(key[767:640]),
	.data(round4),
	.enRound(round5)
);

encryptionRound ROUND6
(
	.key(key[639:512]),
	.data(round5),
	.enRound(round6)
);

encryptionRound ROUND7
(
	.key(key[511:384]),
	.data(round6),
	.enRound(round7)
);

encryptionRound ROUND8
(
	.key(key[383:256]),
	.data(round7),
	.enRound(round8)
);

encryptionRound ROUND9
(
	.key(key[255:128]),
	.data(round8),
	.enRound(round9)
);

round10 ROUND10
(
	.key(key[127:0]),
	.data(round9),
	.enRound(cipherData)
);

endmodule
