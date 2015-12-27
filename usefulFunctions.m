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
            hMarker = findobj(figHandle, 'Color', 'r')
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
    
    function showInvalidNumber   
        msgbox('Invalid Characters in Start and End numbers. Please try again.','Warning');                      
    end
    
    function r = validateSounds
        global musicData1;
        global musicData2;
        if((isempty(musicData1) ||  isempty(musicData1.filename)) || (isempty(musicData2) ||  isempty(musicData2.filename)))
            r = 1;
        else
            r = 0;
        end
    end
    
    function r = validateMusicData2
        global musicData2;
        if(isempty(musicData2) == 1 || isempty(musicData2.filename))
            r = 1;
        else
            r = 0;
        end        
    end
    
     function r = validateMusicData1
        global musicData1;
        if(isempty(musicData1) == 1 || isempty(musicData1.filename))
            r = 1;
        else
            r = 0;
        end        
     end
    
     function mergeSounds(position,handles)
         global editorData; 
         global musicData1;
         global musicData2;
         
         if(position == 1)
            
             % Get the section times needed
             minStart1 = str2num(get(handles.durationPos1MinStart,'String'));            
             secStart1 = str2num(get(handles.durationPos1SecStart,'String'));        
             totalStart1 = minStart1 * 60 + secStart1;   
             
             minEnd1 = str2num(get(handles.durationPos2MinEnd,'String'));            
             secEnd1 = str2num(get(handles.durationPos2SecEnd,'String'));      
             totalEnd1 = minEnd1 * 60 + secEnd1;
             
             minStart2 = str2num(get(handles.durationPos1MinStart,'String'));            
             secStart2 = str2num(get(handles.durationPos1SecStart,'String'));        
             totalStart2 = minStart2 * 60 + secStart2;   
             
             minEnd2 = str2num(get(handles.durationPos2MinEnd,'String'));            
             secEnd2 = str2num(get(handles.durationPos2SecEnd,'String'));      
             totalEnd2 = minEnd2 * 60 + secEnd2;
             
             beginningSample1 = (musicData1.sampleRate * totalStart1) + 80;            
             endSample1 = musicData1.sampleRate * totalEnd1 ;        
             if(endSample1 > length(musicData1.soundStream))            
                 endSample1 = length(musicData1.soundStream);        
             end
             
             beginningSample2 = (musicData2.sampleRate * totalStart2) + 80;            
             endSample2 = musicData2.sampleRate * totalEnd2 ;        
             if(endSample2 > length(musicData2.soundStream))            
                 endSample2 = length(musicData2.soundStream);        
             end
             
             piece1 = musicData1.soundStream(beginningSample1:endSample1,:); 
             piece2 = musicData2.soundStream(beginningSample2:endSample2,:); 
             newSampleRate = (musicData1.sampleRate + musicData2.sampleRate) / 2;
             
             wholeNewSound = vertcat(piece1,piece2);
             %audio = audioplayer(wholeNewSound,newSampleRate);
             %playblocking(audio);
             musicData1.soundStream = wholeNewSound;
             musicData1.sampleRate = newSampleRate;            
             musicData1.audioPlayer = audioplayer(musicData1.soundStream, musicData1.sampleRate);            
             musicData1.audioPlayer.TimerPeriod = 0.01;                          
             axis = findobj(gcf,'Tag','audioAxesPos1');           
             musicData1.audioPlayer.TimerFcn = {@usefulFunctions.plotMarker,musicData1.audioPlayer, axis, musicData1.plotdata};
             musicData1.audioPlayer.TimerPeriod = 0.01; % period of the timer in seconds
             plot(musicData1.soundStream,'b'); % plot audio data            
             title('Merged Sound');            
             xlabel(strcat('Time (s)'));

            ylabel('Amplitude');
            ylimits = get(gca, 'YLim'); % get the y-axis limits
            musicData1.plotdata = [ylimits(1):0.1:ylimits(2)];
            %figure(gcf);
            hline = plot(zeros(size(musicData1.plotdata)), musicData1.plotdata, 'r'); % plot the marker

            editorData.musicData = musicData1;   
            musicData1.filename = 'MergedSound.wav';
            set(handles.durationText1,'String',editorData.musicData.GetDurationAsStr);
            set(handles.durationPos1MinEnd,'String',editorData.musicData.GetDurationMin);
            set(handles.durationPos1SecEnd,'String',editorData.musicData.GetDurationSec);
             
             
             
         else
             
         end        
         
     end
     
     function r = validateStartEndPos1(handles)
         % validate numbers ... pos 1
         
         truth = 1;
         x = str2num(get(handles.durationPos1MinStart,'String'))
         if(isempty(x) == 1)
             truth = 0;         
         end 
         
         x = str2num(get(handles.durationPos1SecStart,'String'))        
         if(isempty(x) == 1)             
             truth = 0;          
         end         
         
         x = str2num(get(handles.durationPos1MinEnd,'String'))       
         if(isempty(x) == 1)             
             truth = 0;  
         end
                  
         x = str2num(get(handles.durationPos1SecEnd,'String'))        
         if(isempty(x) == 1)             
             truth = 0;          
         end
         
         if(truth == 0)
             r = 0;
         else
             r = 1;
         end         
     end
     
     function r = validateStartEndPos2(handles)
         % validate numbers ... pos 2         
         truth = 1;         
       
         x = str2num(get(handles.durationPos2MinStart,'String'))        
         if(isempty(x) == 1)      
             truth = 0;            
         end
         
         
         x = str2num(get(handles.durationPos2SecStart,'String'))        
         if(isempty(x) == 1)             
             truth = 0;          
         end         
         
         x = str2num(get(handles.durationPos2MinEnd,'String'))        
         if(isempty(x) == 1)             
             truth = 0;          
         end        
         
         x = str2num(get(handles.durationPos2SecEnd,'String'))        
         if(isempty(x) == 1)             
             truth = 0;          
         end         
         
         if(truth == 0)
             r = 0;
         else
             r = 1;
         end         
     end
     
    end
end
