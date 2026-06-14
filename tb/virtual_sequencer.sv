class virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
        `uvm_component_utils(virtual_sequencer)

        src_sequencer m_seqr[];
        slv_sequencer s_seqr[];
        bridge_env_config m_cfg;
function new(string name="virtual_sequence",uvm_component parent );
        super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(bridge_env_config)::get(null,get_full_name(),"bridge_env_config",m_cfg))
                `uvm_fatal("virtual_seqr","m_cfg is not perform from the bridge_env_config");

        m_seqr=new[m_cfg.no_of_master];
        s_seqr=new[m_cfg.no_of_slave];
endfunction

endclass
