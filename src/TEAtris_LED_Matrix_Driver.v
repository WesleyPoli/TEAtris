module driver_matriz_2088bs (
    input clock,                  // Clock do sistema
    input reset,                  // Sinal de reset
    
    // Padrões para cada linha da matriz
    input [7:0] padrao_linha0,
    input [7:0] padrao_linha1,
    input [7:0] padrao_linha2,
    input [7:0] padrao_linha3,
    input [7:0] padrao_linha4,
    input [7:0] padrao_linha5,
    input [7:0] padrao_linha6,
    input [7:0] padrao_linha7,
    
    // Saídas individuais para linhas (cátodo comum, ativo baixo)
    output linha0,
    output linha1,
    output linha2,
    output linha3,
    output linha4,
    output linha5,
    output linha6,
    output linha7,
    
    // Saídas individuais para colunas (ânodo comum, ativo alto)
    output coluna0,
    output coluna1,
    output coluna2,
    output coluna3,
    output coluna4,
    output coluna5,
    output coluna6,
    output coluna7
);

    // Contador para varredura das linhas
    reg [2:0] contador_linha;
    
    // Divisor de clock para controlar a taxa de varredura (evitar flicker)
    reg [7:0] divisor_clock;
    wire pulso_varredura;
    
    // Registradores internos
    reg [7:0] linha_ativa;        // Linhas (ativo baixo)
    reg [7:0] coluna_ativa;       // Colunas (ativo alto)
    
    // Gerar clock mais lento para varredura
    always @(posedge clock or posedge reset) begin
        if (reset)
            divisor_clock <= 8'b0;
        else
            divisor_clock <= divisor_clock + 1'b1;
    end
    
    // Usar bit mais significativo do divisor como pulso de varredura
    assign pulso_varredura = divisor_clock[7];
    
    // Contador de varredura de linhas
    always @(posedge pulso_varredura or posedge reset) begin
        if (reset)
            contador_linha <= 3'b000;
        else
            contador_linha <= contador_linha + 1'b1;
    end
    
    // Decodificador para selecionar uma linha por vez (ativo baixo para cátodo comum)
    always @(*) begin
        case (contador_linha)
            3'b000: linha_ativa = 8'b00000001;  // Linha 0 ativa
            3'b001: linha_ativa = 8'b00000010;  // Linha 1 ativa
            3'b010: linha_ativa = 8'b00000100;  // Linha 2 ativa
            3'b011: linha_ativa = 8'b00001000;  // Linha 3 ativa
            3'b100: linha_ativa = 8'b00010000;  // Linha 4 ativa
            3'b101: linha_ativa = 8'b00100000;  // Linha 5 ativa
            3'b110: linha_ativa = 8'b01000000;  // Linha 6 ativa
            3'b111: linha_ativa = 8'b10000000;  // Linha 7 ativa
            default: linha_ativa = 8'b00000000; // Nenhuma linha ativa
        endcase
    end
    
    // Multiplexador para selecionar o padrão da linha atual
    always @(*) begin
        case (contador_linha)
            3'b000: coluna_ativa = padrao_linha0;
            3'b001: coluna_ativa = padrao_linha1;
            3'b010: coluna_ativa = padrao_linha2;
            3'b011: coluna_ativa = padrao_linha3;
            3'b100: coluna_ativa = padrao_linha4;
            3'b101: coluna_ativa = padrao_linha5;
            3'b110: coluna_ativa = padrao_linha6;
            3'b111: coluna_ativa = padrao_linha7;
            default: coluna_ativa = 8'b00000000;
        endcase
    end
    
    // Atribuir saídas individuais para linhas
    assign linha0 = linha_ativa[0];
    assign linha1 = linha_ativa[1];
    assign linha2 = linha_ativa[2];
    assign linha3 = linha_ativa[3];
    assign linha4 = linha_ativa[4];
    assign linha5 = linha_ativa[5];
    assign linha6 = linha_ativa[6];
    assign linha7 = linha_ativa[7];
    
    // Atribuir saídas individuais para colunas
    assign coluna0 = coluna_ativa[0];
    assign coluna1 = coluna_ativa[1];
    assign coluna2 = coluna_ativa[2];
    assign coluna3 = coluna_ativa[3];
    assign coluna4 = coluna_ativa[4];
    assign coluna5 = coluna_ativa[5];
    assign coluna6 = coluna_ativa[6];
    assign coluna7 = coluna_ativa[7];
    
endmodule