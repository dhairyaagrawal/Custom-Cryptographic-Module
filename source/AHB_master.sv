// $Id: $
// File name:   AHB_master.sv
// Created:     4/25/2018
// Author:      Dhairya Agrawal
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: AHB Master to communicate with the SRAM and write to it.
`timescale 1ns / 100ps

module AHB_master
(
	input wire clk,
	input logic n_rst,
	input logic ed_sel,
	input logic aes_done,
	input logic last_packet,
	input logic read_addr,
	input logic [31:0] sram_addr,
	input logic [128:0] data_out,
	
	output logic HWRITE,
	output logic [2:0] HBURST,
	output logic [1:0] HTRANS,
	output logic [31:0] HADDR,
	output logic [127:0] HWDATA
);

	typedef enum bit [3:0] {IDLE, ADDR, WAIT1, OUT, LOOP1, LOOP2, LAST1, LAST2, WAIT2, KEYOUT1, KEYOUT2} stateType;
	stateType state, next_state;

	logic [31:0] next_addr;
	logic [127:0] next_reg1;
	logic [127:0] next_reg2;
	logic [31:0] addr;
	logic [127:0] reg1;
	logic [127:0] reg2;
	logic wrong;
	logic right;
	logic lp;

	always_ff @ (posedge clk, negedge n_rst) begin
		if(n_rst == 1'b0) begin
			state <= IDLE;
			reg1 <= '0;
			reg2 <= '0;
			addr <= '0;
		end else begin
			state <= next_state;
			reg1 <= next_reg1;
			reg2 <= next_reg2; 
			addr <= next_addr;
		end
	end

	assign right = (aes_done == 1'b1 && data_out[128] == 1'b0);
	assign wrong = (aes_done == 1'b1 && data_out[128] == 1'b1);
	assign lp = (aes_done == 1'b0 && last_packet == 1'b1);

	always_comb begin
		next_state = state;
		next_addr = addr;
		next_reg1 = reg1;
		next_reg2 = reg2;
		case(state)
		IDLE: begin
			if(read_addr == 1'b1) begin
				next_state = ADDR;
				next_addr = sram_addr;
			end
		end
		ADDR: begin
			if(wrong) begin
				next_state = WAIT1;
			end else if(right) begin
				next_state = OUT;
				next_reg1 = data_out[127:0];
			end
		end
		WAIT1: begin
			if(right) begin
				next_state = OUT;
				next_reg1 = data_out[127:0];
			end
		end
		OUT: begin
			if(wrong || lp) begin
				next_state = LAST1;
			end else if (right) begin
				next_state = LOOP1;
				next_addr[15:0] = addr[15:0] + 16;
				next_reg2 = data_out[127:0];
			end
		end
		LOOP1: begin
			if(wrong || lp) begin
				next_state = LAST2;
			end else if (right) begin
				next_state = LOOP2;
				next_addr[15:0] = addr[15:0] + 16;
				next_reg1 = data_out[127:0];
			end
		end
		LAST1: begin
			if(right) begin
				next_state = OUT;
				next_addr[15:0] = addr[15:0] + 16;
				next_reg1 = data_out[127:0];
			end else if(aes_done == 1'b0) begin
				next_state = WAIT2;
			end
		end
		LOOP2: begin
			if(wrong || lp) begin
				next_state = LAST1;
			end else if (right) begin
				next_state = LOOP1;
				next_addr[15:0] = addr[15:0] + 16;
				next_reg2 = data_out[127:0];
			end
		end
		LAST2: begin
			if(right) begin
				next_state = OUT;
				next_addr[15:0] = addr[15:0] + 16;
				next_reg1 = data_out[127:0];
			end else if(aes_done == 1'b0) begin
				next_state = WAIT2;
			end
		end
		WAIT2: begin
			if(aes_done) begin
				next_state = KEYOUT1;
				next_addr[15:0] = addr[15:0] + 16;
				next_reg1 = data_out[127:0];
			end else if(ed_sel == 1'b0) begin
				next_state = IDLE;
			end
		end
		KEYOUT1: begin
			next_state = KEYOUT2;
		end
		KEYOUT2: begin
			next_state = IDLE;
		end
		endcase

	end

	always_comb begin
		HWRITE = 1'b1;
		HBURST = '0;
		HTRANS = '0;
		HADDR = addr;
		HWDATA = '0;
			
		case(state)
		IDLE: begin
			HTRANS = '0;
			HWRITE = 1'b0;
		end
		ADDR: begin
			HTRANS = '0;
			HWRITE = 1'b0;
		end
		WAIT1: begin
			HTRANS = '0;
			HWRITE = 1'b0;
		end
		OUT: begin
			HTRANS = 2;
			HADDR = addr;
			HBURST = 1;
		end
		LOOP1: begin
			HWDATA = reg1;
			HTRANS = 3;
			HADDR = addr;
			HBURST = 1;
		end
		LAST1: begin
			HWDATA = reg1;
		end
		LOOP2: begin
			HWDATA = reg2;
			HTRANS = 3;
			HADDR = addr;
			HBURST = 1;
		end
		LAST2: begin
			HWDATA = reg2;
		end
		WAIT2: begin
			HTRANS = '0;
			HWRITE = 1'b0;
		end
		KEYOUT1: begin
			HTRANS = 2;
			HADDR = addr;
		end
		KEYOUT2: begin
			HWDATA = reg1;
		end
		endcase
	end
endmodule
