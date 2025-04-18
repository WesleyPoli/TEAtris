module teatris_memoria_mapas (
    input clock,                // Clock do sistema
    input [3:0] endereco,       // Endereço de memória (0-15)
    output reg [63:0] padrao     // Padrão de mapa para exibição
);

    // Memória ROM de padrões para mapas
    always @(posedge clock) begin
        case (endereco)
            
            4'd0: padrao <= {16'b00000_01_000000_11_0,48'b0}; //1 
            4'd1: padrao <= {48'b0,16'b0_11_000000_11_00000}; //4
			4'd2: padrao <= {16'b0,16'b000_01_000000_01_000, 32'b0}; //2
			4'd3: padrao <= {32'b0,16'b000_00_000000_11_000, 16'b0}; //3
				
            4'd4: padrao <= {16'b0, 16'b000_10_000000_11_000,32'b0}; //2
            4'd5: padrao <= {48'b0,16'b000_11_000000_10_000}; //4
			4'd6: padrao <= {32'b0,16'b000_01_000000_10_000, 16'b0}; //3 
			4'd7: padrao <= {16'b000_10_000000_01_000, 48'b0}; //1
            
			4'd8: padrao <= {48'b0,16'b000_01_000000_11_000}; //4
            4'd9: padrao <= {32'b0,16'b000_11_000000_10_000, 16'b0}; //3
			4'd10: padrao <= {16'b000_01_000000_10_000, 48'b0}; //1
			4'd11: padrao <= {16'b0,16'b000_11_000000_01_000, 32'b0}; //2
            
			4'd12: padrao <= {32'b0,16'b000_11_000000_00_000,16'b0}; //3
            4'd13: padrao <= {16'b000_11_000000_11_000,48'b0}; //1
			4'd14: padrao <= {16'b0,16'b000_10_000000_10_000, 32'b0}; //2
			4'd15: padrao <= {48'b0,16'b000_10_000000_01_000}; //4
            
            
            default: padrao <= {8'b11_00_00_11,
									8'b11_01_01_11,
                          8'b11_11_11_11,
                          8'b11_00_00_11,
                          8'b11_11_11_11,
                          8'b11_00_00_11,
                          8'b11_10_11_11,
                          8'b11_00_00_11};
        endcase
    end

endmodule