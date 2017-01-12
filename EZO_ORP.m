%% Copyright 2016 Atlas Scientific LLC.

classdef EZO_ORP < EzoBase
    
    methods
        function obj = EZO_ORP(serialPort)
            obj@EzoBase(serialPort);
        end
        
        function orp = read(obj)
            orp = 0; %in case nothing gets assigned
            
            flushinput(obj.serialObject)
            fprintf(obj.serialObject,'r%c', 13);
            pause(1.300);
            data = fgetl(obj.serialObject);
            while(data(1) ~= '*') % stop reading when we get *OK or *ER
                %disp(data);
                orp = sscanf(data,'%f');
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
        
    end
end