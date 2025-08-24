// fft8_top.v
// Top-level for 8-point Radix-2 FFT

module fft8_top #(
parameter N= 8,
parameter WIDTH= 12,
parameter FRACTION = 8
)(
input  wire clk,
input  wire rst,
input  wire start,

// External load
input  wire load,
input  wire [$clog2(N)-1:0] load_addr,
input  wire signed [WIDTH-1:0] data_in_re,
input  wire signed [WIDTH-1:0] data_in_im,

// Output selection
input  wire [$clog2(N)-1:0] out_addr,
output wire done,
output wire signed [WIDTH-1:0] data_out_re,
output wire signed [WIDTH-1:0] data_out_im
);

// Internal wiring
wire [$clog2(N)-1:0] raddr1, raddr2, waddr1, waddr2;
wire we1, we2;
wire signed [WIDTH-1:0] u_re, u_im, v_re, v_im;
wire signed [WIDTH-1:0] out1_re, out1_im, out2_re, out2_im;
wire [1:0] tw_addr;
wire signed [WIDTH-1:0] tw_re, tw_im;

// Control FSM
fft8_ctrl #(.N(N)) ctrl (
.clk(clk), .rst(rst), .start(start), .done(done),
.raddr1(raddr1), .raddr2(raddr2),
.we1(we1), .waddr1(waddr1),
.we2(we2), .waddr2(waddr2),
.tw_addr(tw_addr)
);

// Twiddle ROM
twiddle_rom #(.WIDTH(WIDTH), .FRACTION(FRACTION)) rom (
.addr(tw_addr),
.w_re(tw_re),
.w_im(tw_im)
);

// Register File
regfile_fft #(.N(N), .WIDTH(WIDTH), .FRACTION(FRACTION)) regs (
.clk(clk), .rst(rst),
.load(load), .load_addr(load_addr),
.load_re(data_in_re), .load_im(data_in_im),
.raddr1(raddr1), .raddr2(raddr2),
.rdata1_re(u_re), .rdata1_im(u_im),
.rdata2_re(v_re), .rdata2_im(v_im),
.we1(we1), .waddr1(waddr1),
.wdata1_re(out1_re), .wdata1_im(out1_im),
.we2(we2), .waddr2(waddr2),
.wdata2_re(out2_re), .wdata2_im(out2_im),
.out_addr(out_addr),
.out_data_re(data_out_re),
.out_data_im(data_out_im)
);

// Butterfly
butterfly #(.WIDTH(WIDTH), .FRACTION(FRACTION)) bfly (
.u_re(u_re), .u_im(u_im),
.v_re(v_re), .v_im(v_im),
.w_re(tw_re), .w_im(tw_im),
.out1_re(out1_re), .out1_im(out1_im),
.out2_re(out2_re), .out2_im(out2_im)
);

endmodule



