function varargout = audioAppGUI(varargin)
% AUDIOAPPGUI MATLAB code for audioAppGUI.fig
%      AUDIOAPPGUI, by itself, creates a new AUDIOAPPGUI or raises the existing
%      singleton*.
%
%      H = AUDIOAPPGUI returns the handle to a new AUDIOAPPGUI or the handle to
%      the existing singleton*.
%
%      AUDIOAPPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUDIOAPPGUI.M with the given input arguments.
%
%      AUDIOAPPGUI('Property','Value',...) creates a new AUDIOAPPGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before audioAppGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to audioAppGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help audioAppGUI

% Last Modified by GUIDE v2.5 24-Dec-2015 10:31:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @audioAppGUI_OpeningFcn, ...
    'gui_OutputFcn',  @audioAppGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before audioAppGUI is made visible.
function audioAppGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to audioAppGUI (see VARARGIN)

% Initialize global variables
global musicData1;
global musicData2;
global editorData;

musicData1 = MusicData(0,0,0,0,'');
musicData2 = MusicData(0,0,0,0,'');
editorData = EditorData(1.0,1.0,0);
editorData.outputDeviceSelId = 0;



% Choose default command line output for audioAppGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes audioAppGUI wait for user response (see UIRESUME)
% uiwait(handles.mainFigure);

% --- Outputs from this function are returned to the command line.
function varargout = audioAppGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.mainFigure)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.mainFigure,'Name') '?'],...
    ['Close ' get(handles.mainFigure,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.mainFigure)



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------

function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;
clear all;

% --------------------------------------------------------------------
function New_File_Callback(hObject, eventdata, handles)
% hObject    handle to New_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fid = fopen( 'new.wav', 'w' );

%fclose(fid);

% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global editorData;
global musicData1;
global musicData2;

% get the file to be opened
[fileSelected, pathname] = ...
    uigetfile({'*.wav';'*.mp3'},'Audio Track Selector');
if isequal(fileSelected,0)
    % If there is no file selected do nothing    
elseif(get(handles.position2Button,'Value') == 1.0)
    % If position 2 is selected set the variables for the second musicData
    % object 
    [musicData2.soundStream,musicData2.sampleRate] = audioread(fileSelected);
    musicData2.audioPlayer = audioplayer(musicData2.soundStream,musicData2.sampleRate);  
    axis = findobj(gcf,'Tag','audioAxes')
    musicData2.audioPlayer.TimerFcn = {@usefulFunctions.plotMarker,musicData2.audioPlayer, axis, musicData2.plotdata};
    musicData2.audioPlayer.TimerPeriod = 0.01; % period of the timer in seconds
    %display(gcf);
    gcf; hold on;
    plot(musicData2.soundStream,'b'); % plot audio data
    title('Audio Data');
    xlabel(strcat('Time (s)'));
    
    ylabel('Amplitude');
    ylimits = get(gca, 'YLim'); % get the y-axis limits
    musicData2.plotdata = [ylimits(1):0.1:ylimits(2)];
    %figure(gcf);
    hline = plot(zeros(size(musicData2.plotdata)), musicData2.plotdata, 'r'); % plot the marker

    %plot(soundStream);
    if isequal(fileSelected,0)
        disp('User selected Cancel')
    else
        disp(['User selected ', fullfile(pathname, fileSelected)])
        set(handles.audioFileSelectedText2,'String',fileSelected);
    end
    
    editorData.musicData = musicData2;
else
    % If position 1 is selected set the variables for the first musicData
    % object 
    
    [musicData1.soundStream,musicData1.sampleRate] = audioread(fileSelected);
  
    %soundDetails = wav
    %h = findobj(gcf,'Tag','audioAxes');
    
    musicData1.audioPlayer = audioplayer(musicData1.soundStream, musicData1.sampleRate);
    musicData1.audioPlayer.TimerPeriod = 0.01;    
    axis = findobj(gcf,'Tag','audioAxes')
    musicData1.audioPlayer.TimerFcn = {@usefulFunctions.plotMarker,musicData1.audioPlayer, axis, musicData1.plotdata};
    musicData1.audioPlayer.TimerPeriod = 0.01; % period of the timer in seconds
    %display(gcf);
    gcf; hold on;
    plot(musicData1.soundStream,'b'); % plot audio data
    title('Audio Data');
    xlabel(strcat('Time (s)'));
    
    ylabel('Amplitude');
    ylimits = get(gca, 'YLim'); % get the y-axis limits
    musicData1.plotdata = [ylimits(1):0.1:ylimits(2)];
    %figure(gcf);
    hline = plot(zeros(size(musicData1.plotdata)), musicData1.plotdata, 'r'); % plot the marker

    %plot(soundStream);
    if isequal(fileSelected,0)
        disp('User selected Cancel')
    else
        disp(['User selected ', fullfile(pathname, fileSelected)])
        set(handles.audioFileSelectedText,'String',fileSelected);
    end
    editorData.musicData = musicData1;
end


% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global editorData;

if(editorData.musicData.filename == 0)
    usefulFunctions.showNoFileError;
else
    if(~isempty(soundStream))
        audiowrite(editorData.musicData.filename,editorData.musicData.soundStream,editorData.musicData.sampleRate);
    else
        usefulFunctions.showNoSoundStreamError;
    end    
end

% --- Executes on button press in playButton.
function playButton_Callback(hObject, eventdata, handles)
% hObject    handle to playButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global editorData;

axes(handles.audioAxes);
cla;

% If the sound stream is empty show an error    
if(isempty(editorData.musicData.soundStream))              
    usefulFunctions.showNoFileError;    
else
    % otherwise create a new audioplayer object to be assigned to the
    % global editorData var and play it
    editorData.musicData.audioPlayer = audioplayer(editorData.musicData.soundStream ,editorData.musicData.sampleRate,16,editorData.outputDeviceSelId);
    play(editorData.musicData.audioPlayer);
    % set UI fields
    set(handles.outputDevList,'Enable','off');
    set(handles.sampleRateValue,'String',editorData.musicData.sampleRate);
end


% --- Executes on button press in pauseButton.
function pauseButton_Callback(hObject, eventdata, handles)
% hObject    handle to pauseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global editorData;

if(isempty(editorData.musicData.audioPlayer))        
    usefulFunctions.showNoFileError
else
    if(editorData.musicData.audioPlayer.isplaying)
        pause(editorData.musicData.audioPlayer)
        set(handles.pauseButton,'string','Resume');        
    elseif(get(editorData.musicData.audioPlayer,'CurrentSample') == 1)
        usefulFunctions.showStoppedError;       
    else
        resume(editorData.musicData.audioPlayer)
        set(handles.pauseButton,'string','Pause');
    end
    display(editorData.musicData.audioPlayer);    
    set(handles.sampleRateValue,'String',editorData.musicData.sampleRate);
end

% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global editorData;

if(isempty(editorData.musicData.audioPlayer))
    usefulFunctions.showNoFileError;
else
    stop(editorData.musicData.audioPlayer);
    set(handles.pauseButton,'string','Pause');
    plot(editorData.musicData.soundStream,'b');
    set(handles.outputDevList,'Enable','on');
end

% --- Executes when user attempts to close mainFigure.
function mainFigure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to mainFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on slider movement.
function playbackSpeedSlider_Callback(hObject, eventdata, handles)
% hObject    handle to playbackSpeedSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global editorData;
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.playbackSpeedNoText,'String',get(hObject,'Value') );
currentPlaybackSpeed = get(hObject,'Value');
currentSample = get(editorData.musicData.audioPlayer,'CurrentSample') / editorData.musicData.sampleRate;

if(isempty(editorData.musicData))
    
else   
     if(editorData.musicData.audioPlayer.isplaying)           
         %%editorData.musicData.soundStream = ((editorData.musicData.soundStream / editorData.volume ) * editorData.volume);
         editorData.musicData.sampleRate = ((editorData.musicData.sampleRate / editorData.playbackSpeed )* currentPlaybackSpeed);         
         editorData.musicData.audioPlayer = audioplayer(editorData.musicData.soundStream, editorData.musicData.sampleRate,16,editorData.outputDeviceSelId);         
         play(editorData.musicData.audioPlayer,currentSample * editorData.musicData.audioPlayer.sampleRate);    
     else         
        %editorData.musicData.soundStream = (editorData.musicData.soundStream / editorData.volume) * curr;
        editorData.musicData.sampleRate = (editorData.musicData.sampleRate / editorData.playbackSpeed) * currentPlaybackSpeed;
     end  
     
     set(handles.sampleRateValue,'String',editorData.musicData.sampleRate);
end

editorData.playbackSpeed = currentPlaybackSpeed;


% --- Executes during object creation, after setting all properties.
function playbackSpeedSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to playbackSpeedSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global editorData;
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
editorData.playbackSpeed = get(hObject,'Value');


% --- Executes on selection change in outputDevList.
function outputDevList_Callback(hObject, eventdata, handles)
% hObject    handle to outputDevList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns outputDevList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from outputDevList
% Sets the output device
global editorData;
editorData.outputDeviceSelId = hObject.Value - 1; 

% --- Executes during object creation, after setting all properties.
function outputDevList_CreateFcn(hObject, eventdata, handles)
% hObject    handlere to outputDevList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

x = audiodevinfo(0); % get the number of available output devices for the loop
if x > 0
    for i = 1:x
        outDevArr{i} = audiodevinfo(0,(i-1)); % insert out dev into array        
    end 
    set(hObject, 'String', outDevArr); % populate the menu with the string array
end


% --- Executes on selection change in inputDevList.
function inputDevList_Callback(hObject, eventdata, handles)
% hObject    handle to inputDevList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns inputDevList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from inputDevList


% --- Executes during object creation, after setting all properties.
function inputDevList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputDevList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

x = audiodevinfo(1) % get the number of available input devices for the loop
if x > 0
    for i = 1:x
        inputDevArr{i} =  audiodevinfo(1,(i-1)); % insert input dev into array       
    end
    set(hObject, 'String', inputDevArr); % populate the menu with the string array
end


% --- Executes on slider movement.
function volumeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to volumeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global editorData;

currentVolume = hObject.Value;

if(isempty(editorData.musicData.audioPlayer))
    
else   
    if(editorData.musicData.audioPlayer.isplaying)
        pause(editorData.musicData.audioPlayer);
        editorData.musicData.soundStream = ((editorData.musicData.soundStream / editorData.volume) * currentVolume);
        %editorData.musicData.sampleRate = (editorData.musicData.sampleRate * editorData.playbackSpeed);
        editorData.musicData.audioPlayer = audioplayer(editorData.musicData.soundStream, editorData.musicData.sampleRate);
        resume(editorData.musicData.audioPlayer);
    else        
        editorData.musicData.soundStream = ((editorData.musicData.soundStream / editorData.volume) * currentVolume );
        %editorData.musicData.sampleRate = (editorData.musicData.sampleRate * editorData.playbackSpeed);
    end
    
end
editorData.volume = currentVolume;



% --- Executes during object creation, after setting all properties.
function volumeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volumeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global editorData;
editorData.volume = hObject.Value;
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
imgPath = imread('img/soundOut.png');
set(hObject,'CData',imgPath);


% --- Executes during object creation, after setting all properties.
function pushbutton10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
imgPath = imread('img/mic.png');
set(hObject,'CData',imgPath);


% --- Executes on button press in saveAsButton.
function saveAsButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveAsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global editorData;

filename = uiputfile('/','Save sound to file','newSound.wav');
if(filename == 0)
    display('Cancelled selection');
else
    if(~isempty(editorData.musicData.soundStream))
        audiowrite(editorData.musicData.filename,editorData.musicData.soundStream,editorData.musicData.sampleRate);
    else
        usefulFunctions.showNoSoundStreamError;
    end
end


% --- Executes during object creation, after setting all properties.
function saveAsButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to saveAsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
imgPath = imread('img/save.png');
set(hObject,'CData',imgPath);


% --- Executes on button press in position2Button.
function position2Button_Callback(hObject, eventdata, handles)
% hObject    handle to position2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of position2Button
global editorData;
global musicData2;

editorData.musicData = musicData2;


% --- Executes on key press with focus on position1Button and none of its controls.
function position1Button_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to position1Button (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in position1Button.
function position1Button_Callback(hObject, eventdata, handles)
% hObject    handle to position1Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of position1Button
global editorData;
global musicData1;

if(editorData.musicData.audioPlayer.isplaying)
    stop(editorData.musicData.audioPlayer)
    set(handles.pauseButton,'string','Pause');
end

editorData.musicData = musicData1;

set(handles.sampleRateValue,'string',editorData.musicData.sampleRate);
