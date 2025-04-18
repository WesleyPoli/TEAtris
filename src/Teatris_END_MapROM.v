module teatris_memoria_fim(
    input clock,                // Clock do sistema
    input [3:0] endereco,       // Endereço de memória (0-15)
    output reg [63:0] padrao     // Padrão de mapa para exibição
);

    // Memória ROM de FIM DE JOGO
    always @(posedge clock) begin
        case (endereco)
			4'd15: padrao <= {8'b00_00_10_00,
									  8'b01_01_11_00,
									  8'b11_11_11_10,
									  8'b00_00_11_11,
									  8'b11_11_11_11,
									  8'b00_00_11_11,
									  8'b10_11_11_11,
									  8'b00_00_11_11}; //FIM	

			default: padrao <= {8'b00_00_10_00,
									  8'b01_01_11_00,
									  8'b11_11_11_10,
									  8'b00_00_11_11,
									  8'b11_11_11_11,
									  8'b00_00_11_11,
									  8'b10_11_11_11,
									  8'b00_00_11_11}; //FIM				  
            
        endcase
    end

endmodule