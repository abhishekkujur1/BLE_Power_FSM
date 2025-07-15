// BLE SoC Power Controller FSM
module power_fsm (
    input wire clk,
    input wire reset_n,
    input wire wakeup_event,
    input wire radio_request,
    input wire radio_idle,
    input wire cpu_idle,
    input wire timer_expired,
    input wire shutdown_cmd,
    output reg [1:0] power_state
);

// State encoding
localparam SHUTDOWN  = 2'b00;
localparam DEEPSLEEP = 2'b01;
localparam SLEEP     = 2'b10;
localparam ACTIVE    = 2'b11;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        power_state <= SHUTDOWN;
    end else begin
        case (power_state)
            SHUTDOWN:  if (wakeup_event) power_state <= DEEPSLEEP;
            
            DEEPSLEEP: if (shutdown_cmd) power_state <= SHUTDOWN;
                       else if (radio_request) power_state <= ACTIVE;
                       else if (timer_expired) power_state <= SLEEP;
            
            SLEEP:     if (timer_expired) power_state <= DEEPSLEEP;
                       else if (wakeup_event || radio_request) power_state <= ACTIVE;
            
            ACTIVE:    if (cpu_idle) power_state <= SLEEP;
                       else if (radio_idle) power_state <= DEEPSLEEP;
            
            default:   power_state <= SHUTDOWN;
        endcase
    end
end

endmodule