module seletor(a, b, sinal_a, sinal_b, botao_1, botao_2, botao_3, botao_4, clk, saida, sinal_saida);
    input [7:0] a;
	 input [7:0] b;
    input sinal_a; 
	 input sinal_b;
    input botao_1; // Mult
	 input botao_2; // Soma
	 input botao_3; // Subt
	 input botao_4; // ON/OFF
    input clk;
    output [15:0] saida;
	 output sinal_saida;
	 

    reg [3:0] cache = 4'b1111;	 //registrador pra armazenar a memória dos botoes anteriores
    reg [2:0] sel = 3'b111;  // verificamos se ouve alguma alteracao nos botes, caso tiver atualizamos o selec

	 //contador(.clk(clk), .sinal_a(sinal_a), .sinal_b(sinal_b), .a(a), .b(b), .data(data), .EN(EN), .RS(RS), .RW(RW)); // Assim que apertar o botão ligar, vai aparecer o numA e numB
	 
    always @(posedge clk) begin //Recebe a entrada e a operação 
		 if(!cache[0] && botao_1)begin
		     sel[0] <= 1;
			  sel[1] <= 0;
			  sel[2] <= 0;
		 end
		 else if(!cache[1] && botao_2)begin
		     sel[0] <= 0;
			  sel[1] <= 1;
			  sel[2] <= 0;
		 end
		 else if(!cache[2] && botao_3)begin
		     sel[0] <= 0;
			  sel[1] <= 0;
			  sel[2] <= 1;
		 
		 end
		 else if(!cache[3] && botao_4)begin
		     sel[0] <= 0;
			  sel[1] <= 0;
			  sel[2] <= 0;
		 end
		 
		 cache[0] <= botao_1;
		 cache[1] <= botao_2;
		 cache[2] <= botao_3;
		 cache[3] <= botao_4;
    end
	 
	 calculadora(.a(a), .b(b), .sinal_a(sinal_a), .sinal_b(sinal_b), .sel(sel), .saida(saida), .sinal_saida(sinal_saida)); //Faz a operação
	 
	 
endmodule
