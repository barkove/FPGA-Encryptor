`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2018 15:44:09
// Design Name: 
// Module Name: tb_coder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_coder();

parameter TEST_VALUES_QUANTITY   = 100000;
parameter CLOCK_SEMI_PERIOD_NS   = 3  ;
parameter TDATA_WIDTH            = 64 ;
parameter KEY_WIDTH              = 256;
parameter K_WIDTH                = 32 ;
parameter R_WIDTH                = 32 ;

reg clk_i;

// stream slave signals
reg                        ss_aresetn_i, ss_tvalid_i;
reg  [TDATA_WIDTH - 1 : 0] ss_tdata_i;
wire                       ss_tready_o;

// stream master signals
wire                       sm_aresetn_o, sm_tvalid_o;
wire [TDATA_WIDTH - 1 : 0] sm_tdata_o;
reg                        sm_tready_i;

coder #(
  .TDATA_WIDTH     ( TDATA_WIDTH  ),
  .KEY_WIDTH       ( KEY_WIDTH    ),
  .K_WIDTH         ( K_WIDTH      ),
  .R_WIDTH         ( R_WIDTH      )
) lonely_coder (
  .clk_i           ( clk_i        ),
  
  .ss_aresetn_i    ( ss_aresetn_i ),
  .ss_tvalid_i     ( ss_tvalid_i  ),  
  .ss_tdata_i      ( ss_tdata_i   ),
  .ss_tready_o     ( ss_tready_o  ),

  .sm_aresetn_o    ( sm_aresetn_o ),
  .sm_tvalid_o     ( sm_tvalid_o  ),
  .sm_tdata_o      ( sm_tdata_o   ),  
  .sm_tready_i     ( sm_tready_i  )
);

task clock_start();
  begin
    clk_i = 0;
    forever #CLOCK_SEMI_PERIOD_NS 
      clk_i = ~clk_i;
  end
endtask

task reset();
  begin
    ss_aresetn_i = 0;
    @( posedge clk_i );
    ss_aresetn_i = 1;
  end
endtask

task write_value(
  input      [TDATA_WIDTH - 1 : 0] value
);
  begin
    ss_tvalid_i = 1;
    ss_tdata_i = value;
    if ( !ss_tready_o )
      @( posedge ss_tready_o );
    @( posedge clk_i );
    @( negedge clk_i );
    ss_tvalid_i = 0;
  end
endtask

task read_value(
  output reg [TDATA_WIDTH - 1 : 0] value
);
  begin
    sm_tready_i = 1;
    if ( !sm_tvalid_o )
      @( posedge sm_tvalid_o );   
    @( negedge clk_i ); 
    value = sm_tdata_o;
    @( posedge clk_i );
    sm_tready_i = 0;
  end
endtask

integer                       i, j, err_cnt;
reg     [TDATA_WIDTH - 1 : 0] rd_value;

integer                       file;
integer                       file_enc;

reg     [TDATA_WIDTH - 1 : 0] file_val     [0 : TEST_VALUES_QUANTITY];
reg     [TDATA_WIDTH - 1 : 0] file_enc_val [0 : TEST_VALUES_QUANTITY];

initial
  begin
    file     = $fopen("test_sr_100000val.txt"    , "r");
    file_enc = $fopen("test_sr_100000val_enc.txt", "r");
    if ( file == 0 || file_enc == 0 )
      begin
        $display("Error: one of test files has not opened");
        $finish;
      end
    $display( "Input / Output value: ");
    for ( i = 0; i < TEST_VALUES_QUANTITY; i = i + 1 )
      begin
        $fscanf( file    , "%h\n", file_val[i]     );
        $fscanf( file_enc, "%h\n", file_enc_val[i] );
        $display( "\t%h / %h", file_val[i], file_enc_val[i] );
      end
    $fclose( file     );
    $fclose( file_enc );
    clock_start();
  end
  
initial
  begin
    reset();
    @( negedge clk_i);
    for (i = 0; i < TEST_VALUES_QUANTITY; i = i + 1)
        write_value( .value( file_val[i] ) );
  end
  
initial
  begin
    reset();
    err_cnt = 0;
    $display("True value / result value:");
    for (j = 0; j < TEST_VALUES_QUANTITY; j = j + 1)
      begin  
        read_value( .value( rd_value ) );
        $display( "\t%h / %h", file_enc_val[j], rd_value );
        if ( file_enc_val[j] != rd_value )
          err_cnt = err_cnt + 1;
      end
    $display("The number of errors: %d", err_cnt);
  end

endmodule
