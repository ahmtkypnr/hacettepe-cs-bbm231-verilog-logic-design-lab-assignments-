`timescale 1us / 1ps

module ECSU(
    input CLK,
    input RST,
    input thunderstorm,
    input [5:0] wind,
    input [1:0] visibility,
    input signed [7:0] temperature,
    output reg severe_weather,
    output reg emergency_landing_alert,
    output reg [1:0] ECSU_state
);

// Your code goes here.
initial begin
    ECSU_state <= 2'b00;
    severe_weather <= 1'b0;
    emergency_landing_alert <= 1'b0;
end

always @* begin
    case (ECSU_state)
        2'b00:
            if (thunderstorm == 1'b1 | wind > 15 | temperature > 35 | temperature < -35 | visibility == 2'b11) begin
                severe_weather <= 1'b1;
            end
        2'b01:
            if (thunderstorm == 1'b1 | wind > 15 | temperature > 35 | temperature < -35 | visibility == 2'b11) begin
                severe_weather <= 1'b1;
            end
        2'b10:
            if (temperature < -40 | temperature > 40 | wind > 20) begin
                emergency_landing_alert <= 1'b1;
            end
            else begin
                if (thunderstorm == 1'b0 & wind <= 10 & temperature <= 35 & temperature >= -35 & visibility == 2'b01) begin
                    severe_weather <= 1'b0;
                end
            end
    endcase
end

always @(posedge CLK) begin
    if (RST == 1'b1) begin
        ECSU_state <= 2'b00;
        severe_weather <= 1'b0;
        emergency_landing_alert <= 1'b0;
    end
    else begin
        case (ECSU_state)
        2'b00:  if ((wind <= 15 & wind > 10) | visibility == 2'b01) begin
                    ECSU_state <= 2'b01;
                end
                else begin
                    if (thunderstorm == 1'b1 | wind > 15 | temperature > 35 | temperature < -35 | visibility == 2'b11) begin
                        ECSU_state <= 2'b10;
                    end
                end
        2'b01:  if (wind <= 10 & visibility == 2'b00) begin
                    ECSU_state <= 2'b00;
                end
                else begin
                    if (thunderstorm == 1'b1 | wind > 15 | temperature > 35 | temperature < -35 | visibility == 2'b11) begin
                        ECSU_state <= 2'b10;
                    end
                end
        2'b10:  if (temperature < -40 | temperature > 40 | wind > 20) begin
                    ECSU_state <= 2'b11;
                end
                else begin
                    if (thunderstorm == 1'b0 & wind <= 10 & temperature <= 35 & temperature >= -35 & visibility == 2'b01) begin
                        ECSU_state <= 2'b01;
                    end
                end
        //2'b11: 
        //default:
        endcase
    end
end

endmodule