interface bridge_if(input bit clock );




        //inputs
        logic Hresetn;
        logic [1:0] Htrans;
        logic [2:0] Hsize;
        logic Hready_in;
        logic [31:0] Hwdata;
        logic [31:0] Haddr;
        logic Hwrite;
        logic [31:0]prdata;
        logic [31:0] Hrdata;
        logic [1:0] Hresp;
        logic Hready_out;
//      logic Hselapbif;
        logic [3:0]pselx;
        logic pwrite;
        logic penable;
        logic Hburst;
        logic [31:0]paddr;
        logic [31:0]pwdata;



clocking m_dr_cb@(posedge clock);
        default input#1 output  #1;
        output Hwdata;
        output Hwrite;
        output Hresetn;
        output Htrans;
        //output Hselapbif;
        output Hready_in;
        input Hresp;
        input Hrdata;
        output Haddr;
        output Hsize;
        input Hready_out;
        output Hburst;
        endclocking

clocking m_mon_cb@(posedge clock);
        default input#1 output  #1;

        input Hresetn;
        //input Hselapbif;
        input Hresp;
        input Hwrite;
        input Htrans;
        input Hready_in;
        input Hready_out;
        input Hrdata;
        input Haddr;
        input Hsize;
        input Hwdata;
        input Hburst;
        endclocking

clocking s_dr_cb @(posedge clock);
        default input #1 output #1;

        input  penable;
        input pwrite;
        input pwdata;
        input pselx;
        output prdata;
        input paddr;


endclocking

clocking s_mon_cb @(posedge clock);
        default input #1 output #1;

        input prdata;
        input pselx;
        input pwrite;
        input  penable;
        input pwdata;
        input paddr;
        //input Hrdata;
        //input Hresp;
endclocking


        modport MSDR_MP(clocking m_dr_cb);
        modport MSMON_MP(clocking m_mon_cb);
        modport SDR_MP(clocking s_dr_cb);
        modport SMON_MP(clocking s_mon_cb);

endinterface
