`timescale 1ns / 1ps

module tb;

  reg clk;
  reg rst;

  wire        wrEn;
  wire [13:0] addr_toRAM;
  wire [31:0] data_toRAM;
  wire [31:0] data_fromRAM;

  // DUT (CPU)
  VSCPU dut (
    .clk(clk),
    .rst(rst),
    .data_fromRAM(data_fromRAM),
    .wrEn(wrEn),
    .addr_toRAM(addr_toRAM),
    .data_toRAM(data_toRAM)
  );

  // Memory
  blram mem (
    .clk(clk),
    .rst(rst),
    .we(wrEn),
    .addr(addr_toRAM),
    .din(data_toRAM),
    .dout(data_fromRAM)
  );

  // Clock: 10 ns period
  always #5 clk = ~clk;

  initial begin
    // waveform
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);

    
    clk = 1'b0;
    rst = 1'b1;

   
    #20;
    rst = 1'b0;

    #6000;

    // ------------------------------------------------
    // FINAL MEMORY CHECK 
    // mem[100]=0x00001B20 (6944)
    // mem[101]=0x00000018 (24)
    // mem[102]=0x00000002 (2)
    // mem[104]=0xFFFFFFFA (4294967290)
    // mem[108]=0x0000006C (108)
    // mem[110]=0x00000000 (0)
    // mem[111]=0x00000001 (1)
    // mem[112]=0x00000001 (1)
    // mem[120]=0x00000001 (1)
    // mem[121]=0xE0190066 (3759734886)
    // ------------------------------------------------
    $display("===== FINAL MEMORY CHECK (Verilog) =====");
    $display("mem[100] = %h", mem.mem[100]);
    $display("mem[101] = %h", mem.mem[101]);
    $display("mem[102] = %h", mem.mem[102]);
    $display("mem[104] = %h", mem.mem[104]);
    $display("mem[108] = %h", mem.mem[108]);
    $display("mem[110] = %h", mem.mem[110]);
    $display("mem[111] = %h", mem.mem[111]);
    $display("mem[112] = %h", mem.mem[112]);
    $display("mem[120] = %h", mem.mem[120]);
    $display("mem[121] = %h", mem.mem[121]);

    if (mem.mem[100] == 32'h00001B20 &&
        mem.mem[101] == 32'h00000018 &&
        mem.mem[102] == 32'h00000002 &&
        mem.mem[104] == 32'hFFFFFFFA &&
        mem.mem[108] == 32'h0000006C &&
        mem.mem[110] == 32'h00000000 &&
        mem.mem[111] == 32'h00000001 &&
        mem.mem[112] == 32'h00000001 &&
        mem.mem[120] == 32'h00000001 &&
        mem.mem[121] == 32'hE0190066)
      $display("STEP 2: TEST PASS ");
    else
      $display("STEP 2: TEST FAIL ");

    #50;
    $finish;
  end

endmodule
