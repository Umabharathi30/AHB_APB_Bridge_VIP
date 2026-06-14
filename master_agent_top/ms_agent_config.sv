class ms_agent_config extends uvm_object;
        `uvm_object_utils(ms_agent_config)
        virtual bridge_if vif;

        uvm_active_passive_enum is_active =UVM_ACTIVE;

function new(string name="ms_agent_config");
        super.new(name);
endfunction
endclass
