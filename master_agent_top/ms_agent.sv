class ms_agent extends uvm_agent;
        `uvm_component_utils(ms_agent)

        ms_agent_config m_cfg;

        ms_monitor monh;
        src_driver drvh;
        src_sequencer seqrh;

function new(string name="ms_agent",uvm_component parent);
        super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db #(ms_agent_config)::get(this,"","ms_agent_config",m_cfg))
                        `uvm_fatal("ms_agent","m_cfg is not perform from ms_config");

                monh=ms_monitor::type_id::create("monh",this);
                if(m_cfg.is_active==UVM_ACTIVE) begin
                drvh=src_driver::type_id::create("drvh",this);
                seqrh=src_sequencer::type_id::create("seqrh",this);
                end


endfunction

function void connect_phase(uvm_phase phase);
                if(m_cfg.is_active==UVM_ACTIVE) begin
                        drvh.seq_item_port.connect(seqrh.seq_item_export);
                end
        endfunction

endclass
