module shotClock(clk, reset, ones, tens, counter, LED_Timer);
	// Reused lab 4 code, made some changes such as removed the condition where user could choose between 24 seconds and 30 seconds
	// also removed the sart stop feature
	
	input clk, reset;
	output reg [3:0] LED_Timer, ones, tens;
	
	wire clk_out;
	
	output reg [4:0] counter = 5'd30;
	wire [4:0] cnt;
	
	ClockDivider cd (clk, clk_out);

	always @(posedge clk_out or negedge reset) begin
		if(!reset) begin
			counter <= 5'd30;
		end
		else if(counter > 0) begin begin
			counter <= counter - 1;
		end end
	end
	
	assign cnt = counter;
	
	always @(cnt) begin
		ones = cnt % 10;
		tens = (cnt - (cnt%10))/10;
		
		if(tens == 5'd3) begin
			LED_Timer[3:1] = 3'b111;
		end
		else if(tens == 5'd2) begin begin
			LED_Timer[3:1] = 3'b011;
		end end
		else if(tens == 5'd1) begin begin
			LED_Timer[3:1] = 3'b001;
		end end
		else begin
			LED_Timer[3:1] = 3'b000;
		end
		
	end
	
	reg flag = 1;
	
	always @(posedge clk_out) begin
		flag = (cnt <= 0) ? 0 : ~flag;
		LED_Timer[0] = flag;
	end
	
	
endmodule 