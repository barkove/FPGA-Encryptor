`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.07.2018 18:20:53
// Design Name: 
// Module Name: replacer
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


module replacer #(
  parameter R_WIDTH = 32
)(  
  input      [R_WIDTH - 1 : 0] data_i,
  output reg [R_WIDTH - 1 : 0] data_o 
);

always @( * )
  case ( data_i[3 : 0] )
    4'h0: data_o[3 : 0] = 4'hc;
    4'h1: data_o[3 : 0] = 4'h4;
    4'h2: data_o[3 : 0] = 4'h6;
    4'h3: data_o[3 : 0] = 4'h2;
    4'h4: data_o[3 : 0] = 4'ha;
    4'h5: data_o[3 : 0] = 4'h5;
    4'h6: data_o[3 : 0] = 4'hb;
    4'h7: data_o[3 : 0] = 4'h9;
    4'h8: data_o[3 : 0] = 4'he;
    4'h9: data_o[3 : 0] = 4'h8;
    4'ha: data_o[3 : 0] = 4'hd;
    4'hb: data_o[3 : 0] = 4'h7;
    4'hc: data_o[3 : 0] = 4'h0;
    4'hd: data_o[3 : 0] = 4'h3;
    4'he: data_o[3 : 0] = 4'hf;
    4'hf: data_o[3 : 0] = 4'h1;
  endcase

always @( * )
  case ( data_i[7 : 4] )
    4'h0: data_o[7 : 4] = 4'h6;
    4'h1: data_o[7 : 4] = 4'h8;
    4'h2: data_o[7 : 4] = 4'h2;
    4'h3: data_o[7 : 4] = 4'h3;
    4'h4: data_o[7 : 4] = 4'h9;
    4'h5: data_o[7 : 4] = 4'ha;
    4'h6: data_o[7 : 4] = 4'h5;
    4'h7: data_o[7 : 4] = 4'hc;
    4'h8: data_o[7 : 4] = 4'h1;
    4'h9: data_o[7 : 4] = 4'he;
    4'ha: data_o[7 : 4] = 4'h4;
    4'hb: data_o[7 : 4] = 4'h7;
    4'hc: data_o[7 : 4] = 4'hb;
    4'hd: data_o[7 : 4] = 4'hd;
    4'he: data_o[7 : 4] = 4'h0;
    4'hf: data_o[7 : 4] = 4'hf;
  endcase

always @( * )
  case ( data_i[11 : 8] )
    4'h0: data_o[11 : 8] = 4'hb;
    4'h1: data_o[11 : 8] = 4'h3;
    4'h2: data_o[11 : 8] = 4'h5;
    4'h3: data_o[11 : 8] = 4'h8;
    4'h4: data_o[11 : 8] = 4'h2;
    4'h5: data_o[11 : 8] = 4'hf;
    4'h6: data_o[11 : 8] = 4'ha;
    4'h7: data_o[11 : 8] = 4'hd;
    4'h8: data_o[11 : 8] = 4'he;
    4'h9: data_o[11 : 8] = 4'h1;
    4'ha: data_o[11 : 8] = 4'h7;
    4'hb: data_o[11 : 8] = 4'h4;
    4'hc: data_o[11 : 8] = 4'hc;
    4'hd: data_o[11 : 8] = 4'h9;
    4'he: data_o[11 : 8] = 4'h6;
    4'hf: data_o[11 : 8] = 4'h0;
  endcase

always @( * )
  case ( data_i[15 : 12] )
    4'h0: data_o[15 : 12] = 4'hc;
    4'h1: data_o[15 : 12] = 4'h8;
    4'h2: data_o[15 : 12] = 4'h2;
    4'h3: data_o[15 : 12] = 4'h1;
    4'h4: data_o[15 : 12] = 4'hd;
    4'h5: data_o[15 : 12] = 4'h4;
    4'h6: data_o[15 : 12] = 4'hf;
    4'h7: data_o[15 : 12] = 4'h6;
    4'h8: data_o[15 : 12] = 4'h7;
    4'h9: data_o[15 : 12] = 4'h0;
    4'ha: data_o[15 : 12] = 4'ha;
    4'hb: data_o[15 : 12] = 4'h5;
    4'hc: data_o[15 : 12] = 4'h3;
    4'hd: data_o[15 : 12] = 4'he;
    4'he: data_o[15 : 12] = 4'h9;
    4'hf: data_o[15 : 12] = 4'hb;
  endcase

always @( * )
  case ( data_i[19 : 16] )
    4'h0: data_o[19 : 16] = 4'h7;
    4'h1: data_o[19 : 16] = 4'hf;
    4'h2: data_o[19 : 16] = 4'h5;
    4'h3: data_o[19 : 16] = 4'ha;
    4'h4: data_o[19 : 16] = 4'h8;
    4'h5: data_o[19 : 16] = 4'h1;
    4'h6: data_o[19 : 16] = 4'h6;
    4'h7: data_o[19 : 16] = 4'hd;
    4'h8: data_o[19 : 16] = 4'h0;
    4'h9: data_o[19 : 16] = 4'h9;
    4'ha: data_o[19 : 16] = 4'h3;
    4'hb: data_o[19 : 16] = 4'he;
    4'hc: data_o[19 : 16] = 4'hb;
    4'hd: data_o[19 : 16] = 4'h4;
    4'he: data_o[19 : 16] = 4'h2;
    4'hf: data_o[19 : 16] = 4'hc;
  endcase

always @( * )
  case ( data_i[23 : 20] )
    4'h0: data_o[23 : 20] = 4'h5;
    4'h1: data_o[23 : 20] = 4'hd;
    4'h2: data_o[23 : 20] = 4'hf;
    4'h3: data_o[23 : 20] = 4'h6;
    4'h4: data_o[23 : 20] = 4'h9;
    4'h5: data_o[23 : 20] = 4'h2;
    4'h6: data_o[23 : 20] = 4'hc;
    4'h7: data_o[23 : 20] = 4'ha;
    4'h8: data_o[23 : 20] = 4'hb;
    4'h9: data_o[23 : 20] = 4'h7;
    4'ha: data_o[23 : 20] = 4'h8;
    4'hb: data_o[23 : 20] = 4'h1;
    4'hc: data_o[23 : 20] = 4'h4;
    4'hd: data_o[23 : 20] = 4'h3;
    4'he: data_o[23 : 20] = 4'he;
    4'hf: data_o[23 : 20] = 4'h0;
  endcase

always @( * )
  case ( data_i[27 : 24] )
    4'h0: data_o[27 : 24] = 4'h8;
    4'h1: data_o[27 : 24] = 4'he;
    4'h2: data_o[27 : 24] = 4'h2;
    4'h3: data_o[27 : 24] = 4'h5;
    4'h4: data_o[27 : 24] = 4'h6;
    4'h5: data_o[27 : 24] = 4'h9;
    4'h6: data_o[27 : 24] = 4'h1;
    4'h7: data_o[27 : 24] = 4'hc;
    4'h8: data_o[27 : 24] = 4'hf;
    4'h9: data_o[27 : 24] = 4'h4;
    4'ha: data_o[27 : 24] = 4'hb;
    4'hb: data_o[27 : 24] = 4'h0;
    4'hc: data_o[27 : 24] = 4'hd;
    4'hd: data_o[27 : 24] = 4'ha;
    4'he: data_o[27 : 24] = 4'h3;
    4'hf: data_o[27 : 24] = 4'h7;
  endcase

always @( * )
  case ( data_i[31 : 28] )
    4'h0: data_o[31 : 28] = 4'h1;
    4'h1: data_o[31 : 28] = 4'h7;
    4'h2: data_o[31 : 28] = 4'he;
    4'h3: data_o[31 : 28] = 4'hd;
    4'h4: data_o[31 : 28] = 4'h0;
    4'h5: data_o[31 : 28] = 4'h5;
    4'h6: data_o[31 : 28] = 4'h8;
    4'h7: data_o[31 : 28] = 4'h3;
    4'h8: data_o[31 : 28] = 4'h4;
    4'h9: data_o[31 : 28] = 4'hf;
    4'ha: data_o[31 : 28] = 4'ha;
    4'hb: data_o[31 : 28] = 4'h6;
    4'hc: data_o[31 : 28] = 4'h9;
    4'hd: data_o[31 : 28] = 4'hc;
    4'he: data_o[31 : 28] = 4'hb;
    4'hf: data_o[31 : 28] = 4'h2;
  endcase

endmodule
