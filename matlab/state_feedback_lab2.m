function [ x1_m x2_m time ] = state_feedback_lab2(a, v_ref)
    writePWMVoltage(a, 'D6', 0);
    writePWMVoltage(a, 'D9', 0);
    
    
    % just find it 
    V_ref_max = 10/2;

    theta_ref = 2*pi*v_ref/V_ref_max;


    % rpm -> rad/s
    Ko = 2*pi/60;

    % Ki (theta -> volt before reduction by 1/3)
    % calculate by setting potentiometer to pi/2 rad and measuring voltage
    Ki = 12.5/(2*pi);
    Ku = 1/36;
    Km = 297.5;
    Kt = 0.0029;

    % calculating manually TODO
    V_7805 = 2*readVoltage(a, 'A3');

    % x1 = theta (rad)
    % x2 = w (rad/s)
    x1_m = [];
    x2_m = [];
    time = [];

    kx1 = 1;
    kx2 = 0.2;
    gain = 10;
    
    iter = 0;
    tic
    while(iter < 60)
        iter = iter+1;
        
        x1 = readVoltage(a, 'A5')*3*(1/Ki)
        x2 = 2*(2*readVoltage(a, 'A3') - V_7805)*(1/Kt)*Ko*Ku
       
        x1_m(end+1) = x1;
        x2_m(end+1) = x2;
        time(end+1) = toc;

        u = kx1*(theta_ref - x1) - kx2*x2
        u = u*gain;
        
        error = abs(u);
        
        if u>0
            writePWMVoltage(a,'D6',0);
            motor_command=min(u , 5);
            if(motor_command<0.7)
                    motor_command = 0.7;
            end
            writePWMVoltage(a,'D9',motor_command);
        else
            writePWMVoltage(a,'D9',0);
            motor_command=min(-u , 5);
            if(motor_command<0.7)
                motor_command=0.7;
            end
            writePWMVoltage(a,'D6',motor_command); 
        end
    end
    writePWMVoltage(a, 'D6', 0);
    writePWMVoltage(a, 'D9', 0);

end
