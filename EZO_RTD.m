%% Copyright 2016 Atlas Scientific LLC.

classdef EZO_RTD < EzoBase
    
    methods
        function obj = EZO_RTD(serialPort)
            obj@EzoBase(serialPort);
        end
        
        function temp = read(obj)
            temp = 0; %in case nothing gets assigned
            
            flushinput(obj.serialObject)
            fprintf(obj.serialObject,'r%c', 13);
            pause(1.300);
            data = fgetl(obj.serialObject);
            while(data(1) ~= '*') % stop reading when we get *OK or *ER
                %disp(data);
                temp = sscanf(data,'%f');
                data = fgetl(obj.serialObject);
            end
        end
        
        function cal = getCal(obj)
            cal = getAnswer(obj, 'cal,?');
            cal = convertQuery(obj, cal);
            switch cal
                case 0
                    cal = 'Uncalibrated';
                case 1
                    cal = 'Single Point';
            end
        end
        
        function calClear(obj)
            writeCommand(obj, 'cal,clear', 0.6);
        end
        
        function cal(obj, calValue)
            writeCommand(obj, strcat('cal,', num2str(calValue)), 2.0);
        end
        
        function setCelsius(obj)
            writeCommand(obj, 'S,C', 0.6);
        end
        
        function setFehrenheit(obj)
            writeCommand(obj, 'S,F', 0.6);
        end
        
        function setKelvin(obj)
            writeCommand(obj, 'S,K', 0.6);
        end
        
    end
end