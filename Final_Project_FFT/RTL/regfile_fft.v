// regfile_fft.v
// Dual-port register file for FFT with external load mode + external readback
// Stores real and imaginary parts in Q(WIDTH-FRACTION).FRACTION format

module regfile_fft #(
    parameter N        = 8,   // FFT size
    parameter WIDTH    = 12,  // Word length
    parameter FRACTION = 8    // Fraction bits
)(
    input  wire clk,
    input  wire rst,

    // External load interface (testbench / top)
    input  wire load,
    input  wire [$clog2(N)-1:0] load_addr,
    input  wire signed [WIDTH-1:0] load_re,
    input  wire signed [WIDTH-1:0] load_im,

    // Internal FFT read ports
    input  wire [$clog2(N)-1:0] raddr1,
    input  wire [$clog2(N)-1:0] raddr2,
    output reg  signed [WIDTH-1:0] rdata1_re,
    output reg  signed [WIDTH-1:0] rdata1_im,
    output reg  signed [WIDTH-1:0] rdata2_re,
    output reg  signed [WIDTH-1:0] rdata2_im,

    // Internal FFT write ports
    input  wire we1,
    input  wire [$clog2(N)-1:0] waddr1,
    input  wire signed [WIDTH-1:0] wdata1_re,
    input  wire signed [WIDTH-1:0] wdata1_im,

    input  wire we2,
    input  wire [$clog2(N)-1:0] waddr2,
    input  wire signed [WIDTH-1:0] wdata2_re,
    input  wire signed [WIDTH-1:0] wdata2_im,

    // External readback for testbench
    input  wire [$clog2(N)-1:0] out_addr,
    output reg  signed [WIDTH-1:0] out_data_re,
    output reg  signed [WIDTH-1:0] out_data_im
);

    // Memory arrays
    reg signed [WIDTH-1:0] mem_re [0:N-1];
    reg signed [WIDTH-1:0] mem_im [0:N-1];

    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) begin
                mem_re[i] <= 0;
                mem_im[i] <= 0;
            end
        end else begin
            if (load) begin
                mem_re[load_addr] <= load_re;
                mem_im[load_addr] <= load_im;
            end else begin
                if (we1) begin
                    mem_re[waddr1] <= wdata1_re;
                    mem_im[waddr1] <= wdata1_im;
                end
                if (we2) begin
                    mem_re[waddr2] <= wdata2_re;
                    mem_im[waddr2] <= wdata2_im;
                end
            end
        end
    end

    // Combinational reads
    always @(*) begin
        rdata1_re = mem_re[raddr1];
        rdata1_im = mem_im[raddr1];
        rdata2_re = mem_re[raddr2];
        rdata2_im = mem_im[raddr2];
        out_data_re = mem_re[out_addr];
        out_data_im = mem_im[out_addr];
    end

endmodule


// regfile_fft.v
// Dual-port register file for FFT with external load mode + external readback

// module regfile_fft #(
//   parameter N    = 8,  // FFT size
//   parameter WIDTH  = 12, // Word length
//   parameter FRACTION = 8  // Fraction bits
// )(
//   input wire clk,
//   input wire rst,

//   // External load interface (testbench / top)
//   input wire load,
//   input wire [$clog2(N)-1:0] load_addr,
//   input wire signed [WIDTH-1:0] load_re,
//   input wire signed [WIDTH-1:0] load_im,

//   // Internal FFT read ports
//   input wire [$clog2(N)-1:0] raddr1,
//   input wire [$clog2(N)-1:0] raddr2,
//   output reg signed [WIDTH-1:0] rdata1_re,
//   output reg signed [WIDTH-1:0] rdata1_im,
//   output reg signed [WIDTH-1:0] rdata2_re,
//   output reg signed [WIDTH-1:0] rdata2_im,

//   // Internal FFT write ports
//   input wire we1,
//   input wire [$clog2(N)-1:0] waddr1,
//   input wire signed [WIDTH-1:0] wdata1_re,
//   input wire signed [WIDTH-1:0] wdata1_im,
//   input wire we2,
//   input wire [$clog2(N)-1:0] waddr2,
//   input wire signed [WIDTH-1:0] wdata2_re,
//   input wire signed [WIDTH-1:0] wdata2_im,

//   // External readback for testbench
//   input wire [$clog2(N)-1:0] out_addr,
//   output reg signed [WIDTH-1:0] out_data_re,
//   output reg signed [WIDTH-1:0] out_data_im
// );

//   // Memory arrays
//   reg signed [WIDTH-1:0] mem_re [0:N-1];
//   reg signed [WIDTH-1:0] mem_im [0:N-1];

//   integer i;
//   always @(posedge clk or posedge rst) begin
//     if (rst) begin
//       for (i = 0; i < N; i = i + 1) begin
//         mem_re[i] <= 0;
//         mem_im[i] <= 0;
//       end
//     end
//   end
  
//   // Write Port 1 for External Load or FFT
//   always @(posedge clk) begin
//     if (load) begin
//       mem_re[load_addr] <= load_re;
//       mem_im[load_addr] <= load_im;
//     end else if (we1) begin
//       mem_re[waddr1] <= wdata1_re;
//       mem_im[waddr1] <= wdata1_im;
//     end
//   end
  
//   // Write Port 2 for FFT
//   always @(posedge clk) begin
//     if (we2) begin
//       mem_re[waddr2] <= wdata2_re;
//       mem_im[waddr2] <= wdata2_im;
//     end
//   end

//   // Combinational reads
//   always @(*) begin
//     rdata1_re = mem_re[raddr1];
//     rdata1_im = mem_im[raddr1];
//     rdata2_re = mem_re[raddr2];
//     rdata2_im = mem_im[raddr2];
//     out_data_re = mem_re[out_addr];
//     out_data_im = mem_im[out_addr];
//   end

// endmodule





