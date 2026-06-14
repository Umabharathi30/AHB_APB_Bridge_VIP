module top;

import uvm_pkg::*;
import bridge_pkg::*;
`include "uvm_macros.svh"

bit clock;
bridge_if if0(clock);
bridge_if if1(clock);
rtl_top DUV(.clock(clock),
                        .Hresetn(if0.Hresetn),
                        .Htrans(if0.Htrans),
                        .Hsize(if0.Hsize),
                        .Hreadyin(if0.Hready_in),
                        .Hwdata(if0.Hwdata),
                        .Haddr(if0.Haddr),
                        .Hwrite(if0.Hwrite),
                        .Prdata(if1.prdata),
                        .Hrdata(if0.Hrdata),
                        .Hresp(if0.Hresp),
                        .Hreadyout(if0.Hready_out),
                        .Pselx(if1.pselx),
                        .Pwrite(if1.pwrite),
                        .Penable(if1.penable),
                        .Paddr(if1.paddr),
                        .Pwdata(if1.pwdata));
always #10 clock=~clock;

initial begin
                clock=0;

                        `ifdef VCS
                        $fsdbDumpvars(0, top);
                        `endif

        uvm_config_db #(virtual bridge_if)::set(null,"*","vif",if0);
        uvm_config_db#(virtual  bridge_if)::set(null,"*","vif_0",if1);

        run_test("brdige_test");
end

endmodule
