class slv_driver extends uvm_driver#(slv_xtn);
        `uvm_component_utils(slv_driver)

        virtual bridge_if.SDR_MP vif;
        slv_agent_config s_cfg;

function new(string name="slv_driver",uvm_component parent);
        super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db #(slv_agent_config)::get(this,"","slv_agent_config",s_cfg))
                        `uvm_fatal("slv_driver","m_cfg is not perform from slv_agent_config");
endfunction

function void connect_phase(uvm_phase phase);
        vif=s_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
//      phase.raise_objection(this);
        forever
  begin
        seq_item_port.get_next_item(req);
        $display("get next item is getting block");
        send_to_dut(req);
        seq_item_port.item_done();
        $display(" item done is getting block");
        end
//      phase.drop_objection(this);
endtask

task send_to_dut(slv_xtn req);
                $display("entering into the send to dut ");
        // `uvm_info("slave driver ",$sformatf("printing from slave driver \n %p", req.print()),UVM_LOW);

        while(vif.s_dr_cb.pselx===0)
                @(vif.s_dr_cb);
                if(vif.s_dr_cb.pwrite==0)
                        vif.s_dr_cb.prdata<=$random;
                //`uvm_info(get_type_name(),$sformatf("Prdata:%0d",$random),UVM_MEDIUM);

                repeat(2)
                        @(vif.s_dr_cb);

endtask
endclass
