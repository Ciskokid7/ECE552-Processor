module br_control(cond, flags, br_control, clk, branch);

input [2:0] cond, flags; //condition codes and flags = 3'b N, V, Z
input br_control;  //Control Signal telling us if a branch is requested
input clk; //system clk

output reg branch; //Essentially a boolean telling us to take or not take branch

localparam NOT_TAKEN = 0;
localparam TAKEN = 1; 

always @(posedge clk) begin

	if(br_control) begin
		branch = (cond==3'b000 && flags[0]==1'b0) ? TAKEN : 
				(cond==3'b001 && flags[0]==1'b1) ? TAKEN : 
				(cond==3'b010 && flags[0]==1'b0 && flags[2]==1'b0) ? TAKEN : 
				(cond==3'b011 && flags[2]==1'b1) ? TAKEN :
				(cond==3'b100 && (flags[0]==1'b1 || (flags[0]==1'b0 && flags[2]==1'b0))) ? TAKEN :
				(cond==3'b101 && (flags[0]==1'b1 || flags[2]==1'b1)) ? TAKEN : 
				(cond==3'b110 && flags[1]==1'b1) ? TAKEN :
				(cond==3'b111) ? TAKEN :
				 NOT_TAKEN;
	end else begin
		branch = NOT_TAKEN;
	end
	
end

endmodule