module main(input reset, clock, input wire [5:0] SW, output [5:0] HEX, output reg [4:0] LEDR, output [3:0] LED_Timer, output reg [4:0] score, output reg gameEnd);
	
	// The inputs we have are a reset button, 50 MHz clock, 6 switches
	// The outputs we have are a 6 bit hex, with only one of the bit high at a time, two sets of LED's, one for lives and another for timer, score and a register that depicts game has ended
	
	wire clk_out_long, clk_out_fast, ones, tens, timer; // wire initiations for clocks and timer

	reg [5:0] mynum = 6'b110111; // A random number
	reg a, b, c;	// three one bits to generate a random number
	reg [2:0] rand; // reg to strore a 3 bit random number
	reg [2:0] life;		//Reg for life
	reg [5:0] hexOn;	// Reg to strore which hex to be turned on

	ClockDividerLong cdl (clock, clk_out_long);	// 2 sec, Calling a clock that ticks every 2 seconds
	ClockDividerFast cdf (clock, clk_out_fast); // 10 ms clock, to generate a random number every 10 ms
	

	shotClock sc (clock, reset, ones, tens, timer, LED_Timer); // Calling timer

	// Block for generating a random number every 10 mili seconds
	// We use Lab 5 part b code, we get a 6 bit number, which shifts every 10 ns
	// Of the 6 bits, we XOR 2 bits of the 6 bi number and store in a, b, c respectively
	// With the three 1 bits, we combine it to make a 3 bit number which is random and very less chances for predictability
	// A random number is generated every 10 millisecond, but it is updated in the code every 2 seconds, being even less predictable
	
	
	always @(posedge clk_out_fast) begin
		if(!gameEnd && reset) begin  //change condition
			mynum <= {mynum[0] ^ mynum[2], mynum[4:1]};
			a = mynum[2] ^ mynum[5];
			b = mynum[0] ^ mynum[3];
			c = mynum[4] ^ mynum[1];
			rand = {a, b, c};
		end
	end
	
	
	
	// A longer clock that checks the random number every 2 seconds and turns on the respective HEX
	// In this, at a time only one bit is high, meaning at a time only one HEX turns on, rest stays off

	always @(posedge clk_out_long) begin
		case(rand)
			3'b000: hexOn = 6'b00_0001;
			3'b001: hexOn = 6'b00_0010;
			3'b010: hexOn = 6'b00_0100;
			3'b011: hexOn = 6'b00_1000;
			3'b100: hexOn = 6'b01_0000;
			3'b101: hexOn = 6'b10_0000;
			3'b110: hexOn = 6'b00_0100;
			3'b111: hexOn = 6'b01_0000;
		endcase	
	end
	
	// An always block that is triggered when the game is reset or every 2 seconds, when bext input is expected
	// The reset conditions sets the score to 0, lives to 5, and game ended to 0, meanin the game has not yet ended
	// If the game is not reseted, it checks if bothe the timer is more than 0 and the player has more than 0 lives, once any of the condition is reached, the game ends and points are displayed
	// If the input from switches received is equal to the hex turned on, the score is updated, else life is deducted
	// The game ends when either of the condition becomes true first, that is timer runs out or lifes are 0

	always @(negedge reset or posedge clk_out_long) begin
		if (!reset) begin
			score <= 5'd0;
			life <= 3'b101;
			gameEnd <= 1'b0;
		end else begin 
			if (timer > 0 && life > 3'b000 ) begin // user makes 5 mistakes or timer expires
				if (SW == hexOn) begin
						score <= score + 5'd1;
				end else begin
					if (timer != 0) begin
						life <= life - 3'b001;	
					end
				end
			end else begin
				gameEnd <= 1;

			end
		end
	end	

	// An always block, that decides the number of LEDR's to turn on based on the number of lives

	always @(life) begin
		case(life)
		    3'b101: LEDR = 5'b11111;
		    3'b100: LEDR = 5'b01111;
			3'b011: LEDR = 5'b00111;
			3'b010: LEDR = 5'b00011;
			3'b001: LEDR = 5'b00001;
			3'b000: LEDR = 5'b00000;
			default: LEDR = 5'b00000; 
		endcase
	end

	// Assigns the obtained hex to be displayed to the output register
	assign HEX = hexOn;
	
endmodule 