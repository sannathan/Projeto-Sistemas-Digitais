module contador(clk, a, sinal_a, b, sinal_b, data, EN, RS, RW);
    input clk;
	 input [7:0]a;
	 input sinal_a;
	 input [7:0]b;
	 input sinal_b;
    output reg [7:0] data;      //verificar se é essa qtde de bits mesmo
    output reg EN, RS, RW;
	 
	 /*output [3:0] b_dezena,
	 output [3:0] b_centena,
	 output [3:0] b_milhar,
	 output [3:0] b_dez_milhar,
	 output [3:0] b_unidade,
	 
	 output [3:0] a_dezena,
	 output [3:0] a_centena,
	 output [3:0] a_milhar,
	 output [3:0] a_dez_milhar,
	 output [3:0] a_unidade*/
	 
	 
	reg a_dez_milhar;
	reg a_milhar;
	reg a_centena;
	reg a_dezena;
	reg a_unidade;
	reg b_dez_milhar;
	reg b_milhar;
	reg b_centena;
	reg b_dezena;
	reg b_unidade;
	
initial begin
   EN = 1;
   RS = 0;
   RW = 0;
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
end


parameter ONEMS = 50000, HALFMS = 25000;
parameter WRITE = 1, WAIT = 0, FINAL = 10;                          //verificar depois pra confirmar se write é 0 mesmo
reg [31:0] counter = 0;                                 //procurar saber pq [31:0]
reg [1:0] state = WRITE;
reg [7:0] instructions = 0;

always@ (posedge clk) begin
    case(state)
		 WRITE: begin
			  if(counter == ONEMS) begin state <= WAIT; counter <= 0; EN <= 0; end
			  else counter <= counter + 1;
		 end
		 
		 WAIT: begin
		 if(counter == HALFMS) begin state <= WRITE; counter <= 0; EN <= 1; 
			if(instructions < FINAL) instructions <= instructions + 1;
		 end
		 
		 else counter <= counter + 1;
		 end
    endcase
end

// Depois do contador, vem um always@ (*) pra imprimir os valores no LCD
always@ (*) begin
    case (instructions)
		0: begin data = 8'b00000001; RS = 0; end    //Limpar o display
		1: begin data = 8'b10000000; RS = 0;end    //Ir pra posição 0
		2: begin data = sinal_a; RS = 1; end // Printa sinal do num a 
		3: begin data = a_dez_milhar; RS = 1; end //Printa a dezena de milhar
		4: begin data = a_milhar; RS = 1;end //Printa a unidade de milhar
		5: begin data = a_centena; RS = 1;end //Printa a centena
		6: begin data = a_unidade; RS = 1;end //Printa a unidade
		7: begin data = 8'b00100000; RS = 1;end //Printa espaço
		8: begin data = 8'b00111111; RS = 1;end //Printa o operador
		9: begin data = 8'b00100000; RS = 1;end //Printa espaço
		10: begin data = sinal_b; RS = 1; end // Printa sinal do num b
		11: begin data = b_dez_milhar; RS = 1;end //Printa a dezena de milhar
		12: begin data = b_milhar; RS = 1;end //Printa a unidade de milhar
		13: begin data = b_centena; RS = 1;end //Printa a centena
		14: begin data = b_unidade; RS = 1;end //Printa a unidade
		
  
      default: begin data = 8'b10000000; RS = 0; end //ir para a posição 0
    endcase
	end
	
endmodule


		 
		 
		/*1: begin data = 8'b10000000; RS = 0; end    //Ir pra posição 0
		2: begin data = sinal_a; RS = 1; end //Printa sinal de a
		3: begin data = a; RS = 1; end //Printa num a
		3: begin data = 8'b00100000; RS = 1; end //Printa espaço
		4: begin data = ; RS = 1; end //Printa '?'
		5: begin data = 8'b00100000; RS = 1; end //Printa espaço
		6: begin data = sinal_b; RS = 1; end //Printa sinal de b
		2: begin data = b; RS = 1; end //Printa num b
		7: begin data = 8'b00111000; RS = 0; end//Cria segunda linha*/
