classdef usefulFunctions
    %USEFULFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
    end
    
    methods(Static)
        
        %% Set up plot
        function SetupPlot(axesHandle)
            global editorData;
            axes = axesHandle;
            cla(axes);
            plot(editorData.musicData.soundStream,'b','Parent',axes);
            title(axes,editorData.musicData.filename);
            xlabel(axes,strcat('Time (s)'));
            %xlim(axes,auto);
            ylabel(axes,'Amplitude');
            ylimits = get(axes, 'YLim'); % get the y-axis limits
            editorData.musicData.plotdata = [ylimits(1):0.1:ylimits(2)];
            hline = plot(zeros(size(editorData.musicData.plotdata)), editorData.musicData.plotdata, 'r','Parent',axes); % plot the marker
        end
        
        %% Function to update the marker in real-time
        function plotMarker(obj,eventdata,player,figHandle,plotdata)
            
            % check if sound is playing, then only plot new marker
            if strcmp(player.Running, 'on')
                % get the handle of current marker and delete the marker
                axes = figHandle;
                hMarker = findobj(figHandle, 'Color', 'r');
                delete(hMarker);
                % get the currently playing sample
                x = player.CurrentSample;
                % plot the new marker
                plot(repmat(x, size(plotdata)), plotdata, 'r','Parent',axes);
            end
            
        end
        
        %% Shows error in message dialog
        function showNoFileError
            msgbox('No File Loaded. Please load an audio file and try again.','Error');
        end
        %% Shows error for no sound
        function showNoSoundStreamError
            msgbox('No sound file loaded. Please load an audio file and try again.','Error');
        end
        
        %% Shows error for player stopped
        function showStoppedError
            msgbox('The player is stopped. You can only pause/resume if the sound is playing','Warning');
        end
        
        %% Shows error for invalid numbers
        function showInvalidNumber
            msgbox('Invalid Characters in Start and End numbers. Please try again.','Warning');
        end
        
        %% Checks if the music data instances aren't empty
        function r = validateSounds
            global musicData1;
            global musicData2;
            if((isempty(musicData1) ||  isempty(musicData1.filename)) || (isempty(musicData2) ||  isempty(musicData2.filename)))
                r = 1;
            else
                r = 0;
            end
        end
        
        %% Checks if the music data2 instance isn't empty
        function r = validateMusicData2
            global musicData2;
            if(isempty(musicData2) == 1 || isempty(musicData2.filename))
                r = 1;
            else
                r = 0;
            end
        end
        %% Checks if the music data1 instance isn't empty
        function r = validateMusicData1
            global musicData1;
            if(isempty(musicData1) == 1 || isempty(musicData1.filename))
                r = 1;
            else
                r = 0;
            end
        end
        
        %% Does the joining of the two sounds
        function mergeSounds(position,handles)
            global editorData;
            global musicData1;
            global musicData2;
            global axis1;
            global axis2;
            
            
            % Get the section times needed
            minStart1 = str2num(get(handles.durationPos1MinStart,'String'));
            secStart1 = str2num(get(handles.durationPos1SecStart,'String'));
            totalStart1 = minStart1 * 60 + secStart1;
            
            minEnd1 = str2num(get(handles.durationPos1MinEnd,'String'));
            secEnd1 = str2num(get(handles.durationPos1SecEnd,'String'));
            totalEnd1 = minEnd1 * 60 + secEnd1;
            
            minStart2 = str2num(get(handles.durationPos2MinStart,'String'));
            secStart2 = str2num(get(handles.durationPos2SecStart,'String'));
            totalStart2 = minStart2 * 60 + secStart2;
            
            minEnd2 = str2num(get(handles.durationPos2MinEnd,'String'));
            secEnd2 = str2num(get(handles.durationPos2SecEnd,'String'));
            totalEnd2 = minEnd2 * 60 + secEnd2;
            
            % Transform the times into samples and make sure they're within
            % range
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
            
            % Get the corresponding sound samples and concat the matrices
            % into one sound piece
            piece1 = musicData1.soundStream(beginningSample1:endSample1,:);
            piece2 = musicData2.soundStream(beginningSample2:endSample2,:);
            newSampleRate = (musicData1.sampleRate + musicData2.sampleRate) / 2;
            
            if(position == 1)
                wholeNewSound = vertcat(piece1,piece2);
                % Since we've selected the position 1, assign the new sound
                % data into music data 1 and set it as selected for the editor
                musicData1.soundStream = wholeNewSound;
                musicData1.sampleRate = newSampleRate;             
                editorData.ReplotCustomData(axis1,musicData1);                     
                musicData1.filename = 'MergedSound.wav';
                editorData.musicData = musicData1;
                % Set ui variables
                set(handles.durationText1,'String',editorData.musicData.GetDurationAsStr);
                set(handles.durationPos1MinEnd,'String',editorData.musicData.GetDurationMin);
                set(handles.durationPos1SecEnd,'String',editorData.musicData.GetDurationSec);
            else
                wholeNewSound = vertcat(piece2,piece1);
                % Since we've selected the position 2, assign the new sound
                % data into music data 2 and set it as selected for the editor
                musicData2.soundStream = wholeNewSound;
                musicData2.sampleRate = newSampleRate;
                editorData.ReplotCustomData(axis2,musicData1);                  
                musicData2.filename = 'MergedSound.wav';
                editorData.musicData = musicData2;
                
                % Set ui variables
                set(handles.durationText1,'String',editorData.musicData.GetDurationAsStr);
                set(handles.durationPos1MinEnd,'String',editorData.musicData.GetDurationMin);
                set(handles.durationPos1SecEnd,'String',editorData.musicData.GetDurationSec);
                
                
                
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
