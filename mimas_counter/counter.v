//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:51:27 01/24/2017 
// Design Name: 
// Module Name:    counter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
////////////////////////////////////////////////////////////////////////////////
`define LED_INTERVAL 100			// time (ms) delay for each LED count (not count_cycle)
`define TIME_STEP 10				// time step (ms) when push the button
`define SW_INTERVAL 100				// time (ms) delay between successive button pushes
`define CLK_SPEED 100000			// number of clock cycles in 1ms
`define NUM_CYCLE_STEP `TIME_STEP*`CLK_SPEED


module counter(CLK, LED, SW1, SW2, SW4);
	input wire CLK, SW1, SW2, SW4;
	output reg [7:0]LED;
	
	reg [32:0]count_cycle;			// number of cycles
	reg [32:0]num_cycle_LED;			// number of cycles waiting to update LED
	reg [32:0]num_cycle_SW;			// number of cycles waiting to update SW
	reg sw1_pushed, sw4_pushed;						// 1 if switch was pushed, 0 otherwise
	reg state_LED, state_SW;						// 1 if the number of cycle
		
	initial begin
		LED = 0;
		count_cycle = 0;
		state_LED = 0;
		state_SW = 0;
		sw1_pushed = 0;
		sw4_pushed = 0;
		num_cycle_LED = `LED_INTERVAL*`CLK_SPEED;
		num_cycle_SW = `SW_INTERVAL*`CLK_SPEED;
	end
	
	always @(posedge CLK) begin
		if (count_cycle % num_cycle_LED == 0)
			state_LED = 1;	// set state when count_cycle reaches num_cycle_LED

		if (count_cycle % num_cycle_SW == 0)
			state_SW = 1;	// set state when count_cycle reaches num_cycle_SW

		// STATE LED: 
		if (state_LED) begin
			if (LED == {8{1'b1}})
				LED = 0; 			// reset when LED is full
			else
				LED = LED + 1'b1;	// increase LED by 1
			state_LED = 0;
		end


		// STATE SW
		if (!(SW1 | sw1_pushed))
			sw1_pushed = 1;
		if (!(SW4 | sw4_pushed))
			sw4_pushed = 1;

		if (state_SW) begin
			if (sw1_pushed)
				if (num_cycle_LED < {32{1'b1}})
					num_cycle_LED = num_cycle_LED + `NUM_CYCLE_STEP;
			if (sw4_pushed)
				if (num_cycle_LED > `TIME_STEP*`CLK_SPEED)
					num_cycle_LED = num_cycle_LED - `NUM_CYCLE_STEP;
			sw1_pushed = 0;
			sw4_pushed = 0;
			state_SW = 0;
		end

		// RESET
		if (!SW2) begin
			LED = 0;
			count_cycle = 0;
			state_LED = 0;
			state_SW = 0;
			sw1_pushed = 0;
			sw4_pushed = 0;
			num_cycle_LED = `LED_INTERVAL*`CLK_SPEED;
			num_cycle_SW = `SW_INTERVAL*`CLK_SPEED;	
		end

		count_cycle = count_cycle + 1;
		if (count_cycle == {32{1'b1}})
			count_cycle = 0;			// reset when count_cycle is full
	end
	
endmodule