module principal(clk, a, sinal_a, b, sinal_b, data, EN, RS, RW, botao_1, botao_2, botao_3, botao_4);
    input [7:0] a, b;
	 input sinal_a, sinal_b, clk;
	 output [7:0] data;
	 output EN, RS, RW;
	 input botao_1; // Mult
	 input botao_2; // Soma
	 input botao_3; // Subt
	 input botao_4; // ON/OFF
	 parameter temp = 50000, temp_met = 25000;
	 reg estado, est_b4; reg [15:0] cont;
	 initial begin 
	     estado = 0;
		  cont = 0;
	 end
	 //if(estado)begin
	     seletor(.a(a), .b(b), .sinal_a(sinal_a), .sinal_b(sinal_b), .botao_1(botao_1), .botao_2(botao_2), .botao_3(botao_3), .botao_4(botao_4), .clk(clk), .saida(saida), .sinal_saida(sinal_saida));
	     ULA_LCD( .saida(saida), .sinal_saida(sinal_saida), .a(a), .sinal_a(sinal_a), .b(b), .sinal_b(sinal_b), .sel(sel), .EN(EN), .RS(RS), .RW(RW), .data(data));
	 //end
	 //else //desliga lcd
	 always @(posedge clk) begin
	     if(!est_b4 & botao_4)begin
		      if(!estado)begin
		          cont <= cont + 1;
					 if(cont == temp)begin
					     cont <= 0;
						  est_b4 <= 1;
						  estado <= 1;
					 end
				end
				else begin
				    cont <= cont + 1;
					 if(cont == temp_met)begin
					     cont <= 0;
						  est_b4 <= 0;
						  estado <= 0;
					 end
				end
		  end
	 end
endmodule 