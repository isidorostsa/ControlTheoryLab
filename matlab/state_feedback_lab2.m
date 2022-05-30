function [ x1_m x2_m time ] = state_feedback(a, v_ref)
    writePWMVoltage(a, 'D6', 0);
    writePWMVoltage(a, 'D9', 0);
    
    % just find it 
    V_ref_max = 5.0;

    theta_ref = 2*pi*v_ref/V_ref_max


    % rpm -> rad/s
    Ko = 2*pi/60;

    % Ki (theta -> volt before reduction by 1/3)
    % calculate by setting potentiometer to pi/2 rad and measuring voltage
    Ki = 12.5/(2*pi);

    % calculating manually TODO
    V_7805 = 2*readVoltage(a, 'A3');

    % x1 = theta (rad)
    % x2 = w (rad/s)
    x1_m = [];
    x2_m = [];
    time = [];

    iter = 0;
    tic
    while(iter < 100)
        x1 = readVoltage(a, 'A5')*3*(1/Ki);
        x2 = 2(2*readVoltage(a, 'A3') - V_7805)*(1/Kt)*Ko;

        u = ()
    end


end
