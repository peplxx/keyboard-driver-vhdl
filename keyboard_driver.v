//////////////////////////////////////////////////////////////////////////////////
// Company: Innopolis University 
// Engineer: Melnikov Sergey
// 
// Create Date: 2023/12/01 00:35:50
// Design Name: keyboard_4_4
// Module Name: keyboard_4_4
// Project Name: 
// Target Devices: Matrix Keyboard 4x4
// Tool Versions: 
// Description: 
//  This driver allows to get input from Matrix Keyboard 4x4 
// Dependencies: 
// 
// Revision:
// Revision 0.10 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module keyboard_4_4 (
	input clk, 
	input [3:0] col,
	output reg [3:0] row, 
	output reg [7:0] keyCode
);


// Internal signals:
// [ FSM ] Introdusing local variables
reg [1:0]state=2'b00;
reg [1:0]nextState=2'b00;

integer i;
integer bits=0;

// Clock related variables
integer DELAY = 10;
integer ticks = 0;

reg [7:0] buff = 8'b00000000;


// [ FSM ]
always@(posedge clk) begin
	if (ticks == DELAY)begin
		state <= nextState;
	    ticks = 0;
	end
	else begin
		ticks = ticks + 1;
	end
end

//  Keyboard hardware workflow on Finite State Machine
always@(posedge clk) begin
	case (state)
		2'b00: row <= 4'b1110;
		2'b01: row <= 4'b1101;
		2'b10: row <= 4'b1011;
		2'b11: row <= 4'b0111;
	endcase
	
	 bits = 0;
	 buff <= {row[0],row[1],row[2],row[3],col[0],col[1],col[2],col[3]};
	 buff <= ~buff;
	 
	 for (i = 0;i<8;i = i+1)begin
		if (buff[i])begin
			bits = bits+1;
		end
	 end
	 if (~col != 4'b0000 && bits == 2)begin
		 keyCode <= buff;
	 end
end

// [ FSM ] next state preparation:
always @(posedge clk) begin
        case (state)
            2'b00: nextState <= 2'b01;
            2'b01: nextState <= 2'b10;
            2'b10: nextState <= 2'b11;
            2'b11: nextState <= 2'b00;
        endcase
end

endmodule