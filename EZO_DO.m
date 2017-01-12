%% Copyright 2016 Atlas Scientific LLC.

classdef EZO_DO < EzoBase
    
    methods
        function obj = EZO_DO(serialPort)
            obj@EzoBase(serialPort);
            writeCommand(obj, 'O,%%,1', 0.6);
        end
        
        function do = read(obj)
            do = 0; %in case nothing gets assigned
            
            flushinput(obj.serialObject)
            fprintf(obj.serialObject,'r%c', 13);
            pause(1.300);
            data = fgetl(obj.serialObject);
            while(data(1) ~= '*') % stop reading when we get *OK or *ER
                %disp(data);
                do = sscanf(data,'%f');
                data = fgetl(obj.serialObject);
            end
        end
        
        function do = readPercentSat(obj)
            do = 0; %in case nothing gets assigned
            
            flushinput(obj.serialObject)
            fprintf(obj.serialObject,'r%c', 13);
            pause(1.300);
            data = fgetl(obj.serialObject);
            while(data(1) ~= '*') % stop reading when we get *OK or *ER
                %disp(data);
                do = sscanf(data,'%f,%f');
                do = do(2);
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
            end
        end
        
        function calClear(obj)
            writeCommand(obj, 'cal,clear', 0.6);
        end
        
        function cal(obj)
            writeCommand(obj, 'cal', 2.0);
        end
        
        function calZero(obj)
            writeCommand(obj, 'cal,0', 0.6);
        end
        
        function setPressure(obj, pressure)
            writeCommand(obj, strcat('P,', num2str(pressure)), 0.6);
        end
        
        function pressure = getPressure(obj)
            pressure = getAnswer(obj, 'P,?');
            pressure = convertQuery(obj, pressure);
        end
        
        function setSalinity(obj, salinity)
            writeCommand(obj, strcat('S,', num2str(salinity)), 0.6);
        end
        
        function salinity = getSalinity(obj)
            salinity = getAnswer(obj, 'S,?');
            salinity = convertQuery(obj, salinity);
        end
    end
end
