classdef usefulFunctions
    %USEFULFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods      
        
    end
    
    methods(Static)
        
        %% the timer callback function definition
    function plotMarker(...
            obj, ...            % refers to the object that called this function (necessary parameter for all callback functions)
            eventdata, ...      % this parameter is not used but is necessary for all callback functions
            player, ...         % we pass the audioplayer object to the callback function
            figHandle, ...      % pass the figure handle also to the callback function
            plotdata)           % finally, we pass the data necessary to draw the new marker

        % check if sound is playing, then only plot new marker
        if strcmp(player.Running, 'on')
            % get the handle of current marker and delete the marker
            %axes = get(figHandle,'Tag','audioAxes')
            hMarker = findobj(figHandle, 'Color', 'r');
            delete(hMarker);
            % get the currently playing sample
            x = player.CurrentSample;
            % plot the new marker
            display(figHandle);
            plot(repmat(x, size(plotdata)), plotdata, 'r');
        end

    end
        
    %% Shows error in message dialog 
    function showNoFileError    
        msgbox('No File Loaded. Please load an audio file and try again.','Error');                      
    end
    
    function showNoSoundStreamError    
        msgbox('No sound file loaded. Please load an audio file and try again.','Error');                      
    end
    
    function showStoppedError    
        msgbox('The player is stopped. You can only pause/resume if the sound is playing','Warning');                      
    end
    
    end
end
