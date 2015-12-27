classdef EditorData
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        volume;
        playbackSpeed;
        outputDeviceSelId;
        musicData;
    end
    
    methods
        function obj = EditorData(volumeTemp,playbackSpeedTemp,outputDeviceSelIdTemp)         
            if nargin == 3            
                if (isnumeric(volumeTemp)) && (isnumeric(playbackSpeedTemp)) && (isnumeric(outputDeviceSelIdTemp))               
                    obj.volume = volumeTemp;
                    obj.playbackSpeed = playbackSpeedTemp;
                    obj.outputDeviceSelId = outputDeviceSelIdTemp;      
                else                   
                    error('Value must be numeric')           
                end                
            end                       
        end
    end
    
end

