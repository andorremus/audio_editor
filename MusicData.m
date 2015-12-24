classdef MusicData
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        soundStream;
        sampleRate;
        audioPlayer;
        plotdata;
        filename;
    end
    
    methods
        function obj = MusicData(soundStreamTemp, sampleRateTemp, audioPlayerTemp, plotdataTemp,filenameTemp)         
            if nargin == 5
                obj.soundStream = soundStreamTemp;
                obj.sampleRate = sampleRateTemp;
                obj.audioPlayer = audioPlayerTemp;
                obj.plotdata = plotdataTemp;
                obj.filename = filenameTemp;
            else                
                error('Invalid number of arguments.');                
            end            
        end      
        
    end
    
end

