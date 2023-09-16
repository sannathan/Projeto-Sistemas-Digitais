module teste(
	 input [7:0]a,
	 input sinal_a,
	 input [7:0]b,
	 input sinal_b,
    output saida_1, saida_2, saida_3
);
    reg a_dez_milhar, a_milhar, a_centena, a_dezena, a_unidade,
	 reg b_dez_milhar, b_milhar, b_centena, b_dezena, b_unidade,
	 reg dez_milhar, milhar, centena, unidade, dezena
		 a_dez_milhar = (a /10000) % 10;
		 a_milhar = (a /1000) % 10;
		 a_centena = (a /100) % 10;
		 a_dezena = (a /10) % 10;
		 a_unidade = a;
		 
		 b_dez_milhar = (b /10000) % 10;
		 b_milhar = (b /1000) % 10;
		 b_centena = (b /100) % 10;
		 b_dezena = (b /10) % 10;
		 b_unidade = b;
			
		 dez_milhar = (saida /10000) % 10;
		 milhar = (saida /1000) % 10;
		 centena = (saida /100) % 10;
		 dezena = (saida /10) % 10;
		 unidade = saida;
		 saida_1 = a_dez_milhar;
		 saida_2 = a_centena;
		 saida_3 = a_dezena;
endmodule 