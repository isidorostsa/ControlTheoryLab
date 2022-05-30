function [w theta v_tacho u time] = vtacho_u_time(a, u_value)

    writePWMVoltage(a, 'D6', 0);
    writePWMVoltage(a, 'D9', 0);

    % rpm -> rad/s
    Ko = 2*pi/60;

    % Ki (theta -> volt before reduction by 1/3)
    % calculate by setting potentiometer to pi/2 rad and measuring voltage
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

        % in rads
        theta_curr = 3*readVoltage(a, 'A5')/Ki;

        % volts
        v_tacho_curr = 2*(2*readVoltage(a, 'A3') - V_7805);

        % w_curr in rpm 
        w_curr = v_tacho_curr*(1/Kt) 

        % now in rad/s
        w_curr = w_curr*Ko

        theta(end+1) = theta_curr;
        v_tacho(end+1) = v_tacho_curr;
        w(end+1) = w_curr;
        u(end+1) = u_value;

        time(end+1) = toc;

        % in steady state we can measure d(theta)/dt (through A3) to calculate w_out and then Km.  
    end

    writePWMVoltage(a, 'D6', 0);
    writePWMVoltage(a, 'D9', 0);

end