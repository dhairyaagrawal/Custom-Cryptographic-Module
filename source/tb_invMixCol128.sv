// File name:   tb_invMixCol128.sv
// Created:     4/21/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test bench for Inverse Mix Columns operation on 128 bits
`timescale 1ns / 100ps

module tb_invMixCol128 ();

logic [127:0] tb_packet;
logic [127:0] out;

invMixCol128 tester
(
	.packet(tb_packet),
	.invMixPacket(out)
);

initial begin
	#5
	tb_packet = 128'hBA75F47A84A48D32E88D060E1B407D5D;
	#2
	if(out == 128'h632FAFA2EB93C7209F92ABCBA0C0302B) begin
		$info("IT WORKED");
	end else begin
		$info("Wrong 1");
	end

	tb_packet = 128'h10d85324bc94ea40d3e09e73f3e0257b;
	#2
	if(out == 128'hbc389aa151eb1820ee120426b338ff39) begin
		$info("IT WORKED");
	end else begin
		$info("Wrong 4");
	end

	tb_packet = 128'h2a781b5b261ea7628f0c6f00e97a0a3f;
	#2
	if(out == 128'hc8b0ddb730c85055f237d1f894742066) begin
		$info("IT WORKED");
	end else begin
		$info("Wrong 5");
	end

	tb_packet = 128'ha9aee7f037d86cfdaa0cb167f2219c3b;
	#2
	if(out == 128'h14cf7ab1269c81454c07b78c15d19323) begin
		$info("IT WORKED");
	end else begin
		$info("Wrong 6");
	end

	tb_packet = 128'h9faf634b37ec39fb518c04b137fa66d7;
	#2
	if(out == 128'hfa49369d73d04ff5ba763f9b58dcf109) begin
		$info("IT WORKED");
	end else begin
		$info("Wrong 7");
	end

	tb_packet = 128'he874d3558a751f8a4bee750cf5e65838;
	#2
	if(out == 128'hed6fe27a1a675b4c840019419712dc2a) begin
		$info("IT WORKED");
	end else begin
		$info("Wrong 8");
	end

	tb_packet = 128'hb68434e8e78860d7519866708ccafb51;
	#2
	if(out == 128'h338b762051667d92798febc20a3fbe67) begin
		$info("IT WORKED");
	end else begin
		$info("Wrong 9");
	end
end

endmodule
