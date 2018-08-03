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

parameter TEST_VALUES_QUANTITY   = 100;
parameter CLOCK_SEMI_PERIOD_NS   = 10;
parameter TDATA_WIDTH            = 64;
parameter KEY_WIDTH              = 256;
parameter K_WIDTH                = 32;
parameter R_WIDTH                = 32;

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

initial 
  begin
    clk_i = 0;
    forever #CLOCK_SEMI_PERIOD_NS 
      clk_i = ~clk_i;
  end

task write_reset(
  input reset_en
);
  begin
    ss_aresetn_i <= !reset_en;
  end
endtask

task write_read_en(
  input read_en
);
  begin
    sm_tready_i <= read_en;
  end
endtask

task write_data(
  input tvalid  ,
  input tdata   ,
);
  begin
    ss_tvalid_i  <= tvalid ;
    ss_tdata_i   <= tdata  ;
  end
endtask

integer i, j, err_cnt;

integer                       file;
integer                       file_enc;

reg     [TDATA_WIDTH - 1 : 0] file_val     [0 : TEST_VALUES_QUANTITY];
reg     [TDATA_WIDTH - 1 : 0] file_enc_val [0 : TEST_VALUES_QUANTITY];

initial
  begin
    file     = $fopen("test_sr_100val.txt"    , "r");
    file_enc = $fopen("test_sr_100val_enc.txt", "r");
    if ( file == 0 || file_enc == 0 )
      begin
        $display("Error: one of test files has not opened");
        $finish;
      end
    for ( i = 0; i < TEST_VALUES_QUANTITY; i = i + 1 )
      begin
        $fscanf( file    , "%h\n", file_val[i]     );
        $fscanf( file_enc, "%h\n", file_enc_val[i] );
        $display( "Input / Output value: %h - %h", file_val[i], file_enc_val[i] );
      end
    $fclose( file    );
    $fclose( file_enc );
  end

initial
  begin
    write_reset( 1 );
    @( posedge clk );
    write_reset( 0 );
    write_read_en( 1 );
    err_cnt = 0;
    for ( i = 0, k = 0; k != TEST_VALUES_QUANTITY; i = i + 1 )
      begin
        write_data( i < TEST_VALUES_QUANTITY, i < TEST_VALUES_QUANTITY ? file_val[i] : 0 );
        @(posedge clk);
        if ( sm_tvalid_o )
          begin
            $display( ( file_enc_val[k] == sm_tdata_o ) ? 
                      ( "%d pair - correct\n" ) : ( "%d pair - incorrect\n" ), k);
            err_cnt = err_cnt + ( file_enc_val[k] != sm_tdata_o );
            k = k + 1;
          end
  end

endmodule
