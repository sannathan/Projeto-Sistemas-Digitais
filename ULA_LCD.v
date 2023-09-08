module ULA_LCD( saida, sinal_saida, a, sinal_a, b, sinal_b, sel, EN, RS, RW, data);
    input [15:0] saida;
    input sinal_saida;
	 input [7:0]a;
	 input sinal_a;
	 input [7:0]b;
	 input sinal_b;
	 input [2:0] sel;
	 output reg EN;
	 output reg RS;
	 output reg RW;
	 output reg [7:0] data;
    reg a_dez_milhar, a_milhar, a_centena, a_dezena, a_unidade;
	 reg b_dez_milhar, b_milhar, b_centena, b_dezena, b_unidade;
	 reg dez_milhar, milhar, centena, unidade, dezena;
	 initial begin
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
	 end
	
	 reg [5:0] instructions = 0;
	 reg [7:0] oper; 
	 reg [7:0] operA; 
	 reg [7:0] operB; 
	 reg [7:0] operR;
	 
	 always@(*)begin
		case(sel)
			4: begin oper = 8'b00101011; end //Atribui a variável oper, o binario do char '+'
			2: begin oper = 8'b00101101; end //Atribui a variável oper, o binario do char '-'
			1: begin oper = 8'b00101010; end //Atribui a variável oper, o binario do char '*'
		endcase
		
		case(sinal_a)
			1: begin operA = 8'b00101101; end
			default: begin operA = 8'b00100000; end
		endcase
		
		case(sinal_b)
			1: begin operB = 8'b00101101; end
			default: begin operB = 8'b00100000; end
		endcase
		
		case(sinal_saida)
			1: begin operR = 8'b00101101; end
			default: begin operR = 8'b00100000; end
		endcase
	 end
	
	 always@(*) begin
	 case(instructions)
		 0: begin data <= 8'b10000000; RS <= 0; instructions <= instructions + 1;end    //Ir pra posição 0
		 1: begin data <= operA; RS <= 1; instructions <= instructions + 1; end // Printa sinal do num a 
		 2: begin data <= a_dez_milhar; RS <= 1; instructions <= instructions + 1; end //Printa a dezena de milhar
		 3: begin data <= a_milhar; RS <= 1; instructions <= instructions + 1;end //Printa a unidade de milhar
		 4: begin data <= a_centena; RS <= 1; instructions <= instructions + 1;end //Printa a centena
		 5: begin data <= a_unidade; RS <= 1; instructions <= instructions + 1;end //Printa a unidade
		 6: begin data <= 8'b00100000; RS <= 1; instructions <= instructions + 1;end //Printa espaço
		 7: begin data <= oper; RS <= 1; instructions <= instructions + 1;end //Printa o operador
		 8: begin data <= 8'b00100000; RS <= 1; instructions <= instructions + 1;end //Printa espaço
		 9: begin data <= operB; RS <= 1; instructions <= instructions + 1; end // Printa sinal do num b
		 10: begin data <= b_dez_milhar; RS <= 1; instructions <= instructions + 1;end //Printa a dezena de milhar
		 11: begin data <= b_milhar; RS <= 1; instructions <= instructions + 1;end //Printa a unidade de milhar
		 12: begin data <= b_centena; RS <= 1; instructions <= instructions + 1;end //Printa a centena
		 13: begin data <= b_unidade; RS <= 1; instructions <= instructions + 1;end //Printa a unidade
		 14: begin data <= 8'b00111000; RS <= 0; instructions <= instructions + 1;end//Cria segunda linha
		 15: begin data <= 8'b11000000; RS <= 0; instructions <= instructions + 1;end//Vai para o primeiro char da segunda linha
		 16: begin data <= operR; RS <= 1; instructions <= instructions + 1; end // Printa sinal do resultado
		 17: begin data <= dez_milhar; RS <= 1; instructions <= instructions + 1;end //Printa a dezena de milhar
		 18: begin data <= milhar; RS <= 1; instructions <= instructions + 1;end //Printa a unidade de milhar
		 19: begin data <= centena; RS <= 1; instructions <= instructions + 1;end //Printa a centena
		 20: begin data <= unidade; RS <= 1; instructions <= instructions + 1;end //Printa a unidade
		 
	 endcase
	 end
	 
endmodule 