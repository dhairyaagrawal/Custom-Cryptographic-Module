// File name:   tb_shiftRows.sv
// Created:     4/16/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test bench for Shift Rows operation of AES
`timescale 1ns / 100ps

module tb_shiftRows ();

logic [127:0] out;

shiftRows test
(
	.afterSub(128'h63C0AB20EB2F30CB9F93AF2BA092C7A2),
	.shifted(out)
);

initial begin
	# 5
	if(out == 128'h632FAFA2EB93C7209F92ABCBA0C0302B) begin	
		$info("IT WORKED");
	end
end

endmodule
