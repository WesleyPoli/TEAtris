module teatris_fluxo_dados (
    // Entradas básicas
    input clock,                // Clock do sistema
    input reset,                // Sinal de reset
    input [3:0] botoes,         // Botões de entrada
	 input dificuldade,
    
    // Sinais de controle da UC
    input zera_contador,        // Zera o contador de endereços
    input conta_contador,       // Incrementa o contador
    input enable_memoria,       // Habilita leitura/registro da memória
    input registra_jogada,      // Registra a jogada atual
	input zera_jogada,
    input timer_restart,        // Reinicia o temporizador
	input timer_animacao_restart,
	input conta_timer_animacao,
    input zera_erro,
    input conta_erro,
	 input mapa_fim,
    
    // Sinais de estado para a UC
    output tem_jogada, 
    output fim_erro,         // Indica que um botão foi pressionado
    output jogada_ok,           // Indica que a jogada está correta
    output fim_sequencia,       // Indica fim da sequência atual
    output timeout,             // Indica que o tempo se esgotou
	output fim_timer_animacao,
    output [3:0] erros,
    
    // Saídas para exibição
    output [15:0] padrao_peca,   // Padrão para matriz de peça
    output [63:0] padrao_mapa,   // Padrão para matriz de mapa
	output [63:0] padrao_coluna,   // Padrão para matriz de colunas certas
    
    // Saídas de depuração
    output [3:0] db_contagem,   // Valor atual do contador
    output [3:0] db_jogada,     // Jogada atual registrada
    output [3:0] db_memoria,     // Valor esperado da memória
	output db_tem_jogada
);

    // Sinais internos
    wire [3:0] s_endereco;        // Endereço atual da memória
	 wire [3:0] s_endereco_fim;
    wire [15:0] s_padrao_peca;     // Padrão de peça da memória
	 wire [63:0] s_mapas_facil;
	 wire [63:0] s_mapas_dificil;
	 wire [63:0] s_fim;
    wire [63:0] s_padrao_mapa;     // Padrão de mapa da memória
	wire [63:0] s_padrao_coluna;
    wire [3:0] s_jogada_correta;  // Jogada correta para o padrão atual
	wire [3:0] s_erro;
    wire s_pulso_jogada;
    wire [3:0] s_jogada_atual;     // Jogada atual registrada
    reg [15:0] r_padrao_peca;      // Registrador para padrão de peça
    reg [63:0] r_padrao_mapa;      // Registrador para padrão de mapa
	reg [63:0] r_padrao_coluna;    // Registrador para padrão de colunas corretas
	
	  
    
    edge_detector detector_jogada (
      .clock(clock),
      .reset( ~botoes[3] & ~botoes[2] & ~botoes[1] & ~botoes[0]),
      .sinal( botoes[3] | botoes[2] | botoes[1] | botoes[0]),
      .pulso(s_pulso_jogada)
	 );

    
    // Contador de endereços para acessar a memória
    contador_163 contador_endereco (
        .clock(clock),
        .clr(~zera_contador),
        .ld(1'b1),               // Load ativo alto
        .ent(1'b1),              // Enable de contagem
        .enp(conta_contador),    // Enable de incremento
        .D(4'b0000),             // Valor inicial
        .Q(s_endereco),          // Saída do contador
        .rco(fim_sequencia)      // Ripple Carry Out como fim de sequência
    );
    
    // Memórias ROM
    teatris_memoria_pecas memoria_pecas (
        .clock(clock),
        .endereco(s_endereco),
        .padrao(s_padrao_peca)
    );
    
    teatris_memoria_mapas memoria_mapas (
        .clock(clock),
        .endereco(s_endereco),
        .padrao(s_mapas_facil)
    );
	 
	 teatris_memoria_mapas_dificil(
			.clock(clock),
			.endereco(s_endereco),
			.padrao(s_mapas_dificil)
	 );
	 
	 teatris_memoria_fim(
			.clock(clock),
			.endereco(s_endereco),
			.padrao(s_fim)
	 );
	 
	 
	 mux4x1_n #(.BITS(64)) selecao_mapa(
			.D00(s_mapas_facil),
			.D01(s_mapas_dificil),
			.D10(s_fim),
			.D11(s_fim),
			.SEL({mapa_fim,dificuldade}),
			.OUT(s_padrao_mapa)
	 );
    
    teatris_memoria_jogadas memoria_jogadas (
        .clock(clock),
        .endereco(s_endereco),
        .jogada(s_jogada_correta)
    );
	 
	 teatris_memoria_colunas_certas memoria_colunas_certas(
			.clock(clock),
			.endereco(s_endereco),
			.coluna(s_padrao_coluna)
	 );
	 
    
    
	 registrador_4 r_jogada(
			.clock(clock),
			.clear(zera_jogada),
			.enable(registra_jogada),
			.D(botoes),
			.Q(s_jogada_atual)
			);
	 
    // Registradores para armazenar padrões atuais
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            r_padrao_peca <= 16'hffff;
            r_padrao_mapa <= {8'b00_01_10_00,
										8'b11_10_11_00,
										8'b00_01_10_10,
										8'b00_00_11_11,
										8'b01_01_11_11,
										8'b00_00_11_11,
										8'b11_11_11_11,
										8'b00_00_11_11};
				r_padrao_coluna <= 64'h00000000;
        end
        else if (enable_memoria) begin
            r_padrao_peca <= s_padrao_peca;
            r_padrao_mapa <= s_padrao_mapa;
				r_padrao_coluna <= s_padrao_coluna;
        end
    end
    
    // Comparador para verificar jogada
    comparador_85 comparador_jogada (
        .A(s_jogada_atual),      // Jogada registrada
        .B(s_jogada_correta),    // Jogada esperada da memória
        .ALBi(1'b0),
        .AGBi(1'b0),
        .AEBi(1'b1),
        .ALBo(),
        .AGBo(),
        .AEBo(jogada_ok)         // Saída: jogada correta ou não
    );
    
    contador_163 contador_de_erro(
        .clock(clock),
        .clr(~zera_erro),
        .ld(1'b1),               // Load ativo alto
        .ent(1'b1),              // Enable de contagem
        .enp(conta_erro),    // Enable de incremento
        .D(4'b0000),             // Valor inicial
        .Q(s_erro),          // Saída do contador
        .rco(fim_erro)      // Ripple Carry Out como fim de sequência

    );
    // Temporizador para timeout
    contador_m #(.M(100_000_000_000), .N(34)) temporizador (
        .clock(clock),
        .zera_as(reset),
        .zera_s(timer_restart || s_pulso_jogada),
        .conta(1'b1),            // Sempre contando
        .Q(),                    // Valor do contador (não usado)
        .fim(timeout)            // Timeout quando chega ao fim
    );
	 
	     // Temporizador para tempo de animacao
    contador_m #(.M(25_000_000), .N(25)) temporizador_animacao (
        .clock(clock),
        .zera_as(reset),
        .zera_s(timer_animacao_restart),
        .conta(conta_timer_animacao),            
        .Q(),                    
        .fim(fim_timer_animacao)            
    );
    
    // Atribuição das saídas
    assign padrao_peca = r_padrao_peca;
    assign padrao_mapa = r_padrao_mapa;
	assign padrao_coluna = r_padrao_coluna;
    assign erros = s_erro;

    // Saídas de depuração
    assign db_contagem = s_endereco;
    assign db_jogada = s_jogada_atual;
    assign db_memoria = s_jogada_correta;
	assign tem_jogada = s_pulso_jogada;
	assign db_tem_jogada = botoes[3] | botoes[2]| botoes[1] | botoes[0];
	  

endmodule

