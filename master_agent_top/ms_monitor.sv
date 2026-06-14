class ms_monitor extends uvm_monitor;
        `uvm_component_utils(ms_monitor)

        virtual bridge_if.MSMON_MP vif;
        ms_agent_config m_cfg;
        src_xtn data_sent;
        uvm_analysis_port #(src_xtn) monitor_port;
function new(string name="ms_monitor",uvm_component parent);
        super.new(name,parent);
        monitor_port=new("monitor_port",this);
endfunction

function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db #(ms_agent_config)::get(this,"","ms_agent_config",m_cfg))
                        `uvm_fatal("ms_monitor","m_cfg is not perform from ms_config");
                data_sent=src_xtn::type_id::create("data_sent");
endfunction

function void connect_phase(uvm_phase phase);
        vif=m_cfg.vif;
endfunction

task run_phase(uvm_phase phase);

        forever begin
                collect_data();
        end
endtask

task collect_data();
       //  `uvm_info("MASTER_MONITOR",$sformatf("printing from monitor \n %p", data_sent.print()),UVM_LOW)

        while(vif.m_mon_cb.Hready_out!==1)
                @(vif.m_mon_cb);
        while(vif.m_mon_cb.Htrans!==2'b10 && vif.m_mon_cb.Htrans!==2'b11)
                @(vif.m_mon_cb);
                 data_sent.Hadder=vif.m_mon_cb.Haddr;
                 data_sent.Hwrite=vif.m_mon_cb.Hwrite;
                 data_sent.Hsize=vif.m_mon_cb.Hsize;
                 data_sent.Htrans=vif.m_mon_cb.Htrans;
                 data_sent.Hburst=vif.m_mon_cb.Hburst;
                 data_sent.Hwdata=vif.m_mon_cb.Hwdata;
                 data_sent.Hready_in=vif.m_mon_cb.Hready_in;
                @(vif.m_mon_cb);
                while(vif.m_mon_cb.Hready_out!==1)
                        @(vif.m_mon_cb);
                if(data_sent.Hwrite)
                        data_sent.Hwdata=vif.m_mon_cb.Hwdata;
                else
                        data_sent.Hrdata=vif.m_mon_cb.Hrdata ;
        $display("master monitor data");
        data_sent.print();
        $display("master sampling is done");
        monitor_port.write(data_sent);
        //      @(vif.m_mon_cb);

endtask

endclass
