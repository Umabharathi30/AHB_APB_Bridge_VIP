class bridge_test extends uvm_test;

        `uvm_component_utils(bridge_test)

        virtual_sequence v_seqh;
        bridge_env_config m_cfg;
        tb envh;
        slv_agent_config s_cfg;
        ms_agent_config ms_cfg;
function new(string name="bridge_test",uvm_component parent );
        super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
                super.build_phase(phase);

                m_cfg=bridge_env_config::type_id::create("m_cfg");

                v_seqh=virtual_sequence::type_id::create("v_seqh");

                envh=tb::type_id::create("envh",this);

                ms_cfg=ms_agent_config::type_id::create("ms_cfg");

                ms_cfg.is_active=UVM_ACTIVE;
                if(!uvm_config_db#(virtual bridge_if)::get(this,"","vif",ms_cfg.vif))
                        `uvm_fatal("test","vif is not performing from the top");

                m_cfg.ms_cfg=ms_cfg;

                s_cfg=slv_agent_config::type_id::create("s_cfg");

                s_cfg.is_active=UVM_ACTIVE;
                if(!uvm_config_db#(virtual bridge_if)::get(this,"","vif_0",s_cfg.vif))
                        `uvm_fatal("test_slv","vif is not performing from the top");

                m_cfg.s_cfg=s_cfg;


                uvm_config_db#(bridge_env_config)::set(this,"*","bridge_env_config",m_cfg);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
endfunction
endclass

class single_test extends bridge_test;

        `uvm_component_utils(single_test)

        single_seqs s_seqrh;

function new(string name="single_test",uvm_component parent );
        super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
                super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        repeat(15) begin
        s_seqrh=single_seqs::type_id::create("s_seqrh");
        s_seqrh.start(envh.m_toph.agenth.seqrh);
        end
        #85;

         phase.drop_objection(this);
endtask
endclass


class increment_test extends bridge_test;

        `uvm_component_utils(increment_test)

        increment_seqs inc_seqrh;

function new(string name="increment_test",uvm_component parent );
        super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
                super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        repeat(15) begin
        inc_seqrh=increment_seqs::type_id::create("inc_seqrh");
        inc_seqrh.start(envh.m_toph.agenth.seqrh);
        end
        #200;
         phase.drop_objection(this);
endtask
endclass

class wrap_test extends bridge_test;

        `uvm_component_utils(wrap_test)

        wrap_seqs wrp_seqrh;

function new(string name="wrap_test",uvm_component parent );
        super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
                super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        repeat(15) begin
        wrp_seqrh=wrap_seqs::type_id::create("wrp_seqrh");
        wrp_seqrh.start(envh.m_toph.agenth.seqrh);
        end
        #200;
         phase.drop_objection(this);
endtask
endclass
