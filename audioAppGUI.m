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

% Last Modified by GUIDE v2.5 21-Nov-2015 20:44:18

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
global volume;
global sampleRate;
global audioPlayerObject;
global playbackSpeed;
global fileSelected;
global outputDeviceSelId;
global soundStream;

% Choose default command line output for audioAppGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using audioAppGUI.
%if strcmp(get(hObject,'Visible'),'off')
%    plot(rand(5));
%end

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

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.audioAxes);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        plot(rand(5));
    case 2
        plot(sin(1:0.01:25.99));
    case 3
        bar(1:.5:10);
    case 4
        plot(membrane);
    case 5
        surf(peaks);
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


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

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on key press with focus on popupmenu1 and none of its controls.
function popupmenu1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on pushbutton1 and none of its controls.
function pushbutton1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in playButton.
function playButton_Callback(hObject, eventdata, handles)
% hObject    handle to playButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global soundStream;
global sampleRate;
global audioPlayerObject;
global plotdata;
global playbackSpeed;
global volume; 

axes(handles.audioAxes);
cla;

if(isempty(soundStream))            
    usefulFunctions.showNoFileError;
else
    audioPlayerObject = audioplayer(soundStream * volume,sampleRate * playbackSpeed);
    play(audioPlayerObject);
    set(handles.sampleRateValue,'String',sampleRate);
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
clear all;
close all;

% --------------------------------------------------------------------
function New_File_Callback(hObject, eventdata, handles)
% hObject    handle to New_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fid = fopen( 'new.wav', 'w' );

%fclose(fid);

% --------------------------------------------------------------------
function Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global soundStream;
global sampleRate;
global filename;
global plotdata;

[filename, pathname] = ...
    uigetfile({'*.wav';'*.mp3'},'Audio Track Selector');
if isequal(filename,0)
    
else
    [soundStream,sampleRate] = audioread(filename);

    %% create the plot of audio samples
   
    %soundDetails = wav
    %h = findobj(gcf,'Tag','audioAxes');
    
    audioPlayerObject = audioplayer(soundStream, sampleRate);
    audioPlayerObject.TimerPeriod = 0.01;    
    axis = findobj(gcf,'Tag','audioAxes')
    audioPlayerObject.TimerFcn = {@usefulFunctions.plotMarker,audioPlayerObject, axis, plotdata};
    audioPlayerObject.TimerPeriod = 0.01; % period of the timer in seconds
    display(gcf);
    gcf; hold on;
    plot(soundStream,'b'); % plot audio data
    title('Audio Data');
    xlabel(strcat('Time (s)'));
    
    ylabel('Amplitude');
    ylimits = get(gca, 'YLim'); % get the y-axis limits
    plotdata = [ylimits(1):0.1:ylimits(2)];
    %figure(gcf);
    hline = plot(zeros(size(plotdata)), plotdata, 'r'); % plot the marker

    %plot(soundStream);
    if isequal(filename,0)
        disp('User selected Cancel')
    else
        disp(['User selected ', fullfile(pathname, filename)])
        set(handles.audioFileSelectedText,'String',filename);
    end
end


% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pauseButton.
function pauseButton_Callback(hObject, eventdata, handles)
% hObject    handle to pauseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global audioPlayerObject
if(isempty(audioPlayerObject))
    usefulFunctions.showNoFileError
else
    if(audioPlayerObject.isplaying)
        pause(audioPlayerObject)
        set(handles.pauseButton,'string','Resume');
    else
        resume(audioPlayerObject)
        set(handles.pauseButton,'string','Pause');
    end
    display (audioPlayerObject);
end


% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global audioPlayerObject;
global soundStream;
if(isempty(audioPlayerObject))
    usefulFunctions.showNoFileError;
else
    stop(audioPlayerObject);
    set(handles.pauseButton,'string','Pause');
    plot(soundStream,'b');
end

% --- Executes when user attempts to close mainFigure.
function mainFigure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to mainFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
clear all;


% --- Executes on slider movement.
function playbackSpeedSlider_Callback(hObject, eventdata, handles)
% hObject    handle to playbackSpeedSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global playbackSpeed;
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.playbackSpeedNoText,'String',get(hObject,'Value') );
playbackSpeed = get(hObject,'Value');



% --- Executes during object creation, after setting all properties.
function playbackSpeedSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to playbackSpeedSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global playbackSpeed;
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
playbackSpeed = get(hObject,'Value');


% --- Executes on selection change in outputDevList.
function outputDevList_Callback(hObject, eventdata, handles)
% hObject    handle to outputDevList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns outputDevList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from outputDevList


% --- Executes during object creation, after setting all properties.
function outputDevList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputDevList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

x = audiodevinfo(0); % get the number of available output devices for the loop
if x > 0
    for i = 1:x
        outDevArr{i} =  audiodevinfo(0,(i-1)); % insert out dev into array        
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
global audioPlayerObject;
global soundStream;
global volume;
global playbackSpeed;
global sampleRate;

volume = hObject.Value;

if(isempty(audioPlayerObject))
    
else    
    audioPlayerObject = audioplayer(soundStream * volume, sampleRate);
    
    if strcmp(audioPlayerObject.Running, 'on')
        play(audioPlayerObject,sampleRate);
    end
end



% --- Executes during object creation, after setting all properties.
function volumeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volumeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global volume;
volume = hObject.Value;
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
