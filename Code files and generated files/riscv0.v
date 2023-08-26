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
    
    integer i;                                       //variale i used in loop

    always @(posedge i_clk or posedge rst)        //if reset is active high, set 0 to initial values else program counter is incremented by 4 pointing to next instruction          
    begin
        if (rst) 
        begin
            pc <= 0;
            opcode <= 0;
            rs1 <= 0;
            rs2 <= 0;
            rd <= 0;
            imm <= 0;
        end 
        else 
        begin
            pc <= pc + 4;                            
            opcode <= i_instr[6:2];
            rs1 <= i_instr[19:15];
            rs2 <= i_instr[24:20];
            rd <= i_instr[11:7];
            imm <= i_instr[31:20];
        end
    end

    always @(posedge i_clk or posedge rst)       //if reset is active high, initialize registers in register file to 0 else update the destination register rd with result 
    begin     
        if (rst) 
        begin
            for (i = 0; i <= 31; i = i + 1) 
            begin
                reg_file[i] <= 0;
            end
        end 
        else 
        begin
            if (rd != 0) 
            begin
                reg_file[rd] <= o_result;
            end
        end
    end

    always @(posedge i_clk or posedge rst)      //if reset is active high, result is cleared to 0 else decode opcode of given instruction and perform the operation
    begin     
        if (rst) 
        begin
            o_result <= 0;
        end 
        else 
        begin
            case(opcode)
                5'b00000: o_result <= reg_file[rs1] + reg_file[rs2];     //Add
                5'b00010: o_result <= reg_file[rs1] - reg_file[rs2];     //Subtract
                5'b01101: o_result <= imm;                               //Load Immediate
                default: o_result <= 0;
            endcase
        end
    end

endmodule

