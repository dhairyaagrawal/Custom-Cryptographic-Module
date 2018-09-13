// File name:   tb_invShiftRows.sv
// Created:     4/22/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test bench for the inverse shift rows operation on AES-128
`timescale 1ns / 100ps

module tb_invShiftRows ();

logic [127:0] out;

invShiftRows test
(
	.packet(128'h632FAFA2EB93C7209F92ABCBA0C0302B),
	.invShifted(out)
);

initial begin
	# 5
	if(out == 128'h63C0AB20EB2F30CB9F93AF2BA092C7A2) begin	
		$info("IT WORKED");
	end
end

endmodule
