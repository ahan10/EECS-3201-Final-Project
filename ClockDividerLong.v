module ClockDividerLong(cin,cout);

	// Based on (corrected) code from fpga4student.com
	// cin is the input clock; if from the DE10-Lite,
	// the input clock will be at 50 MHz
	// The clock divider toggles cout every 25 million
	// cycles of the input clock
	// Provided clock divider code, edited it so that it ticks every 2 second

	input cin;
	output reg cout;
	reg[31:0] count; 
	parameter D = 32'd50_000_000;
	always @(posedge cin) begin
		count <= count + 32'd1;
		if (count >= (D-1)) begin
			cout <= ~cout;
			count <= 32'd0;
		end
	end
endmodule