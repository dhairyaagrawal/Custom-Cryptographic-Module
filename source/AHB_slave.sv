// File name:   AHB_slave.sv
// Created:     4/24/2018
// Author:      Samanth Mottera Srinivas
// Lab Section: 05
// Version:     1.0  Initial Design Entry
// Description: AMBA AHB-Lite Data Bus
`timescale 1ns / 100ps

module AHB_slave 
(
	input logic clk,
	input logic n_rst,
	input logic [1:0] HTRANS, // Type of transfer
	input logic HWRITE,
	input logic HSELx,
	input logic HREADY,
	input logic [127:0] HWDATA,
	//output logic HRESP, // Active High error (error state)
	//output logic HREADYOUT,
	output logic [128:0] data_in,
	output logic read,
	output logic [31:0] sram_addr,
	output logic read_addr,
	output logic last_packet
);

typedef enum bit [2:0] {IDLE, KEY, WAIT, ADDR, DATAVALID, BUSY} stateType;

stateType state, next_state;

always_comb begin
	next_state = state;

	case(state)	
	IDLE: begin
		if(HWRITE == 1'b1 && HSELx == 1'b1 && HREADY == 1'b1) begin
			next_state = KEY;
		end
	end	
	KEY: begin
		next_state = WAIT;
	end
	WAIT: begin
		if(HWRITE == 1'b1 && HSELx == 1'b1 && HREADY == 1'b1) begin
			next_state = ADDR;
		end
	end		
	ADDR: begin
		if(HWRITE == 1'b1 && HSELx == 1'b1 && HREADY == 1'b1 && HTRANS == 2'h1) begin
			next_state = BUSY;
		end
		else if(HWRITE == 1'b1 && HSELx == 1'b1 && HREADY == 1'b1 && HTRANS == 2'h3) begin
			next_state = DATAVALID;
		end
	end	
	DATAVALID: begin
		if(HWRITE == 1'b1 && HSELx == 1'b1 && HREADY == 1'b1 && HTRANS == 2'h1) begin
			next_state = BUSY;
		end
		else if(HWRITE == 1'b1 && HSELx == 1'b1 && HREADY == 1'b1 && HTRANS == 2'h3) begin
			next_state = DATAVALID;
		end
		else begin
			next_state = IDLE;
		end
	end
	BUSY: begin
		if(HWRITE == 1'b1 && HSELx == 1'b1 && HREADY == 1'b1 && HTRANS == 2'h1) begin
			next_state = BUSY;
		end
		else if(HWRITE == 1'b1 && HSELx == 1'b1 && HREADY == 1'b1 && HTRANS == 2'h3) begin
			next_state = DATAVALID;
		end
	end
	endcase
end

always_comb begin
	//HRESP = 1'b0;
	//HREADYOUT = 1'b1;
	data_in = '0;
	read = 1'b0;
	sram_addr = '0;
	read_addr = 1'b0;
	last_packet = 1'b0;

	case(state)	
	IDLE: begin
		last_packet = 1'b1;
	end	
	KEY: begin
		data_in = {1'b0, HWDATA};
		read = 1'b1;
	end
	WAIT: begin
		read = 1'b0;
	end		
	ADDR: begin
		sram_addr = HWDATA[31:0];
		read_addr = 1'b1;
	end	
	DATAVALID: begin
		data_in = {1'b0, HWDATA};
		read = 1'b1;
	end
	BUSY: begin
		data_in = {1'b1, HWDATA};
		read = 1'b1;
	end
	endcase
end

always_ff @ (posedge clk, negedge n_rst) begin
	if(n_rst == 1'b0) begin
		state <= IDLE;
	end else begin
		state <= next_state; 
	end
end

endmodule
