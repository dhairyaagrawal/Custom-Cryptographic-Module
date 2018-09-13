// $Id: $
// File name:   ECU.sv
// Created:     4/23/2018
// Author:      Ryan Devlin
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Encryption Control Unit to control encryption logic.
`timescale 1ns / 100ps

module ECU
(
	input wire clk,
	input logic n_rst,
	input logic start_op,
	input logic ed_sel,
	input logic r_ready,
	input logic key_op,
	input logic key_expanded,
	input logic [128:0] data_in,
	input logic [127:0] key_in,
	input logic [127:0] mk_key,
	output logic [128:0] e_data,
	output logic [127:0] e_key,
	output logic start_key_exp,
	output logic en_done
);
	
typedef enum bit [4:0] {IDLE, DATA_OP, KEY_EXP, LOW_KEY, WAIT1, WAIT2, WAIT3, WAIT4, WAIT5, WAIT6, WAIT7, WAIT8, WAIT9, WAIT10, KEY_OP, MK_EXP, WAIT11, WAIT12, WAIT13, WAIT14, WAIT15, WAIT16, WAIT17, WAIT18, WAIT19, WAIT20} stateType;
stateType state, next_state;
	
always_ff @ (posedge clk, negedge n_rst)
begin
	if(n_rst == 1'b0) begin
		state <= IDLE;
	end else begin
		state <= next_state;
	end
end

always_comb begin 
	next_state = state;

	case(state)
	IDLE: begin
		if((start_op == 1'b1) && (ed_sel == 1'b1)) begin
			next_state = DATA_OP;
		end	
	end
	DATA_OP: begin
		next_state = KEY_EXP;
	end
	KEY_EXP: begin
		if(key_expanded == 1'b1) begin
			next_state = LOW_KEY;
		end
	end
	LOW_KEY: begin
		if(r_ready == 1'b1) begin
			next_state = WAIT1;
		end
	end
	WAIT1: begin
		next_state = WAIT2;
	end
	WAIT2: begin
		next_state = WAIT3;
	end
	WAIT3: begin
		next_state = WAIT4;
	end
	WAIT4: begin
		next_state = WAIT5;
	end
	WAIT5: begin
		next_state = WAIT6;
	end
	WAIT6: begin
		next_state = WAIT7;
	end
	WAIT7: begin
		next_state = WAIT8;
	end
	WAIT8: begin
		next_state = WAIT9;
	end
	WAIT9: begin
		next_state = WAIT10;
	end
	WAIT10: begin
		if(key_op == 1'b1) begin
			next_state = KEY_OP;
		end
	end
	KEY_OP: begin
		next_state = MK_EXP;
	end
	MK_EXP: begin
		if(key_expanded == 1'b1) begin
			next_state = WAIT11;
		end
	end
	WAIT11: begin
		next_state = WAIT12;
	end
	WAIT12: begin
		next_state = WAIT13;
	end
	WAIT13: begin
		next_state = WAIT14;
	end
	WAIT14: begin
		next_state = WAIT15;
	end
	WAIT15: begin
		next_state = WAIT16;
	end
	WAIT16: begin
		next_state = WAIT17;
	end
	WAIT17: begin
		next_state = WAIT18;
	end
	WAIT18: begin
		next_state = WAIT19;
	end
	WAIT19: begin
		next_state = WAIT20;
	end
	WAIT20: begin
		next_state = IDLE;
	end	
	endcase
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always_comb begin 
	start_key_exp = 1'b0;
	en_done = 1'b0;
	e_data = '0;
	e_key = '0;	


	case(state)
	IDLE: begin
		en_done = 1'b0;
		e_data = '0;
		e_key = '0;
	end
	DATA_OP: begin
		e_data = data_in;
		e_key = key_in;
	end
	KEY_EXP: begin
		start_key_exp = 1'b1;
		e_data = data_in;
		e_key = key_in;
	end
	LOW_KEY: begin
		e_data = data_in;
		e_key = key_in;
	end
	WAIT1: begin
		e_data = data_in;
		e_key = key_in;
	end
	WAIT2: begin
		e_data = data_in;
		e_key = key_in;
	end
	WAIT3: begin
		e_data = data_in;
		e_key = key_in;
	end
	WAIT4: begin
		e_data = data_in;
		e_key = key_in;
	end
	WAIT5: begin
		e_data = data_in;
		e_key = key_in;
	end
	WAIT6: begin
		e_data = data_in;
		e_key = key_in;
	end
	WAIT7: begin
		e_data = data_in;
		e_key = key_in;
	end
	WAIT8: begin
		e_data = data_in;
		e_key = key_in;
	end
	WAIT9: begin
		e_data = data_in;
		e_key = key_in;
	end
	WAIT10: begin
		en_done = 1'b1;
		e_data = data_in;
		e_key = key_in;
	end
	KEY_OP: begin
		en_done = 1'b0;
		e_data = {0, key_in};
		e_key = mk_key;
	end
	MK_EXP: begin
		start_key_exp = 1'b1;
		e_data = {0, key_in};
		e_key = mk_key;
	end
	WAIT11: begin	
		e_data = {0, key_in};
		e_key = mk_key;
	end
	WAIT12: begin
		e_data = {0, key_in};
		e_key = mk_key;
	end
	WAIT13: begin
		e_data = {0, key_in};
		e_key = mk_key;
	end
	WAIT14: begin
		e_data = {0, key_in};
		e_key = mk_key;
	end
	WAIT15: begin
		e_data = {0, key_in};
		e_key = mk_key;
	end
	WAIT16: begin
		e_data = {0, key_in};
		e_key = mk_key;
	end
	WAIT17: begin
		e_data = {0, key_in};
		e_key = mk_key;
	end
	WAIT18: begin
		e_data = {0, key_in};
		e_key = mk_key;
	end
	WAIT19: begin
		e_data = {0, key_in};
		e_key = mk_key;
	end
	WAIT20: begin	
		en_done = 1'b1;
		e_data = {0, key_in};
		e_key = mk_key;
	end
	endcase
end






endmodule
