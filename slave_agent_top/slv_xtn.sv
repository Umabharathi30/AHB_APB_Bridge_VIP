class slv_xtn extends uvm_sequence_item;

        `uvm_object_utils(slv_xtn)

        bit Penable,Pwrite;
        bit[31:0] Paddr,Pwdata;
        rand bit [31:0] Prdata;
        bit [3:0] Pselx;


//constraint a{ Pselx dist {{4'b0001}:/5,{4'b0010}:/5,{4'b0100}:/5,{4'b1000}:/5};}

//constraint a1{ Pwrite dist {{2'b00}:/5,{2'b01}:/5};}


function new(string name="slv_xtn");
        super.new(name);
endfunction


function void  do_print(uvm_printer printer);
        super.do_print(printer);

        printer.print_field("Pneable",this.Penable,"1",UVM_DEC);
        printer.print_field("Pwrite",this.Pwrite,"1",UVM_DEC);
        printer.print_field("Paddr",this.Paddr,"32",UVM_HEX);
        printer.print_field("Pwdata",this.Pwdata,"32",UVM_DEC);
        printer.print_field("Prdata",this.Prdata,"32",UVM_DEC);
        printer.print_field("Pselx",this.Pselx,"8",UVM_DEC);


endfunction
endclass
