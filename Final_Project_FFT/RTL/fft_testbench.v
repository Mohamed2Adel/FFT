// `timescale 1ns/1ps

// module fft8_tb;

//     parameter N        = 8;
//     parameter WIDTH    = 12;
//     parameter FRACTION = 8;

//     reg clk;
//     reg rst;
//     reg start;
//     reg load;
//     reg [$clog2(N)-1:0] load_addr; // for regfile loading
//     reg [$clog2(N)-1:0] out_addr;  // for reading results
//     reg signed [WIDTH-1:0] data_in_re;
//     reg signed [WIDTH-1:0] data_in_im;
//     wire done;
//     wire signed [WIDTH-1:0] data_out_re;
//     wire signed [WIDTH-1:0] data_out_im;

//     // DUT instance
//     fft8_top #(.N(N), .WIDTH(WIDTH), .FRACTION(FRACTION)) dut (
//         .clk(clk),
//         .rst(rst),
//         .start(start),
//         .data_in_re(data_in_re),
//         .data_in_im(data_in_im),
//         .load(load),
//         .load_addr(load_addr),  // extra load address
//         .out_addr(out_addr),
//         .done(done),
//         .data_out_re(data_out_re),
//         .data_out_im(data_out_im)
//     );

//     // Clock generation
//     always #5 clk = ~clk;

//     // Test vectors from MATLAB
//     reg signed [WIDTH-1:0] input_data [0:(2*N)-1];    
//     reg signed [WIDTH-1:0] expected_data [0:(2*N)-1]; 

//     integer i, idx;

//     initial begin
//         clk   = 0;
//         rst   = 1;
//         start = 0;
//         load  = 0;
//         load_addr = 0;
//         out_addr = 0;
//         data_in_re = 0;
//         data_in_im = 0;

//         // Load vectors
//         $readmemh("input_data.mem", input_data);
//         $readmemh("expected_output.mem", expected_data);

//         // Reset
//         #20 rst = 0;

//         // Load input samples into register file
//         load = 1;
//         idx = 0;
//         for (i = 0; i < N; i = i + 1) begin
//             load_addr = i; // store in sequential addresses
//             data_in_re = input_data[idx]; idx = idx + 1;
//             data_in_im = input_data[idx]; idx = idx + 1;
//             #10;
//         end
//         load = 0;

//         // Start FFT
//         #10 start = 1;
//         #10 start = 0;

//         // Wait until done
//         wait(done);
//         #10;

//         // Read results sequentially
//         $display("\n=== FFT Output Comparison ===");
//         for (i = 0; i < N; i = i + 1) begin
//             out_addr = i;
//             #10; // settle
//             idx = i*2;
//             $display("Y[%0d] DUT: %0d + j%0d   | Expected: %0d + j%0d",
//                      i, data_out_re, data_out_im,
//                      expected_data[idx], expected_data[idx+1]);

//             if ((data_out_re !== expected_data[idx]) ||
//                 (data_out_im !== expected_data[idx+1])) begin
//                 $display("  -> MISMATCH");
//             end else begin
//                 $display("  -> MATCH");
//             end
//         end

//         $stop;
//     end

//     // Put after DUT instantiation in the testbench
// reg [31:0] cycle;
// initial cycle = 0;


// endmodule



`timescale 1ns/1ps

module fft8_tb;

    parameter N        = 8;
    parameter WIDTH    = 12;
    parameter FRACTION = 8;

    reg clk;
    reg rst;
    reg start;
    reg load;
    reg [$clog2(N)-1:0] load_addr; // for regfile loading
    reg [$clog2(N)-1:0] out_addr;  // for reading results
    reg signed [WIDTH-1:0] data_in_re;
    reg signed [WIDTH-1:0] data_in_im;
    wire done;
    wire signed [WIDTH-1:0] data_out_re;
    wire signed [WIDTH-1:0] data_out_im;

    // DUT instance
    fft8_top #(.N(N), .WIDTH(WIDTH), .FRACTION(FRACTION)) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in_re(data_in_re),
        .data_in_im(data_in_im),
        .load(load),
        .load_addr(load_addr),  // extra load address
        .out_addr(out_addr),
        .done(done),
        .data_out_re(data_out_re),
        .data_out_im(data_out_im)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test vectors from MATLAB
    reg signed [WIDTH-1:0] input_data [0:(2*N)-1];    
    reg signed [WIDTH-1:0] expected_data [0:(2*N)-1]; 

    // Bit-reversal mapping for 8-point FFT (0-indexed)
    reg [2:0] bit_rev_map [0:N-1];

    integer i, idx;

    initial begin
        // Initialize bit-reversal mapping
        bit_rev_map[0] = 0; // 000 -> 000
        bit_rev_map[1] = 4; // 001 -> 100  
        bit_rev_map[2] = 2; // 010 -> 010
        bit_rev_map[3] = 6; // 011 -> 110
        bit_rev_map[4] = 1; // 100 -> 001
        bit_rev_map[5] = 5; // 101 -> 101
        bit_rev_map[6] = 3; // 110 -> 011
        bit_rev_map[7] = 7; // 111 -> 111

        clk   = 0;
        rst   = 1;
        start = 0;
        load  = 0;
        load_addr = 0;
        out_addr = 0;
        data_in_re = 0;
        data_in_im = 0;

        // Load vectors
        $readmemh("input_data.mem", input_data);            //get input file generated from matlab
        $readmemh("expected_output.mem", expected_data);    //get output file generated from matlab

        // Reset
        #20 rst = 0;

        // Load input samples into register file with bit-reversal
        load = 1;
        idx = 0;
        for (i = 0; i < N; i = i + 1) begin
            load_addr = bit_rev_map[i];                     // Use bit-reversed address for etching the inputs
            data_in_re = input_data[idx]; idx = idx + 1;
            data_in_im = input_data[idx]; idx = idx + 1;
            #10;
        end
        load = 0;

        // Start FFT
        #10 start = 1;
        #10 start = 0;

        // Wait until done
        wait(done);
        #10;

        // Read results sequentially
        $display("\n=== FFT Output Comparison ===");
        for (i = 0; i < N; i = i + 1) begin
            out_addr = i;
            #10; // settle
            idx = i*2;
            $display("Y[%0d] DUT: %0d + j%0d   | Expected: %0d + j%0d",
                     i, data_out_re, data_out_im,
                     expected_data[idx], expected_data[idx+1]);

            if ((data_out_re !== expected_data[idx]) ||
                (data_out_im !== expected_data[idx+1])) begin
                $display("  -> MISMATCH");
            end else begin
                $display("  -> MATCH");
            end
        end

        $stop;
    end


endmodule

