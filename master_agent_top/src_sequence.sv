class src_sequence extends uvm_sequence#(src_xtn);
                        `uvm_object_utils(src_sequence)
                bit [31:0] haddr;
                bit [2:0]hsize;
                bit hwrite;
                bit [9:0] hlength;
                bit [2:0]hburst;

function new(string name="src_sequence");
        super.new(name);
endfunction
endclass

class single_seqs extends src_sequence;
        `uvm_object_utils(single_seqs)

function new(string name="single_seqs");
        super.new(name);
endfunction

task body();
        req=src_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize()with{Htrans==2'b10; Hburst==3'b000;});
        req.print();
        finish_item(req);

endtask
endclass

class increment_seqs extends src_sequence;
        `uvm_object_utils(increment_seqs)

function new(string name="increment_seqs");
        super.new(name);
endfunction

task body();
        req=src_xtn::type_id::create("req");
        start_item(req);
        //$display("start item is getting block");
        assert(req.randomize()with{Htrans==2'b10; Hburst inside{1,3,5,7}; Hwrite==1;});
        req.print();
        finish_item(req);
        //$display("finish item is getting block");
        haddr=req.Hadder;
        hsize=req.Hsize;
        hwrite=req.Hwrite;
        hburst=req.Hburst;

        hlength=req.Hlength;

        for(int i=1;i<hlength;i++) begin

        start_item(req);
        assert(req.randomize()with{Hsize==hsize; Hwrite==hwrite;  Htrans==2'b11; Hburst==hburst; Hadder==haddr+(2**hsize);});
        req.print();
        finish_item(req);
        haddr=req.Hadder;
        $display("inc value for given to the driver");
        end
endtask
endclass


class wrap_seqs extends src_sequence;
        `uvm_object_utils(wrap_seqs)

        bit [31:0] start_addr,boundary_addr;
function new(string name="wrap_seqs");
        super.new(name);
endfunction

task body();
        req=src_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize()with{Htrans==2'b10; Hburst inside{2,4,6};});
        req.print();
        finish_item(req);
        haddr=req.Hadder;
        hsize=req.Hsize;
        hburst=req.Hburst;
        hwrite=req.Hwrite;

        hlength=req.Hlength;

        start_addr=int'((haddr/(2**hsize)*(hlength))*((2**hsize)*(hlength)));
        boundary_addr=start_addr+((2**hsize)*(hlength));
        haddr=req.Hadder+(2**hsize);
        for(int i=1;i<hlength;i++) begin
        $display("start addr =%0h,boundary addr=%0h",start_addr,boundary_addr);
        if(haddr==boundary_addr) begin
                haddr=start_addr;
        end
        start_item(req);
        assert(req.randomize()with{ Hsize==hsize; Hburst==hburst;
                                                Hadder==haddr; Htrans==2'b11;Hwrite==hwrite;  Hlength==hlength;});
        req.print();
        finish_item(req);
        haddr=req.Hadder+(2**hsize);//value for given to the driver
        end

endtask
endclass
