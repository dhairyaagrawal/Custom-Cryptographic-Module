// File name:   tb_encryptionRound.sv
// Created:     4/17/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test bench for 1 round of standard aes-128
`timescale 1ns / 100ps

module tb_encryptionRound();

logic [127:0] out;
logic [127:0] tb_key;
logic [127:0] tb_data;

encryptionRound X1
(
	.key(tb_key),
	.data(tb_data),
	.enRound(out)
);

initial begin
	#5;
	tb_key = 128'hE232FCF191129188B159E4E6D679A293;	
	tb_data = 128'h001F0E543C4E08596E221B0B4774311A;
	#5;
	if(out == 128'h5847088B15B61CBA59D4E2E8CD39DFCE) begin
		$info("It worked.");
	end
end

endmodule
