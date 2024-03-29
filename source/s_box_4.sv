// $Id: $
// File name:   s_box_4.sv
// Created:     4/21/2018
// Author:      Dhairya Agrawal
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: 4 s-box module for key expansion

module s_box_4(
	input wire [31 : 0] in_data,
	output wire [31 : 0] out_data
);
	// A single s_box array
	wire [7 : 0] s_box [0 : 255];

	// Mapped out s_box
assign s_box[8'h0] = 8'h63;
assign s_box[8'h1] = 8'h7c;
assign s_box[8'h2] = 8'h77;
assign s_box[8'h3] = 8'h7b;
assign s_box[8'h4] = 8'hf2;
assign s_box[8'h5] = 8'h6b;
assign s_box[8'h6] = 8'h6f;
assign s_box[8'h7] = 8'hc5;
assign s_box[8'h8] = 8'h30;
assign s_box[8'h9] = 8'h1;
assign s_box[8'ha] = 8'h67;
assign s_box[8'hb] = 8'h2b;
assign s_box[8'hc] = 8'hfe;
assign s_box[8'hd] = 8'hd7;
assign s_box[8'he] = 8'hab;
assign s_box[8'hf] = 8'h76;
assign s_box[8'h10] = 8'hca;
assign s_box[8'h11] = 8'h82;
assign s_box[8'h12] = 8'hc9;
assign s_box[8'h13] = 8'h7d;
assign s_box[8'h14] = 8'hfa;
assign s_box[8'h15] = 8'h59;
assign s_box[8'h16] = 8'h47;
assign s_box[8'h17] = 8'hf0;
assign s_box[8'h18] = 8'had;
assign s_box[8'h19] = 8'hd4;
assign s_box[8'h1a] = 8'ha2;
assign s_box[8'h1b] = 8'haf;
assign s_box[8'h1c] = 8'h9c;
assign s_box[8'h1d] = 8'ha4;
assign s_box[8'h1e] = 8'h72;
assign s_box[8'h1f] = 8'hc0;
assign s_box[8'h20] = 8'hb7;
assign s_box[8'h21] = 8'hfd;
assign s_box[8'h22] = 8'h93;
assign s_box[8'h23] = 8'h26;
assign s_box[8'h24] = 8'h36;
assign s_box[8'h25] = 8'h3f;
assign s_box[8'h26] = 8'hf7;
assign s_box[8'h27] = 8'hcc;
assign s_box[8'h28] = 8'h34;
assign s_box[8'h29] = 8'ha5;
assign s_box[8'h2a] = 8'he5;
assign s_box[8'h2b] = 8'hf1;
assign s_box[8'h2c] = 8'h71;
assign s_box[8'h2d] = 8'hd8;
assign s_box[8'h2e] = 8'h31;
assign s_box[8'h2f] = 8'h15;
assign s_box[8'h30] = 8'h4;
assign s_box[8'h31] = 8'hc7;
assign s_box[8'h32] = 8'h23;
assign s_box[8'h33] = 8'hc3;
assign s_box[8'h34] = 8'h18;
assign s_box[8'h35] = 8'h96;
assign s_box[8'h36] = 8'h5;
assign s_box[8'h37] = 8'h9a;
assign s_box[8'h38] = 8'h7;
assign s_box[8'h39] = 8'h12;
assign s_box[8'h3a] = 8'h80;
assign s_box[8'h3b] = 8'he2;
assign s_box[8'h3c] = 8'heb;
assign s_box[8'h3d] = 8'h27;
assign s_box[8'h3e] = 8'hb2;
assign s_box[8'h3f] = 8'h75;
assign s_box[8'h40] = 8'h9;
assign s_box[8'h41] = 8'h83;
assign s_box[8'h42] = 8'h2c;
assign s_box[8'h43] = 8'h1a;
assign s_box[8'h44] = 8'h1b;
assign s_box[8'h45] = 8'h6e;
assign s_box[8'h46] = 8'h5a;
assign s_box[8'h47] = 8'ha0;
assign s_box[8'h48] = 8'h52;
assign s_box[8'h49] = 8'h3b;
assign s_box[8'h4a] = 8'hd6;
assign s_box[8'h4b] = 8'hb3;
assign s_box[8'h4c] = 8'h29;
assign s_box[8'h4d] = 8'he3;
assign s_box[8'h4e] = 8'h2f;
assign s_box[8'h4f] = 8'h84;
assign s_box[8'h50] = 8'h53;
assign s_box[8'h51] = 8'hd1;
assign s_box[8'h52] = 8'h0;
assign s_box[8'h53] = 8'hed;
assign s_box[8'h54] = 8'h20;
assign s_box[8'h55] = 8'hfc;
assign s_box[8'h56] = 8'hb1;
assign s_box[8'h57] = 8'h5b;
assign s_box[8'h58] = 8'h6a;
assign s_box[8'h59] = 8'hcb;
assign s_box[8'h5a] = 8'hbe;
assign s_box[8'h5b] = 8'h39;
assign s_box[8'h5c] = 8'h4a;
assign s_box[8'h5d] = 8'h4c;
assign s_box[8'h5e] = 8'h58;
assign s_box[8'h5f] = 8'hcf;
assign s_box[8'h60] = 8'hd0;
assign s_box[8'h61] = 8'hef;
assign s_box[8'h62] = 8'haa;
assign s_box[8'h63] = 8'hfb;
assign s_box[8'h64] = 8'h43;
assign s_box[8'h65] = 8'h4d;
assign s_box[8'h66] = 8'h33;
assign s_box[8'h67] = 8'h85;
assign s_box[8'h68] = 8'h45;
assign s_box[8'h69] = 8'hf9;
assign s_box[8'h6a] = 8'h2;
assign s_box[8'h6b] = 8'h7f;
assign s_box[8'h6c] = 8'h50;
assign s_box[8'h6d] = 8'h3c;
assign s_box[8'h6e] = 8'h9f;
assign s_box[8'h6f] = 8'ha8;
assign s_box[8'h70] = 8'h51;
assign s_box[8'h71] = 8'ha3;
assign s_box[8'h72] = 8'h40;
assign s_box[8'h73] = 8'h8f;
assign s_box[8'h74] = 8'h92;
assign s_box[8'h75] = 8'h9d;
assign s_box[8'h76] = 8'h38;
assign s_box[8'h77] = 8'hf5;
assign s_box[8'h78] = 8'hbc;
assign s_box[8'h79] = 8'hb6;
assign s_box[8'h7a] = 8'hda;
assign s_box[8'h7b] = 8'h21;
assign s_box[8'h7c] = 8'h10;
assign s_box[8'h7d] = 8'hff;
assign s_box[8'h7e] = 8'hf3;
assign s_box[8'h7f] = 8'hd2;
assign s_box[8'h80] = 8'hcd;
assign s_box[8'h81] = 8'hc;
assign s_box[8'h82] = 8'h13;
assign s_box[8'h83] = 8'hec;
assign s_box[8'h84] = 8'h5f;
assign s_box[8'h85] = 8'h97;
assign s_box[8'h86] = 8'h44;
assign s_box[8'h87] = 8'h17;
assign s_box[8'h88] = 8'hc4;
assign s_box[8'h89] = 8'ha7;
assign s_box[8'h8a] = 8'h7e;
assign s_box[8'h8b] = 8'h3d;
assign s_box[8'h8c] = 8'h64;
assign s_box[8'h8d] = 8'h5d;
assign s_box[8'h8e] = 8'h19;
assign s_box[8'h8f] = 8'h73;
assign s_box[8'h90] = 8'h60;
assign s_box[8'h91] = 8'h81;
assign s_box[8'h92] = 8'h4f;
assign s_box[8'h93] = 8'hdc;
assign s_box[8'h94] = 8'h22;
assign s_box[8'h95] = 8'h2a;
assign s_box[8'h96] = 8'h90;
assign s_box[8'h97] = 8'h88;
assign s_box[8'h98] = 8'h46;
assign s_box[8'h99] = 8'hee;
assign s_box[8'h9a] = 8'hb8;
assign s_box[8'h9b] = 8'h14;
assign s_box[8'h9c] = 8'hde;
assign s_box[8'h9d] = 8'h5e;
assign s_box[8'h9e] = 8'hb;
assign s_box[8'h9f] = 8'hdb;
assign s_box[8'ha0] = 8'he0;
assign s_box[8'ha1] = 8'h32;
assign s_box[8'ha2] = 8'h3a;
assign s_box[8'ha3] = 8'ha;
assign s_box[8'ha4] = 8'h49;
assign s_box[8'ha5] = 8'h6;
assign s_box[8'ha6] = 8'h24;
assign s_box[8'ha7] = 8'h5c;
assign s_box[8'ha8] = 8'hc2;
assign s_box[8'ha9] = 8'hd3;
assign s_box[8'haa] = 8'hac;
assign s_box[8'hab] = 8'h62;
assign s_box[8'hac] = 8'h91;
assign s_box[8'had] = 8'h95;
assign s_box[8'hae] = 8'he4;
assign s_box[8'haf] = 8'h79;
assign s_box[8'hb0] = 8'he7;
assign s_box[8'hb1] = 8'hc8;
assign s_box[8'hb2] = 8'h37;
assign s_box[8'hb3] = 8'h6d;
assign s_box[8'hb4] = 8'h8d;
assign s_box[8'hb5] = 8'hd5;
assign s_box[8'hb6] = 8'h4e;
assign s_box[8'hb7] = 8'ha9;
assign s_box[8'hb8] = 8'h6c;
assign s_box[8'hb9] = 8'h56;
assign s_box[8'hba] = 8'hf4;
assign s_box[8'hbb] = 8'hea;
assign s_box[8'hbc] = 8'h65;
assign s_box[8'hbd] = 8'h7a;
assign s_box[8'hbe] = 8'hae;
assign s_box[8'hbf] = 8'h8;
assign s_box[8'hc0] = 8'hba;
assign s_box[8'hc1] = 8'h78;
assign s_box[8'hc2] = 8'h25;
assign s_box[8'hc3] = 8'h2e;
assign s_box[8'hc4] = 8'h1c;
assign s_box[8'hc5] = 8'ha6;
assign s_box[8'hc6] = 8'hb4;
assign s_box[8'hc7] = 8'hc6;
assign s_box[8'hc8] = 8'he8;
assign s_box[8'hc9] = 8'hdd;
assign s_box[8'hca] = 8'h74;
assign s_box[8'hcb] = 8'h1f;
assign s_box[8'hcc] = 8'h4b;
assign s_box[8'hcd] = 8'hbd;
assign s_box[8'hce] = 8'h8b;
assign s_box[8'hcf] = 8'h8a;
assign s_box[8'hd0] = 8'h70;
assign s_box[8'hd1] = 8'h3e;
assign s_box[8'hd2] = 8'hb5;
assign s_box[8'hd3] = 8'h66;
assign s_box[8'hd4] = 8'h48;
assign s_box[8'hd5] = 8'h3;
assign s_box[8'hd6] = 8'hf6;
assign s_box[8'hd7] = 8'he;
assign s_box[8'hd8] = 8'h61;
assign s_box[8'hd9] = 8'h35;
assign s_box[8'hda] = 8'h57;
assign s_box[8'hdb] = 8'hb9;
assign s_box[8'hdc] = 8'h86;
assign s_box[8'hdd] = 8'hc1;
assign s_box[8'hde] = 8'h1d;
assign s_box[8'hdf] = 8'h9e;
assign s_box[8'he0] = 8'he1;
assign s_box[8'he1] = 8'hf8;
assign s_box[8'he2] = 8'h98;
assign s_box[8'he3] = 8'h11;
assign s_box[8'he4] = 8'h69;
assign s_box[8'he5] = 8'hd9;
assign s_box[8'he6] = 8'h8e;
assign s_box[8'he7] = 8'h94;
assign s_box[8'he8] = 8'h9b;
assign s_box[8'he9] = 8'h1e;
assign s_box[8'hea] = 8'h87;
assign s_box[8'heb] = 8'he9;
assign s_box[8'hec] = 8'hce;
assign s_box[8'hed] = 8'h55;
assign s_box[8'hee] = 8'h28;
assign s_box[8'hef] = 8'hdf;
assign s_box[8'hf0] = 8'h8c;
assign s_box[8'hf1] = 8'ha1;
assign s_box[8'hf2] = 8'h89;
assign s_box[8'hf3] = 8'hd;
assign s_box[8'hf4] = 8'hbf;
assign s_box[8'hf5] = 8'he6;
assign s_box[8'hf6] = 8'h42;
assign s_box[8'hf7] = 8'h68;
assign s_box[8'hf8] = 8'h41;
assign s_box[8'hf9] = 8'h99;
assign s_box[8'hfa] = 8'h2d;
assign s_box[8'hfb] = 8'hf;
assign s_box[8'hfc] = 8'hb0;
assign s_box[8'hfd] = 8'h54;
assign s_box[8'hfe] = 8'hbb;
assign s_box[8'hff] = 8'h16;

	// 4 s_boxes created at once
	assign out_data[31 : 24] = s_box[in_data[31 : 24]];
	assign out_data[23 : 16] = s_box[in_data[23 : 16]];
	assign out_data[15 : 8] = s_box[in_data[15 : 8]];
	assign out_data[7 : 0] = s_box[in_data[7 : 0]];

endmodule 