class slv_monitor extends uvm_monitor;
        `uvm_component_utils(slv_monitor)

        virtual bridge_if vif;
        slv_agent_config s_cfg;
        slv_xtn  sent;
uvm_analysis_port #(slv_xtn) monitor_port1;
function new(string name="slv_monitor",uvm_component parent);
        super.new(name,parent);
        monitor_port1=new("monitor_port1",this);

endfunction

function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db #(slv_agent_config)::get(this,"","slv_agent_config",s_cfg))
                        `uvm_fatal("slv_monitor","m_cfg is not perform from slv_agent_config");
                        sent=slv_xtn::type_id::create("sent");

endfunction

function void connect_phase(uvm_phase phase);
        vif=s_cfg.vif;
endfunction

task run_phase(uvm_phase phase);

        forever begin
        $display("enterning the slave monitor");
                collect_data();
        end
endtask

task collect_data();
//         `uvm_info("SLAVE MONITOR",$sformatf("printing from slave monitor \n %p", sent.print()),UVM_LOW);

        while(vif.s_mon_cb.penable!==1)
        @(vif.s_mon_cb);
        sent.Paddr=vif.s_mon_cb.paddr;
        sent.Pwrite=vif.s_mon_cb.pwrite;
        sent.Pselx=vif.s_mon_cb.pselx;
        sent.Penable=vif.s_mon_cb.penable;

        if(sent.Pwrite)
                sent.Pwdata=vif.s_mon_cb.pwdata;
        else
                sent.Prdata=vif.s_mon_cb.prdata;
        repeat(2)
                        @(vif.s_mon_cb);
        sent.print();
        $display(" slave sampling is done");
        monitor_port1.write(sent);

        endtask




endclass
