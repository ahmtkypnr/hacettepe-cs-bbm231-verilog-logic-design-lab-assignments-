`timescale 1us / 1ps

module ARTAU(
    input radar_echo,
    input scan_for_target,
    input [31:0] jet_speed,
    input [31:0] max_safe_distance,
    input RST,
    input CLK,
    output reg radar_pulse_trigger,
    output reg [31:0] distance_to_target,
    output reg threat_detected,
    output reg [1:0] ARTAU_state
);

// Your code goes here.
integer listen_to_echo_timer;
integer pulse_count;
integer status_update_timer;
reg is_detected;
integer old_distance_to_target;
real velocity;
reg status_timer_trigger;

initial begin
    ARTAU_state <= 2'b00;
    radar_pulse_trigger <= 1'b0;
    threat_detected <= 1'b0;
    distance_to_target <= 0;
    old_distance_to_target <= 0;
    listen_to_echo_timer <= 0;
    status_update_timer <= 0;
    pulse_count <= 0;
    is_detected <= 1'b0;
    velocity <= 0;
    status_timer_trigger <= 1'b0;
end

always @(radar_echo) begin
    if (radar_echo == 1'b1) begin
        is_detected <= 1'b1;
        listen_to_echo_timer = $stime - listen_to_echo_timer;
        old_distance_to_target = distance_to_target;
        distance_to_target = 150 * listen_to_echo_timer;
        if (pulse_count < 2) begin
            radar_pulse_trigger <= 1'b1;
            #300;
            listen_to_echo_timer <= $stime;
            radar_pulse_trigger <= 1'b0;
        end
        else begin
            status_timer_trigger <= 1'b1;
            velocity = (distance_to_target + (jet_speed * listen_to_echo_timer / 1000000.0)) - old_distance_to_target;
            if (distance_to_target < max_safe_distance & velocity < 0) begin
                threat_detected <= 1'b1;
            end
        end
    end
end

always @(scan_for_target) begin
    if (scan_for_target == 1'b1 & radar_pulse_trigger == 1'b0) begin
        case (ARTAU_state)
            2'b00: begin
                radar_pulse_trigger <= 1'b1;
                #300;
                listen_to_echo_timer <= $stime;
                radar_pulse_trigger <= 1'b0;
            end
            2'b11: begin
                radar_pulse_trigger <= 1'b1;
                #300;
                listen_to_echo_timer <= $stime;
                radar_pulse_trigger <= 1'b0;
            end
        endcase
    end
end

always @(status_timer_trigger) begin
    if (status_timer_trigger == 1'b1) begin
        while (status_update_timer <= 3000 & scan_for_target == 1'b0) begin
            #1;
            status_update_timer++;
        end
        if (scan_for_target == 1'b0) begin
            radar_pulse_trigger <= 1'b0;
            threat_detected <= 1'b0;
            distance_to_target <= 0;
            old_distance_to_target <= 0;
            listen_to_echo_timer <= 0;
            velocity <= 0;
        end
    end
end

always @(radar_pulse_trigger) begin
    if (radar_pulse_trigger == 1'b0) begin
        while ($stime - listen_to_echo_timer <= 2000 & is_detected == 1'b0) begin
            #1;
        end
        if (is_detected == 1'b0) begin
            radar_pulse_trigger <= 1'b0;
            threat_detected <= 1'b0;
            distance_to_target <= 0;
            old_distance_to_target <= 0;
            status_timer_trigger <= 1'b0;
            velocity <= 0;
            status_update_timer <= 0;
        end
    end
end

always @(posedge CLK) begin
    if (RST == 1'b1) begin
        ARTAU_state <= 2'b00;
        radar_pulse_trigger <= 1'b0;
        threat_detected <= 1'b0;
        distance_to_target <= 0;
        old_distance_to_target <= 0;
        listen_to_echo_timer <= 0;
        status_update_timer <= 0;
        pulse_count <= 0;
        is_detected <= 1'b0;
        velocity <= 0;
        status_timer_trigger <= 1'b0;
    end
    else begin
        case (ARTAU_state)
            2'b00:
                if (radar_pulse_trigger == 1'b1) begin
                    ARTAU_state <= 2'b01;
                    pulse_count++;
                end
            2'b01:
                if (radar_pulse_trigger == 1'b0) begin
                    ARTAU_state <= 2'b10;
                end
            2'b10:
                if (is_detected == 1'b1 & pulse_count == 1) begin
                    ARTAU_state <= 2'b01;
                    is_detected <= 1'b0;
                    pulse_count++;
                end
                else begin
                    if (is_detected == 1'b1 & pulse_count == 2) begin
                        ARTAU_state <= 2'b11;
                        is_detected <= 1'b0;
                    end
                    else begin
                        if ($stime - listen_to_echo_timer >= 2000) begin
                            ARTAU_state <= 2'b00;
                            listen_to_echo_timer <= 0;
                            pulse_count <= 0;
                            is_detected <= 1'b0;
                        end
                    end
                end
            2'b11: begin
                pulse_count = 0;
                if (scan_for_target == 1'b1) begin
                    ARTAU_state <= 2'b01;
                    pulse_count++;
                    status_update_timer <= 0;
                    status_timer_trigger <= 1'b0;
                end
                else begin
                    if (status_update_timer >= 3000) begin
                        ARTAU_state <= 2'b00;
                        pulse_count <= 0;
                        is_detected <= 1'b0;
                        status_update_timer <= 0;
                        status_timer_trigger <= 1'b0;
                    end
                end
            end
        endcase
    end
end

endmodule