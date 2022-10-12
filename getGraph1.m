function [ x1_m x2_m time ] = getGraph1(a, motor_command)

    % measured as such
    V_7805 = 5.366;
    % Not using legacy
    V_ref_arduino = 1.0;

    %reset the motor
    writePWMVoltage(a, 'D6', 0);
    writePWMVoltage(a, 'D9', 0);
    
    Ku = 1/36;
    Km = 259;
    Kt = 0.0043;
    Tm = 0.54;
    Ko = 0.25;

    % record x1, x2 values
    x1_m = [];
    x2_m = [];
    time = [];

    iter = 0;
    tic
    while(iter < 120)
        iter = iter + 1
        % the first 
        if(size(time) == 0) 
            writePWMVoltage(a,'D6',motor_command); 
        end
        
        % x1 = theta_out (volt)
        % x2 = V_tacho (volt)

        x1 = readVoltage(a, 'A5')*V_ref_arduino*3;
        x2 = 2*(2*V_ref_arduino*readVoltage(a, 'A3') - V_7805)
       
        % record stuff
        x1_m(end+1) = x1;
        x2_m(end+1) = x2;
        time(end+1) = toc;
    end

    % end the experiment by reseting everything

    writePWMVoltage(a, 'D6', 0);
    writePWMVoltage(a, 'D9', 0);

end
