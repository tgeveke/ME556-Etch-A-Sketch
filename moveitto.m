% This function will travel to the commanded x,y position put in.

function [] = moveitto(gox, goy)
    % Bring global variables into function
    global time;
    global arduino_object;
    global currentx currenty;
    global currentdirx currentdiry;
    global backlashx backlashy;
    global stepX dirX stepY dirY enPin;
    
    % Determine screen distance to move (does not factor in backlash) in x and y directions
    disx = gox-currentx;
    disy = goy-currenty;
    
    % Mark direction of new movement
    % This is needed for backlash consideration
    if disx <= 0
        directionx = 0;
    else
        directionx = 1;
    end
    
    if disy <= 0
        directiony = 0;
    else
        directiony = 1;
    end

    %did direction change in the x? and was there was movement in the x?  if yes backlash needs
    %is added or subtracted in
    if directionx ~= currentdirx && disx ~= 0
        
        if directionx == 0 % Directionx change and is now negative
             disx = disx - backlashx; % Backlash must be subtracted
        end
        
        if directionx == 1 %directionx change and is now positive
             disx = disx + backlashx; % Backlash must be added
        end   
        
        currentdirx = directionx; % For next time function is called currentdirx is set
        
    end
    
    % Did direction change in the y? and was there was movement in the y?  if yes backlash needs to be added or subtracted in
    if directiony ~= currentdiry && disy ~= 0
        if directiony == 0 %directiony change and is now negative
             disy = disy - backlashy; %backlash must be subtracted
        end
        
        if directiony == 1 % Directiony change and is now positive
             disy = disy + backlashy; % Backlash must be added
        end   
       
         currentdiry = directiony; %for next time function is called currentdiry is set
        
    end
    
    
    % Position input to step commands are positive when read into arduino
    disx = abs(disx);
    disy = abs(disy);
    
    
    if disx > disy   % Deterime which one is large movement
        ratio = disx / disy;  % Deterime ratio greater than or equal to 1
        largesize = disx;  % Major movement set
        bigdir = dirY;     % Pins determined to control major and minor movement
        smalldir = dirX;   
        bigstep = stepY;    
        smallstep = stepX;
        bigdirectionvalue = directionx;  %direction set
        smalldirectionvalue = directiony;
    else
        ratio = disy / disx; %deterime ratio greater than or equal to 1
        largesize = disy;  %major movement set
        bigdir = dirX;   %pins determined to control major and minor movement
        smalldir = dirY;
        bigstep = stepX;
        smallstep = stepY;
        bigdirectionvalue = directiony;   %direction set
        smalldirectionvalue = directionx;
    end  
        
    count = 1;  
    
    if (disx + disy) > 0   %if both are 0 then no movement occurs, This can accidently happen when applying rounding.
    
    writeDigitalPin(arduino_object, bigdir, bigdirectionvalue); % Writes direction
    writeDigitalPin(arduino_object, smalldir, smalldirectionvalue); % Writes direction
    
    
    for i = 1:largesize
        
        writeDigitalPin(arduino_object, bigstep, 1); % Each loop writes one major steps;
           
         if i == round(ratio * count) && ratio ~= 1/0   %if it is due, a minor step is written,  ratio~=1/0 means minor step is never written if minor step=0
            writeDigitalPin(arduino_object, smallstep, 1);
         end
        
        %pause(time/1000);
        writeDigitalPin(arduino_object, bigstep, 0);
        
        if i == round(ratio * count) && ratio ~= 1/0   %if it is due a minor step is written
        writeDigitalPin(arduino_object, smallstep,0); 
        count = count + 1; %sets number of counts from small movement, used to determine if minor step is due
        end
            
            
    end
    end
    currentx = gox;
    currenty = goy;

end
    