// File name:   RCU.sv
// Created:     4/25/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Receiver Controller Unit module
`timescale 1ns / 100ps

module RCU
(
	input logic clk,
	input logic n_rst,
	input logic read,
	input logic [128:0] data_in,
	output logic [127:0] key,
	output logic [128:0] data,
	output logic r_ready
);

logic [127:0] next_key;
logic [128:0] next_data;

typedef enum bit [1:0] {IDLE, KEY, DATA} stateType;
stateType state, next_state;

always_comb begin
	next_state = state;
	
	case(state)
	IDLE: begin
		if(read == 1'b1) begin
			next_state = KEY;	
		end
	end
	KEY: begin
		if(read == 1'b1) begin
			next_state = DATA;	
		end
	end
	DATA: begin
		if(read == 1'b0) begin
			next_state = IDLE;
		end
	end
	endcase
end


always_comb begin
	next_key = key;
	next_data = data;
	r_ready = 1'b1;

	case(state)
	IDLE: begin
		r_ready = 1'b0;
		if(read == 1'b1) begin
			next_key = data_in[127:0];
		end
	end
	KEY: begin
		r_ready = 1'b0;
		if(read == 1'b1) begin
			next_data = data_in;
		end
	end
	DATA: begin
		if(read == 1'b1) begin
			next_data = data_in;
		end
	end
	endcase
end

always_ff @ (posedge clk, negedge n_rst) begin
	if(n_rst == 1'b0) begin
		state <= IDLE;
		key <= '0;
		data <= '0;
	end else begin
		state <= next_state; 
		key <= next_key;
		data <= next_data;
	end
end

endmodule
