module Start(
	input logic start,
	input logic reset,
	output logic pause
);

logic reset_pause;
logic tg;
logic rp;

assign pause = tg;

//assign pause = ((reset_pause == 1'b1) ? 1'b0 : tg);
//assign reset_pause = (rp == 1'b1) ? 1'b1 : ( (pause == 1'b0) ? 1'b0 : pause);

always_ff @(negedge start or reset)
	tg = ~tg;
	
//always_ff @(negedge reset)
//	rp = 1'b1;
	
endmodule
