`timescale 1ns / 1ps

module teatris_tb;

    // Entradas
    reg clock;
    reg reset;
    reg [3:0] botoes;

    reg zera_contador;
    reg conta_contador;
    reg enable_memoria;
    reg registra_jogada;
    reg compara_jogada;
    reg timer_restart;

    // Saídas
    wire tem_jogada;
    wire jogada_ok;
    wire fim_sequencia;
    wire timeout;
    wire [15:0] padrao_peca;
    wire [15:0] padrao_mapa;
    wire [3:0] db_contagem;
    wire [3:0] db_jogada;
    wire [3:0] db_memoria;

    // Instância do DUT (Device Under Test)
    teatris_fluxo_dados dut (
        .clock(clock),
        .reset(reset),
        .botoes(botoes),
        .zera_contador(zera_contador),
        .conta_contador(conta_contador),
        .enable_memoria(enable_memoria),
        .registra_jogada(registra_jogada),
        .compara_jogada(compara_jogada),
        .timer_restart(timer_restart),
        .tem_jogada(tem_jogada),
        .jogada_ok(jogada_ok),
        .fim_sequencia(fim_sequencia),
        .timeout(timeout),
        .padrao_peca(padrao_peca),
        .padrao_mapa(padrao_mapa),
        .db_contagem(db_contagem),
        .db_jogada(db_jogada),
        .db_memoria(db_memoria)
    );

    // Clock 50 MHz
    always #10 clock = ~clock;

    initial begin
        // Inicialização
        clock = 0;
        reset = 1;
        botoes = 4'b0000;
        zera_contador = 0;
        conta_contador = 0;
        enable_memoria = 0;
        registra_jogada = 0;
        compara_jogada = 0;
        timer_restart = 0;

        #30;
        reset = 0;
        zera_contador = 1;
        #20;
        zera_contador = 0;

        // Carrega o primeiro dado da memória
        enable_memoria = 1;
        #20;
        enable_memoria = 0;

        // Simula um botão sendo pressionado
        botoes = 4'b0001;  // Botão 0 (esperado para endereço 0)
        #20;
        botoes = 4'b0000;  // Libera o botão

        // Aguarda detecção de jogada
        #20;

        // Registra a jogada
        registra_jogada = 1;
        #20;
        registra_jogada = 0;

        // Compara a jogada
        compara_jogada = 1;
        #20;
        compara_jogada = 0;

        // Incrementa para próximo padrão
        conta_contador = 1;
        #20;
        conta_contador = 0;

        // Verifica fim da sequência e reinicia timer
        timer_restart = 1;
        #20;
        timer_restart = 0;

        #100;

        $display("Contador: %d", db_contagem);
        $display("Jogada registrada: %b", db_jogada);
        $display("Jogada esperada  : %b", db_memoria);
        $display("Jogada OK: %b", jogada_ok);

        $stop;
    end

endmodule