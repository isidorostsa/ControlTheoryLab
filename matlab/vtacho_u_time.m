function [vtacho u time] vtacho_u_time (a, u_value)
    writePWMVoltage(a, 'D9', 0); 
    writePWMVoltage(a, 'D6', 0); 

    disp(['Connect cable from Arduino to Input Power Amplifier and then press enter to start controller']);

    % u_value must E[0, 5]


    time = [];
    time(1) = 0;

    v_tacho = [];
    u = [];

    writePWMVoltage(a, 'D9', u_value)
    time_start = tic;

    % maybe use while(time(end) < someTimeframe)

    iter = 0;
    while(iter < 100)
        iter = iter+1 


        vtacho_reading = readVoltage(a, 'A3')

        vtacho(end+1) = vtacho_reading
        u(end+1) = u_value
        time(end+1) = toc;
    end

    % max(vtacho)/u_value = km*kt
    % i think: plot(vtacho, time) works well

    writePWMVoltage(a, 'D9', 0);
    writePWMVoltage(a, 'D6', 0); 
end