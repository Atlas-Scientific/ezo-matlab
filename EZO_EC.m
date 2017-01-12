%% Copyright 2016 Atlas Scientific LLC.

classdef EZO_EC < EzoBase
    
    methods
        function obj = EZO_EC(serialPort)
            obj@EzoBase(serialPort);
        end
        
        function EC = read(obj)
            EC= 0; %in case nothing gets assigned
            flushinput(obj.serialObject)
            fprintf(obj.serialObject,'r%c', 13);
            pause(1.300);
            data = fgetl(obj.serialObject);
            while(data(1) ~= '*') % stop reading when we get *OK or *ER
                %disp(data);
                EC = sscanf(data,'%f');
                data = fgetl(obj.serialObject);
            end
        end
        
        function TDS = readTDS(obj)
            TDS = 0; %in case nothing gets assigned
            flushinput(obj.serialObject)
            fprintf(obj.serialObject,'r%c', 13);
            pause(1.300);
            data = fgetl(obj.serialObject);
            while(data(1) ~= '*') % stop reading when we get *OK or *ER
                %disp(data);
                result = sscanf(data,'%f,%f');
                TDS = result(2);
                data = fgetl(obj.serialObject);
            end
        end
        
        function SAL = readSAL(obj)
            SAL = 0; %in case nothing gets assigned
            flushinput(obj.serialObject)
            fprintf(obj.serialObject,'r%c', 13);
            pause(1.300);
            data = fgetl(obj.serialObject);
            while(data(1) ~= '*') % stop reading when we get *OK or *ER
                %disp(data);
                result = sscanf(data,'%f,%f,%f');
                SAL = result(3);
                data = fgetl(obj.serialObject);
            end
        end
        
        function SG = readSG(obj)
            SG = 0; %in case nothing gets assigned
            flushinput(obj.serialObject)
            fprintf(obj.serialObject,'r%c', 13);
            pause(1.300);
            data = fgetl(obj.serialObject);
            while(data(1) ~= '*') % stop reading when we get *OK or *ER
                %disp(data);
                result = sscanf(data,'%f,%f,%f,%f');
                SG = result(4);
                data = fgetl(obj.serialObject);
            end
        end
        
        function [EC, TDS, SAL, SG] = readAll(obj)
            EC = 0; TDS = 0; SAL = 0; SG = 0; %in case nothing gets assigned
            flushinput(obj.serialObject)
            fprintf(obj.serialObject,'r%c', 13);
            pause(1.300);
            data = fgetl(obj.serialObject);
            while(data(1) ~= '*') % stop reading when we get *OK or *ER
                %disp(data);
                [EC, TDS, SAL, SG] = sscanf(data,'%f,%f,%f,%f');
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
        
        function calDry(obj)
            writeCommand(obj, 'cal,dry', 2.0);
        end
        
        function calOne(obj, ecCalPoint)
            writeCommand(obj, strcat('cal,one,', num2str(ecCalPoint)), 2.0);
        end
        
        function calLow(obj, ecCalPoint)
            writeCommand(obj, strcat('cal,low,', num2str(ecCalPoint)), 2.0);
        end
        
        function calHigh(obj, ecCalPoint)
            writeCommand(obj, strcat('cal,high,', num2str(ecCalPoint)), 2.0);
        end
        
    end
end