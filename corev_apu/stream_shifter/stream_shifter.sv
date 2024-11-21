//   Copyright 2024 Cesar Fuguet
//
//   Licensed under the Solderpad Hardware License, Version 2.1 (the “License”);
//   you may not use this file except in compliance with the License.
//   SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//   You may obtain a copy of the License at https://solderpad.org/licenses/
//
//   Authors: Cesar Fuguet
//   Date: November, 2024
module stream_shifter
#(
  parameter type data_t        = logic,
  parameter int unsigned Depth = logic
)
(
  input logic   clk_i,
  input logic   rst_ni,

  input  logic  w_i,
  input  data_t wdata_i,
  output logic  wok_o,

  input  logic  r_i,
  output data_t rdata_o,
  output logic  rok_o
);

  logic  [Depth-1:0] val_q;
  data_t [Depth-1:0] reg_q;

  if (Depth == 0) begin : gen_passthrough
    assign rok_o   = w_i;
    assign rdata_o = wdata_i;
    assign wok_o   = r_i;

  end else if (Depth == 1) begin : gen_register
    always_ff @(posedge clk_i or negedge rst_ni)
    begin : shifter_ff
      if (!rst_ni) begin
        reg_q[0] <= '0;
        val_q[0] <= '0;
      end else begin
        if (r_i || !val_q[0]) begin
          reg_q[0] <= wdata_i;
          val_q[0] <= w_i;
        end
      end
    end

    assign rdata_o = reg_q[0];
    assign rok_o = val_q[0];
    assign wok_o = r_i | ~val_q[0];

  end else begin : gen_shifter
    always_ff @(posedge clk_i or negedge rst_ni)
    begin : shifter_ff
      if (!rst_ni) begin
        reg_q <= '0;
        val_q <= '0;
      end else begin
        if (r_i || !val_q[0]) begin
          reg_q <= {wdata_i, reg_q[Depth-1:1]};
          val_q <= {w_i, val_q[Depth-1:1]};
        end
      end
    end

    assign rdata_o = reg_q[0];
    assign rok_o = val_q[0];
    assign wok_o = r_i | ~val_q[0];
  end

endmodule
