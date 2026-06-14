class scoreboard extends uvm_env;
        `uvm_component_utils(scoreboard)

          uvm_tlm_analysis_fifo#(src_xtn) bridge_srh;
          uvm_tlm_analysis_fifo#(slv_xtn) bridge_dsth;
          bridge_env_config m_cfg;

          src_xtn xtnh1;
          slv_xtn xtnh2;


covergroup ahb_cg;
        HADDR:coverpoint  xtnh1.Hadder{bins slave1={[32'H8000_0000:32'H8000_03FF]};
                                                                  bins slave2={[32'H8400_0000:32'H8400_03FF]};
                                          bins slave3={[32'H8800_0000:32'H8800_03FF]};
                                                                  bins slave4={[32'H8C00_0000:32'H8C00_03FF]};}
        HSIZE:coverpoint xtnh1.Hsize{ bins zero={0};
                                                                  bins one={1};
                                                                  bins two={2};}
        HWRITE:coverpoint xtnh1.Hwrite{ bins read={0};
                                                                  bins write={1};}
        HTRANS:coverpoint xtnh1.Htrans{ bins non_sequential={2'b10};
                                                                  bins sequential={2'b11};}

        AHB_FC:cross HADDR,HSIZE,HWRITE,HTRANS;
endgroup

covergroup apb_cg;
        PADDR:coverpoint  xtnh2.Paddr{bins slave1={[32'H8000_0000:32'H8000_03FF]};
                                                                  bins slave2={[32'H8400_0000:32'H8400_03FF]};
                                          bins slave3={[32'H8800_0000:32'H8800_03FF]};
                                                                  bins slave4={[32'H8C00_0000:32'H8C00_03FF]};}
        PWRITE:coverpoint xtnh2.Pwrite{ bins read={0};
                                                                  bins write={1};}
        PSELX:coverpoint xtnh2.Pselx{ bins d0={1};
                                                                  bins d1={2};
                                                                  bins d2={4};
                                                                  bins d3={8};}
        APB_FC:cross PADDR,PWRITE;
endgroup

function new(string name="scoreboard",uvm_component parent );
        super.new(name,parent);
        ahb_cg=new();
        apb_cg=new();
endfunction


function void  build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(bridge_env_config)::get(this,"","bridge_env_config",m_cfg))
                `uvm_fatal("scoreboard","cannot get() m_cfg from uvm_config_db. Have you set() it?")
        //`uvm_info(get_type_name(),"dst mon data from scoreboard",UVM_MEDIUM);
        bridge_srh=new("bridge_srh",this);
        bridge_dsth=new("bridge_dsth",this);
        xtnh1=src_xtn::type_id::create("xtnh1");
        xtnh2=slv_xtn::type_id::create("xtnh2");

endfunction

task run_phase(uvm_phase phase);

        forever begin
                fork
                        begin
                        bridge_srh.get(xtnh1);
                        `uvm_info(get_type_name(),"src mon data from scoreboard",UVM_MEDIUM);
                        xtnh1.print();
                        ahb_cg.sample();
                        end
                begin

                        bridge_dsth.get(xtnh2);
                        `uvm_info(get_type_name(),"slv mon data from scoreboard",UVM_MEDIUM);
                        xtnh2.print();
                        apb_cg.sample();
                end
                join
        check_data(xtnh1,xtnh2);
        end
endtask

task compare(int Haddr,Paddr,Hdata,Pdata);
        if(Haddr==Paddr)
                        $display("address compared successfully");
        else
                        $display("address compared failed");
        if(Hdata==Pdata)
                        $display("data compared successfully");
        else
                        $display("data compared failed");
endtask

task check_data(src_xtn xtnh1, slv_xtn xtnh2);
        if(xtnh1.Hwrite==1) begin
                if(xtnh1.Hsize==2'b00) begin
                        if(xtnh1.Hadder[1:0]==2'b00)
                                compare( xtnh1.Hadder,xtnh2.Paddr,xtnh1.Hwdata[7:0],xtnh2.Pwdata);
                        if(xtnh1.Hadder[1:0]==2'b01)
                                compare( xtnh1.Hadder,xtnh2.Paddr,xtnh1.Hwdata[15:8],xtnh2.Pwdata);
                        if(xtnh1.Hadder[1:0]==2'b10)
                                compare( xtnh1.Hadder,xtnh2.Paddr,xtnh1.Hwdata[23:16],xtnh2.Pwdata);
                        if(xtnh1.Hadder[1:0]==2'b11)
                                compare( xtnh1.Hadder,xtnh2.Paddr,xtnh1.Hwdata[31:24],xtnh2.Pwdata);
                end
                if(xtnh1.Hsize==2'b01) begin
                        if(xtnh1.Hadder[1:0]==2'b00)
                                compare( xtnh1.Hadder,xtnh2.Paddr,xtnh1.Hwdata[15:0],xtnh2.Pwdata);
                        if(xtnh1.Hadder[1:0]==2'b10)
                                compare( xtnh1.Hadder,xtnh2.Paddr,xtnh1.Hwdata[31:16],xtnh2.Pwdata);
                end
                if(xtnh1.Hsize==2'b10) begin
                        compare( xtnh1.Hadder,xtnh2.Paddr,xtnh1.Hwdata[31:0],xtnh2.Pwdata);
                end
        end
        else begin
                if(xtnh1.Hsize==2'b00) begin
                        if(xtnh1.Hadder[1:0]==2'b00)
                                compare( xtnh1.Hadder,xtnh2.Paddr,xtnh1.Hrdata,xtnh2.Prdata[7:0]);
                        if(xtnh1.Hadder[1:0]==2'b01)
                                compare( xtnh1.Hadder,xtnh2.Paddr,xtnh1.Hrdata,xtnh2.Prdata[15:8]);
                        if(xtnh1.Hadder[1:0]==2'b10)
                                compare( xtnh1.Hadder,xtnh2.Paddr,xtnh1.Hrdata,xtnh2.Prdata[23:16]);
                        if(xtnh1.Hadder[1:0]==2'b11)
                                compare( xtnh1.Hadder,xtnh2.Paddr,xtnh1.Hrdata,xtnh2.Prdata[31:24]);
                end
                if(xtnh1.Hsize==2'b01) begin
                        if(xtnh1.Hadder[1:0]==2'b00)
                                compare( xtnh1.Hadder,xtnh2.Paddr,xtnh1.Hrdata,xtnh2.Prdata[15:0]);
                        if(xtnh1.Hadder[1:0]==2'b10)
                                compare( xtnh1.Hadder,xtnh2.Paddr,xtnh1.Hrdata,xtnh2.Prdata[31:16]);
                end
                if(xtnh1.Hsize==2'b10) begin
                        compare( xtnh1.Hadder,xtnh2.Paddr,xtnh1.Hrdata,xtnh2.Prdata[31:0]);
                end
        end
endtask

endclass
