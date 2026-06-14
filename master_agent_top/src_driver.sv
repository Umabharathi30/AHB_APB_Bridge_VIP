
class src_driver extends uvm_driver#(src_xtn);
        `uvm_component_utils(src_driver)

        virtual bridge_if.MSDR_MP vif;
        ms_agent_config m_cfg;

function new(string name="src_driver",uvm_component parent);
        super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db #(ms_agent_config)::get(this,"","ms_agent_config",m_cfg))
                        `uvm_fatal("src_driver","m_cfg is not perform from src_config");
endfunction

function void connect_phase(uvm_phase phase);
        vif=m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
//      phase.raise_objection(this);
        @(vif.m_dr_cb);
        vif.m_dr_cb.Hresetn<=0;
        @(vif.m_dr_cb);
        vif.m_dr_cb.Hresetn<=1;
        $display("reset is done");
        forever
  begin
        seq_item_port.get_next_item(req);
        send_to_dut(req);
        //@(vif.m_dr_cb);
        seq_item_port.item_done();
        end
//      phase.drop_objection(this);
endtask

task send_to_dut(src_xtn req);

        while(vif.m_dr_cb.Hready_out!==1)
                @(vif.m_dr_cb);
                        $display("hready_out is getting 1 ");
                vif.m_dr_cb.Haddr <=req.Hadder;
                vif.m_dr_cb.Hwrite <=req.Hwrite;
                vif.m_dr_cb.Hsize <=req.Hsize;
                vif.m_dr_cb.Htrans <=req.Htrans;
                vif.m_dr_cb.Hwdata<=req.Hwdata;
                vif.m_dr_cb.Hburst<=req.Hburst;
                vif.m_dr_cb.Hready_in <=1;
                @(vif.m_dr_cb);
//      `uvm_info("master driver ",$sformatf("printing from driver \n %p", req.print()),UVM_LOW);;


                while(vif.m_dr_cb.Hready_out!==1)
                @(vif.m_dr_cb);
                if(req.Hwrite)
                        vif.m_dr_cb.Hwdata <=req.Hwdata;
                else
                        vif.m_dr_cb.Hwdata <=0;
                $display("master driving is done  ");


endtask
endclass
