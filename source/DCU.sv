// $Id: $
// File name:   DCU.sv
// Created:     4/24/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Decryption Controller Unit for the AES Core block

module DCU
(
	input logic clk,
	input logic n_rst,
	input logic start_op,
	input logic ed_sel,
	input logic r_ready,
	input logic key_op, // maybe needed
	input logic key_expanded,
	input logic [128:0] data_in,
	input logic [127:0] key_in,
	input logic [127:0] mk_key,
	input logic [128:0] plaintext_data,
	output logic start_key_exp,
	output logic dec_done,
	output logic [128:0] d_data,
	output logic [127:0] d_key
);

typedef enum bit [4:0] {IDLE, MK_KEY, KEY_EXP, WAIT1, WAIT2, WAIT3, WAIT4, WAIT5, WAIT6, WAIT7, WAIT8, WAIT9, WAIT10, AUX_KEY, KEY_EXP2, LOW_KEY, WAIT11, WAIT12, WAIT13, WAIT14, WAIT15, WAIT16, WAIT17, WAIT18, WAIT19, WAIT20} stateType;
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
		if((start_op == 1'b1) && (ed_sel == 1'b0)) begin
			next_state = MK_KEY;
		end	
	end
	MK_KEY: begin
		next_state = KEY_EXP;
	end
	KEY_EXP: begin
		if(key_expanded == 1'b1) begin
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
		next_state = AUX_KEY;
	end
	AUX_KEY: begin
		next_state = KEY_EXP2;
	end
	KEY_EXP2: begin
		if(key_expanded == 1'b1) begin
			next_state = LOW_KEY;
		end
	end
	LOW_KEY: begin
		if(r_ready == 1'b1) begin
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
		if(key_op == 1'b1) begin
			next_state = IDLE; // might be changed (key_op)?
		end
	end
	endcase
end

always_comb begin
	start_key_exp = 1'b0;
	dec_done = 1'b0;
	d_data = '0;
	d_key = '0;


	case(state)
	IDLE: begin
		dec_done = 1'b0;
		d_data = '0;
		d_key = '0;
	end
	MK_KEY: begin
		d_data = key_in;
		d_key = mk_key;
	end
	KEY_EXP: begin
		d_data = key_in;
		d_key = mk_key;
		start_key_exp = 1'b1;
	end
	WAIT1: begin
		d_data = key_in;
		d_key = mk_key;
		start_key_exp = 1'b0;
	end
	WAIT2: begin
		d_data = key_in;
		d_key = mk_key;
	end
	WAIT3: begin
		d_data = key_in;
		d_key = mk_key;
	end
	WAIT4: begin
		d_data = key_in;
		d_key = mk_key;
	end
	WAIT5: begin
		d_data = key_in;
		d_key = mk_key;
	end
	WAIT6: begin
		d_data = key_in;
		d_key = mk_key;
	end
	WAIT7: begin
		d_data = key_in;
		d_key = mk_key;
	end
	WAIT8: begin
		d_data = key_in;
		d_key = mk_key;
	end
	WAIT9: begin
		d_data = key_in;
		d_key = mk_key;
	end
	WAIT10: begin
		d_data = key_in;
		d_key = mk_key;
	end
	AUX_KEY: begin
		d_data = data_in;
		d_key = plaintext_data[127:0];
	end
	KEY_EXP2: begin
		d_data = data_in;
		d_key = plaintext_data[127:0];
		start_key_exp = 1'b1;
	end
	LOW_KEY: begin
		d_data = data_in;
		d_key = plaintext_data[127:0];
	end
	WAIT11: begin
		d_data = data_in;
		d_key = plaintext_data[127:0];
		start_key_exp = 1'b0;
	end
	WAIT12: begin
		d_data = data_in;
		d_key = plaintext_data[127:0];
	end
	WAIT13: begin
		d_data = data_in;
		d_key = plaintext_data[127:0];
	end
	WAIT14: begin
		d_data = data_in;
		d_key = plaintext_data[127:0];
	end
	WAIT15: begin
		d_data = data_in;
		d_key = plaintext_data[127:0];
	end
	WAIT16: begin
		d_data = data_in;
		d_key = plaintext_data[127:0];
	end
	WAIT17: begin
		d_data = data_in;
		d_key = plaintext_data[127:0];
	end
	WAIT18: begin
		d_data = data_in;
		d_key = plaintext_data[127:0];
	end
	WAIT19: begin
		d_data = data_in;
		d_key = plaintext_data[127:0];
	end
	WAIT20: begin
		d_data = data_in;
		d_key = plaintext_data[127:0];
		dec_done = 1'b1;
	end
	endcase
end

endmodule
