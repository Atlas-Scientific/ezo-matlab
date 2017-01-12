%% Copyright 2016 Atlas Scientific LLC.

classdef EzoBase
    properties
        serialObject
    end
    
    methods
        %% initialization
        function obj = EzoBase(serialPort)
%             if ~iscellstr(serialPort)
%                 error('Serial port is passed in as a string in thr form of ''COM#'', where # is the number of the serial port, Ex. ''COM3''')
%             end
            % Create a serial port object.
            obj.serialObject = instrfind('Type', 'serial', 'Port', serialPort, 'Tag', '');
            
            % Create the serial port object if it does not exist
            % otherwise use the object that was found.
            if isempty(obj.serialObject)
                obj.serialObject = serial(serialPort);
            else
                fclose(obj.serialObject);
                obj.serialObject = obj.serialObject(1);
            end
            
            %set a line to be terminated with carraige return
            set(obj.serialObject, 'Terminator', 'CR');
            fopen(obj.serialObject);
            
            flushoutput(obj.serialObject);
            
            % turn off continuous readings
            fprintf(obj.serialObject,'c,0%c', 13); % use %c and 13 to create carriage return
            flushinput(obj.serialObject);
        end
        
        function close(obj)
            fclose(obj.serialObject);
        end
        
        %% common ezo commands
        function factoryReset(obj)
            writeCommand(obj, 'factory', 5.0);
             % turn off continuous readings
            fprintf(obj.serialObject,'c,0%c', 13);
            flushinput(obj.serialObject);
        end
        
        function temp = getTemperature(obj)
            temp = getAnswer(obj, 'T,?');
            temp = convertQuery(obj, temp);
        end
        
        function setTemperature(obj, temp)
            writeCommand(obj, strcat('T,', num2str(temp)), 0.6);
        end
        
        function ledOn(obj)
            writeCommand(obj, 'L,1', 0.6);
        end
        
        function ledOff(obj)
            writeCommand(obj, 'L,0', 0.6);
        end
        
        %% general purpose comms abstractions
        function writeCommand(obj, string, delay)
            flushinput(obj.serialObject)
            fprintf(obj.serialObject,strcat(string, '%c'), 13);
            pause(delay);
            data = fgetl(obj.serialObject);
            disp(data);
        end
            
        function result = getAnswer(obj, query)
            flushinput(obj.serialObject)
            fprintf(obj.serialObject, strcat(query, '%c'), 13);
            pause(.6);
            result = fgetl(obj.serialObject);
            if(result(1) ~= '*') % if not error, get the *OK
                fgetl(obj.serialObject);
            end
        end
        
         function result = convertQuery(~, ansString)
            if (ansString(1) == '?')
                split = strsplit(ansString, ',');
                result = str2double(split(2));
            else
                result = ansString;
            end
        end
        
    end
    
    methods(Abstract)
        reading = read(obj);
    end
    
end

