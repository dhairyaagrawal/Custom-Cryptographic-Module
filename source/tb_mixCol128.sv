// File name:   tb_mixCol128.sv
// Created:     4/13/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test bench for Mix Columns: 128 bit packet
`timescale 1ns / 100ps

module tb_mixCol128 ();

logic [127:0] out;
logic [127:0] tb_packet;

mixCol128 tester 
(
	.packet(tb_packet),
	.mixPacket(out)
);

initial begin
	#5
	tb_packet = 128'h6A4E988B59489E3DCB1230F4BDA09B9B;
	if(out == 128'h15CE8965C94D71477F4BBE979DC288CD) begin
		$info("IT WORKED");
	end
end

endmodule

