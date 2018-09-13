// File name:   tb_decryptionFull.sv
// Created:     4/22/2018
// Author:      Samuale Yigrem
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Test bench for Full Decryption of AES 128 bit block
`timescale 1ns / 100ps

module tb_decryptionFull ();

logic [1407:0] exp_key;
logic [127:0] plain_text;
logic [127:0] cipher_text;

//Portmap
decryptionFull TENROUNDS
(
	.key(exp_key),
	.data(cipher_text),
	.plainText(plain_text)
);

initial begin
	#5;
	cipher_text = 128'h29C3505F571420F6402299B31A02D73A;
	exp_key = 1408'h5468617473206D79204B756E67204675E232FCF191129188B159E4E6D679A29356082007C71AB18F76435569A03AF7FAD2600DE7157ABC686339E901C3031EFBA11202C9B468BEA1D75157A01452495BB1293B3305418592D210D232C6429B69BD3DC287B87C47156A6C9527AC2E0E4ECC96ED1674EAAA031E863F24B2A8316A8E51EF21FABB4522E43D7A0656954B6CBFE2BF904559FAB2A16480B4F7F1CBD828FDDEF86DA4244ACCC0A4FE3B316F26;

	#100;
	if(plain_text == 128'h54776F204F6E65204E696E652054776F) begin
		$info("WE ARE SMART :)");
	end

	#5;
	cipher_text = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
	exp_key = 1408'h000102030405060708090a0b0c0d0e0fd6aa74fdd2af72fadaa678f1d6ab76feb692cf0b643dbdf1be9bc5006830b3feb6ff744ed2c2c9bf6c590cbf0469bf4147f7f7bc95353e03f96c32bcfd058dfd3caaa3e8a99f9deb50f3af57adf622aa5e390f7df7a69296a7553dc10aa31f6b14f9701ae35fe28c440adf4d4ea9c02647438735a41c65b9e016baf4aebf7ad2549932d1f08557681093ed9cbe2c974e13111d7fe3944a17f307a78b4d2b30c5;
	
	#100;
	if(plain_text == 128'h00112233445566778899aabbccddeeff) begin
		$info("WE ARE SMARTER :)))");
	end

end

endmodule
