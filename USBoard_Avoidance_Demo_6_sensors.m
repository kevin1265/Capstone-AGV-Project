%fclose(usboard);
usboard = serial('COM10'); %establishing object identifier
set(usboard, 'BaudRate', 19200, 'InputBufferSize', 22); %setting baudrate and size to read
fopen(usboard); %opening communication with USBoard
[sdata, count, msg] = fread(usboard); %stores one sensor data, returns number of values to count, displays warning message if read unsuccessful


sensor1 = sdata(4); %car's right side
sensor2 = sdata(5); %car's left side
sensor3 = sdata(6); %front of car
sensor4 = sdata(7); %mid right of car
sensor5 = sdata(15); %mid left of ar
sesnor6 = sdata(16); %back of car
a = arduino('com5', 'uno');

if (usboard.status == 'open')
    
     while (true)
         [sdata, count, msg] = fread(usboard); %stores one sensor data, returns number of values to count, displays warning message if read unsuccessful
        
         if (not((sdata(2) == 2) && (sdata(3) == 0)))
            continue
         else
            sensor1 = sdata(4);
            sensor2 = sdata(5);
            sensor3 = sdata(6);
            sensor4 = sdata(7);
            
            sensor5 = sdata(15);
            sensor6 = sdata(16);
%             writeDigitalPin(a, 'D11', 0); %turn left led
%             writeDigitalPin(a, 'D09', 0); %turn right led
%             writeDigitalPin(a, 'D13', 0); %brakes led
%             writeDigitalPin(a, 'D07', 0); %accelerator led
         end
         
         %sensor 3 (front of car) 
         if ((sensor3 <= 100) || ((sensor1 <= 100) && (sensor2 <= 100)))
            disp('Braking')
            writeDigitalPin(a, 'D13', 1); %car brakes
            writeDigitalPin(a, 'D07', 0); %car stops accelerating
            writeDigitalPin(a, 'D11', 0); %turn left led
            writeDigitalPin(a, 'D09', 0); %turn right led
        
         %sensor 1 (car's front right side)     
         elseif (sensor1 <= 50)      
            disp('Danger!')
            writeDigitalPin(a, 'D11', 1); %car turns left
            writeDigitalPin(a, 'D13', 1); %car brakes
            writeDigitalPin(a, 'D07', 0); %car stops accelerating
            writeDigitalPin(a, 'D09', 0); %turn right led
         
         elseif (sensor1 <= 100)
            disp('Warning!')
            writeDigitalPin(a, 'D11', 1); %car turns left
            writeDigitalPin(a, 'D07', 0); %accelerator led
            writeDigitalPin(a, 'D13', 0); %brakes led
            writeDigitalPin(a, 'D09', 0); %turn right led
        
         %sensor 2 (car's front left side)
         elseif (sensor2 <= 50)      
            disp('Danger!')
            writeDigitalPin(a, 'D09', 1); %car turns right
            writeDigitalPin(a, 'D13', 1); %car brakes
            writeDigitalPin(a, 'D07', 0); %car stops accelerating
            writeDigitalPin(a, 'D11', 0); %turn left led
         
         elseif (sensor2 <= 100)
            disp('Warning!')
            writeDigitalPin(a, 'D09', 1); %car turns right
            writeDigitalPin(a, 'D07', 0); %accelerator led
            writeDigitalPin(a, 'D13', 0); %brakes led
            writeDigitalPin(a, 'D11', 0); %turn left led 
            
         %sensor 4 (car's mid right side)     
         elseif (sensor4 <= 100)
            disp('Warning!')
            writeDigitalPin(a, 'D11', 1); %car turns left
            writeDigitalPin(a, 'D07', 1); %accelerator led
            writeDigitalPin(a, 'D13', 0); %brakes led
            writeDigitalPin(a, 'D09', 0); %turn right led
          
         %sensor 5 (car's mid left side)   
         elseif (sensor5 <= 100)
            disp('Warning!')
            writeDigitalPin(a, 'D09', 1); %car turns right
            writeDigitalPin(a, 'D07', 1); %accelerator led
            writeDigitalPin(a, 'D13', 0); %brakes led
            writeDigitalPin(a, 'D11', 0); %turn left led
            
         %sensor 6 (back of car)   
         elseif (sensor6 <= 100)
            disp('Warning!')
            writeDigitalPin(a, 'D09', 0); %turn right led           
            writeDigitalPin(a, 'D13', 0); %brakes led
            writeDigitalPin(a, 'D11', 0); %turn left led
            writeDigitalPin(a, 'D07', 1); %car accelerates away from obstacle
            pause(0.2);
            writeDigitalPin(a, 'D07', 0); %flashing green light simulates acceleration
            pause(0.2);
            writeDigitalPin(a, 'D07', 1); %flashing green light simulates acceleration
         
         %accelerate if no obstacles
         elseif (not((sensor1 < 100 ) || (sensor2 < 100) || (sensor3 < 75)))
            writeDigitalPin(a, 'D07', 1); %accelerator led
            writeDigitalPin(a, 'D13', 0); %brakes led
            writeDigitalPin(a, 'D11', 0); %turn left led
            writeDigitalPin(a, 'D09', 0); %turn right led
        end
        
        sdata
        end
    end
    





fclose(usboard); %closes communication with USBoard