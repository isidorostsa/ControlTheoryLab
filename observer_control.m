function [ x1_est_m x2_est_m x1_m x2_m time ] = observer_control(a, theta_ref)

    MIN_VOLTAGE = 0.8;
    MAX_ITER = 150;

    % measured as such
    V_7805 = 5.366;
    % Not using legacy
    V_ref_arduino = 1.03;

    % reset the motor
    writePWMVoltage(a, 'D6', 0);
    writePWMVoltage(a, 'D9', 0);

    % wait for stuff to settle down
    pause;
    
    Ku = 1/36;
    Km = 259;
    Kt = 0.0043;
    Tm = 0.54;
    Ko = 0.25;
    
    time = [];
    
    # record the real x1, x2
    x1_m = [];
    x2_m = [];
    
    % initial conditions
    x1_est = readVoltage(a, 'A5')*V_ref_arduino*3;
    x2_est = 0;
    
    % record the estimations
    x1_est_m = [];
    x2_est_m = [];

    % observer gains
    l1 = 82;
    l2 = 1000;
    
    % controller gains (same as lab2) 
    k2 = 1.3;
    k1 = (Km*Kt*k2+1)^2/(4*Tm*Km*Ku*Ko);
    kr = k1;

    iter = 0;
    tic;
    while(iter < MAX_ITER)
        iter = iter+1;
        
        x1 = readVoltage(a, 'A5')*V_ref_arduino*3;
        x2 = 2*(2*V_ref_arduino*readVoltage(a, 'A3') - V_7805);
        
        x1_m(end+1) = x1;
        x2_m(end+1) = x2;
        
        time(end+1) = toc;
        
        dt = 0;
        if(iter == 1)
            dt = time(iter);
        else
            dt = time(iter) - time(iter-1);
        end
        dt
        
        % calculate u based on the observer
        u = kr*theta_ref - k1*x1_est - k2*x2_est;
        
        x1_est_new = x1_est + dt*(l1*(x1-x1_est) + (Ku*Ko/Kt)*x2_est);
        x2_est_new = x2_est + dt*(l2*(x1-x1_est) + (Km*Kt/Tm)*u - (1/Tm)*x2_est);
        
        % update values in parallel
        x1_est = x1_est_new;
        x2_est = x2_est_new;
        
        x1_est_m(end+1) = x1_est;
        x2_est_m(end+1) = x2_est;
        
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
  
    % scale overly large samples for plotting
    i = 1;
    while(i <= MAX_ITER)
      x1_est_m(i) = max(min(x1_est_m(i), 100), -100);
      x2_est_m(i) = max(min(x2_est_m(i), 100), -100);
      i = i + 1;
    end
   
    clf;
    subplot(2, 1, 1);
    plot(time, ones(1, MAX_ITER)*theta_ref);
    hold on;
    plot(time, x1_m);
    hold on;
    plot(time, x1_est_m);

    subplot(2, 1, 2);
    plot(time, x2_est_m);
    hold on;
    plot(time, x2_m);

end
