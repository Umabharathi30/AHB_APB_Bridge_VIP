class slv_sequencer extends uvm_sequencer#(slv_xtn);
        `uvm_component_utils(slv_sequencer)

function new(string name="slv_sequencer",uvm_component parent);
        super.new(name,parent);
endfunction
endclass
