// File name:   tb_aesEncryption.sv
// Created:     4/16/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Full testbench for AES-128 algorithm
`timescale 1ns / 100ps

module tb_aesEncryption ();

logic [127:0] out;

aesEncryption ae
(
	.packet(0'h63C0AB20EB2F30CB9F93AF2BA092C7A2),
	.encryptedPacket(out)
);

initial begin
	# 5
	if (out == 0'hBA75F47A84A48D32E88D060E1B407D5D) begin
		$info("IT WORKED");
	end
end

endmodule
