module tb_RISC_V_Processor;
    reg i_clk;
    reg rst;
    reg [31:0] i_instr;
    wire [31:0] o_result;

    RISC_V_Processor dut (
        .i_clk(i_clk),
        .rst(rst),
        .i_instr(i_instr),
        .o_result(o_result)
    );

    integer i; // Declare the variable i

    initial begin
        $dumpfile("riscv0tb.vcd");
        $dumpvars(0, tb_RISC_V_Processor);
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

    initial begin
        rst = 1;
        #10 rst = 0;

        i_instr = 32'h00000013; 

        #100 $finish;
    end
endmodule

