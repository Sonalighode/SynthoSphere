<h1> 3-Stage Pipeline RISC-V Processor</h1>

A simple 3-stage pipeline RISC-V processor refers to a basic microprocessor design that implements the RISC-V instruction set architecture and employs a 3-stage pipeline structure for instruction execution. 
The execution of instructions is divided into multiple stages, with each stage handling a specific part of the instruction processing.

<h3>Block diagram of 3-stage pipeline RISC-V Processor:</h3>

![image](https://github.com/Sonalighode/SynthoSphere/assets/125658017/31c5c2c9-5e6b-48bb-81ed-4c50ee2d773b)


The pipeline stages for a simple 3-stage RISC-V processor typically include:
1. Fetch Stage (IF - Instruction Fetch): In this stage, the processor fetches the next instruction from memory. The program counter (PC) is used to determine the memory address of the next instruction. The fetched instruction is then sent to the next stage for decoding.
2. Decode and Execute Stage (ID/EX - Instruction Decode/Execute): In this stage, the fetched instruction is decoded to determine the operation to be performed and the operands involved. Register values needed for the operation are also read from the register file. The instruction's operation is executed, which may involve arithmetic, logic, or memory operations. The result of the operation and other control signals are prepared to be passed to the next stage.
3. Memory and Writeback Stage (MEM/WB - Memory Access/Writeback): In this stage, memory-related operations are performed. For load instructions, data is fetched from memory; for store instructions, data is written to memory. For arithmetic or logic instructions, this stage is not dominant. Finally, the result of the operation is written back to the destination register in the register file.

The steps below involve designing and simulating a simple RISC-V processor using Verilog. The process flows from creating RTL (Register Transfer Level) design to GLS (Gate-Level Simulation) verification. 

<h2>Pre-synthesis:</h2>

This process involves the use of the following tools:
1. iverilog compiler
2. GTKwave synthesiser
3. Yosys synthesis tool

Below is the verilog code and testbench to design the processor to perform fundamental operations of addition, substraction, and load/store operations.

<h2>Verilog Code</h2>

```
module RISC_V_Processor(
    input wire i_clk,                                //clock input signal
    input wire rst,                                  //rest input signal
    input wire [31:0] i_instr,                       //instruction to be executed
    output reg [31:0] o_result                       //result
);

    reg [31:0] pc;                                   //program counter
    reg [4:0] opcode;                                //opcode of the instruction
    reg [4:0] rs1, rs2, rd;                          //source and destination registers
    reg [31:0] imm;                                  //immediate value extracted from instruction
    reg [31:0] reg_file [31:0];                      //register file
    
    integer i;                                       /variable i used in the loop

    always @(posedge i_clk or posedge rst)          //trigger at positive edge of input clock or reset
    begin
        if (rst)                                   //check if reset is high
        begin                                      //if true, set 0 to the following ports
            pc <= 0;
            opcode <= 0;
            rs1 <= 0;
            rs2 <= 0;
            rd <= 0;
            imm <= 0;
        end 
        else                                      //if reset is low                          
        begin
            pc <= pc + 4;                         /increment program counter by 4                          
            opcode <= i_instr[6:2];               //[6:2] bits of the instruction bare assigned to opcode 
            rs1 <= i_instr[19:15];                //[19:15] bits of the instruction are assigned to the source register rs1
            rs2 <= i_instr[24:20];                //[24:20] bits of the instruction are assigned to the source register rs2
            rd <= i_instr[11:7];                  //[11:7] bits of the instruction are assigned to the destination register rd
            imm <= i_instr[31:20];                //[31:20] bits of the instruction are assigned to immediate value
        end
    end

    always @(posedge i_clk or posedge rst)        //trigger at the positive edge of the input clock or reset
    begin     
        if (rst)                                  //check if reset is high
        begin
            for (i = 0; i <= 31; i = i + 1) 
            begin
                reg_file[i] <= 0;                 //assign 0 to destination register rd if reset is high using for loop
            end
        end 
        else                                      //if reset is low
        begin
            if (rd != 0)                          //check rd value 
            begin
                reg_file[rd] <= o_result;         //assign the rd value to the result
            end
        end
    end

    always @(posedge i_clk or posedge rst)      //trigger at the positive edge of the input clock or reset 
    begin     
        if (rst)                                //check if reset is high 
        begin
            o_result <= 0;                      //if reset high, the result is cleared to 0
        end 
        else                                    //if reset is low
        begin
            case(opcode)                        //using case to decode the opcode of the instruction
                5'b00000: o_result <= reg_file[rs1] + reg_file[rs2];          // Add
                5'b00010: o_result <= reg_file[rs1] - reg_file[rs2];          // Subtract
                5'b01101: o_result <= imm;                                    // Load Immediate
                default: o_result <= 0;
            endcase
        end
    end

endmodule

```

Refer to the description below for an understanding of the case assignments:

![image](https://github.com/Sonalighode/SynthoSphere/assets/125658017/089ef9b0-4cc0-48b5-9ed7-a0d5202d2553)

<h2>Testbench</h2>

```

module tb_RISC_V_Processor;
    reg i_clk;                               //clock input signal
    reg rst;                                 //rest input signal
    reg [31:0] i_instr;                      //instruction to be executed
    wire [31:0] o_result;                    //result

    RISC_V_Processor dut (                   //module instantiation
        .i_clk(i_clk),
        .rst(rst),
        .i_instr(i_instr),
        .o_result(o_result)
    );

    
    initial 
    begin
        $dumpfile("riscv0tb.vcd");             //creating dumpfile of .vcd type
        $dumpvars(0, tb_RISC_V_Processor);
        i_clk = 0;                              //initialise clock to 0          
        forever #5 i_clk = ~i_clk;              //toggle every 5ns
    end

    initial 
    begin
        rst = 1;                           //initialise reset as high
        #10 rst = 0;                       //reset is low after 10ns

        i_instr = 32'h00000013;             //hex value assigned to instruction which performs ADDI x1, x0, 0

        #100 $finish;
    end
endmodule

```

The value of the instruction in hexadecimal is 00000013 which in binary is 00000000010000010000000000000011.

Hence according to the verilog code written:

opcode = 000000 

rs1 = 00000 

rs2 = 00000

rd = 00001 

imm = 0000000000000011 

Therefore the opcode for the given instruction is 5'b00000, which corresponds to the ADD operation. 
The instruction is ADDI x1, x0, 0, which adds zero to a register. The result of this addition is the register itself and in this case, the result will be 0.

Below is the corresponding instruction set:

![image](https://github.com/Sonalighode/SynthoSphere/assets/125658017/2f95fa0d-a998-462d-96ee-25fc2078db12)

The verilog code and test bench are compiled by iverilog by using the command ``` iverilog file_name.v testbench_file_name.v ```.

After the compilation, a dumpfile of .vcd type is generated with ``` ./a.out ``` command. The dumpfile is then used to perform waveform synthesis by the GTKwave synthesizer.

<h3>Waveforms:</h3>

With the given clock and reset signals and the add instruction, the result is obtained.

![image](https://github.com/Sonalighode/SynthoSphere/assets/125658017/b984938b-ae6f-4153-a5be-bb57c050b6cc)

The image below shows the updation of the program counter, registers, and result with the input clock, reset signals, and the add instruction.

![image](https://github.com/Sonalighode/SynthoSphere/assets/125658017/bcd319ae-6aa8-464d-98b3-04a292c6d4db)

<h3>Design requirements:</h3>

After loading the file with ``` read_verilog file_name.v ``` in the corresponding directory, the design requirements are obtained by the commands ``` synth -top top_module_name ``` and performing the mapping by using the required library.

![image](https://github.com/Sonalighode/SynthoSphere/assets/125658017/bfdfc365-46bb-4ff5-878e-39471dfa9025)

![image](https://github.com/Sonalighode/SynthoSphere/assets/125658017/07c5fd79-c83d-4411-bd53-3fdef70aa96d)

![image](https://github.com/Sonalighode/SynthoSphere/assets/125658017/cb0ec70b-1e4e-47ab-8c47-51157a3ae07b)

<h3>Pictorial representation of the synthesis:</h3>

![image](https://github.com/Sonalighode/SynthoSphere/assets/125658017/1b7bc502-fa54-4ac2-bc87-4bfcd4a174ce)

<h2>Post-synthesis:</h2>

As a part of the post-synthesis, a netlist is created with ``` write_verilog -noattr netlist_file_name.v ``` command. 
The waveform is then generated with the netlist file.

<h3>Waveforms:</h3>

![image](https://github.com/Sonalighode/SynthoSphere/assets/125658017/7380c040-8393-4ea6-9595-b7b82dd03d82)

![image](https://github.com/Sonalighode/SynthoSphere/assets/125658017/c66b25c1-125d-4ea2-a5cb-a0509249e50e)

The waveform results of the post and pre-synthesis are coherent.








