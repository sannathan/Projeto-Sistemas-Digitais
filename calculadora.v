module calculadora(a, b, sinal_a, sinal_b, sel, saida, sinal_saida, EN, RS, RW, data);
    input [7:0] a;
	 input [2:0] sel;
	 input [7:0] b;
	 input sinal_a;
	 input sinal_b;   
	 output reg [15:0] saida;
	 output reg sinal_saida;
	 
	 output [7:0] data;      //verificar se é essa qtde de bits mesmo
    output EN, RS, RW;
	 
	 initial begin
			saida = 0;
			sinal_saida = 0;
	  end
	  
	  always @(*) begin
		 case (sel)
			  3'b100:begin   
					sinal_saida = a > b? (sinal_a) : (sinal_b);
					if((sinal_a & sinal_b) | ((~sinal_a) & (~sinal_b)))begin 
						 saida = (a + b);
					end
					else begin
						 if(a > b)
							  saida = (a - b);
						 else 
							  saida = (b - a);
					end
			  end
			  3'b010:begin
					sinal_saida = a > b? (sinal_a) : (~sinal_b);
					if((sinal_a & sinal_b) | (~sinal_a & ~sinal_b))begin
						 saida = a>b? (a - b): (b - a);
					end
					else begin
						  saida = (a + b);
					end
				end
				 3'b001: begin
					  if((sinal_a & sinal_b) | (~sinal_a & ~sinal_b)) sinal_saida = 0;
					  else sinal_saida = 1;
					  saida = (a * b);
				 end
				 default: begin
						saida = 0;
						sinal_saida = 0;
					end
		  endcase
		end
		
		ULA_LCD(.saida(saida), .sinal_saida(sinal_saida), .a(a), .b(b), .sinal_a(sinal_a), .sinal_b(sinal_b), .sel(sel), .EN(EN), .RS(RS), .RW(RW));
endmodule 