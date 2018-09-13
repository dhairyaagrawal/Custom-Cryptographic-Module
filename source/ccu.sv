// $Id: $
// File name:   ccu.sv
// Created:     4/26/2018
// Author:      Ryan Devlin
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Cryptographic Control Unit to control overall operation.
// $Id: $

module ccu
(
	input logic clk,
	input logic n_rst,
	input logic enable,
	input logic irq_resp,
	input logic e_or_d,
	input logic read,
	input logic data_done,
	input logic key_expanded,
	input logic aes_done,
	output logic ed_sel,
	output logic start_op,
	output logic irq,
	output logic key_op,
	output logic ready
);

typedef enum bit [5:0] {IDLE, KEY_WAIT_E, START_E, IRQ_E, SERVICED_E, RCU_WAIT_E, ROUND1_E, ROUND2_E, ROUND3_E, ROUND4_E, ROUND5_E, ROUND6_E, ROUND7_E, ROUND8_E, ROUND9_E, ROUND10_E, HOLD, FINISHED_E, KEY_WAIT_D, START_D, DEC_KEY, IRQ_D, SERVICED_D, RCU_WAIT_D, ROUND1_D, ROUND2_D, ROUND3_D, ROUND4_D, ROUND5_D, ROUND6_D, ROUND7_D, ROUND8_D, ROUND9_D, ROUND10_D, FINISHED_D} stateType;
stateType state, next_state;
logic next_irq;

always_ff @ (posedge clk, negedge n_rst)
begin
	if(n_rst == 1'b0) begin
		state <= IDLE;
		irq <= 1'b0;
	end else begin
		state <= next_state;
		irq <= next_irq;
	end
end

always_comb begin
	next_state = state;

	case(state)
	IDLE: begin
		if((enable == 1'b1) && (e_or_d == 1'b1)) begin //ENCRYPTION
			next_state = KEY_WAIT_E;
		end
		if((enable == 1'b1) && (e_or_d == 1'b0)) begin //DECRYPTION
			next_state = KEY_WAIT_D;
		end		
	end
	// -- ENCRYPTION -- //
	KEY_WAIT_E: begin
		if(read == 1'b1) begin
			next_state = START_E;
		end
	end
	START_E: begin
		if(key_expanded == 1'b1) begin
			next_state = IRQ_E;
		end
	end
	IRQ_E: begin
		if(irq_resp == 1'b1) begin
			next_state = SERVICED_E;
		end
	end
	SERVICED_E: begin
		if(data_done == 1'b1) begin
			next_state = RCU_WAIT_E;
		end
	end
	RCU_WAIT_E: begin
		next_state = ROUND1_E;
	end
	ROUND1_E: begin
		next_state = ROUND2_E;
	end
	ROUND2_E: begin
		next_state = ROUND3_E;
	end
	ROUND3_E: begin
		next_state = ROUND4_E;
	end
	ROUND4_E: begin
		next_state = ROUND5_E;
	end
	ROUND5_E: begin
		next_state = ROUND6_E;
	end
	ROUND6_E: begin
		next_state = ROUND7_E;
	end
	ROUND7_E: begin
		next_state = ROUND8_E;
	end
	ROUND8_E: begin
		next_state = ROUND9_E;
	end
	ROUND9_E: begin
		next_state = ROUND10_E;
	end
	ROUND10_E: begin
		next_state = HOLD;
	end
	HOLD: begin
		if(aes_done == 1'b1) begin
			next_state = FINISHED_E;
		end
	end
	FINISHED_E: begin
		if(enable == 1'b0) begin
			next_state = IDLE;
		end
	end

	// -- DECRYPTION -- //
	KEY_WAIT_D: begin
		if(read == 1'b1) begin
			next_state = START_D;
		end
	end
	START_D: begin
		if(key_expanded == 1'b1) begin
			next_state = DEC_KEY;
		end
	end
	DEC_KEY: begin
		if(key_expanded == 1'b1) begin
			next_state = IRQ_D;
		end
	end
	IRQ_D: begin
		if(irq_resp == 1'b1) begin
			next_state = SERVICED_D;
		end
	end
	SERVICED_D: begin
		if(data_done == 1'b1) begin
			next_state = RCU_WAIT_D;
		end
	end
	RCU_WAIT_D: begin
		next_state = ROUND1_D;
	end
	ROUND1_D: begin
		next_state = ROUND2_D;
	end
	ROUND2_D: begin
		next_state = ROUND3_D;
	end
	ROUND3_D: begin
		next_state = ROUND4_D;
	end
	ROUND4_D: begin
		next_state = ROUND5_D;
	end
	ROUND5_D: begin
		next_state = ROUND6_D;
	end
	ROUND6_D: begin
		next_state = ROUND7_D;
	end
	ROUND7_D: begin
		next_state = ROUND8_D;
	end
	ROUND8_D: begin
		next_state = ROUND9_D;
	end
	ROUND9_D: begin
		next_state = ROUND10_D;
	end
	ROUND10_D: begin
		next_state = FINISHED_D;
	end
	FINISHED_D: begin
		if(enable == 1'b0) begin
			next_state = IDLE;
		end
	end
	endcase
end

always_comb begin
	ed_sel = 1'b0;
	start_op = 1'b0;
	next_irq = 1'b0;
	key_op = 1'b0;
	ready = 1'b0;

	case(state)
	IDLE: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b1;
	end
	// -- ENCRYPTION -- //
	KEY_WAIT_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	START_E: begin
		ed_sel = 1'b1;
		start_op = 1'b1;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
		if(key_expanded == 1'b1) begin
			next_irq = 1'b1;
		end
	end
	IRQ_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
		if(irq_resp == 1'b1) begin
			next_irq = 1'b0;
		end else begin
			next_irq = 1'b1;
		end
	end
	SERVICED_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	RCU_WAIT_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND1_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND2_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND3_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND4_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND5_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND6_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND7_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND8_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND9_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND10_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b1;
		ready = 1'b0;
	end
	HOLD: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	FINISHED_E: begin
		ed_sel = 1'b1;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b1;
	end

	// -- DECRYPTION -- //
	KEY_WAIT_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	START_D: begin
		ed_sel = 1'b0;
		start_op = 1'b1;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	DEC_KEY: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
		if(key_expanded == 1'b1) begin
			next_irq = 1'b1;
		end
	end
	IRQ_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
		if(irq_resp == 1'b1) begin
			next_irq = 1'b0;
		end else begin
			next_irq = 1'b1;
		end
	end
	SERVICED_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	RCU_WAIT_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND1_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND2_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND3_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND4_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND5_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND6_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND7_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND8_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND9_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b0;
	end
	ROUND10_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b1;
		ready = 1'b0;
	end
	FINISHED_D: begin
		ed_sel = 1'b0;
		start_op = 1'b0;
		next_irq = 1'b0;
		key_op = 1'b0;
		ready = 1'b1;
	end
	endcase
end

endmodule
