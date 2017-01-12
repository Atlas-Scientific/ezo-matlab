%% Copyright 2016 Atlas Scientific LLC.

classdef EZO_PH < EzoBase
    
    methods
        function obj = EZO_PH(serialPort)
            obj@EzoBase(serialPort);
        end
        
        function ph = read(obj)
            ph = 0; %in case nothing gets assigned
            
            flushinput(obj.serialObject)
            fprintf(obj.serialObject,'r%c', 13);
            pause(1.300);
            data = fgetl(obj.serialObject);
            while(data(1) ~= '*') % stop reading when we get *OK or *ER
                %disp(data);
                ph = sscanf(data,'%f');
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
                case 2
                    cal = 'Two Points';
                case 3
                    cal = 'Three Points';
            end
        end
        
        function calClear(obj)
            writeCommand(obj, 'cal,clear', 0.6);
        end
        
        function calMid(obj, calValue)
            writeCommand(obj, strcat('cal,mid,', num2str(calValue)), 2.0);
        end
        
        function calLow(obj, calValue)
            writeCommand(obj, strcat('cal,low,', num2str(calValue)), 2.0);
        end
        
        function calHigh(obj, calValue)
            writeCommand(obj, strcat('cal,high,', num2str(calValue)), 2.0);
        end
        
    end
end