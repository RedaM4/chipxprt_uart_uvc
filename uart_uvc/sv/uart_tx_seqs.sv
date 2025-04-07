class uart_tx_seqs extends uvm_sequence #(uart_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(uart_tx_seqs)

  // Constructor
  function new(string name="uart_tx_seqs");
    super.new(name);
     `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : uart_tx_seqs


class uart_1_seq extends uart_tx_seqs;
    `uvm_object_utils(uart_1_seq)
    // Constructor
    function new(string name = "uart_1_seq");
        super.new(name);
    endfunction

    // Body task
    
    //sequence
    task body();
        `uvm_info(get_type_name(), "Executing uart_1_seq sequence", UVM_LOW)
        for (bit [7:0] i =0 ;i<8 ;i++ ) begin
      `uvm_do_with(req, { req.data == i; });
          
        end 
        // `uvm_do_with(req, { req.data == 8'b00000001; });
        // `uvm_do_with(req, { req.data == 8'b11110000; });
        // `uvm_do_with(req, { req.data == 8'b00011011; });
        // `uvm_do_with(req, { req.data == 8'b00000000; });
        // `uvm_do_with(req, { req.data == 8'b01111100; });
        // `uvm_do_with(req, { req.data == 8'b01111101; });
        // `uvm_do_with(req, { req.data == 8'b00101100; });
        // `uvm_do_with(req, { req.data == 8'b00001100; });

        // #2360;
       #5000;
    endtask
endclass
