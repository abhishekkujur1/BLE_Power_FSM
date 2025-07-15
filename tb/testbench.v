`timescale 1ns/1ps

module testbench;

// Clock generation
reg clk;
always #5 clk = ~clk;  // 100MHz clock

// DUT signals
reg reset_n;
reg wakeup_event;
reg radio_request;
reg radio_idle;
reg cpu_idle;
reg timer_expired;
reg shutdown_cmd;
wire [1:0] power_state;

// Instantiate DUT
power_fsm dut (
    .clk(clk),
    .reset_n(reset_n),
    .wakeup_event(wakeup_event),
    .radio_request(radio_request),
    .radio_idle(radio_idle),
    .cpu_idle(cpu_idle),
    .timer_expired(timer_expired),
    .shutdown_cmd(shutdown_cmd),
    .power_state(power_state)
);

// State names for display
reg [79:0] state_name;
always @(*) begin
    case(power_state)
        2'b00: state_name = "SHUTDOWN";
        2'b01: state_name = "DEEPSLEEP"; 
        2'b10: state_name = "SLEEP";
        2'b11: state_name = "ACTIVE";
        default: state_name = "UNKNOWN";
    endcase
end

initial begin
    // Initialize signals
    clk = 0;
    reset_n = 0;
    wakeup_event = 0;
    radio_request = 0;
    radio_idle = 0;
    cpu_idle = 0;
    timer_expired = 0;
    shutdown_cmd = 0;
    
    // Create waveform file
    $dumpfile("waves.vcd");
    $dumpvars(0, testbench);
    
    // Reset sequence
    #10 reset_n = 1;
    $display("[%0t] Reset released", $time);
    
    // Test sequence
    #10 wakeup_event = 1;
    #10 wakeup_event = 0;
    
    #20 radio_request = 1;
    #10 radio_request = 0;
    
    #30 radio_idle = 1;
    #10 radio_idle = 0;
    
    #100 $finish;
end

// Monitor
always @(posedge clk) begin
    $display("[%0t] State: %-8s | Events: WAKE=%b RAD_REQ=%b",
        $time, state_name, wakeup_event, radio_request);
end

endmodule