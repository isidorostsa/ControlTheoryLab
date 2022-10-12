function [ x1_m x2_m theta_ref_m time ] = state_feedback_lab2_osc(a, w)

    MIN_VOLTAGE = 0.8;

    % measured as such
    V_7805 = 5.366;
    % Not using legacy
    V_ref_arduino = 1.0;

    %reset the motor
    writePWMVoltage(a, 'D6', 0);
    writePWMVoltage(a, 'D9', 0);
    
    % wait for stuff to settle down
    pause;
    
    Ku = 1/36;
    Km = 259;
    Kt = 0.0043;
    Tm = 0.54;
    Ko = 0.25;

    % record x1, x2 values
    x1_m = [];
    x2_m = [];
    time = [];
    theta_ref_m = [];

    k2 = 1.3;
    k1 = (Km*Kt*k2+1)^2/(4*Tm*Km*Ku*Ko);
    kr = k1;
    
    iter = 0;
    tic;
    while(iter < 120)
        iter = iter+1;
        
        % x1 = theta_out (volt)
        % x2 = V_tacho (volt)

        x1 = readVoltage(a, 'A5')*V_ref_arduino*3;
        x2 = 2*(2*V_ref_arduino*readVoltage(a, 'A3') - V_7805);
       
        % record stuff
        x1_m(end+1) = x1;
        x2_m(end+1) = x2;
        time(end+1) = toc;

        theta_ref = 5 + 2*sin(w * time(end));
        theta_ref_m(end+1) = theta_ref;

        % linear feedback
        u = kr*theta_ref - k1*x1 - k2*x2;

        u = u*gain;
        u = u/2;

        % adjust to the voltage transformations
        motor_command = u/2;

        if motor_command>0
            writePWMVoltage(a,'D6',0);

            % do not go over 5 volts
            motor_command=min(motor_command, 5);

            % nor under the MIN_VOLTAGE 
            motor_command=max(motor_command, MIN_VOLTAGE)

            writePWMVoltage(a, 'D9', motor_command);

        else
            writePWMVoltage(a, 'D9', 0);

            motor_command = -motor_command;
            
            % do not go over 5 volts
            motor_command=min(motor_command, 5)

            % nor under the MIN_VOLTAGE 
            motor_command=max(motor_command, MIN_VOLTAGE)
            
            writePWMVoltage(a,'D6',motor_command); 
        end

    end

    % end the experiment by reseting everything

    writePWMVoltage(a, 'D6', 0);
    writePWMVoltage(a, 'D9', 0);
end