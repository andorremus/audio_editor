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
        
        function ReplotData(obj,axes)
            global editorData;
            cla(axes);
            plot(editorData.musicData.soundStream,'b','Parent',axes); % plot audio data
            title(editorData.musicData.filename,'Parent',axes);
            xlabel(strcat('Time (s)'));
            ylabel('Amplitude');
            ylimits = get(axes, 'YLim'); % get the y-axis limits
            editorData.musicData.plotdata = [ylimits(1):0.1:ylimits(2)];
            editorData.musicData.audioPlayer.TimerFcn = {@usefulFunctions.plotMarker,editorData.musicData.audioPlayer, axes, editorData.musicData.plotdata};
            editorData.musicData.audioPlayer.TimerPeriod = 0.01; % period of the timer in seconds
        end
        
        function ReplotCustomData(obj,axes,musicData)
            cla(axes);
            plot(musicData.soundStream,'b','Parent',axes); % plot audio data
            title('Merged Sound');
            xlabel(strcat('Time (s)'));
            
            ylabel('Amplitude');
            ylimits = get(axes, 'YLim'); % get the y-axis limits
            musicData.plotdata = [ylimits(1):0.1:ylimits(2)];
            %figure(gcf);
            hline = plot(zeros(size(musicData.plotdata)), musicData.plotdata, 'r','Parent',axes); % plot the marker
        end
    end
    
end

