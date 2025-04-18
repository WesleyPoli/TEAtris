module TEAtris_Top (
    // Entradas principais
    input clock_50MHz,        // Clock principal (tipicamente 50MHz)
    input reset,              // Reset global (ativo alto)
    input start,              // Botão para iniciar o jogo
    input [3:0] botoes,       // 4 botões para as jogadas
    input dificuldade,        // Seletor de nível de dificuldade
    
    // Saídas para matriz de peça (linhas e colunas individuais)
    output peca_linha0,
    output peca_linha1,
    output peca_linha2,
    output peca_linha3,
    output peca_linha4,
    output peca_linha5,
    output peca_linha6,
    output peca_linha7,
    output peca_coluna0,
    output peca_coluna1,
    output peca_coluna2,
    output peca_coluna3,
    output peca_coluna4,
    output peca_coluna5,
    output peca_coluna6,
    output peca_coluna7,
    
    // Saídas para matriz de mapa (linhas e colunas individuais)
    output mapa_linha0,
    output mapa_linha1,
    output mapa_linha2,
    output mapa_linha3,
    output mapa_linha4,
    output mapa_linha5,
    output mapa_linha6,
    output mapa_linha7,
    output mapa_coluna0,
    output mapa_coluna1,
    output mapa_coluna2,
    output mapa_coluna3,
    output mapa_coluna4,
    output mapa_coluna5,
    output mapa_coluna6,
    output mapa_coluna7,
    
    // Saída para som (opcional)
    output speaker,                    // Saída para speaker/buzzer
    
    // Saídas de depuração
    output [6:0] db_estado,            // Estado atual da UC
    output [6:0] db_contagem,          // Contador atual
    output [6:0] db_jogada,            // Jogada atual
    output [6:0] db_memoria,            // Valor da memória
	output db_tem_jogada,
    output db_fim_contador_erro,
	 output db_chave_dificuldade,
    output [6:0] erros
);

    // Sinais entre UC e FD
    wire s_conta_erro;
    wire s_zera_erro;
    wire s_fim_erro;
    wire s_zera_contador;
    wire s_conta_contador;
    wire s_enable_memoria;
    wire s_registra_jogada;
    wire s_compara_jogada;
    wire s_timer_restart;
	 wire s_timer_animacao_restart;
	 wire s_conta_timer_animacao;
	 wire s_fim_timer_animacao;
    wire s_tem_jogada;
    wire s_jogada_ok;
    wire s_fim_sequencia;
    wire s_timeout;
    wire s_game_over;
	 wire s_mapa_fim;
	 wire [1:0] sel_mapa;
	 wire sel_peca;
	 wire [3:0] db_jogada_fio;
	 wire [3:0] db_estado_fio;
	 wire [3:0] db_memoria_fio;
	 wire [3:0] db_contagem_fio;
    wire [3:0] s_erro;
    
    // Sinais para matrizes de LED
	 wire [15:0] s_padrao_peca;
    wire [7:0] s_padrao_peca_sup;
	 wire [7:0] s_padrao_peca_inf;
	 
    wire [63:0] s_padrao_mapa;
	 wire [7:0] s_padrao_mapa_1;
	 wire [7:0] s_padrao_mapa_2;
	 wire [7:0] s_padrao_mapa_3;
	 wire [7:0] s_padrao_mapa_4;
	 wire [7:0] s_padrao_mapa_5;
	 wire [7:0] s_padrao_mapa_6;
	 wire [7:0] s_padrao_mapa_7;
	 wire [7:0] s_padrao_mapa_8;
	 
	 wire [63:0] s_padrao_coluna;
    
    // Sinais para exibição nas matrizes
    wire [7:0] s_peca_linhas [0:7];
    wire [7:0] s_mapa_linhas [0:7];
    
    // Instanciação da UNIDADE DE CONTROLE
    teatris_uc unidade_controle (
        .clock(clock_50MHz),
        .reset(reset),
        .timeout(s_timeout),
        .start(start),
        .fim_sequencia(s_fim_sequencia),
        .tem_jogada(s_tem_jogada),
        .jogada_ok(s_jogada_ok),
		  .mapa_fim(s_mapa_fim),
        
        .conta_erro(s_conta_erro),
        .zera_erro(s_zera_erro),

		.sel_mapa(sel_mapa),
		.sel_peca(sel_peca),
        .zera_contador(s_zera_contador),
        .conta_contador(s_conta_contador),
        .enable_memoria(s_enable_memoria),
        .registra_jogada(s_registra_jogada),
        .timer_restart(s_timer_restart),
		.timer_animacao_restart (s_timer_animacao_restart),
		.conta_timer_animacao (s_conta_timer_animacao),
		.fim_timer_animacao (s_fim_timer_animacao),
        .game_over(s_game_over),
        .db_estado(db_estado_fio)
    );
    
    // Instanciação do FLUXO DE DADOS
    teatris_fluxo_dados fluxo_dados (
        .clock(clock_50MHz),
        .reset(reset),
        .botoes(botoes),
        .dificuldade(dificuldade),
		  
        .zera_contador(s_zera_contador),
        .conta_contador(s_conta_contador),
        .enable_memoria(s_enable_memoria),
        .registra_jogada(s_registra_jogada),
        .timer_restart(s_timer_restart),
		  .timer_animacao_restart (s_timer_animacao_restart),
		  .conta_timer_animacao (s_conta_timer_animacao),
		  .fim_timer_animacao (s_fim_timer_animacao),
        
        .tem_jogada(s_tem_jogada),
        .jogada_ok(s_jogada_ok),
        .fim_sequencia(s_fim_sequencia),
        .timeout(s_timeout),
		  .mapa_fim(s_mapa_fim),
        
        .conta_erro(s_conta_erro),
        .zera_erro(s_zera_erro),
        .fim_erro(s_fim_erro),
        .erros(s_erro),

        .padrao_peca(s_padrao_peca),
        .padrao_mapa(s_padrao_mapa),
		.padrao_coluna(s_padrao_coluna),
        
        .db_contagem(db_contagem_fio),
        .db_jogada(db_jogada_fio),
        .db_memoria(db_memoria_fio),
		.db_tem_jogada(db_tem_jogada)
    );
    
    assign db_fim_contador_erro = s_fim_erro;
    // Configuração dos padrões para as matrizes de LEDs
	 assign s_padrao_peca_sup = sel_peca ? 8'b11111111 : s_padrao_peca [7:0] ;
	 assign s_padrao_peca_inf = sel_peca ? 8'b11111111 : s_padrao_peca [15:8] ;
	 assign s_padrao_mapa_8 = ~sel_mapa[0] ? s_padrao_mapa [7 : 0] : sel_mapa[1] ? s_padrao_coluna [7:0] : 8'b0;
	 assign s_padrao_mapa_7 = ~sel_mapa[0] ? s_padrao_mapa [15: 8] : sel_mapa[1] ? s_padrao_coluna [15:8] : 8'b0;
	 assign s_padrao_mapa_6 = ~sel_mapa[0] ? s_padrao_mapa [23:16] : sel_mapa[1] ? s_padrao_coluna [23:16] : 8'b0;
	 assign s_padrao_mapa_5 = ~sel_mapa[0] ? s_padrao_mapa [31:24] : sel_mapa[1] ? s_padrao_coluna [31:24] : 8'b0;
	 assign s_padrao_mapa_4 = ~sel_mapa[0] ? s_padrao_mapa [39:32] : sel_mapa[1] ? s_padrao_coluna [39:32] : 8'b0;
	 assign s_padrao_mapa_3 = ~sel_mapa[0] ? s_padrao_mapa [47:40] : sel_mapa[1] ? s_padrao_coluna [47:40] : 8'b0;
	 assign s_padrao_mapa_2 = ~sel_mapa[0] ? s_padrao_mapa [55:48] : sel_mapa[1] ? s_padrao_coluna [55:48] : 8'b0;
	 assign s_padrao_mapa_1 = ~sel_mapa[0] ? s_padrao_mapa [63:56] : sel_mapa[1] ? s_padrao_coluna [63:56] : 8'b0;
	 
    // Configuração para matriz de peça (centralizada nas linhas 3 e 4)
    assign s_peca_linhas[0] = 8'b11111111;
    assign s_peca_linhas[1] = 8'b11111111;
    assign s_peca_linhas[2] = 8'b11111111;
    assign s_peca_linhas[3] = s_padrao_peca_sup;
    assign s_peca_linhas[4] = s_padrao_peca_inf;
    assign s_peca_linhas[5] = 8'b11111111;
    assign s_peca_linhas[6] = 8'b11111111;
    assign s_peca_linhas[7] = 8'b11111111;
    
    // Configuração para matriz de mapa (padrão na linha 3)
    assign s_mapa_linhas[0] = s_padrao_mapa_1;
    assign s_mapa_linhas[1] = s_padrao_mapa_2;
    assign s_mapa_linhas[2] = s_padrao_mapa_3;
    assign s_mapa_linhas[3] = s_padrao_mapa_4;
    assign s_mapa_linhas[4] = s_padrao_mapa_5;
    assign s_mapa_linhas[5] = s_padrao_mapa_6; 
    assign s_mapa_linhas[6] = s_padrao_mapa_7;
    assign s_mapa_linhas[7] = s_padrao_mapa_8;
    
    // Instanciação dos DRIVERS PARA MATRIZES 2088BS com pinos individuais
    driver_matriz_2088bs driver_matriz_peca (
        .clock(clock_50MHz),
        .reset(reset),
        .padrao_linha0(s_peca_linhas[0]),
        .padrao_linha1(s_peca_linhas[1]),
        .padrao_linha2(s_peca_linhas[2]),
        .padrao_linha3(s_peca_linhas[3]),
        .padrao_linha4(s_peca_linhas[4]),
        .padrao_linha5(s_peca_linhas[5]),
        .padrao_linha6(s_peca_linhas[6]),
        .padrao_linha7(s_peca_linhas[7]),
        
        // Linhas para matriz de peça
        .linha0(peca_linha0),
        .linha1(peca_linha1),
        .linha2(peca_linha2),
        .linha3(peca_linha3),
        .linha4(peca_linha4),
        .linha5(peca_linha5),
        .linha6(peca_linha6),
        .linha7(peca_linha7),
        
        // Colunas para matriz de peça
        .coluna0(peca_coluna0),
        .coluna1(peca_coluna1),
        .coluna2(peca_coluna2),
        .coluna3(peca_coluna3),
        .coluna4(peca_coluna4),
        .coluna5(peca_coluna5),
        .coluna6(peca_coluna6),
        .coluna7(peca_coluna7)
    );
    
    driver_matriz_2088bs driver_matriz_mapa (
        .clock(clock_50MHz),
        .reset(reset),
        .padrao_linha0(s_mapa_linhas[0]),
        .padrao_linha1(s_mapa_linhas[1]),
        .padrao_linha2(s_mapa_linhas[2]),
        .padrao_linha3(s_mapa_linhas[3]),
        .padrao_linha4(s_mapa_linhas[4]),
        .padrao_linha5(s_mapa_linhas[5]),
        .padrao_linha6(s_mapa_linhas[6]),
        .padrao_linha7(s_mapa_linhas[7]),
        
        // Linhas para matriz de mapa
        .linha0(mapa_linha0),
        .linha1(mapa_linha1),
        .linha2(mapa_linha2),
        .linha3(mapa_linha3),
        .linha4(mapa_linha4),
        .linha5(mapa_linha5),
        .linha6(mapa_linha6),
        .linha7(mapa_linha7),
        
        // Colunas para matriz de mapa
        .coluna0(mapa_coluna0),
        .coluna1(mapa_coluna1),
        .coluna2(mapa_coluna2),
        .coluna3(mapa_coluna3),
        .coluna4(mapa_coluna4),
        .coluna5(mapa_coluna5),
        .coluna6(mapa_coluna6),
        .coluna7(mapa_coluna7)
    );
    
	   estado7seg HEX2(
      .estado( db_jogada_fio ),
      .display( db_jogada)
		);
		
		hexa7seg HEX3(
			 .hexa( db_contagem_fio ),
			 .display( db_contagem )
		);

		hexa7seg HEX0(
			 .hexa( db_memoria_fio ),
			 .display( db_memoria )
		);

		estado7seg HEX4(
			 .estado( db_estado_fio ),
			 .display( db_estado )
		);

        hexa7seg HEX5(
			 .hexa( s_erro ),
			 .display( erros )
		);

	 
    // Gerador de som simplificado
    reg [15:0] contador_som;
    always @(posedge clock_50MHz) begin
        if (reset)
            contador_som <= 0;
        else
            contador_som <= contador_som + 1'b1;
    end
    
    // Som ativo durante game_over (pode ser modificado conforme necessário)
    assign speaker = s_game_over ? contador_som[14] : 1'b0;
	 
	 assign db_chave_dificuldade = dificuldade;

endmodule