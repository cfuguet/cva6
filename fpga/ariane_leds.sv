// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

// Status LEDs
module ariane_leds (
    input  logic       clk_i,    // Clock
    input  logic       rst_ni,  // Asynchronous reset active low
    output logic [7:0] led_o,
    input  logic       dmactive_i
);

    logic [31:0] cnt_d, cnt_q;

    always_comb begin
        cnt_d = cnt_q;
        led_o = '0;
        // hearbeat
        led_o[0] = cnt_q[18];
        // debugging active
        led_o[1] = dmactive_i;
        led_o[7] = 1'b1;
    end

    always_ff @(posedge clk_i or negedge rst_ni) begin : proc_
        if (~rst_ni) begin
            cnt_q <= 0;
        end else begin
            cnt_q <= cnt_d + 1;
        end
    end
endmodule