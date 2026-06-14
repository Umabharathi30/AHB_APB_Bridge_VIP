class src_xtn extends uvm_sequence_item;
	
        `uvm_object_utils(src_xtn)

        rand logic [31:0] Hadder;
        rand logic [1:0] Htrans;
        logic Hready_in;
        logic Hready_out;
        logic Hresp;
        rand logic [31:0] Hwdata;
        logic [31:0] Hrdata;
        rand logic [2:0] Hburst;
        rand logic Hwrite;
        rand logic [2:0] Hsize;
        rand bit[9:0] Hlength;

        constraint valid_Haddr{Hadder inside {[32'H8000_0000:32'H8000_03FF],
                                              [32'H8400_0000:32'H8400_03FF],
                                              [32'H8800_0000:32'H8800_03FF],
                                              [32'H8C00_0000:32'H8C00_03FF]};}
        constraint valid_Hsize{Hsize inside{0,1,2};}
        constraint valid_alined{(Hsize==1)->Hadder%2==0;
                                (Hsize==2)->Hadder%4==0;}
        constraint valid_adder{((Hadder%1024)+((Hlength*(2**Hsize))<=1023));}
        constraint valid_Hlength{(Hburst==0)->Hlength==1;
                                                (Hburst==2)->Hlength==4;
                                                    (Hburst==3)->Hlength==4;
                                                        (Hburst==4)->Hlength==8;
                                                        (Hburst==5)->Hlength==8;
                                                        (Hburst==6)->Hlength==16;
                                                        (Hburst==7)->Hlength==16;}
        constraint a{ Hadder dist {[32'H8000_0000:32'H8000_03FF]:/5,[32'H8400_0000:32'H8400_03FF]:/5,[32'H8800_0000:32'H8800_03FF]:/5,[32'H8C00_0000:32'H8C00_03FF]:/5};}

//      constraint a1{ Hsize dist { {2'b00}:/5,{2'b01}:/5,{2'b10}:/5};}
//      constraint a2{ Hwrite dist {{2'b00}:/5,{2'b01}:/5};}



function new(string name="src_xtn");
        super.new(name);
endfunction

function void  do_print(uvm_printer printer);
        super.do_print(printer);

        printer.print_field("Hadder",this.Hadder,"32",UVM_HEX);
        printer.print_field("Htrans",this.Htrans,"2",UVM_DEC);
        printer.print_field("Hwdata",this.Hwdata,"32",UVM_HEX);
        printer.print_field("Hwrite",this.Hwrite,"1",UVM_DEC);
        printer.print_field("Hsize",this.Hsize,"3",UVM_DEC);
        printer.print_field("Hburst",this.Hburst,"8",UVM_DEC);
        printer.print_field("Hlength",this.Hlength,"10",UVM_DEC);


endfunction
endclass
