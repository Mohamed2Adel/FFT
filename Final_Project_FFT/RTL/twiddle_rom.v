// twiddle_rom.v
// Twiddle ROM for N=8 FFT (stores W8^0 .. W8^3) 
// Fixed-point format: Q(integer).FRACTION  => WIDTH total bits, FRACTION fractional bits
// Default: WIDTH = 12, FRACTION = 8  (i.e. Q4.8, matches MATLAB fi(...,12,8))

module twiddle_rom #(
    parameter WIDTH    = 12,
    parameter FRACTION = 8
)(
    input  wire [1:0] addr,                  // 2-bit address: 0..3
    output reg  signed [WIDTH-1:0] w_re,     // real part (signed)
    output reg  signed [WIDTH-1:0] w_im      // imag part (signed)
);

    // Precomputed Q4.8 values (value * 2^FRACTION, rounded to nearest integer)
    // W8^0 =  1.000000 + j0.000000  -> re =  1 * 256 = 256,  im = 0           0001.0000 0000   
    // W8^1 =  0.707107 - j0.707107  -> re ≈ 0.70710678*256 ≈ 181,  im ≈ -181  0000.1011 0100 
    // W8^2 =  0.000000 - j1.000000  -> re = 0,                im = -256
    // W8^3 = -0.707107 - j0.707107  -> re ≈ -181,               im ≈ -181

    always @(*) begin
        case (addr)
            2'd0: begin
                w_re = 12'sd256;   // W0.re = +256
                w_im = 12'sd0;     // W0.im = 0
            end
            2'd1: begin
                w_re = 12'sd181;   // W1.re  ≈ +0.7071 * 256
                w_im = -12'sd181;  // W1.im  ≈ -0.7071 * 256
            end
            2'd2: begin
                w_re = 12'sd0;     // W2.re = 0
                w_im = -12'sd256;  // W2.im = -1 * 256
            end
            2'd3: begin
                w_re = -12'sd181;  // W3.re ≈ -0.7071 * 256
                w_im = -12'sd181;  // W3.im ≈ -0.7071 * 256
            end
            default: begin
                w_re = 12'sd0;
                w_im = 12'sd0;
            end
        endcase
    end

endmodule


