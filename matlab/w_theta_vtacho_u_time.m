function [w theta v_tacho u time] = vtacho_u_time(a, u_value)

    writePWMVoltage(a, 'D6', 0);
    writePWMVoltage(a, 'D6', 0);

    % rpm -> rad/s
    Ko = 2*pi/60;

    % 
    Ki = 12.5/(2*pi);

    % calculating manually TODO
    V_7805 = 2*readVoltage(a, 'A3');

    w = [];
    theta = [];
    v_tacho = [];
    u = [];
    time = [];

    writePWMVoltage(a, 'D6', u_value)
    
    tic;
    while(iter < 100)
        iter = iter+1;

        theta_curr = 3 * readVoltage(a, 'A5') / Ki;
        v_tacho_curr = 2*(2*readVoltage, 'A3') - V_7805);
        w_curr = 

        time(end+1) = toc;
    end

end