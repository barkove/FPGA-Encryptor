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

initial
  begin
    // reset
    ss_aresetn_i = 0;
    ss_tvalid_i  = 0;
    ss_tdata_i   = 0;
    sm_tready_i  = 0;
    #CLOCK_SEMI_PERIOD_NS;
    #CLOCK_SEMI_PERIOD_NS;
    // get ss_tdata_i
    ss_aresetn_i = 1;
    ss_tvalid_i  = 1;
    ss_tdata_i   = 'h0123456789abcdef;
    sm_tready_i  = 0;
    #CLOCK_SEMI_PERIOD_NS;
    #CLOCK_SEMI_PERIOD_NS;
    // coder is full and cannot to get data
    ss_aresetn_i = 1;
    ss_tvalid_i  = 1;
    ss_tdata_i   = 'habcdef0123456789;
    sm_tready_i  = 0;
    #CLOCK_SEMI_PERIOD_NS;
    #CLOCK_SEMI_PERIOD_NS;
    // coder can to get data, because its data will be passed the next rising edge 
    ss_aresetn_i = 1;
    ss_tvalid_i  = 1;
    ss_tdata_i   = 'habcdef0123456789;
    sm_tready_i  = 1;
    #CLOCK_SEMI_PERIOD_NS;
    #CLOCK_SEMI_PERIOD_NS;
    // coder is passing data without getting new data
    ss_aresetn_i = 1;
    ss_tvalid_i  = 0;
    ss_tdata_i   = 'habcdef0123456789;
    sm_tready_i  = 1;       
  end

endmodule
