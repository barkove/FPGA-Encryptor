`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2018 17:41:37
// Design Name: 
// Module Name: cd_unit
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


module cd_unit #(
  parameter TDATA_WIDTH     = 64,
  parameter K_WIDTH         = 32,
  parameter R_WIDTH         = 32,
  parameter SHIFT_VAL       = 11
)(
  input                              clk_i,
  input      [K_WIDTH - 1 : 0]       key_i,

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

// replacer's ensuring wires
wire [R_WIDTH - 1 : 0]        r_arg;
wire [R_WIDTH - 1 : 0]        r_res;

wire [R_WIDTH - 1 : 0]        shift_r_res;

reg  [TDATA_WIDTH - 1 : 0]    in_block;

reg                           is_valid_in_block;

// sm_tvalid_o's ensuring registers
reg                           in_block_chk;
reg                           sm_tdata_o_chk;

replacer #(
  .R_WIDTH ( R_WIDTH )
) replacer_0 (
  .data_i  ( r_arg   ),
  .data_o  ( r_res   )
);

assign r_arg        =    in_block[R_WIDTH - 1 : 0] + key_i[K_WIDTH - 1 : 0];
// shift_r_res contains the cyclical shifted data of r_res
assign shift_r_res  =  ( r_res << SHIFT_VAL ) | ( ( ( ~0 << ( R_WIDTH - SHIFT_VAL ) ) & r_res ) >> ( R_WIDTH - SHIFT_VAL ) );
assign sm_tdata_o   =  { in_block[R_WIDTH - 1 : 0],  in_block[TDATA_WIDTH - 1 : R_WIDTH] ^ shift_r_res };

assign sm_aresetn_o =    ss_aresetn_i;
assign ss_tready_o  =  ( !is_valid_in_block ) || ( sm_tvalid_o && sm_tready_i ); 

// the sm_tdata_o is valid only when in_block contains valid data and after clock cycle 
//  - in_block has changed and sm_tdata_o has changed
//  - in_block has no changed and sm_tdata_o has no changed 
// *_chk signals are ensuring the last two conditions
assign sm_tvalid_o  = !( in_block_chk ^ sm_tdata_o_chk ) && is_valid_in_block;

initial 
  begin
    in_block_chk      = 0;
    sm_tdata_o_chk    = 0;
  end
  
always @( in_block )
  in_block_chk <= ~in_block_chk;

always @( sm_tdata_o )
  sm_tdata_o_chk <= ~sm_tdata_o_chk;

always @( posedge clk_i or negedge ss_aresetn_i )
  if ( !ss_aresetn_i )
    is_valid_in_block <= 0;
  else
    if ( ss_tvalid_i && ss_tready_o )
      is_valid_in_block <= 1;
    else
      if ( sm_tvalid_o && sm_tready_i )
        is_valid_in_block <= 0;

always @( posedge clk_i or negedge ss_aresetn_i )
  if ( !ss_aresetn_i )
    in_block <= 0;
  else 
    if ( ss_tvalid_i && ss_tready_o )
        in_block <= ss_tdata_i;
  
endmodule
