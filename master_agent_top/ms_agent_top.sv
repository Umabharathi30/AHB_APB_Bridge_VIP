class ms_agent_top extends uvm_env;
        `uvm_component_utils(ms_agent_top)

        bridge_env_config m_cfg;
        ms_agent_config ms_cfg;
        ms_agent agenth;
function new(string name="ms_agent_top",uvm_component parent);
        super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
                super.build_phase(phase);
        if(!uvm_config_db#(bridge_env_config)::get(this,"","bridge_env_config",m_cfg))
                `uvm_fatal("ms_agent_top","m_cfg is not perform from the m_config");

                if(m_cfg.has_magent)  begin
                agenth=ms_agent::type_id::create("agenth",this);
                ms_cfg=ms_agent_config::type_id::create("ms_cfg");

                ms_cfg=m_cfg.ms_cfg;
                uvm_config_db#(ms_agent_config)::set(this,"*","ms_agent_config",ms_cfg);
                end
endfunction
endclass
