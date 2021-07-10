interface dummy_if;
    logic [31:0] signal;
endinterface

module dummy;
  reg [31:0]sig0;
  reg [31:0]sig1;
  reg [31:0]sig2;

  initial begin
      sig0 = $urandom();
      sig1 = $urandom();
      sig2 = $urandom();
      $display("%m: sig0 = %0x, sig1 = %0x, sig2 = %0x", sig0, sig1, sig2);
  end
endmodule


module top;
    //define interface
    dummy_if ifs[6]();

    //instantiate dut.
    dummy u_inst_0();
    dummy u_inst_1();
    dummy u_inst_2();

    //trial1
    //for(genvar i = 0; i < 3; i++) begin
    //    assign ifs[i] = top.u_inst_i.sig1;
    //    assign ifs[i+3] = top.u_inst_i.sig2;
    //end

    //trial2
    //for(genvar i = 0; i < 3; i++) begin
    //    assign ifs[i] = top.u_inst_``i``.sig1;
    //    assign ifs[i+3] = top.u_inst_``i``.sig2;
    //end
    
    //trial3
    //for(genvar i = 0; i < 3; i++) begin
    //    assign ifs[i] = $sformatf("top.u_inst_%0d.sig1", i);
    //    assign ifs[i+3] = $sformatf("top.u_inst_%0d.sig2", i);
    //end

    
    //trial4
    `define ASSIGN_SIGAL(if_idx, inst_idx) \
            assign ifs[if_idx].signal = top.u_inst_``inst_idx``.sig1; \
            assign ifs[if_idx + 3].signal = top.u_inst_``inst_idx``.sig2;

    //trial 4.1
    //for(genvar i = 0 ; i < 3; i++) begin
    //    `ASSIGN_SIGAL(i, i)
    //end

    `ASSIGN_SIGAL(0, 0)
    `ASSIGN_SIGAL(1, 1)
    `ASSIGN_SIGAL(2, 2)

  
  //end

  initial begin
      #100;
      assert(ifs[0].signal == top.u_inst_0.sig1);
      assert(ifs[1].signal == top.u_inst_1.sig1);
      assert(ifs[2].signal == top.u_inst_2.sig1);

      assert(ifs[3].signal == top.u_inst_0.sig2);
      assert(ifs[4].signal == top.u_inst_1.sig2);
      assert(ifs[5].signal == top.u_inst_2.sig2);


      $finish(0);
  end
endmodule
 
