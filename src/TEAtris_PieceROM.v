module teatris_memoria_pecas (
    input clock,                // Clock do sistema
    input [3:0] endereco,       // Endereço de memória (0-15)
    output reg [15:0] padrao     // Padrão de peça para exibição
);

    // Memória ROM de padrões para peças
    always @(posedge clock) begin
        case (endereco)
            // Peça 0: L vertical (2 blocos)
            4'd0: padrao <= 16'b111_00_111111_10_111; 
            4'd1: padrao <= 16'b111_00_111111_00_111;
			4'd2: padrao <= 16'b111_10_111111_10_111;
			4'd3: padrao <= 16'b111_00_111111_11_111;
				
			4'd4: padrao <= 16'b111_00_111111_01_111; 
            4'd5: padrao <= 16'b111_01_111111_00_111;
			4'd6: padrao <= 16'b111_01_111111_10_111;
			4'd7: padrao <= 16'b111_10_111111_01_111;
				
			4'd8: padrao <= 16'b111_00_111111_10_111; 
            4'd9: padrao <= 16'b111_01_111111_00_111;
			4'd10: padrao <= 16'b111_01_111111_10_111;
			4'd11: padrao <= 16'b111_10_111111_00_111;
				
			4'd12: padrao <= 16'b111_11_111111_00_111; 
            4'd13: padrao <= 16'b111_00_111111_00_111;
			4'd14: padrao <= 16'b111_01_111111_01_111;
			4'd15: padrao <= 16'b111_10_111111_01_111;
				
            
            
            default: padrao <= 16'b1111111111111111;
        endcase
    end

endmodule