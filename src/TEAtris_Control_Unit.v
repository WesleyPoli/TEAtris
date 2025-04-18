module teatris_uc (
    input clock,              // Clock do sistema
    input reset,              // Sinal de reset
    input timeout,            // Sinal de timeout do temporizador
    input start,              // Sinal para iniciar jogo
    input fim_sequencia,      // Indicador de fim da sequência
    input tem_jogada,         // Indicador de jogada realizada
    input jogada_ok,          // Indicador de jogada correta
	 input fim_timer_animacao,
    
    // Sinais de controle para o fluxo de dados
    output reg zera_contador,    // Zera o contador de endereços
    output reg conta_contador,   // Incrementa o contador de endereços
    output reg enable_memoria,   // Habilita registrador de memória
    output reg registra_jogada,  // Habilita registro da jogada
    output reg compara_jogada,   // Habilita comparação da jogada
    output reg timer_restart,    // Reiniciar o temporizador
    output reg game_over,        // Sinal de fim de jogo
    output reg zera_jogada,
	 output reg timer_animacao_restart,
	 output reg [1:0] sel_mapa,
	 output reg conta_timer_animacao,
    output reg conta_erro,
    output reg zera_erro,
	 output reg sel_peca,
	 output reg mapa_fim,
    

	 
    // Saída de depuração
    output reg [4:0] db_estado   // Estado atual do jogo
);
    // Estados do jogo 
    localparam INICIAL            = 5'b00000; //0
    localparam CONFIGURA_JOGO     = 5'b00001; //1
    localparam CARREGA_DADO       = 5'b00010; //2
    localparam MOSTRA_DADO        = 5'b00011; //3
    localparam ESPERA_JOGADA      = 5'b00100; //4  
    localparam TIMEOUT            = 5'b00101; //5
    localparam REGISTRA           = 5'b00110; //6
    localparam COMPARA            = 5'b00111; //7
    localparam ANALISA_SEQUENCIA  = 5'b01000; //8
    localparam FIM                = 5'b01001; //9
    localparam ERRO_JOGADA        = 5'b01010; //a
	 localparam ACERTA_JOGADA	  = 5'b01011; //b
	 localparam MOSTRA_ACERTO	  = 5'b01100; //c
	 localparam MOSTRA_ORIGINAL	  = 5'b01101; //d
	 localparam ZERA_TIMER_ANIMACAO = 5'b01110; //e
	 localparam MOSTRA_ERRO			 = 5'b01111; //f
	 localparam ZERA_TIMER_ANIMACAO_ERRO = 5'b10000; //10
	 localparam MOSTRA_ORIGINAL_ERRO	= 5'b10001; //11
	 localparam MOSTRA_FIM	= 5'b10010; //12
    
    reg [4:0] Eatual, Eprox;
    
    // Memória de Estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= INICIAL;
        else
            Eatual <= Eprox;
    end
    
    // Lógica para determinar próximo estado
    always @(*) begin
        case (Eatual)
            INICIAL: 
                Eprox = start ? CONFIGURA_JOGO : INICIAL;
                
            CONFIGURA_JOGO: 
                Eprox = CARREGA_DADO;
                
            CARREGA_DADO: 
                Eprox = MOSTRA_DADO;
                
            MOSTRA_DADO: 
                Eprox = ESPERA_JOGADA;
                
            ESPERA_JOGADA:
					 Eprox = timeout ? TIMEOUT : tem_jogada ? REGISTRA : ESPERA_JOGADA;
                    
            TIMEOUT: 
                Eprox = start ? INICIAL : TIMEOUT;
                
            REGISTRA: 
                Eprox = COMPARA;
                
            COMPARA: 
					 Eprox = jogada_ok ? ACERTA_JOGADA : ERRO_JOGADA;
					 
			ACERTA_JOGADA:
				 Eprox = MOSTRA_ACERTO;
					
			MOSTRA_ACERTO:
				 Eprox = fim_timer_animacao ? ZERA_TIMER_ANIMACAO : MOSTRA_ACERTO;
				
			ZERA_TIMER_ANIMACAO:
				 Eprox = MOSTRA_ORIGINAL;
				
			MOSTRA_ORIGINAL:
				 Eprox = fim_timer_animacao ? ANALISA_SEQUENCIA : MOSTRA_ORIGINAL;
				 
				
							  
            ANALISA_SEQUENCIA: 
                Eprox = fim_sequencia ? FIM : CARREGA_DADO;
                
    
                
            ERRO_JOGADA:
					Eprox = MOSTRA_ERRO;
				
				MOSTRA_ERRO:
					Eprox = fim_timer_animacao ? ZERA_TIMER_ANIMACAO_ERRO : MOSTRA_ERRO ;
				
				ZERA_TIMER_ANIMACAO_ERRO:
					Eprox = MOSTRA_ORIGINAL_ERRO;
					
				MOSTRA_ORIGINAL_ERRO:
					Eprox = ANALISA_SEQUENCIA;
               
            FIM: 
                Eprox = MOSTRA_FIM;
				
				MOSTRA_FIM:
					Eprox = start ? INICIAL : FIM;
                
            default: 
                Eprox = INICIAL;
        endcase
    end
    
    // Lógica de saída (máquina Moore - saídas dependem apenas do estado atual)
    always @(*) begin
        // Valores default
        conta_erro = 1'b0;
        zera_erro = 1'b0;
        zera_contador = 1'b0;
		zera_jogada = 1'b0;
        conta_contador = 1'b0;
        enable_memoria = 1'b0;
        registra_jogada = 1'b0;
        compara_jogada = 1'b0;
        timer_restart = 1'b0;
        game_over = 1'b0;
        db_estado = Eatual;  // Sempre mostra o estado atual
		timer_animacao_restart = 1'b0;
        sel_mapa = 2'b00;
		  sel_peca = 1'b0;
		conta_timer_animacao = 1'b0;
		mapa_fim = 1'b0;
		  
        case (Eatual)
            INICIAL: begin
                zera_contador = 1'b1;
                timer_restart = 1'b1;
					 zera_jogada = 1'b0;
                zera_erro = 1'b1;
					 mapa_fim = 1'b0;
            end
            
            CONFIGURA_JOGO: begin
                zera_contador = 1'b1;
                timer_restart = 1'b1;
				zera_jogada = 1'b0;
                zera_erro = 1'b1;
					 mapa_fim = 1'b0;

            end
            
            CARREGA_DADO: begin
			    zera_contador = 1'b0;
              enable_memoria = 1'b1;
				  mapa_fim = 1'b0;
            end
            
            MOSTRA_DADO: begin
	             zera_contador = 1'b0;
                enable_memoria = 1'b1;
                timer_restart = 1'b1;
					 mapa_fim = 1'b0;
            end
            
            ESPERA_JOGADA: begin
					 zera_contador = 1'b0;
                mapa_fim = 1'b0;
            end
				
				ACERTA_JOGADA:begin
				   zera_contador = 1'b0;
					sel_mapa = 2'b00;
					mapa_fim = 1'b0;
					
				end
				
				MOSTRA_ACERTO:begin
				   zera_contador = 1'b0;
					sel_mapa = 2'b01;
					sel_peca = 1'b1;
					conta_timer_animacao = 1'b1;
					mapa_fim = 1'b0;
				end
				
				ZERA_TIMER_ANIMACAO:begin
					timer_animacao_restart = 1'b1;
					mapa_fim = 1'b0;
				end
				
				
				MOSTRA_ORIGINAL:begin
				   zera_contador = 1'b0;
					sel_mapa = 2'b01;
					sel_peca = 1'b1;
					conta_timer_animacao = 1'b1;
					mapa_fim = 1'b0;
				end
            
            TIMEOUT: begin
				zera_contador = 1'b0;
                game_over = 1'b1;
					 mapa_fim = 1'b0;
            end
            
            REGISTRA: begin
                registra_jogada = 1'b1;
					 mapa_fim = 1'b0;
            end
            
            COMPARA: begin
			    zera_contador = 1'b0;
				 mapa_fim = 1'b0;
            end
            
            ANALISA_SEQUENCIA: begin
				zera_contador = 1'b0;
            conta_contador = 1'b1;
				timer_animacao_restart = 1'b1;
				enable_memoria = 1'b1;
            timer_restart = 1'b1;
				mapa_fim = 1'b0;
            end
            
            
            ERRO_JOGADA: begin
					 conta_erro = 1'b1;
                zera_contador = 1'b0;
					 sel_mapa = 2'b00;
					 mapa_fim = 1'b0;
                
            end
				
				MOSTRA_ERRO:begin
					zera_contador = 1'b0;
					sel_mapa = 2'b11;
					sel_peca = 1'b1;
					conta_timer_animacao = 1'b1;
					mapa_fim = 1'b0;
				end
				
				ZERA_TIMER_ANIMACAO_ERRO:begin
					timer_animacao_restart = 1'b1;
					mapa_fim = 1'b0;
				end
				
				MOSTRA_ORIGINAL_ERRO:begin
					zera_contador = 1'b0;
					sel_mapa = 2'b11;
					sel_peca = 1'b1;
					conta_timer_animacao = 1'b1;
					mapa_fim = 1'b0;
				end
            
            FIM: begin
				zera_contador = 1'b0;
				mapa_fim		  = 1'b1;
              
            end
				
				MOSTRA_FIM: begin
				zera_contador = 1'b0;
				mapa_fim		  = 1'b1;
              
            end
            
            
            default: begin
                zera_contador = 1'b1;
					 mapa_fim = 1'b0;
            end
        endcase
    end

endmodule