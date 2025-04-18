module mux4x1_n #(parameter BITS = 4)(
        input      [BITS-1:0] D00,
        input      [BITS-1:0] D01,
		  input      [BITS-1:0] D10,
		  input      [BITS-1:0] D11,
        input           [1:0]  SEL,
        output reg [BITS-1:0] OUT
    );

    always @(*) begin
        case (SEL)
            2'b00:    OUT = D00;
            2'b01:    OUT = D01;
				2'b10:	 OUT = D10;
				2'b11:	 OUT = D11;
            default: OUT = D10; 
        endcase
    end

endmodule
