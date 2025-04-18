module teatris_memoria_jogadas (
    input clock,                // Clock do sistema
    input [3:0] endereco,       // Endereço de memória (0-15)
    output reg [3:0] jogada     // Padrão de botão correto
);

    // Memória ROM de botões corretos para cada padrão
    always @(posedge clock) begin
        case (endereco)
            4'h0: jogada <= 4'b1000; //1
            4'h1: jogada <= 4'b0001; //4
				4'h2: jogada <= 4'b0100; //2
				4'h3: jogada <= 4'b0010; //3
				
				4'h4: jogada <= 4'b0100; //2
            4'h5: jogada <= 4'b0001; //4
				4'h6: jogada <= 4'b0010; //3
				4'h7: jogada <= 4'b1000; //1
				
				4'h8: jogada <= 4'b0001; //4
            4'h9: jogada <= 4'b0010; //2
				4'hA: jogada <= 4'b1000; //1
				4'hB: jogada <= 4'b0100; //3
				
				4'hC: jogada <= 4'b0010; //3
            4'hD: jogada <= 4'b1000; //1
				4'hE: jogada <= 4'b0100; //2
				4'hF: jogada <= 4'b0001; //4
			
			

        endcase
    end

endmodule