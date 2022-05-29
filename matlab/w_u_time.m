function [w u time] = vtacho_u_time(a, u_value)

    w = [];
    u = [];
    time = [];

    time_start = tic;

    writePWMVoltage(a, 'D6', u_value)




end