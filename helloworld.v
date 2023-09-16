module helloworld(
	output reg [7:0] data, //registrador que vai mandar o comando para o lcd
	output reg RW, RS, EN, estado, //comandos do lcd
	input clk, //clock
	input [7:0] a, b, //modulo da entrada a e b
	input sinal_a, sinal_b, botao_1, botao_2, botao_3, botao_4 // sinal de a e b, e respectivos botoes
);
   reg [15:0] saida; //variável que armazena o resultado das operações
	reg sinal_saida; // sinal do monstrão



parameter WAIT = 0, WRITE = 1, FINAL = 23;
reg [31:0] counter = 0;
parameter ONEMS = 50000, HALFMS = 25000;
reg [1:0] state = WRITE;
reg [7:0] instructions = 0;

reg [3:0] cache = 4'b1111;
reg [2:0] sel;

initial begin
	RS = 0;
	RW = 0;
	EN = 1;
	estado = 0;
	sel = 3'b000;
end //inicializa as variaveis

 always @(posedge clk) begin //Recebe a entrada e a operação 
		 if(!cache[0] && botao_1 && estado)begin
		     sel[0] <= 1;
			  sel[1] <= 0;
			  sel[2] <= 0;
			  estado <= 1;
		 end
		 else if(!cache[1] && botao_2 && estado)begin
		     sel[0] <= 0;
			  sel[1] <= 1;
			  sel[2] <= 0;
			  estado <= 1;
			  
		 end
		 else if(!cache[2] && botao_3 && estado)begin
		     sel[0] <= 0;
			  sel[1] <= 0;
			  sel[2] <= 1;
			  estado <= 1;
		 
		 end
		 else if(!cache[3] && botao_4)begin
		     if(estado)begin
		         sel[0] <= 0;
			      sel[1] <= 0;
			      sel[2] <= 0;
			      estado <= 0;
			  end
			  else begin
			      sel[0] <= 0;
			      sel[1] <= 0;
			      sel[2] <= 0;
			      estado <= 1;
			  end
		 end
		 
		 cache[0] <= botao_1;
		 cache[1] <= botao_2;
		 cache[2] <= botao_3;
		 cache[3] <= botao_4;
    end
	 
/*^ o codigo recebe a entrada dos botões da variável e a lógica é a seguinte: como a atuvação é em posedge, quando o botão variar de 1 > 0 ele vai ser acionado. Portanto, tem duas variáveis uma que guarda o estado anterior e o estado atual. Nisso faremos uma and com estado anterior, estado atual e estado de energia
assim quando a negação do estado anterior for 1, o botão atual for 1 e ele estiver no estado ligado, a variável sel recebe o botão pressionado e manda para a calculadora com a respectiva operação*/    
always @(*) begin
	case (sel)
		3'b100:begin   
		  sinal_saida = a > b? (sinal_a) : (sinal_b); //Usa ternario para descobrir qual o sinal vai prevalecer
		  if((sinal_a & sinal_b) | ((~sinal_a) & (~sinal_b)))begin //se o sinal for ambos positivos ou ambos negativos
				saida = (a + b); //apenas soma
		  end
		  else begin//Caso contrário
		    if(a > b) //Se a for maior que b
				  saida = (a - b); //
			  else 
					saida = (b - a);
			end
		end
		3'b010:begin
			sinal_saida = a > b? (sinal_a) : (~sinal_b);
			if((sinal_a & sinal_b) | (~sinal_a & ~sinal_b))begin //se os sinais forem iguais
					saida = a>b? (a - b): (b - a); //apenas subtrai
			end
			else begin
					saida = (a + b); //b sendo negativo, negativo com negativo soma
			end
		end
			3'b001: begin
				if((sinal_a & sinal_b) | (~sinal_a & ~sinal_b)) sinal_saida = 0; //Se os sinais forem iguais, a saída vai ser positiva
			   else sinal_saida = 1; //Caso contrario, vai ser negativa
				saida = (a * b); //Multiplica
			end
			default: begin
				saida = 0;
				sinal_saida = 0;
			end
	endcase
end
	 
	 
	 

reg [3:0] a_centena, a_dezena, a_unidade;
reg [3:0] b_centena, b_dezena, b_unidade;
reg [3:0] dez_milhar, milhar, centena, unidade, dezena;
reg [3:0] operacao; // armazena o simbolo da opercao que foi feita

always @(*)begin
	a_centena = ((a /100) % 10);
	a_dezena = ((a /10) % 10);
	a_unidade = a%10;
		 
	b_centena = ((b /100) % 10);
	b_dezena = ((b /10) % 10);
	b_unidade = b%10;
			
	dez_milhar = ((saida /10000) % 10);
	milhar = ((saida /1000) % 10);
	centena = ((saida /100) % 10);
	dezena = ((saida /10) % 10);
	unidade = saida%10;
end





always @(posedge clk) begin
	case (state)
		WRITE:begin
			if (counter == ONEMS) begin
				counter <= 0;
				state <= WAIT;
				EN <= 0;
			end
			else counter <= counter + 1;
		end
		WAIT:begin
			if (counter == HALFMS) begin
				counter <= 0;
				state <= WRITE;
				EN <= 1;
				if (instructions != FINAL) instructions <= instructions + 1;
				else instructions <= 0;
			end
			else begin counter <= counter + 1; end
		end
	endcase
end
always @(posedge clk) begin
         if (estado) begin
			case (instructions) 
				0: begin data <= 8'b00111000; RS <= 0; end //liga a primeira fileira do lcd
				1: begin data <= 8'b00001100; RS <= 0; end // segunda fileira do lcd
				2: begin data <= 8'b00000001; RS <= 0; end // limpa display
				3: begin data <= 8'b10000000; RS <= 0; end // vai para posição inicial na primeira linha
				4: begin
			   if(sinal_a) begin   
				data <= 8'b00101101; RS <= 1; end	//printa sinal negativo de a, caso exista
				end
				5: begin
	             case(a_centena)	
						  4'd0: begin data <= 8'b00110000; RS <= 1; end
						  4'd1: begin data <= 8'b00110001; RS <= 1; end
						  4'd2: begin data <= 8'b00110010; RS <= 1; end
						  4'd3: begin data <= 8'b00110011; RS <= 1; end
						  4'd4: begin data <= 8'b00110100; RS <= 1; end
						  4'd5: begin data <= 8'b00110101; RS <= 1; end
						  4'd6: begin data <= 8'b00110110; RS <= 1; end
						  4'd7: begin data <= 8'b00110111; RS <= 1; end
						  4'd8: begin data <= 8'b00111000; RS <= 1; end
						  4'd9: begin data <= 8'b00111001; RS <= 1; end
					endcase
					 
					 
				end
				6: begin 
			       case(a_dezena)
						  4'd0: begin data <= 8'b00110000; RS <= 1; end
						  4'd1: begin data <= 8'b00110001; RS <= 1; end
						  4'd2: begin data <= 8'b00110010; RS <= 1; end
						  4'd3: begin data <= 8'b00110011; RS <= 1; end
						  4'd4: begin data <= 8'b00110100; RS <= 1; end
						  4'd5: begin data <= 8'b00110101; RS <= 1; end
						  4'd6: begin data <= 8'b00110110; RS <= 1; end
						  4'd7: begin data <= 8'b00110111; RS <= 1; end
						  4'd8: begin data <= 8'b00111000; RS <= 1; end
						  4'd9: begin data <= 8'b00111001; RS <= 1; end
					endcase
		   	end
				7: begin 
				    case(a_unidade)	
					     4'd0: begin data <= 8'b00110000; RS <= 1; end
					     4'd1: begin data <= 8'b00110001; RS <= 1; end
						  4'd2: begin data <= 8'b00110010; RS <= 1; end
						  4'd3: begin data <= 8'b00110011; RS <= 1; end
						  4'd4: begin data <= 8'b00110100; RS <= 1; end
						  4'd5: begin data <= 8'b00110101; RS <= 1; end
						  4'd6: begin data <= 8'b00110110; RS <= 1; end
						  4'd7: begin data <= 8'b00110111; RS <= 1; end
						  4'd8: begin data <= 8'b00111000; RS <= 1; end
						  4'd9: begin data <= 8'b00111001; RS <= 1; end
					endcase
				end
				8: begin data <= 8'b00100000; RS <= 1; end //Printa Espaço
				9: begin
				      if(sel == 3'b100)begin data <= 8'h2B; RS <= 1;end
						else if(sel == 3'b010)begin data <= 8'h2D; RS <= 1;end
						else if(sel == 3'b001) begin data <= 8'h2A; RS <= 1; end
						else begin data <= 8'h3F; RS <= 1; end
				end
				10: begin data <= 8'h20; RS <= 1; end
				11: begin
				if(sinal_b) begin   
				data <= 8'b00101101; RS <= 1; end
				end
				12: begin 
			       case(b_centena)
						  4'd0: begin data <= 8'b00110000; RS <= 1; end
						  4'd1: begin data <= 8'b00110001; RS <= 1; end
						  4'd2: begin data <= 8'b00110010; RS <= 1; end
						  4'd3: begin data <= 8'b00110011; RS <= 1; end
						  4'd4: begin data <= 8'b00110100; RS <= 1; end
						  4'd5: begin data <= 8'b00110101; RS <= 1; end
						  4'd6: begin data <= 8'b00110110; RS <= 1; end
						  4'd7: begin data <= 8'b00110111; RS <= 1; end
						  4'd8: begin data <= 8'b00111000; RS <= 1; end
						  4'd9: begin data <= 8'b00111001; RS <= 1; end
					endcase
				
				end
				13: begin 
				    case(b_dezena)
						  4'd0: begin data <= 8'b00110000; RS <= 1; end
						  4'd1: begin data <= 8'b00110001; RS <= 1; end
						  4'd2: begin data <= 8'b00110010; RS <= 1; end
						  4'd3: begin data <= 8'b00110011; RS <= 1; end
						  4'd4: begin data <= 8'b00110100; RS <= 1; end
						  4'd5: begin data <= 8'b00110101; RS <= 1; end
						  4'd6: begin data <= 8'b00110110; RS <= 1; end
						  4'd7: begin data <= 8'b00110111; RS <= 1; end
						  4'd8: begin data <= 8'b00111000; RS <= 1; end
						  4'd9: begin data <= 8'b00111001; RS <= 1; end
					endcase
				end
				14: begin 
				    case(b_unidade)
						  4'd0: begin data <= 8'b00110000; RS <= 1; end
					     4'd1: begin data <= 8'b00110001; RS <= 1; end
						  4'd2: begin data <= 8'b00110010; RS <= 1; end
						  4'd3: begin data <= 8'b00110011; RS <= 1; end
						  4'd4: begin data <= 8'b00110100; RS <= 1; end
						  4'd5: begin data <= 8'b00110101; RS <= 1; end
						  4'd6: begin data <= 8'b00110110; RS <= 1; end
						  4'd7: begin data <= 8'b00110111; RS <= 1; end
						  4'd8: begin data <= 8'b00111000; RS <= 1; end
						  4'd9: begin data <= 8'b00111001; RS <= 1; end
					endcase
				end
				15: begin data <= 8'b11000000; RS <= 0; end
				16: begin data <= 8'h20; RS <= 1; end
				17: begin
				if(sinal_saida && saida != 0) begin   
				data <= 8'b00101101; RS <= 1; end
				end
				18: begin 
				    case(dez_milhar)
					     4'd0: begin data <= 8'b00110000; RS <= 1; end
						  4'd1: begin data <= 8'b00110001; RS <= 1; end
						  4'd2: begin data <= 8'b00110010; RS <= 1; end
						  4'd3: begin data <= 8'b00110011; RS <= 1; end
						  4'd4: begin data <= 8'b00110100; RS <= 1; end
						  4'd5: begin data <= 8'b00110101; RS <= 1; end
						  4'd6: begin data <= 8'b00110110; RS <= 1; end
						  4'd7: begin data <= 8'b00110111; RS <= 1; end
						  4'd8: begin data <= 8'b00111000; RS <= 1; end
						  4'd9: begin data <= 8'b00111001; RS <= 1; end
					endcase
				end 
				19: begin 
				    case(milhar)
						  4'd0: begin data <= 8'b00110000; RS <= 1; end
						  4'd1: begin data <= 8'b00110001; RS <= 1; end
						  4'd2: begin data <= 8'b00110010; RS <= 1; end
						  4'd3: begin data <= 8'b00110011; RS <= 1; end
						  4'd4: begin data <= 8'b00110100; RS <= 1; end
						  4'd5: begin data <= 8'b00110101; RS <= 1; end
						  4'd6: begin data <= 8'b00110110; RS <= 1; end
						  4'd7: begin data <= 8'b00110111; RS <= 1; end
						  4'd8: begin data <= 8'b00111000; RS <= 1; end
						  4'd9: begin data <= 8'b00111001; RS <= 1; end
					endcase
				end 
				20: begin
				    case(centena)
						  4'd0: begin data <= 8'b00110000; RS <= 1; end
						  4'd1: begin data <= 8'b00110001; RS <= 1; end
						  4'd2: begin data <= 8'b00110010; RS <= 1; end
						  4'd3: begin data <= 8'b00110011; RS <= 1; end
						  4'd4: begin data <= 8'b00110100; RS <= 1; end
						  4'd5: begin data <= 8'b00110101; RS <= 1; end
						  4'd6: begin data <= 8'b00110110; RS <= 1; end
						  4'd7: begin data <= 8'b00110111; RS <= 1; end
						  4'd8: begin data <= 8'b00111000; RS <= 1; end
						  4'd9: begin data <= 8'b00111001; RS <= 1; end
					endcase
				end
				21: begin
				    case(dezena)
						  4'd0: begin data <= 8'b00110000; RS <= 1; end
						  4'd1: begin data <= 8'b00110001; RS <= 1; end
						  4'd2: begin data <= 8'b00110010; RS <= 1; end
						  4'd3: begin data <= 8'b00110011; RS <= 1; end
						  4'd4: begin data <= 8'b00110100; RS <= 1; end
						  4'd5: begin data <= 8'b00110101; RS <= 1; end
						  4'd6: begin data <= 8'b00110110; RS <= 1; end
						  4'd7: begin data <= 8'b00110111; RS <= 1; end
						  4'd8: begin data <= 8'b00111000; RS <= 1; end
						  4'd9: begin data <= 8'b00111001; RS <= 1; end
					endcase
				end
				22: begin 
				    case(unidade)
						  4'd0: begin data <= 8'b00110000; RS <= 1; end
					     4'd1: begin data <= 8'b00110001; RS <= 1; end
						  4'd2: begin data <= 8'b00110010; RS <= 1; end
						  4'd3: begin data <= 8'b00110011; RS <= 1; end
						  4'd4: begin data <= 8'b00110100; RS <= 1; end
						  4'd5: begin data <= 8'b00110101; RS <= 1; end
						  4'd6: begin data <= 8'b00110110; RS <= 1; end
						  4'd7: begin data <= 8'b00110111; RS <= 1; end
						  4'd8: begin data <= 8'b00111000; RS <= 1; end
						  4'd9: begin data <= 8'b00111001; RS <= 1; end
					endcase
				end
				default: begin data <= 8'b10000000; RS <= 0; end
			endcase
			end
			else begin
			data <= 8'b00000001; RS <= 0;  // limpa display
			data <= 8'b00001001; RS <= 0; end		//desligar
			
end



endmodule 