class slv_agent_top extends uvm_env;
        `uvm_component_utils(slv_agent_top)

        bridge_env_config m_cfg;
        slv_agent_config s_cfg;
        slv_agent s_agenth;
function new(string name="slv_agent_top",uvm_component parent);
        super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
                super.build_phase(phase);
        if(!uvm_config_db#(bridge_env_config)::get(this,"","bridge_env_config",m_cfg))
                `uvm_fatal("slv_agent_top","m_cfg is not perform from the m_config");
                if(m_cfg.has_sagent) begin
                s_agenth=slv_agent::type_id::create("s_agenth",this);
                end
                s_cfg=slv_agent_config::type_id::create("s_cfg");
                s_cfg=m_cfg.s_cfg;
                uvm_config_db#(slv_agent_config)::set(this,"*","slv_agent_config",s_cfg);
endfunction
endclass
