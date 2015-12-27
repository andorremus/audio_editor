classdef MusicData
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        soundStream;
        sampleRate;
        audioPlayer;
        plotdata;
        filename;
        duration;
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
        
        function r = GetDurationAsStr(obj)
            minutes = int16( ( length(obj.soundStream) / obj.sampleRate ) / 60 );
            seconds = int16( mod( length(obj.soundStream) / obj.sampleRate,60) );
            r = strcat(int2str(minutes),'min',int2str(seconds),'s');
        end
        
        function r = GetDurationSec(obj)
            seconds = int16( mod( length(obj.soundStream) / obj.sampleRate,60) );
            r = int2str(seconds);
        end
        
        function r = GetDurationMin(obj)
            minutes = int16( ( length(obj.soundStream) / obj.sampleRate ) / 60 );
            r = int2str(minutes);
        end
        
        
        
    end
    
end

