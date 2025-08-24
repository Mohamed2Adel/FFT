module butterfly #(
    parameter WIDTH    = 12, // Total word length (matches MATLAB 'wl')
    parameter FRACTION = 8   // Fraction length (matches MATLAB 'fl')
)(
    input  signed [WIDTH-1:0] u_re,
    input  signed [WIDTH-1:0] u_im,
    input  signed [WIDTH-1:0] v_re,
    input  signed [WIDTH-1:0] v_im,
    input  signed [WIDTH-1:0] w_re,
    input  signed [WIDTH-1:0] w_im,
    output signed [WIDTH-1:0] out1_re,
    output signed [WIDTH-1:0] out1_im,
    output signed [WIDTH-1:0] out2_re,
    output signed [WIDTH-1:0] out2_im
);

    // Twiddle multiplication (complex multiply)
    wire signed [2*WIDTH-1:0] mult_re = (v_re * w_re) - (v_im * w_im);
    wire signed [2*WIDTH-1:0] mult_im = (v_re * w_im) + (v_im * w_re);

    // Scale product back to Q(WIDTH-FRACTION).FRACTION
    wire signed [WIDTH-1:0] t_re = mult_re >>> FRACTION;  //t is temp var to store the twiddle multip. result
    wire signed [WIDTH-1:0] t_im = mult_im >>> FRACTION;

    // Butterfly outputs
    assign out1_re = u_re + t_re;
    assign out1_im = u_im + t_im;
    assign out2_re = u_re - t_re;
    assign out2_im = u_im - t_im;

endmodule

