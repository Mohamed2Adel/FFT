// fft8_ctrl.v
// Control FSM for 8-point Radix-2 FFT
// Generates read/write addresses and twiddle ROM address

module fft8_ctrl #(
    parameter N        = 8,
    parameter WIDTH    = 12,
    parameter FRACTION = 8
)(
    input  wire clk,
    input  wire rst,
    input  wire start,
    output reg  done,

    // Register file control
    output reg  [$clog2(N)-1:0] raddr1,
    output reg  [$clog2(N)-1:0] raddr2,
    output reg                  we1,
    output reg  [$clog2(N)-1:0] waddr1,
    output reg                  we2,
    output reg  [$clog2(N)-1:0] waddr2,

    // Twiddle ROM address
    output reg  [1:0]           tw_addr
);

integer m, half_m;

    // ===== State encoding =====
    localparam IDLE  = 2'd0;
    localparam STAGE = 2'd1;
    localparam DONE  = 2'd2;

    reg [1:0] state;
    reg [1:0] stage;         // stage index: 0..2 for N=8
    reg [2:0] butterfly_idx; // butterfly within stage

    // ===== FSM sequential =====
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            stage <= 0;
            butterfly_idx <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        stage <= 0;
                        butterfly_idx <= 0;
                        state <= STAGE;
                    end
                end

                STAGE: begin
                    if (butterfly_idx == 3 ) begin     //(N >> 1) - 1   replace 3 with this when we need it more general
                        butterfly_idx <= 0;
                        if (stage == 2) begin
                            state <= DONE;
                        end else begin
                            stage <= stage + 1;
                        end
                    end else begin
                        butterfly_idx <= butterfly_idx + 1;
                    end
                end

                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

    // ===== FSM combinational =====
    always @(*) begin
        // Defaults
        raddr1 = 0;
        raddr2 = 0;
        waddr1 = 0;
        waddr2 = 0;
        we1    = 0;
        we2    = 0;
        tw_addr = 0;

        if (state == STAGE) begin    //m , half_m
            m = 1 << (stage + 1);
            half_m = m >> 1;

            // Address calculation
            raddr1 = (butterfly_idx / half_m) * m + (butterfly_idx % half_m);
            raddr2 = raddr1 + half_m;

            // Writes happen immediately after butterfly calculation
            waddr1 = raddr1;
            waddr2 = raddr2;
            we1 = 1;
            we2 = 1;

            // Twiddle ROM address
            tw_addr = (butterfly_idx * (N / m)) % (N/2);
        end
    end

endmodule





