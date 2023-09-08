module counter(input clk, output led[7:0]);
reg [27:0] count = 28'b0;
reg [7:0] code = 8'b0;
reg init = 1;
always @(posedge clk)begin
    count = count + 1;
	 if(init)begin
	     case(count[27:0])
		      0: code <= 8'b00010000;
				1: code <= 8'b10010010;
				2: code <= 8'b01010011;
				3: code <= 8'b11101110;
				4: code <= 8'b01110111;
				7: init <= 0;
				default: code <= 8'h00000000;
		  endcase
    end else begin
	     code <= 8'b00000000;
	 end
endmodule
