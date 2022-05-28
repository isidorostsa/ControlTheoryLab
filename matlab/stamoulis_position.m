function [ x1 ] = Legacy_Pos_Control(setpos )


delete(instrfind({'Port'},{'COM16'}));

a=arduino('COM16');



analogWrite(a,9,0);   % Σταματάμε τον κινητήρα.
analogWrite(a,6,0);

% WAIT A KEY TO PROCEED
disp(['Connect cable from Arduino to Input Power Amplifier and then press enter to start controller']);
pause()
 



	position=analogRead(a,5); % Διαβάζουμε τις αρχικές τιμές. Δηλαδή την κατάσταση που βρίσκεται το σύστημα στη εκκίνηση.

	u= setpos-position;

	error=abs(u);
	
while (error)

	
	if u>0
		analogWrite(a,9,0);
		
		motor_command=min(u , 255);		% Επειδή η εντολή που δέχεται το Arduino δεν μπορεί να είναι μεγαλύτερη του 255
										% αλλά το u μπορεί να προκύψει μεγαλύτερο του 255 , τότε στέλνουμε το 255.

		if(motor_command<45)			% Σε μικρές τιμές της τάσης δεν γυρίζει ο κινητήρας. Για αυτό επιλέγεται σαν ελάχιστη τιμή η τιμή με την οποία  μπορει να κινηθεί ο κινητήρας.
			
                motor_command = 45
		end
		
		
		analogWrite(a,6,motor_command);
		

	 else
		analogWrite(a,6,0);

		
		motor_command=min(-u , 255);
		
		if(motor_command<45)
			
			motor_command=45;
		end
		
		
		analogWrite(a,9,motor_command); 
   
	end
 
	position=analogRead(a,5);

	u= setpos-position

	error=abs(u);
 
 end
 

analogWrite(a,9,0);		% Σταματάμε τον κινητήρα.
analogWrite(a,6,0);

  disp(['End of control Loop.']);
  pause();


end