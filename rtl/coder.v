`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.07.2018 15:25:30
// Design Name: 
// Module Name: coder
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


module coder #(
  parameter STAGES_QUANTITY = 32,
  parameter TDATA_WIDTH     = 64,
  parameter KEY_WIDTH       = 256,
  parameter K_WIDTH         = 32,
  parameter R_WIDTH         = 32
)(
  input                              clk_i,
  
  // stream slave signals
  input                              ss_aresetn_i,
  input                              ss_tvalid_i,
  
  input      [TDATA_WIDTH - 1 : 0]   ss_tdata_i,
  output                             ss_tready_o,

  // stream master signals
  output                             sm_aresetn_o,
  output                             sm_tvalid_o,

  output     [TDATA_WIDTH - 1 : 0]   sm_tdata_o,  
  input                              sm_tready_i
);


// hidden wires
wire                          aresetn_h  [0 : STAGES_QUANTITY - 2];
wire                          tvalid_h   [0 : STAGES_QUANTITY - 2];
wire  [TDATA_WIDTH - 1 : 0]   tdata_h    [0 : STAGES_QUANTITY - 2];
wire                          tready_h   [0 : STAGES_QUANTITY - 2];


reg   [KEY_WIDTH - 1 : 0] key; 

cd_unit #(
  .TDATA_WIDTH   ( TDATA_WIDTH                      ),
  .K_WIDTH       ( K_WIDTH                          ),
  .R_WIDTH       ( R_WIDTH                          )
) cd_unit_i (
  .clk_i         ( clk_i                            ),
  
  .key_i         ( key            [K_WIDTH - 1 : 0] ),
  
  .ss_aresetn_i  ( ss_aresetn_i                     ),
  .ss_tvalid_i   ( ss_tvalid_i                      ),
  .ss_tdata_i    ( ss_tdata_i                       ),
  .ss_tready_o   ( ss_tready_o                      ),
  
  .sm_aresetn_o  ( aresetn_h      [0]               ),
  .sm_tvalid_o   ( tvalid_h       [0]               ),
  .sm_tdata_o    ( tdata_h        [0]               ),  
  .sm_tready_i   ( tready_h       [0]               )
);

generate
  genvar j;
    for (j = 1; j < STAGES_QUANTITY - 1; j = j + 1)
      begin: conveyor_gen
        cd_unit #(
          .TDATA_WIDTH   ( TDATA_WIDTH                                                               ),
          .K_WIDTH       ( K_WIDTH                                                                   ),
          .R_WIDTH       ( R_WIDTH                                                                   )
        ) cd_unit_h (
          .clk_i         ( clk_i                                                                     ),
          
          .key_i         ( j < 24 ? key[( j % 8 + 1 ) * K_WIDTH - 1 : ( j % 8         ) * K_WIDTH] : 
                                    key[( 8 - j % 8 ) * K_WIDTH - 1 : ( 8 - j % 8 - 1 ) * K_WIDTH]   ),
          
          .ss_aresetn_i  ( aresetn_h   [j - 1]                                                       ),
          .ss_tvalid_i   ( tvalid_h    [j - 1]                                                       ),
          .ss_tdata_i    ( tdata_h     [j - 1]                                                       ),
          .ss_tready_o   ( tready_h    [j - 1]                                                       ),
          
          .sm_aresetn_o  ( aresetn_h   [j]                                                           ),
          .sm_tvalid_o   ( tvalid_h    [j]                                                           ),
          .sm_tdata_o    ( tdata_h     [j]                                                           ),  
          .sm_tready_i   ( tready_h    [j]                                                           )
        );
      end  
endgenerate

cd_unit #(
  .TDATA_WIDTH   ( TDATA_WIDTH                             ),
  .K_WIDTH       ( K_WIDTH                                 ),
  .R_WIDTH       ( R_WIDTH                                 )
) cd_unit_o (
  .clk_i         ( clk_i                                   ),
  
  .key_i         ( key           [K_WIDTH - 1 : 0]         ),
  
  .ss_aresetn_i  ( aresetn_h     [STAGES_QUANTITY - 2]     ),
  .ss_tvalid_i   ( tvalid_h      [STAGES_QUANTITY - 2]     ),
  .ss_tdata_i    ( tdata_h       [STAGES_QUANTITY - 2]     ),
  .ss_tready_o   ( tready_h      [STAGES_QUANTITY - 2]     ),
  
  .sm_aresetn_o  ( sm_aresetn_o                            ),
  .sm_tvalid_o   ( sm_tvalid_o                             ),
  .sm_tdata_o    ( sm_tdata_o                              ),  
  .sm_tready_i   ( sm_tready_i                             )
);

initial
  begin
    key[31 : 0]    = 32'h69969669;
    key[63 : 32]   = 32'h96696996;
    key[95 : 64]   = 32'h96696996;
    key[127 : 96]  = 32'h69969669;
    key[159 : 128] = 32'h96696996;
    key[191 : 160] = 32'h69969669;
    key[223 : 192] = 32'h69969669;
    key[255 : 224] = 32'h96696996;
  end

endmodule
