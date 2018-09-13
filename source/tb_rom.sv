// $Id: $
// File name:   tb_rom.sv
// Created:     4/24/2018
// Author:      Ryan Devlin
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Testbench for ROM.
`timescale 1ns / 100ps

module tb_rom();

logic [127 : 0] out_put;

// Portmap
rom ROM(
	.mk_key(out_put)
);

initial begin
	#10
	if(out_put == 128'h6265657062656570606574747563652e) begin
		$info("ROM correct.");
	end else begin
		$info("Wrong:(");
	end
end

endmodule
