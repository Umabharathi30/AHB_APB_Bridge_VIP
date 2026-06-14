class bridge_env_config extends uvm_object;
        `uvm_object_utils(bridge_env_config)
        //virtual bridge_if vif;

        ms_agent_config ms_cfg;
        slv_agent_config s_cfg;

        bit has_magent=1;
        bit has_sagent=1;
        bit has_virtual_sequencer=1;
        bit has_scoreboard=1;
        int no_of_master=1;
        int no_of_slave=1;

function new(string name="bridge_env_config");
        super.new(name);
endfunction

endclass
