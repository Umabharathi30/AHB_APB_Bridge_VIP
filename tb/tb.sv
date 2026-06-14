class tb extends uvm_env;
        `uvm_component_utils(tb)

        ms_agent_top m_toph;
        slv_agent_top s_toph;
        bridge_env_config m_cfg;
        virtual_sequencer v_sequencer;
        scoreboard sbh;

function new(string name="tb",uvm_component parent );
        super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
                super.build_phase(phase);
        if(!uvm_config_db#(bridge_env_config)::get(this,"","bridge_env_config",m_cfg))
                `uvm_fatal("tb","m_cfg is not perform from the env_config");

        m_toph=ms_agent_top::type_id::create("m_toph",this);
        s_toph=slv_agent_top::type_id::create("s_toph",this);

        if(m_cfg.has_virtual_sequencer)
                v_sequencer=virtual_sequencer::type_id::create("v_sequencer",this);

        if(m_cfg.has_scoreboard)
                sbh=scoreboard::type_id::create("sbh",this);

endfunction

function void connect_phase(uvm_phase phase);

                     if(m_cfg.has_scoreboard) begin

                                 m_toph.agenth.monh.monitor_port.connect(sbh.bridge_srh.analysis_export);
                                         s_toph.s_agenth.monh.monitor_port1.connect(sbh.bridge_dsth.analysis_export);

                                         end
endfunction
endclass

