// $Id: $
// File name:   keyScheduleCore.sv
// Created:     4/21/2018
// Author:      Dhairya Agrawal
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: perform the core operations of key scheduling to produr a new 16 byte key

module keyScheduleCore
(
	input logic [31:0] inputWord,
	input logic [3:0] roundNumber,
	output logic [31:0] outputWord
);
	logic [31:0] rotate;
	logic [31:0] sboxMapped;
	logic [7:0] roundConstant;

	assign rotate = {inputWord[23:0], inputWord[31:24]};
	s_box_4 U1 (.in_data(rotate), .out_data(sboxMapped));
	rcon U2 (.roundNumber(roundNumber), .out(roundConstant));
	
	assign outputWord = sboxMapped ^ {roundConstant,24'b0};	

endmodule
