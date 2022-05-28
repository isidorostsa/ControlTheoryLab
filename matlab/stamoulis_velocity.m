function [ x1 ] = Set_Velocity_2018(vel )

delete(instrfind({'Port'},{'COM16'}))

Vref_arduino=5;
a=arduino('COM16');

analogWrite(a,9,0);
analogWrite(a,6,0);

%writePWMVoltage(a, 'D9',0);
%writePWMVoltage(a, 'D6',0);

% WAIT A KEY TO PROCEED
disp(['Connect cable from Arduino to Input Power Amplifier and then press enter to start controller']);
pause()

 while(1)
 
analogWrite(a,9,vel);
analogWrite(a,6,0);

%writePWMVoltage(a, 'D9',vel);
%writePWMVoltage(a, 'D6',0);

% WAIT A KEY TO PROCEED
disp(['Press enter to change direction']);
pause()

analogWrite(a,9,0);
analogWrite(a,6,vel);
 
%writePWMVoltage(a, 'D9',0);
%writePWMVoltage(a, 'D6',vel);

% WAIT A KEY TO PROCEED
disp(['Press enter to change direction']);
pause()

end
end
