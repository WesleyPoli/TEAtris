module teatris_memoria_colunas_certas (
    input clock,                // Clock do sistema
    input [3:0] endereco,       // Endereço de memória (0-15)
    output reg [63:0] coluna     // Padrão de mapa para exibição
);

    // Memória ROM de padrões para mapas
    always @(posedge clock) begin
        case (endereco)
            
         4'd0: coluna <= {16'b0,48'hffff_ffff_ffff}; //col1 - copiar esses para as demais jogadas
         4'd1: coluna <= {48'hffff_ffff_ffff,16'b0,}; //col4
			4'd2: coluna <= {16'hffff,16'b0, 16'hffff,16'hffff}; //col2
			4'd3: coluna <= {16'hffff, 16'hffff, 16'b0 ,16'hffff}; //col3
            
         4'd7: coluna <= {16'b0,48'hffff_ffff_ffff}; //col1 - 
         4'd5: coluna <= {48'hffff_ffff_ffff,16'b0,}; //col4
			4'd4: coluna <= {16'hffff,16'b0, 16'hffff,16'hffff}; //col2
			4'd6: coluna <= {16'hffff, 16'hffff, 16'b0 ,16'hffff}; //col3
            
         4'd10: coluna <= {16'b0,48'hffff_ffff_ffff}; //col1 - 
         4'd8: coluna <= {48'hffff_ffff_ffff,16'b0,}; //col4
			4'd9: coluna <= {16'hffff,16'hffff,16'b0,16'hffff}; //col3
			4'd11: coluna <= {16'hffff,16'b0,16'hffff,16'hffff}; //col2
            
         4'd13: coluna <= {16'b0,48'hffff_ffff_ffff}; //col1 - 
         4'd15: coluna <= {48'hffff_ffff_ffff,16'b0,}; //col4
			4'd14: coluna <= {16'hffff,16'b0, 16'hffff,16'hffff}; //col2
			4'd12: coluna <= {16'hffff, 16'hffff, 16'b0 ,16'hffff}; //col3
            
      
        endcase
    end

endmodule