package bridge_pkg;

import uvm_pkg::*;

        `include "uvm_macros.svh"

        `include "src_xtn.sv"
        `include "ms_agent_config.sv"
        `include "slv_agent_config.sv"
        `include "bridge_env_config.sv"

        `include "src_driver.sv"
        `include "ms_monitor.sv"
        `include "src_sequencer.sv"
        `include "ms_agent.sv"
        `include "ms_agent_top.sv"
        `include "src_sequence.sv"

        `include "slv_xtn.sv"
        `include "slv_monitor.sv"
        `include "slv_sequencer.sv"
        `include "slv_sequence.sv"
        `include "slv_driver.sv"
        `include "slv_agent.sv"
        `include "slv_agent_top.sv"

        `include "virtual_sequencer.sv"
        `include "virtual_seqs.sv"
        `include "scoreboard.sv"

        `include "tb.sv"

        `include "bridge_test.sv"




endpackage
