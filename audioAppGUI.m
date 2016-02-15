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

% Last Modified by GUIDE v2.5 27-Dec-2015 15:56:07

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
global axis2;
global axis1;

% get the file to be opened
[fileSelected, pathname] = ...
    uigetfile({'*.wav';'*.mp3'},'Audio Track Selector');
if isequal(fileSelected,0)
    % If there is no file selected do nothing
elseif(get(handles.position2Button,'Value') == 1.0)
    % If position 2 is selected set the variables for the second musicData
    % object
    axes = axis2;
    cla(axes);
    [musicData2.soundStream,musicData2.sampleRate] = audioread(fileSelected);
    musicData2.audioPlayer = audioplayer(musicData2.soundStream,musicData2.sampleRate);
    editorData.ReplotCustomData(axes,musicData2);
    hline = plot(zeros(size(musicData2.plotdata)), musicData2.plotdata, 'r','Parent',axes); % plot the marker
    disp(['User selected ', fullfile(pathname, fileSelected)])
    set(handles.audioFileSelectedText2,'String',fileSelected);
    musicData2.filename = fileSelected;
    editorData.musicData = musicData2;
    set(handles.durationText2,'String',editorData.musicData.GetDurationAsStr);
    set(handles.durationPos2MinEnd,'String',editorData.musicData.GetDurationMin);
    set(handles.durationPos2SecEnd,'String',editorData.musicData.GetDurationSec);
else
    % If position 1 is selected set the variables for the first musicData
    % object
    axes = axis1;
    cla(axes);
    [musicData1.soundStream,musicData1.sampleRate] = audioread(fileSelected);
    musicData1.audioPlayer = audioplayer(musicData1.soundStream, musicData1.sampleRate);   
    editorData.ReplotCustomData(axes,musicData1);
    hline = plot(zeros(size(musicData1.plotdata)), musicData1.plotdata, 'r','Parent',axes); % plot the marker
    disp(['User selected ', fullfile(pathname, fileSelected)])
    set(handles.audioFileSelectedText,'String',fileSelected);
    musicData1.filename = fileSelected;
    editorData.musicData = musicData1;
    set(handles.durationText1,'String',editorData.musicData.GetDurationAsStr);
    set(handles.durationPos1MinEnd,'String',editorData.musicData.GetDurationMin);
    set(handles.durationPos1SecEnd,'String',editorData.musicData.GetDurationSec);
end




% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global editorData;

if(isempty(editorData.musicData) == 1)
    usefulFunctions.showNoFileError;
else
    if(~isempty(editorData.musicData.soundStream))
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
global axis1;
global axis2;

% If the sound stream is empty show an error
if(isempty(editorData.musicData) || isempty(editorData.musicData.filename))
    usefulFunctions.showNoFileError;
else
    % otherwise create a new audioplayer object to be assigned to the
    % global editorData var and play it
    if(handles.position2Button.Value == 1)
        axis = axis2;
    else
        axis = axis1;
    end
    usefulFunctions.SetupPlot(axis);
    editorData.musicData.audioPlayer = audioplayer(editorData.musicData.soundStream ,editorData.musicData.sampleRate,16,editorData.outputDeviceSelId);
    editorData.musicData.audioPlayer.TimerFcn = {@usefulFunctions.plotMarker,editorData.musicData.audioPlayer, axis, editorData.musicData.plotdata};
    editorData.musicData.audioPlayer.TimerPeriod = 0.01; % period of the timer in seconds
    play(editorData.musicData.audioPlayer);
    % set UI fields
    set(handles.outputDevList,'Enable','off');
    set(handles.sampleRateValue,'String',editorData.musicData.sampleRate);
    set(handles.pauseButton,'String','Pause');
end


% --- Executes on button press in pauseButton.
function pauseButton_Callback(hObject, eventdata, handles)
% hObject    handle to pauseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global editorData;

if(isempty(editorData.musicData) || isempty(editorData.musicData.filename))
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
global axis1;
global axis2;

if(isempty(editorData.musicData) || isempty(editorData.musicData.filename))
    usefulFunctions.showNoFileError;
else
    stop(editorData.musicData.audioPlayer);
    set(handles.pauseButton,'string','Pause');
    if(handles.position1Button.Value == 1)
        axis = axis1;
        cla(axis);
        plot(editorData.musicData.soundStream,'b','Parent',axis);
    else
        axis = axis2;
        cla(axis);
        plot(editorData.musicData.soundStream,'b','Parent',axis);
    end
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
global axis1;
global axis2;
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.playbackSpeedNoText,'String',get(hObject,'Value') );
currentPlaybackSpeed = get(hObject,'Value');

if(handles.position1Button.Value == 1)
    axes = axis1;
else
    axes = axis2;
end

if(isempty(editorData.musicData) || isempty(editorData.musicData.filename))
    
else
    if(editorData.musicData.audioPlayer.isplaying)
        currentSample = get(editorData.musicData.audioPlayer,'CurrentSample') / editorData.musicData.sampleRate;
        editorData.musicData.sampleRate = ((editorData.musicData.sampleRate / editorData.playbackSpeed )* currentPlaybackSpeed);
        editorData.musicData.audioPlayer = audioplayer(editorData.musicData.soundStream, editorData.musicData.sampleRate,16,editorData.outputDeviceSelId);
        resumeSample = currentSample * editorData.musicData.audioPlayer.sampleRate;
        resumeSample = fix(resumeSample);
        editorData.ReplotData(axes);
        play(editorData.musicData.audioPlayer,resumeSample);
    else
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
m= audiodevinfo
x = audiodevinfo(0); % get the number of available output devices for the loop
if x > 0
    for i = 3:x
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
function volumeSlider_Callback(hObject, ~, handles)

global editorData;
global axis1;
global axis2;
currentVolume = hObject.Value;
if(handles.position1Button.Value == 1)
    axes = axis1;
else
    axes = axis2;
end

if(isempty(editorData.musicData) || isempty(editorData.musicData.filename))
    
else
    if(editorData.musicData.audioPlayer.isplaying)
        % Get the current sample before reinitializing the audio player
        resumeSample = get(editorData.musicData.audioPlayer,'CurrentSample') / editorData.musicData.sampleRate * editorData.musicData.audioPlayer.sampleRate;
        editorData.musicData.soundStream = ((editorData.musicData.soundStream / editorData.volume ) * currentVolume);
        editorData.musicData.audioPlayer = audioplayer(editorData.musicData.soundStream, editorData.musicData.sampleRate,16,editorData.outputDeviceSelId);
        editorData.ReplotData(axes);
        play(editorData.musicData.audioPlayer,resumeSample);
    else
        editorData.musicData.soundStream = (editorData.musicData.soundStream / editorData.volume) * currentVolume;
    end
    
    set(handles.sampleRateValue,'String',editorData.musicData.sampleRate);
end

editorData.volume = currentVolume;



% --- Executes during object creation, after setting all properties.
function volumeSlider_CreateFcn(hObject, ~, ~)
global editorData;
editorData.volume = hObject.Value;
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function pushbutton9_CreateFcn(hObject, ~, ~)
imgPath = imread('img/soundOut.png');
set(hObject,'CData',imgPath);


% --- Executes during object creation, after setting all properties.
function pushbutton10_CreateFcn(hObject, ~, ~)
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
    if(~isempty(editorData.musicData))
        audiowrite(filename,editorData.musicData.soundStream,editorData.musicData.sampleRate);
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

notEmpty = ~isempty(editorData.musicData);
if(notEmpty > 0)
    if(editorData.musicData.soundStream > 0)
        if(editorData.musicData.audioPlayer.isplaying)
            stop(editorData.musicData.audioPlayer)
            set(handles.pauseButton,'string','Pause');
        end
    end
end

editorData.musicData = musicData2;
set(handles.sampleRateValue,'string',editorData.musicData.sampleRate);


% --- Executes on key press with focus on position1Button and none of its controls.
function position1Button_KeyPressFcn(hObject, eventdata, handles)


% --- Executes on button press in position1Button.
function position1Button_Callback(hObject, eventdata, handles)

global editorData;
global musicData1;

notEmpty = ~isempty(editorData.musicData);
if(notEmpty > 0)
    if(editorData.musicData.soundStream > 0)
        if(editorData.musicData.audioPlayer.isplaying)
            stop(editorData.musicData.audioPlayer)
            set(handles.pauseButton,'string','Pause');
        end
    end
end

editorData.musicData = musicData1;

set(handles.sampleRateValue,'string',editorData.musicData.sampleRate);
%set(handles.durationText1,'String',editorData.musicData.GetDuration);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function durationPos1MinStart_Callback(hObject, eventdata, handles)
% hObject    handle to durationPos1MinStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durationPos1MinStart as text
%        str2double(get(hObject,'String')) returns contents of durationPos1MinStart as a double


% --- Executes during object creation, after setting all properties.
function durationPos1MinStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to durationPos1MinStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function durationPos1SecStart_Callback(hObject, eventdata, handles)
% hObject    handle to durationPos1SecStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durationPos1SecStart as text
%        str2double(get(hObject,'String')) returns contents of durationPos1SecStart as a double


% --- Executes during object creation, after setting all properties.
function durationPos1SecStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to durationPos1SecStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function durationPos1MinEnd_Callback(hObject, eventdata, handles)
% hObject    handle to durationPos1MinEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durationPos1MinEnd as text
%        str2double(get(hObject,'String')) returns contents of durationPos1MinEnd as a double


% --- Executes during object creation, after setting all properties.
function durationPos1MinEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to durationPos1MinEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function durationPos1SecEnd_Callback(hObject, eventdata, handles)
% hObject    handle to durationPos1SecEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durationPos1SecEnd as text
%        str2double(get(hObject,'String')) returns contents of durationPos1SecEnd as a double


% --- Executes during object creation, after setting all properties.
function durationPos1SecEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to durationPos1SecEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function durationPos2MinStart_Callback(hObject, eventdata, handles)
% hObject    handle to durationPos2MinStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durationPos2MinStart as text
%        str2double(get(hObject,'String')) returns contents of durationPos2MinStart as a double


% --- Executes during object creation, after setting all properties.
function durationPos2MinStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to durationPos2MinStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function durationPos2SecStart_Callback(hObject, eventdata, handles)
% hObject    handle to durationPos2SecStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durationPos2SecStart as text
%        str2double(get(hObject,'String')) returns contents of durationPos2SecStart as a double


% --- Executes during object creation, after setting all properties.
function durationPos2SecStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to durationPos2SecStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function durationPos2MinEnd_Callback(hObject, eventdata, handles)
% hObject    handle to durationPos2MinEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durationPos2MinEnd as text
%        str2double(get(hObject,'String')) returns contents of durationPos2MinEnd as a double


% --- Executes during object creation, after setting all properties.
function durationPos2MinEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to durationPos2MinEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function durationPos2SecEnd_Callback(hObject, eventdata, handles)
% hObject    handle to durationPos2SecEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durationPos2SecEnd as text
%        str2double(get(hObject,'String')) returns contents of durationPos2SecEnd as a double


% --- Executes during object creation, after setting all properties.
function durationPos2SecEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to durationPos2SecEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in playButtonPos1.
function playButtonPos1_Callback(hObject, eventdata, handles)

global musicData1;
global editorData;
global axis1;

if(usefulFunctions.validateMusicData1 == 1)
    usefulFunctions.showNoFileError;
else
    if(usefulFunctions.validateStartEndPos1(handles) == 1)
        axes = axis1;
        
        minStart = str2num(get(handles.durationPos1MinStart,'String'));
        secStart = str2num(get(handles.durationPos1SecStart,'String'));
        totalStart = minStart * 60 + secStart;
        
        minEnd = str2num(get(handles.durationPos1MinEnd,'String'));
        secEnd = str2num(get(handles.durationPos1SecEnd,'String'));
        totalEnd = minEnd * 60 + secEnd ;
        
        tempAudioPlayer = audioplayer(musicData1.soundStream * handles.volumeSlider.Value,musicData1.sampleRate * handles.playbackSpeedSlider.Value,16,editorData.outputDeviceSelId);
        beginningSample =(musicData1.sampleRate * totalStart) + 80;
        ylimits = get(axes, 'YLim'); % get the y-axis limits
        plotdata = [ylimits(1):0.1:ylimits(2)];
        
        tempAudioPlayer.TimerPeriod = 0.01;
        tempAudioPlayer.TimerFcn = {@usefulFunctions.plotMarker,tempAudioPlayer, axes, plotdata};
        
        endSample = musicData1.sampleRate * totalEnd ;
        if(endSample > length(musicData1.soundStream))
            endSample = length(musicData1.soundStream);
        end
        playblocking(tempAudioPlayer,[beginningSample endSample]);
        % set UI fields
        set(handles.outputDevList,'Enable','off');
        set(handles.sampleRateValue,'String',musicData1.sampleRate);
    else
        usefulFunctions.showInvalidNumber;
    end
end


% --- Executes on button press in playButtonPos2.
function playButtonPos2_Callback(hObject, eventdata, handles)
% hObject    handle to playButtonPos2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global musicData2;
global editorData;
global axis2;

% validate sound stream
if(usefulFunctions.validateMusicData2 == 1)
    usefulFunctions.showNoFileError;
else
    if(usefulFunctions.validateStartEndPos2(handles) == 1)
        axes = axis2;
        minStart = str2num(get(handles.durationPos2MinStart,'String'));
        secStart = str2num(get(handles.durationPos2SecStart,'String'));
        totalStart = minStart * 60 + secStart;
        
        minEnd = str2num(get(handles.durationPos2MinEnd,'String'));
        secEnd = str2num(get(handles.durationPos2SecEnd,'String'));
        totalEnd = minEnd * 60 + secEnd ;
        
        
        tempAudioPlayer = audioplayer((musicData2.soundStream * handles.volumeSlider.Value),...
            (musicData2.sampleRate * handles.playbackSpeedSlider.Value),...
            16,editorData.outputDeviceSelId);
        beginningSample = (musicData2.sampleRate * totalStart ) + 80;
        endSample = musicData2.sampleRate * totalEnd ;
        if(endSample > length(musicData2.soundStream))
            endSample = length(musicData2.soundStream);
        end
        ylimits = get(axes, 'YLim'); % get the y-axis limits
        plotdata = [ylimits(1):0.1:ylimits(2)];
        
        tempAudioPlayer.TimerPeriod = 0.01;
        tempAudioPlayer.TimerFcn = {@usefulFunctions.plotMarker,tempAudioPlayer, axes, plotdata};
        
        playblocking(tempAudioPlayer,[beginningSample endSample]);
        % set UI fields
        set(handles.sampleRateValue,'String',musicData2.sampleRate);
    else
        usefulFunctions.showInvalidNumber;
    end
end


% --------------------------------------------------------------------
function Edit_Callback(hObject, eventdata, handles)


% --- Executes on button press in joinButton.
function joinButton_Callback(hObject, eventdata, handles)

global editorData;
global musicData1;
global musicData2;

position = 1;
if(handles.position2Button.Value == 1)
    position = 2;
end

if(usefulFunctions.validateStartEndPos1(handles) == 0 || usefulFunctions.validateStartEndPos2(handles) == 0 )
    usefulFunctions.showInvalidNumber;
else
    if(usefulFunctions.validateSounds == 1)
        usefulFunctions.showNoSoundStreamError;
    else
        usefulFunctions.mergeSounds(position,handles);
    end
end




% --- Executes during object creation, after setting all properties.
function audioAxesPos1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to audioAxesPos1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate audioAxesPos1
global axis1;
axis1 = hObject;
set(axis1,'NextPlot','add')


% --- Executes during object creation, after setting all properties.
function audioAxesPos2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to audioAxesPos2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global axis2;
axis2 = hObject;
set(axis2,'NextPlot','add')
