class apb_sequence extends uvm_sequence#(src_xtn);
        `uvm_object_utils(slv_sequence)

function new(string name="slv_sequence");
        super.new(name);
endfunction
endclass

