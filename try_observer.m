function [ x1_est_m x2_est_m ] = try_observer(x1_real_m, x2_real_m, time, v_in)

    MIN_VOLTAGE = 0.8;

    % measured as such
    V_7805 = 5.366;
    % Not using legacy
    V_ref_arduino = 1.03;

    
    % reset the motor
    %writePWMVoltage(a, 'D6', 0);
    %writePWMVoltage(a, 'D9', 0);

    % wait for stuff to settle down
    %pause;
    
    Ku = 1/36;
    Km = 259;
    Kt = 0.0043;
    Tm = 0.54;
    Ko = 0.25;
    
    x1_est = x1_real_m(1);
    x2_est = 0;
    
    x1_est_m = [];
    x2_est_m = [];

    % to record x1_est, x2_est values

    l1 = 82;
    l2 = 1000;

    iter = 0;
    tic;
    while(iter < size(time)(2))
        iter = iter+1;
        
        x1 = x1_real_m(iter);
        %x2 = x2_real_m(iter);
        
        % x1 = theta_out (volt)
        % x2 = V_tacho (volt)

        dt = 0;
        if(iter == 1)
            dt = time(iter);
        else
            dt = time(iter) - time(iter-1);
        end
        dt
        
        u = v_in;
        
        x1_est_new = x1_est + dt*(l1*(x1-x1_est) + (Ku*Ko/Kt)*x2_est);
        x2_est_new = x2_est + dt*(l2*(x1-x1_est) + (Km*Kt/Tm)*u - (1/Tm)*x2_est);
        
        x1_est = x1_est_new;
        x2_est = x2_est_new;
        
        x1_est_m(end+1) = x1_est;
        x2_est_m(end+1) = x2_est;
        
        % record stuff

%{
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
%} 
  end
  
  % scale overly large samples for plotting
  i = 1;
  while(i <= size(time)(2))
    x1_est_m(i) = max(min(x1_est_m(i), 100), -100);
    x2_est_m(i) = max(min(x2_est_m(i), 100), -100);
    i = i + 1;
  end
 
  clf;
  subplot(2, 1, 1);
  plot(time, x1_est_m);
  hold on;
  plot(time, x1_real_m);

  subplot(2, 1, 2);
  plot(time, x2_est_m);
  hold on;
  plot(time, x2_real_m);

end
