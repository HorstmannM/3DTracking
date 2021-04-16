        
function VideoControl()
h=struct(); % structure for all gui-elements, storage for variables to be shared among callbacks

cd 'S:\Admin\Tracking\necessary files'
calib=load('cameraCalibrations_200918.mat');

% definition of main figure
h.main = figure('Tag', 'Main','Position', [300 250 1120 700],'Name', 'EvoOeko-3D-Tracking', ...
    'MenuBar', 'none','NumberTitle', 'off','Resize','on');
set(h.main,'WindowKeyPressFcn', @key_pressed);
%---------------------------------------------------------------------
        
% Create panels, sub groups of the main figure

h.info = uipanel('Parent', h.main,'Tag', 'info','Units', 'pix', ...
    'Position', [10 300 200 400],'Units', 'norm','Title', 'Info');

h.camera = uipanel('Parent', h.main,'Tag', 'control','Units', 'pix', ...
       'Position', [10 10 200 280],'Units', 'norm','Title', 'Camera');
  
h.video = uipanel('Parent', h.main,'Tag', 'decide','Units', 'pix', ...
    'Position', [220 550 890 150],'Units', 'norm','Title', 'Video');

h.event = uipanel('Parent', h.main,'Tag', 'event','units','pix', ...
    'Position', [220 10 890 530],'Units', 'norm');
% -------------------------------------------------------------------

% Create headers and buttons for all panels

% ***************** Info Panel ***************************************

uicontrol('Par',h.info,'Style','togglebutton','String','Information',...
    'units','pix','Pos',[10 350 180 40],'Units','norm','enable','inactive', ...
    'FontSize',12,'Value',0);

curFol=pwd;
h.cur_Fol =  uicontrol('Par',h.info,'Style','edit','String',curFol,...
    'units','pix','Pos',[10 230 180 120],'Units','norm','enable','inactive', ...
    'Value',0,'BackgroundColor','[.83 .83 .83]');
textVideo{1,3}=('No video loaded!');
textVideo{1,4}=('No video loaded!');
textVideo{1,6}=('Current frame: ');

h.vid_Info =  uicontrol('Par',h.info,'Style','edit','String',textVideo,...
    'units','pix','Pos',[10 120 180 100],'Units','norm','enable','inactive', ...
    'Value',0,'BackgroundColor','[.83 .83 .83]', 'Max', 2);

data=struct();                          %data structure for temporal initialisation
data.captureDuration=[];                %in seconds; how many seconds shall be recorded?
data.minutes=[];                        %in minutes; how many minutes shall be reserved for acclimatisation?
textRecordOptions{1,1}=('');
textRecordOptions{1,2}=('Video settings:');
textRecordOptions{1,4}=['Video length in seconds: ', num2str(data.captureDuration)];
textRecordOptions{1,3}=['Acclimatisation time in seconds: ',num2str(data.minutes)];
textRecordOptions{1,7}='User free text: ';
textRecordOptions{1,5}='Video type: ';

%textRecordOptions{1,3}=[num2str(data.minutes)]
h.vid_set_Info =  uicontrol('Par',h.info,'Style','edit','String', textRecordOptions,...
    'units','pix','Pos',[10 10 180 100],'Units','norm','enable','inactive', ...
    'Value',0,'BackgroundColor','[.83 .83 .83]', 'Max', 2);
%**********************************************************************

%************************ Camera Panel ********************************

h.connect = uicontrol('Parent', h.camera,'Tag', 'connect','Style','pushbutton', ...
    'Units', 'pix','Position', [10 205 180 55],'enable','on', ...
    'String', 'Connect cameras','FontSize',12,'Units', 'norm','Callback', @connect);

h.live = uicontrol('Parent', h.camera,'Tag', 'live','Style', 'pushbutton', ...
    'Units', 'pix','Position', [10 75 180 55],'enable','on', ...
    'String', 'Live view','FontSize',12,'Units', 'norm', ...
    'Callback', @live);

h.reset = uicontrol('Parent', h.camera,'Tag', 'reset','Style', 'pushbutton', ...
    'Units', 'pix','Position', [10 140 180 55],'enable','on', ...
    'String', 'Disconnect cameras','FontSize',12,'Units', 'norm', ...
    'Callback', @reset);

h.stop = uicontrol('Parent', h.camera,'Tag', 'stop','Style', 'pushbutton', ...
    'Units', 'pix','Position', [10 10 180 55],'enable','on', ...
    'String', 'Play / load video pair','FontSize',12,'Units', 'norm','Callback', @stop);
%**********************************************************************

%************************ Event Panel *********************************

h.ax = axes('Parent',h.event,'Units','Pix','Position',[30 30 830 480],'Tag','Axes','Units', 'norm');
%**********************************************************************

%************************ Video Panel *********************************

uicontrol('Par',h.video,'Style','togglebutton','String','1: Video',...
    'units','pix','Pos',[5 100 172 40],'Units','norm','enable','inactive', ...
    'BackgroundColor','[.75 .75 .75]','Foregroundcolor','w','FontSize',12,'Value',0);

uicontrol('Par',h.video,'Style','togglebutton','String','2: Position detection',...
    'units','pix','Pos',[182 100 172 40],'Units','norm','enable','inactive', ...
    'BackgroundColor','[.75 .75 .75]','Foregroundcolor','w','FontSize',12,'Value',0);

uicontrol('Par',h.video,'Style','togglebutton','String','3: 2D',...
    'units','pix','Pos',[359 100 172 40],'Units','norm','enable','inactive', ...
    'BackgroundColor','[.75 .75 .75]','Foregroundcolor','w','FontSize',12,'Value',0);

uicontrol('Par',h.video,'Style','togglebutton','String','4: 3D',...
    'units','pix','Pos',[536 100 172 40],'Units','norm','enable','inactive', ...
    'BackgroundColor','[.75 .75 .75]','Foregroundcolor','w','FontSize',12,'Value',0);

uicontrol('Par',h.video,'Style','togglebutton','String','5: Results',...
    'units','pix','Pos',[713 100 172 40],'Units','norm','enable','inactive', ...
    'BackgroundColor','[.75 .75 .75]','Foregroundcolor','w','FontSize',12,'Value',0);


h.VS = uicontrol('Parent', h.video,'Tag', 'Video setup','Style','pushbutton', ...
    'Units', 'pix','Position', [5 55 172 40],'enable','on', ...
    'String', 'Video settings','FontSize',12,'Units', 'norm','Callback', @VideoSetup);

h.DSV = uicontrol('Parent', h.video,'Tag', 'DetectionSingleVid','Style', 'pushbutton', ...
    'Units', 'pix','Position', [182 55 172 40],'enable','on', ...
    'String', 'Single video pair','FontSize',12,'Units', 'norm','Callback', @DetSingleVideo);

h.SYNC = uicontrol('Parent', h.video,'Tag', 'Synchronisation','Style', 'pushbutton', ...
    'Units', 'pix','Position', [359 55 172 40],'enable','on', ...
    'String', 'Synchronisation','FontSize',12,'Units', 'norm','Callback', @Synchronisation);

h.CALC = uicontrol('Parent', h.video,'Tag', 'Calculation','Style', 'pushbutton', ...
    'Units', 'pix','Position', [536 55 172 40],'enable','on', ...
    'String', '3D calculation','FontSize',12,'Units', 'norm','Callback', @Calculation);

h.VRES = uicontrol('Parent', h.video,'Tag', 'ViewResult','Style', 'pushbutton', ...
    'Units', 'pix','Position', [713 10 172 40],'enable','on', ...
    'String', 'View results','FontSize',12,'Units', 'norm','Callback', @ViewResults);

h.VR = uicontrol('Parent', h.video,'Tag', 'Video recording','Style','pushbutton', ...
    'Units', 'pix','Position', [5 10 172 40],'enable','on', ...
    'String', 'Video recording','FontSize',12,'Units', 'norm','Callback', @VideoRecording);

h.DON = uicontrol('Parent', h.video,'Tag', 'DetectionOvernight','Style', 'pushbutton', ...
    'Units', 'pix','Position', [182 10 172 40],'enable','on', ...
    'String', 'Multiple video pairs','FontSize',12,'Units', 'norm','Callback', @DetOvernight);

h.TRACK = uicontrol('Parent', h.video,'Tag', 'Synchronisation','Style', 'pushbutton', ...
    'Units', 'pix','Position', [359 10 172 40],'enable','on', ...
    'String', '2D tracking','FontSize',12,'Units', 'norm','Callback', @Tracking);

h.PLOT = uicontrol('Parent', h.video,'Tag', 'Plot','Style', 'pushbutton', ...
    'Units', 'pix','Position', [536 10 172 40],'enable','on', ...
    'String', '3D plot','FontSize',12,'Units', 'norm','Callback', @D_Plot);

h.SRES = uicontrol('Parent', h.video,'Tag', 'SaveResult','Style', 'pushbutton', ...
    'Units', 'pix','Position', [713 55 172 40],'enable','on', ...
    'String', 'Write results','FontSize',12,'Units', 'norm','Callback', @SaveResults);
%--------------------------------------------------------------------

%--------------------------------------------------------------------
% all functions that can be called via callbacks of the buttons

    function connect(~,~)
        %create raspi connection
        rpi1 = raspi('192.168.178.22', 'pi', 'raspberry');
        rpi2 = raspi('192.168.178.23', 'pi', 'raspberry');
        setappdata(h.main, 'rpi1', rpi1)
        setappdata(h.main, 'rpi2', rpi2)
        
        %setup cameras on the raspi
        cam1 = cameraboard(getappdata(h.main, 'rpi1'), 'Resolution', '1920x1080', 'FrameRate', 30, 'Rotation', 180, 'Brightness', 50, 'Contrast', 50,  'ExposureMode', 'backlight', 'Sharpness', 100);
        cam2 = cameraboard(getappdata(h.main, 'rpi2'), 'Resolution', '1920x1080', 'FrameRate', 30, 'Rotation', 180, 'Brightness', 50, 'Contrast', 50,  'ExposureMode', 'backlight', 'Sharpness', 100);
        setappdata(h.main, 'cam1', cam1)
        setappdata(h.main, 'cam2', cam2)
        
        set(h.connect, 'BackgroundColor', [0.9 0.2 0])
        disp('Connecting of cameras successful!')
    end

    function live(~,~)
        %checking cameras
        rpi1=getappdata((h.main),'rpi1');
        con=isempty(rpi1);
        
        if (con==1)
            disp('You need to connect the cameras beforehand.')
        else
            %Livestream for checking cam 1+2
            set(h.live, 'BackgroundColor', [0.9 0.2 0])
            %Define the length of the live view
            prompt={'Define the duration of the live view in seconds [s], stop at any time with ´Esc´:'};
            answer=inputdlg(prompt,'Live image settings',1,{'10'});
            liveDur=str2double(answer{1});
            %loop for the live view
            for i = 1:(liveDur*5)
                subplot(1,2,1)
                img1=snapshot(getappdata((h.main),'cam1'));
                image(img1);
                title('Video from Raspberry Pi Red')
                axis equal
                subplot(1,2,2)
                img2=snapshot(getappdata((h.main),'cam2'));
                image(img2);
                title('Video from Raspberry Pi Green')
                axis equal
                drawnow;
                set(gcf,'KeyPressFcn', @key_pressed);
                
                if i==20
                    writeDigitalPin(getappdata(h.main, 'rpi1'), 24, 1);
                elseif i==40
                    writeDigitalPin(getappdata(h.main, 'rpi1'), 24, 0);
                else
                end
                
            end
            disp('Live view finished!');
        end
        
        set(h.live, 'BackgroundColor', [0.94 0.94 0.94])
    end

    function reset(~,~)
        delete=[];
        setappdata(h.main, 'rpi1', delete)
        setappdata(h.main, 'rpi2', delete)
        setappdata(h.main, 'cam1', delete)
        setappdata(h.main, 'cam2', delete)
        
        set(h.connect, 'BackgroundColor', [0.94 0.94 0.94])
        disp('Disconnecting of cameras successful!');
    end

    function stop(~,~)
        play = MFquestdlg([ 1.4 , 0.45 ],'Do you want to watch the current video pair or load another one?', ...
            'Play/Load Video', ...
            'Play current video pair','Load another video pair','Play current video pair');
        switch play
            case 'Play current video pair'
                %get nececssary data for playing video
                vid1=getappdata(h.main, 'vid1');
                vid2=getappdata(h.main, 'vid2');
                
                ex=isempty(vid1);   %check whether videos to be played exists
                
                %play videos
                if (ex==1)
                    disp('You need to capture a video/load a figure beforehand.')
                elseif (ex==0)
                    set(h.stop, 'BackgroundColor', [0.9 0.2 0])
                    choice = MFquestdlg([ 1.4 , 0.45 ],'How much of the video do you want to watch?', ...
                        'Play Video', ...
                        'Show first 10 seconds of the video','Show first 15 seconds of the video','Show the whole video','Show first 10 seconds of the video');
                    switch choice
                        case 'Show first 10 seconds of the video'
                            disp(choice)
                            for k = 1:300
                                if k<vid1.NumberOfFrames
                                    subplot(1,2,1)
                                    image(read(vid1, k));
                                    axis equal
                                    title('Video from Raspberry Pi red')
                                    subplot(1,2,2)
                                    image(read(vid2, k));
                                    axis equal
                                    title('Video from Raspberry Pi green')
                                    drawnow;
                                else
                                    disp('Your video is shorter than 10 seconds.')
                                    break;
                                end
                            end
                        case 'Show first 15 seconds of the video'
                            disp(choice)
                            for k = 1:450
                                if k<vid1.NumberOfFrames
                                    subplot(1,2,1)
                                    image(read(vid1, k));
                                    axis equal
                                    title('Video from Raspberry Pi red')
                                    subplot(1,2,2)
                                    image(read(vid2, k));
                                    axis equal
                                    title('Video from Raspberry Pi green')
                                    drawnow;
                                else
                                    disp('Your video is shorter than 15 seconds.')
                                    break;
                                end
                            end
                        case 'Show the whole video'
                            disp(choice)
                            for k = 1:vid1.NumberOfFrames
                                subplot(1,2,1)
                                image(read(vid1, k));
                                axis equal
                                title('Video from Raspberry Pi red')
                                subplot(1,2,2)
                                image(read(vid2, k));
                                axis equal
                                title('Video from Raspberry Pi green')
                                drawnow;
                            end
                    end
                    set(h.stop, 'BackgroundColor', [0.94 0.94 0.94])
                end
            case 'Load another video pair'
                close
                cd 'S:\Admin\Tracking\raw data-input'
                uiopen('figure')
                disp('Video pair successfully loaded!')
        end
    end

    function VideoSetup(~,~)
        ffmpegDir = 'S:\Admin\Tracking\necessary files\ffmpeg-20170208-3aae1ef-win64-static';
        setappdata(h.main, 'ffmpegDir', ffmpegDir)
        
        prompt={'Enter acclimatisation time, which gives the time until recording starts, in seconds:','Enter video length in seconds:', 'Enter any free text that is important for you:'};
        dlg_title='Video settings';
        num_lines=1;
        defaultans={'5', '90', ''};
        answer=inputdlg(prompt,dlg_title,num_lines,defaultans);
        captureDuration=str2double(answer{2,1});
        minutes=str2double(answer{1,1});
        freeText=answer{3,1};
        textRecordOptions{1,4}=['Video length in seconds: ', num2str(captureDuration)];
        textRecordOptions{1,3}=['Acclimatisation time in seconds: ',num2str(minutes)];
        textRecordOptions{1,7}=['User free text: ', freeText];
        set(h.vid_set_Info, 'String', textRecordOptions)
        setappdata(h.main, 'minutes', minutes)
        setappdata(h.main, 'captureDuration', captureDuration)
        setappdata(h.main, 'freeText', freeText)
        
        set(h.VS, 'BackgroundColor', [0 0.9 0])
        disp('Video settings successful!');
    end

    function VideoRecording(~,~)
        cd 'S:\Admin\Tracking\raw data-input\1_record';
        set(h.VR, 'BackgroundColor', [1 1 0])
        
        choice = MFquestdlg([ 1.4 , 0.45 ],'Are the cameras connected (visible as red button)?', ...
            'Camera connection', ...
            'Yes','No','Yes');
        switch choice
            case 'Yes'
                rpi1=getappdata((h.main),'rpi1');
                con1=isempty(rpi1);
                rpi2=getappdata((h.main),'rpi2');
                con2=isempty(rpi2);
                
                if con1==1 && con2==1
                    disp('Cameras were not connected.')
                    MFquestdlg([ 1.4 , 0.45 ],'Cameras were not connected. Trying to establish a connection to the cameras.', 'Connection Warning', 'Ok', 'Cancel', 'Ok');
                    
                    reset();
                    rpi1=[];
                    rpi2=[];
                    disp('Trying to establish a connection to the cameras.')
                    connect();
                    VideoRecording();
                    
                elseif con1==0 && con2==0
                    choice = MFquestdlg([ 1.4 , 0.45 ],'What kind of video are you about to record?', ...
                        'Video type ', ...
                        'White Background','Black Background','Infrared','White Background');
                    switch choice
                        case 'White Background'
                            disp(choice)
                            textRecordOptions{1,5}='Video type: White Background';
                            set(h.vid_set_Info, 'String', textRecordOptions)
                        case 'Black Background'
                            disp(choice)
                            textRecordOptions{1,5}='Video type: Black Background';
                            set(h.vid_set_Info, 'String', textRecordOptions)
                        case 'Infrared'
                            disp(choice)
                            textRecordOptions{1,5}='Video type: Infrared';
                            set(h.vid_set_Info, 'String', textRecordOptions)
                    end
                    
                    countd=getappdata(h.main, 'minutes');
                    i=0;
                    while i<countd     %acclimatisation pause
                        disp(['Acclimatisation done in ', num2str(countd-i), ' seconds.']);
                        i=i+1;
                        pause(1);
                    end
                    timecode2=datetime('now', 'Format', 'dd_MM_y_HH_mm_ss');                    %capture the time at start of recording
                    setappdata(h.main, 'timecode2', timecode2)
                    timeBegin=datestr(timecode2);
                    set(h.VR, 'BackgroundColor', [0.9 0.2 0])
                    disp('Recording started at: ')
                    disp(timeBegin)
                    captureDuration=getappdata(h.main, 'captureDuration');
                    record(getappdata((h.main),'cam2'), 'vid2.h264', captureDuration)          %record simultaneously from both cameras
                    record(getappdata((h.main),'cam1'), 'vid1.h264', captureDuration)          %record simultaneously from both cameras
                    
                    %turn on and off the infrared LED to synchronize videos later on
                    pause(1.5)
                    writeDigitalPin(getappdata(h.main, 'rpi1'), 24, 1);
                    pause(0.5)
                    writeDigitalPin(getappdata(h.main, 'rpi1'), 24, 0);
                    
                    i=0;
                    while i<captureDuration     %acclimatisation pause
                        disp(['Recording done in ', num2str(captureDuration-i), ' seconds.']);
                        i=i+1;
                        pause(1);
                    end
                    pause(5);           %to enable the raspi to save the video
                    timeEnd=datestr(clock);
                    S(1)=load('gong');       %load sounds
                    S(2)=load('handel');
                    set(h.VR, 'BackgroundColor', [0 0.9 0])
                    
                    set(h.DSV, 'BackgroundColor', [0.94 0.94 0.94])     %reset colours of all buttons
                    set(h.DON, 'BackgroundColor', [0.94 0.94 0.94])
                    set(h.SYNC, 'BackgroundColor', [0.94 0.94 0.94])
                    set(h.TRACK, 'BackgroundColor', [0.94 0.94 0.94])
                    set(h.CALC, 'BackgroundColor', [0.94 0.94 0.94])
                    set(h.PLOT, 'BackgroundColor', [0.94 0.94 0.94])
                    set(h.SRES, 'BackgroundColor', [0.94 0.94 0.94])
                    set(h.VRES, 'BackgroundColor', [0.94 0.94 0.94])
                    
                    sound(S(1).y)       %play sounds with slight time delay
                    pause(1)
                    sound(S(2).y)
                    
                    %transfer file from raspi to host computer
                    getFile(getappdata(h.main, 'rpi1'), 'vid1.h264');
                    getFile(getappdata(h.main, 'rpi2'), 'vid2.h264');
                    ffmpegDir=getappdata(h.main, 'ffmpegDir');
                    freeText=getappdata(h.main, 'freeText');
                    
                    %convert video to mp4, exit.txt has to be in the working directory
                    % Video Raspi red
                    cmd = ['"' fullfile(ffmpegDir, 'bin', 'ffmpeg.exe') '" -r 30 -i vid1.h264 -vcodec copy myvid1.mp4 &''exit.txt'];
                    [~, ~] = system(cmd);
                    filename1=sprintf('%s_%s_1.mp4', timecode2, freeText);
                    setappdata(h.main, 'filename1', filename1)
                    movefile('myvid1.mp4', filename1);
                    disp('Video1 downloaded from Raspberry')
                    
                    % Video Raspi green
                    cmd = ['"' fullfile(ffmpegDir, 'bin', 'ffmpeg.exe') '" -r 30 -i vid2.h264 -vcodec copy myvid2.mp4 &''exit.txt'];
                    [~, ~] = system(cmd);
                    filename2=sprintf('%s_%s_2.mp4', timecode2, freeText);
                    setappdata(h.main, 'filename2', filename2)
                    movefile('myvid2.mp4', filename2);
                    disp('Video2 downloaded from Raspberry')
                    
                    % load videos into Matlab
                    vid1 = VideoReader(filename1);
                    vid2 = VideoReader(filename2);
                    
                    setappdata(h.main, 'vid1', vid1)
                    setappdata(h.main, 'vid2', vid2)
                    textVideo{1,3}=filename1;
                    textVideo{1,4}=filename2;
                    set(h.vid_Info, 'String', textVideo)
                    cd 'S:\Admin\Tracking\raw data-input\1_record'
                    
                    progress='RC';
                    filename3=sprintf('%s_%s_%s.fig', timecode2, freeText, progress);
                    setappdata(h.main, 'filename3', filename3)
                    savefig(filename3);
                    
                    curFol=pwd;
                    set(h.cur_Fol, 'String', curFol)
                    disp('Video recording successful!')
                    disp('Recording started at: ')
                    disp(timeBegin)
                    disp('Recording ended at (ca.): ')
                    disp(timeEnd)
                    
                    %play videos in Matlab video player?
                    choice = MFquestdlg([ 1.4 , 0.45 ],'Do you want to watch the video that you have just recorded?', ...
                        'View video', ...
                        'Show 1/10th of the video','Show the whole video','Don´t show the video','Show 1/10th of the video');
                    switch choice
                        case 'Show 1/10th of the video'
                            disp(choice)
                            set(h.stop, 'BackgroundColor', [0.9 0.2 0])
                            for k = 1:((vid1.NumberOfFrames)/10)
                                subplot(1,2,1)
                                image(read(vid1, k));
                                title('Video from Raspberry Pi Red')
                                axis equal
                                subplot(1,2,2)
                                image(read(vid2, k));
                                title('Video from Raspberry Pi Green')
                                axis equal
                                drawnow;
                            end
                            set(h.stop, 'BackgroundColor', [0.94 0.94 0.94])
                        case 'Show the whole video'
                            disp(choice)
                            set(h.stop, 'BackgroundColor', [0.9 0.2 0])
                            for k = 1:vid1.NumberOfFrames
                                subplot(1,2,1)
                                image(read(vid1, k));
                                title('Video from Raspberry Pi Red')
                                axis equal
                                subplot(1,2,2)
                                image(read(vid2, k));
                                title('Video from Raspberry Pi Green')
                                axis equal
                                drawnow;
                            end
                            set(h.stop, 'BackgroundColor', [0.94 0.94 0.94])
                        case 'Don´t show the video'
                            disp(choice)
                    end
                else
                    disp('Please check the connection to the cameras.')
                end
            case 'No'
                set(h.VR, 'BackgroundColor', [0.94 0.94 0.94])
                terminateExecution;
                disp('Recording was interrupted. Please connect cameras beforehand.')
        end
    end

    function DetSingleVideo(~,~)
        cd 'S:\Admin\Tracking\raw data-input\1_record';
        MFquestdlg([ 1.4 , 0.45 ],'Please make sure that both orginal videos as well as the record-figure are in the folder for video recording.', 'Important Note', 'Ok', 'Cancel', 'Ok');
        
        %(Re-)Blopping with altered threshold
        %--------------------------------------------------------------------------
        prompt={'Enter the lower size boundary of your animals (in pixels, recommended: ~15): ','Enter the upper size boundary of your animals (in pixels, recommended: ~800):'};
        dlg_title='Detection size boundaries';
        num_lines=1;
        defaultans={'5', '800'};
        answer=inputdlg(prompt,dlg_title,num_lines,defaultans);
        lowerB=str2double(answer(1,1));
        upperB=str2double(answer(2,1));
        
        prompt={'Enter the requested threshold value (WB: 40, BB: 40, IR: 45):'};
        dlg_title='Set threshold value';
        num_lines=1;
        defaultans={'35'};
        thresh=inputdlg(prompt,dlg_title,num_lines,defaultans);
        thresh=str2num(cell2mat(thresh));
        setappdata(h.main, 'thresh', thresh)
        vid1=getappdata(h.main, 'vid1');
        vid2=getappdata(h.main, 'vid2');
        set(h.DSV, 'BackgroundColor', [0.9 0.2 0])
        %----------------------------------------------------------------
        
        % determine blops for Camera/Raspi Red
        blobM=[];
        for k = calib.firstFrame:1:(vid1.NumberOfFrames-10)
            img11 = read(vid1, k);
            [img11u,~] = undistortImage(img11,calib.cameraParams_red);
            img12 = read(vid1, k+10);
            [img12u,~] = undistortImage(img12,calib.cameraParams_red);
            originalImage=imsubtract(img11u, img12u);        %use the images coorected by the calibartion parameters
            %originalImage=imsubtract(img11, img12);         %use the images uncoorected by the calibartion parameters
            
            % Convert to grayscale
            originalImage = rgb2gray(originalImage);
            binaryImage = originalImage > thresh; % Bright objects will be chosen if you use >.
            % Do a "hole fill" to get rid of any background pixels or "holes" inside the blobs.
            binaryImage = imfill(binaryImage, 'holes');
            % Identify individual blobs by seeing which pixels are connected to each other.
            % Each group of connected pixels will be given a label, a number, to identify it and distinguish it from the other blobs.
            % Do connected components labeling with either bwlabel() or bwconncomp().
            labeledImage = bwlabel(binaryImage, 8);     % Label each blob so we can make measurements of it
            % labeledImage is an integer-valued image where all pixels in the blobs have values of 1, or 2, or 3, or ... etc.
            
            blobMeasurements = regionprops(labeledImage, originalImage, 'all');
            setappdata(h.main, 'blobMeasurements', blobMeasurements)
            numberOfBlobs = size(blobMeasurements, 1);
            setappdata(h.main, 'numberOfBlobs', numberOfBlobs)
          
            l=0;
            for a = 1 : numberOfBlobs           % Loop through all blobs to create a new list of blobs with limited size
                
                if (blobMeasurements(a).Area > lowerB && blobMeasurements(a).Area < upperB)
                    
                    l=l+1;
                    blobM.(['frame' num2str(k)])(l).Area=blobMeasurements(a).Area;
                    blobM.(['frame' num2str(k)])(l).Centroid=blobMeasurements(a).Centroid;
                else
                    %end the loop after all centroids and areas are copied to the new
                    %list
                end
            end
            
            if isfield(blobM, (['frame' num2str(k)]))       %check whether structures were created for every frame, otherwise create at least one blob and Area field
                %thats good! :-) Nothing else to do
            else
                l=l+1;
                blobM.(['frame' num2str(k)])(l).Area=[];
                blobM.(['frame' num2str(k)])(l).Centroid=[0 0];
            end
            disp(k)       %count the number of frames already handled
        end
        setappdata(h.main, 'blobM', blobM)
        %----------------------------------------------------------------
        
        % blop detection for Camera/Raspi Green
        blobM2=[];
        for k2 = calib.firstFrame:1:(vid2.NumberOfFrames-10)
            img11 = read(vid2, k2);
            [img11u,~] = undistortImage(img11,calib.cameraParams_green);
            img12 = read(vid2, k2+10);
            [img12u,~] = undistortImage(img12,calib.cameraParams_green);
            originalImage=imsubtract(img11u, img12u);        %use the images coorected by the calibartion parameters
            %originalImage=imsubtract(img11, img12);         %use the images uncoorected by the calibartion parameters
            
            % Convert to grayscale
            originalImage = rgb2gray(originalImage);
            binaryImage = originalImage > thresh; % Bright objects will be chosen if you use >.
            % Do a "hole fill" to get rid of any background pixels or "holes" inside the blobs.
            binaryImage = imfill(binaryImage, 'holes');
            % Identify individual blobs by seeing which pixels are connected to each other.
            % Each group of connected pixels will be given a label, a number, to identify it and distinguish it from the other blobs.
            % Do connected components labeling with either bwlabel() or bwconncomp().
            labeledImage = bwlabel(binaryImage, 8);     % Label each blob so we can make measurements of it
            % labeledImage is an integer-valued image where all pixels in the blobs have values of 1, or 2, or 3, or ... etc.
            blobMeasurements2 = regionprops(labeledImage, originalImage, 'all');
            numberOfBlobs2 = size(blobMeasurements2, 1);
            setappdata(h.main, 'blobMeasurements2', blobMeasurements2)
            setappdata(h.main, 'numberOfBlobs2', numberOfBlobs2)
           
            l=0;
            for a = 1 : numberOfBlobs2           % Loop through all blobs to create a new list of blobs with limited size
                
                if (blobMeasurements2(a).Area > lowerB && blobMeasurements2(a).Area < upperB)
                    
                    l=l+1;
                    blobM2.(['frame' num2str(k2)])(l).Area=blobMeasurements2(a).Area;
                    blobM2.(['frame' num2str(k2)])(l).Centroid=blobMeasurements2(a).Centroid;
                else
                    %end the loop after all centroids and areas are copied to the new
                    %list
                end
            end
            
            if isfield(blobM2, (['frame' num2str(k2)]))         %check whether structures were created for every frame, otherwise create at least one blob and Area field
                %     thats good! :-) Nothing else to do
            else
                l=l+1;
                blobM2.(['frame' num2str(k2)])(l).Area=[];
                blobM2.(['frame' num2str(k2)])(l).Centroid=[0 0];
            end
            disp(k2)     %count the number of frames already handled
        end
        
        setappdata(h.main, 'blobM2', blobM2)
        setappdata(h.main, 'thresh', thresh)
        setappdata(h.main, 'upperB', upperB)
        setappdata(h.main, 'lowerB', lowerB)
        
        timecode2=getappdata(h.main, 'timecode2');
        freeText=getappdata(h.main, 'freeText');
        
        %Save progress
        cd 'S:\Admin\Tracking\raw data-input\2_singleVideo'
        progress='DS';
        filename3=sprintf('%s_%s_%s.fig', timecode2, freeText, progress);
        setappdata(h.main, 'filename3', filename3)
        
        curFol=pwd;
        set(h.cur_Fol, 'String', curFol)
        set(h.DSV, 'BackgroundColor', [0 0.9 0])
        savefig(filename3);
        disp('Single video detection successful!')
    end

    function DetOvernight(~,~)
        
        cd 'S:\Admin\Tracking\raw data-input\1_record'
        listFolderFigs=dir('*_RC.fig');
        FigArray=struct2cell(listFolderFigs);
        
        prompt={'Enter the lower size boundary of your animals (in pixels, recommended: ~15): ','Enter the upper size boundary of your animals (in pixels, recommended: ~800):'};
        dlg_title='Detection size boundaries';
        num_lines=1;
        defaultans={'5', '800'};
        answer=inputdlg(prompt,dlg_title,num_lines,defaultans);
        lowerB=str2double(answer(1,1));
        upperB=str2double(answer(2,1));
        
        % Set threshold values for blob detection
        prompt={'Enter the requested threshold value (recommended: WB: 40, BB: 40, IR: 45):'};
        dlg_title='Set threshold value';
        num_lines=1;
        defaultans={'35'};
        thresh=inputdlg(prompt,dlg_title,num_lines,defaultans);
        thresh=str2num(cell2mat(thresh));
        setappdata(h.main, 'thresh', thresh)
        MFquestdlg([ 1.4 , 0.45 ],['Please make sure that for every video pair both orginal videos as well as the record-figure are in the folder for video recording.' sprintf('\n') 'Furthermore, only videos of one background type and animal size should be processed within one ´Multiple videos´-processing.'], 'Important Note', 'Ok', 'Cancel', 'Ok');
        
        %load necessary data
        set(h.DON, 'BackgroundColor', [0.9 0.2 0])
        
        for i=1:(size(FigArray,2))
            filename=char(FigArray(1,i));
            cd 'S:\Admin\Tracking\raw data-input\1_record';
            currentFig=load(filename, '-mat');
            fig=gcf;
            close
            ex=isfield(currentFig.hgS_070000.properties.ApplicationData, 'filename2');
            set(h.DON, 'BackgroundColor', [0.9 0.2 0])
            if (ex==0)
                disp('This recording is damaged. Moving on to the next recording.')
                disp('Erroneous video pair:');
                disp(i);
            elseif (ex==1)
                filename2=currentFig.hgS_070000.properties.ApplicationData.filename2;
                setappdata(h.main, 'filename2', filename2);
                filename1=currentFig.hgS_070000.properties.ApplicationData.filename1;
                setappdata(h.main, 'filename1', filename1);
                timecode2=currentFig.hgS_070000.properties.ApplicationData.timecode2;
                setappdata(h.main, 'timecode2', timecode2);
                captureDuration=currentFig.hgS_070000.properties.ApplicationData.captureDuration;
                setappdata(h.main, 'captureDuration', captureDuration);
                minutes=currentFig.hgS_070000.properties.ApplicationData.minutes;
                setappdata(h.main, 'minutes', minutes);
                vid1=currentFig.hgS_070000.properties.ApplicationData.vid1;
                setappdata(h.main, 'vid1', vid1);
                vid2=currentFig.hgS_070000.properties.ApplicationData.vid2;
                setappdata(h.main, 'vid2', vid2);
                filename3=currentFig.hgS_070000.properties.ApplicationData.filename3;
                setappdata(h.main, 'filename3', filename3);
                freeText=currentFig.hgS_070000.properties.ApplicationData.freeText;
                setappdata(h.main, 'freeText', freeText);
                %----------------------------------------------------------------
                
                % determine blops for Camera/Raspi Red
                blobM=[];
                for k = calib.firstFrame:1:(vid1.NumberOfFrames-10)
                    img11 = read(vid1, k);
                    [img11u,~] = undistortImage(img11,calib.cameraParams_red);
                    img12 = read(vid1, k+10);
                    [img12u,~] = undistortImage(img12,calib.cameraParams_red);
                    originalImage=imsubtract(img11u, img12u);
                    %originalImage=imsubtract(img11, img12);         %use the images uncoorected by the calibartion parameters
                    
                    % Convert to grayscale
                    originalImage = rgb2gray(originalImage);
                    binaryImage = originalImage > thresh; % Bright objects will be chosen if you use >.
                    % Do a "hole fill" to get rid of any background pixels or "holes" inside the blobs.
                    binaryImage = imfill(binaryImage, 'holes');
                    % Identify individual blobs by seeing which pixels are connected to each other.
                    % Each group of connected pixels will be given a label, a number, to identify it and distinguish it from the other blobs.
                    % Do connected components labeling with either bwlabel() or bwconncomp().
                    labeledImage = bwlabel(binaryImage, 8);     % Label each blob so we can make measurements of it
                    % labeledImage is an integer-valued image where all pixels in the blobs have values of 1, or 2, or 3, or ... etc.
                    
                    blobMeasurements = regionprops(labeledImage, originalImage, 'all');
                    setappdata(h.main, 'blobMeasurements', blobMeasurements)
                    numberOfBlobs = size(blobMeasurements, 1);
                    setappdata(h.main, 'numberOfBlobs', numberOfBlobs)
                    
                    l=0;
                    for a = 1 : numberOfBlobs           % Loop through all blobs to create a new list of blobs with limited size
                        
                        if (blobMeasurements(a).Area > lowerB && blobMeasurements(a).Area < upperB)
                            l=l+1;
                            blobM.(['frame' num2str(k)])(l).Area=blobMeasurements(a).Area;
                            blobM.(['frame' num2str(k)])(l).Centroid=blobMeasurements(a).Centroid;
                        else
                            %end the loop after all centroids and areas are copied to the new
                            %list
                        end
                    end
                    
                    if isfield(blobM, (['frame' num2str(k)]))       %check whether structures were created for every frame, otherwise create at least one blob and Area field
                        %   thats good! :-) Nothing else to do
                    else
                        l=l+1;
                        blobM.(['frame' num2str(k)])(l).Area=[];
                        blobM.(['frame' num2str(k)])(l).Centroid=[0 0];
                    end
                    disp(['videopair: ', num2str(i),', Camera 1, frame: ', num2str(k)])       %count the number of frames already handled
                end
                
                setappdata(h.main, 'blobM', blobM)
                
                
                % blop detection for Camera/Raspi Green
                blobM2=[];
                for k2 = calib.firstFrame:1:(vid2.NumberOfFrames-10)
                    img11 = read(vid2, k2);
                    [img11u,~] = undistortImage(img11,calib.cameraParams_green);
                    img12 = read(vid2, k2+10);
                    [img12u,~] = undistortImage(img12,calib.cameraParams_green);
                    originalImage=imsubtract(img11u, img12u);
                    %originalImage=imsubtract(img11, img12);         %use the images uncoorected by the calibartion parameters
                    
                    % Convert to grayscale
                    originalImage = rgb2gray(originalImage);
                    binaryImage = originalImage > thresh; % Bright objects will be chosen if you use >.
                    % Do a "hole fill" to get rid of any background pixels or "holes" inside the blobs.
                    binaryImage = imfill(binaryImage, 'holes');
                    % Identify individual blobs by seeing which pixels are connected to each other.
                    % Each group of connected pixels will be given a label, a number, to identify it and distinguish it from the other blobs.
                    % Do connected components labeling with either bwlabel() or bwconncomp().
                    labeledImage = bwlabel(binaryImage, 8);     % Label each blob so we can make measurements of it
                    % labeledImage is an integer-valued image where all pixels in the blobs have values of 1, or 2, or 3, or ... etc.
                    blobMeasurements2 = regionprops(labeledImage, originalImage, 'all');
                    setappdata(h.main, 'blobMeasurements2', blobMeasurements2)
                    numberOfBlobs2 = size(blobMeasurements2, 1);
                    setappdata(h.main, 'numberOfBlobs2', numberOfBlobs2)
                    
                    l=0;
                    for a = 1 : numberOfBlobs2           % Loop through all blobs to create a new list of blobs with limited size
                        
                        if (blobMeasurements2(a).Area > lowerB && blobMeasurements2(a).Area < upperB)
                            l=l+1;
                            blobM2.(['frame' num2str(k2)])(l).Area=blobMeasurements2(a).Area;
                            blobM2.(['frame' num2str(k2)])(l).Centroid=blobMeasurements2(a).Centroid;
                        else
                            %end the loop after all centroids and areas are copied to the new
                            %list
                        end
                    end
                    
                    if isfield(blobM2, (['frame' num2str(k2)]))         %check whether structures were created for every frame, otherwise create at least one blob and Area field
                        %     thats good! :-) Nothing else to do
                    else
                        l=l+1;
                        blobM2.(['frame' num2str(k2)])(l).Area=[];
                        blobM2.(['frame' num2str(k2)])(l).Centroid=[0 0];
                    end
                    disp(['videopair: ', num2str(i),', Camera 2, frame: ', num2str(k2)])
                end
                setappdata(h.main, 'blobM2', blobM2)
                setappdata(h.main, 'upperB', upperB)
                setappdata(h.main, 'lowerB', lowerB)
                
                textVideo{1,3}=filename1;
                textVideo{1,4}=filename2;
                textRecordOptions{1,3}=['Video length in seconds: ', num2str(captureDuration)];
                textRecordOptions{1,4}=['Acclimatisation time in seconds: ',num2str(minutes)];
                
                set(h.vid_set_Info, 'String', textRecordOptions)
                set(h.vid_Info, 'String', textVideo)
                cd 'S:\Admin\Tracking\raw data-input\3_multipleVideos'
                progress='DO';
                filename3=sprintf('%s_%s_%s.fig', timecode2, freeText, progress);
                setappdata(h.main, 'filename3', filename3)
                curFol=pwd;
                set(h.cur_Fol, 'String', curFol)
                set(h.DON, 'BackgroundColor', [0 0.9 0])
                savefig(1, filename3);
                disp('Video blobbing successful!')
            else
                disp('Something went wrong during position detection in a video.');
                disp(i);
            end 
        end   
         
        disp('Overnight detection successful!')
        
        %If you want your computer to shut down after it has finished the blop
        %detection, uncomment the following line and execute it with the whole
        %script, it will shut down the whole system, unless there are MS Office
        %programs running
        %system (shutdown -s);
    end


    function Synchronisation(~,~)
        
        vid1=getappdata(h.main, 'vid1');
        vid2=getappdata(h.main, 'vid2');
        set(h.SYNC, 'BackgroundColor', [0.9 0.2 0])
        figPos_1=[100 50 1500 900];
        setappdata(h.main, 'figPos_1', figPos_1)
        %camera Pi red
        figure(10);
        set(gcf,'KeyPressFcn', @key_pressed)
        for StartFrame_Red = 21:vid1.NumberOfFrames
            set(gcf,'position',figPos_1)
            image(read(vid1, StartFrame_Red));
            title('Video from Raspberry Pi Red')
            axis equal
            drawnow;
            
            choice = MFquestdlg([ 1.4 , 0.45 ],'Is the LED already turned on in this video?', ...
                'Pi Red', ...
                'Yes','No','Cancel','Cancel');
            switch choice
                case 'Yes'
                    close figure 10
                    break
                case 'No'
                case 'Cancel'
                    close figure 10
                    break
            end
        end
        
        %camera Pi green
        figure(10);
        set(gcf,'KeyPressFcn', @key_pressed)
        for StartFrame_Green = 21:vid2.NumberOfFrames
            set(gcf,'position',figPos_1)
            image(read(vid2, StartFrame_Green));
            title('Video from Raspberry Pi Green')
            axis equal
            drawnow;
            
            choice = MFquestdlg([ 1.4 , 0.45 ],'Is the LED already turned on in this video?', ...
                'Pi green', ...
                'Yes','No','Cancel','Cancel');
            switch choice
                case 'Yes'
                    close figure 10
                    break
                case 'No'
                case 'Cancel'
                    close figure 10
                    break
            end
        end
        
        setappdata(h.main, 'StartFrame_Green', StartFrame_Green)
        setappdata(h.main, 'StartFrame_Red', StartFrame_Red)
        tracking1=0;
        setappdata(h.main, 'tracking1', tracking1)
        
        cd 'S:\Admin\Tracking\raw data-input\4_synchronisation'
        timecode2=getappdata(h.main, 'timecode2');
        freeText=getappdata(h.main, 'freeText');
        progress='SY';
        filename3=sprintf('%s_%s_%s.fig', timecode2, freeText, progress);
        setappdata(h.main, 'filename3', filename3);
        curFol=pwd;
        set(h.cur_Fol, 'String', curFol)
        
        set(h.SYNC, 'BackgroundColor', [0 0.9 0])
        savefig(filename3);
        disp('Synchronisation successful!')
        
        
    end

    function Tracking(~,~)
        dg=[0,0.6,0.2];
        global interruption
        tracking1=getappdata(h.main, 'tracking1');
        if tracking1 ==0
            set(h.TRACK, 'BackgroundColor', [0.9 0.2 0])
            StartFrame_Red=getappdata(h.main, 'StartFrame_Red');
            StartFrame_Green=getappdata(h.main, 'StartFrame_Green');
            vid1=getappdata(h.main, 'vid1');
            vid2=getappdata(h.main, 'vid2');
            blobM=getappdata(h.main, 'blobM');
            blobM2=getappdata(h.main, 'blobM2');
            timecode2=getappdata(h.main, 'timecode2');
            freeText=getappdata(h.main, 'freeText');
            delay=0;
            figPos_1=getappdata(h.main, 'figPos_1');
            
            interruption=0;
            
            %Homegeneize tracked video length
            %-------------------------------------------------------------------------
            if (StartFrame_Red>StartFrame_Green)
                StartFrame_Red2=0;
                StartFrame_Green2=StartFrame_Red-StartFrame_Green;
            elseif (StartFrame_Red<StartFrame_Green)
                StartFrame_Green2=0;
                StartFrame_Red2=StartFrame_Green-StartFrame_Red;
            elseif (StartFrame_Red==StartFrame_Green)
                StartFrame_Red2=0;
                StartFrame_Green2=0;
            else
                disp('An error occurred');
            end
            
            %play videos in Matlab video player?
            choice = MFquestdlg([ 1.4 , 0.45 ],'Do you want to watch the video that you are about to track beforehand?', ...
                'View Video', ...
                'Yes','No','No');
            switch choice
                case 'Yes'
                    choice = MFquestdlg([ 1.4 , 0.45 ],'How much of the video do you want to see?', ...
                        'Play Video', ...
                        'Show the first 10 seconds of the video','Show the first 15 seconds of the video','Show the whole video','Show the first 10 seconds of the video');
                    switch choice
                        case 'Show the first 10 seconds of the video'
                            disp(choice)
                            set(h.stop, 'BackgroundColor', [0.9 0.2 0])
                            for k = 1:300
                                if (k+StartFrame_Green2>vid1.NumberOfFrames || k+StartFrame_Red2>vid1.NumberOfFrames)
                                    break;
                                else
                                    subplot(1,2,1)
                                    image(read(vid1, k+StartFrame_Green2));
                                    axis equal
                                    title('Video from Raspberry Pi red')
                                    subplot(1,2,2)
                                    image(read(vid2, k+StartFrame_Red2));
                                    axis equal
                                    title('Video from Raspberry Pi green')
                                    drawnow;
                                end
                            end
                            set(h.stop, 'BackgroundColor', [0.94 0.94 0.94])
                        case 'Show the first 15 seconds of the video'
                            disp(choice)
                            set(h.stop, 'BackgroundColor', [0.9 0.2 0])
                            for k = 1:450
                                if (k+StartFrame_Green2>vid1.NumberOfFrames || k+StartFrame_Red2>vid1.NumberOfFrames)
                                    break;
                                else
                                    subplot(1,2,1)
                                    image(read(vid1, k+StartFrame_Green2));
                                    axis equal
                                    title('Video from Raspberry Pi red')
                                    subplot(1,2,2)
                                    image(read(vid2, k+StartFrame_Red2));
                                    axis equal
                                    title('Video from Raspberry Pi green')
                                    drawnow;
                                end
                            end
                            set(h.stop, 'BackgroundColor', [0.94 0.94 0.94])
                            
                        case 'Show the whole video'
                            disp(choice)
                            set(h.stop, 'BackgroundColor', [0.9 0.2 0])
                            for k = 1:vid1.NumberOfFrames
                                if (k+StartFrame_Green2>vid1.NumberOfFrames || k+StartFrame_Red2>vid1.NumberOfFrames)
                                    break;
                                else
                                    subplot(1,2,1)
                                    image(read(vid1, k+StartFrame_Green2));
                                    axis equal
                                    title('Video from Raspberry Pi red')
                                    subplot(1,2,2)
                                    image(read(vid2, k+StartFrame_Red2));
                                    axis equal
                                    title('Video from Raspberry Pi green')
                                    drawnow;
                                end
                            end
                            set(h.stop, 'BackgroundColor', [0.94 0.94 0.94])
                    end
                case 'No'
                    disp('Starting the tracking')
            end
            
            NOF1=vid1.NumberOfFrames;
            NOF2=vid2.NumberOfFrames;
            
            if NOF1<NOF2
                k=vid1.NumberOfFrames;
            elseif NOF1>NOF2
                k=vid2.NumberOfFrames;
            elseif NOF1==NOF2
                k=vid1.NumberOfFrames;
            else
                disp('Error in comparison of video length!')
            end
            
            k=k-50;
            k2=k;
            
            %Find a suitable starting frame (use default or scroll through
            %them
            offset=1;
            subplot(1,2,1)
            image(read(vid1, calib.firstFrame+StartFrame_Red+offset));
            axis equal
            title('Video from Raspberry Pi red')
            subplot(1,2,2)
            image(read(vid2, calib.firstFrame+StartFrame_Green+offset));
            axis equal
            title('Video from Raspberry Pi green')
            drawnow;
            message = sprintf('Do you want to use the default settings or set your own start frame?');
            reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Start frame', 'Use default settings', 'Set own start frame', 'Use default settings');
            switch reply
                case 'Use default settings'
                case 'Set own start frame'
                    for i=1:100
                        choice = MFquestdlg([ 0.5 , 0.4 ],'Press ´backwards´/´forwards´ until you find a suitable start frame. If you found it, press ´choose´.', ...
                            'Setting start frame', ...
                            'backwards','choose','forwards', 'backwards');
                        goEsc=isempty(choice);
                        if goEsc==1
                            terminateExecution
                        else
                            switch choice
                                case 'backwards'
                                    offset=offset-3;
                                    subplot(1,2,1)
                                    image(read(vid1, calib.firstFrame+StartFrame_Red+offset));
                                    axis equal
                                    title('Video from Raspberry Pi red')
                                    subplot(1,2,2)
                                    image(read(vid2, calib.firstFrame+StartFrame_Green+offset));
                                    axis equal
                                    title('Video from Raspberry Pi green')
                                    drawnow;
                                    disp('Offset:')
                                    disp(offset)
                                    textVideo{1,6}=['Current frame: ', num2str(offset)];
                                    set(h.vid_Info, 'String', textVideo)
                                case 'choose'
                                    disp('Offset:')
                                    disp(offset)
                                    textVideo{1,6}=['Current frame: ', num2str(offset)];
                                    set(h.vid_Info, 'String', textVideo)
                                    break;
                                case 'forwards'
                                    offset=offset+3;
                                    subplot(1,2,1)
                                    image(read(vid1, calib.firstFrame+StartFrame_Red+offset));
                                    axis equal
                                    title('Video from Raspberry Pi red')
                                    subplot(1,2,2)
                                    image(read(vid2, calib.firstFrame+StartFrame_Green+offset));
                                    axis equal
                                    title('Video from Raspberry Pi green')
                                    drawnow;
                                    disp('Offset:')
                                    disp(offset)
                                    textVideo{1,6}=['Current frame: ', num2str(offset)];
                                    set(h.vid_Info, 'String', textVideo)
                            end
                        end
                    end
            end
            
            % Determine the tracks for both cameras
            % -------------------------------------------------------------------------
            
            BlopDistThresh=40;              %set threshold for maximum distance between blops
            figPos_2=[1780 50 1500 900];
            %figPos=[1780 50 1500 900];
            % camera 1:
            
            % Define the Position of water fleas in the start frame of video 1
            c=calib.firstFrame+StartFrame_Red+offset;
            setappdata(h.main, 'startRed', c)
            x=1;        %variable to count the length of the track
            imgStart = read(vid1, c); %c must be the first frame of the video to be analysed
            figure(3);
            set(gcf,'KeyPressFcn', @key_pressed)
            imshow(imgStart)
            set(gcf,'position', figPos_1)
            
            message = sprintf('Please click on every animal to mark the starting positions for camera red. \nIf you have less than five animals, please place the superfluous starting positions in the margins of the figure. \nPress "Start" to begin, "Cancel" to interrupt.');
            reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Animal starting positions camera red', 'Start', 'Cancel', 'Start');
            switch reply
                case 'Start'
                    [orginalPositionsX, orginalPositionsY]=ginputW(5);      %using ginputW() as a duplicate of ginput() with white crosshairs//ginput() needs to be changed (RGB [1 1 1] in line 272) and saved in a path folder!
                    close(figure(3))
                    
                    j=figure(2);
                    set(j,'KeyPressFcn', @key_pressed)
                    a=imshow(imgStart);
                    set(j,'position',figPos_2)
                    hold on
                    scatter(orginalPositionsX(1),orginalPositionsY(1),100,'r', 'o');
                    scatter(orginalPositionsX(2),orginalPositionsY(2),100,'y', 'o');
                    scatter(orginalPositionsX(3),orginalPositionsY(3),100,'c', 'o');
                    scatter(orginalPositionsX(4),orginalPositionsY(4),100,'m', 'o');
                    scatter(orginalPositionsX(5),orginalPositionsY(5),100, dg, 'Marker', 'o');
                    text(orginalPositionsX(1),orginalPositionsY(1), '\leftarrow animal 1', 'Color', 'w')
                    text(orginalPositionsX(2),orginalPositionsY(2), '\leftarrow animal 2', 'Color', 'w')
                    text(orginalPositionsX(3),orginalPositionsY(3), '\leftarrow animal 3', 'Color', 'w')
                    text(orginalPositionsX(4),orginalPositionsY(4), '\leftarrow animal 4', 'Color', 'w')
                    text(orginalPositionsX(5),orginalPositionsY(5), '\leftarrow animal 5', 'Color', 'w')
                    hold off
                    
                    cd 'S:\Admin\Tracking\raw data-input\5_tracking2D'
                    filename4=sprintf('%s_%s_1.png', timecode2, freeText);
                    saveas(a, filename4)
                    
                    prompt={'Please confirm how many animals you marked (1-5):'};
                    answer=inputdlg(prompt,'Number of animals',1,{'5'});
                    noAnimals=str2double(answer{1});
                    
                    prompt={'Define the size of the circles that mark the animals´ positions (Recommended: 5 for small, 10 for medium-sized, 15 for larger animals).'};
                    answer=inputdlg(prompt,'Tracking circle size',1,{'10'});
                    circSize=str2double(answer{1});
                    
                    figure(4)
                    set(gcf,'position', figPos_1)
                    set(gcf,'KeyPressFcn', @key_pressed)
                    im=imread(filename4);
                    imshow(im);
                    
                    originalPositions=[orginalPositionsX, orginalPositionsY];
                    
                    % check random blobs/lists of blobs
                    q=1;
                    blobM.(['frame' num2str(c)])(q).Centroid;
                    blobM.(['frame' num2str(c)]).Centroid;
                    listBlopsInFrame=cat(1,blobM.(['frame' num2str(c)]).Centroid);
                    
                    % generate path-arrays with individual name
                    for p = 1:size(originalPositions, 1)
                        paths=genvarname(['path' num2str(p)]);
                        eval([paths '=originalPositions(p,:);']);
                    end
                    
                    % calculate the distance between the blop position in the current frame and the frame before (here it is the start frame)
                    for z1 = 1:(size(listBlopsInFrame, 1))
                        p1=listBlopsInFrame(z1,:);
                        
                        for z2 = 1:size(originalPositions, 1)
                            P2=originalPositions(z2,:);
                            distances(z1, z2)= pdist2(p1,P2,'euclidean');
                        end
                    end
                    
                    x=x+1;          %counting the length of the tracks
                    
                    h1=2;
                    h2=2;
                    h3=2;
                    h4=2;
                    h5=2;
                    for z3 = 1:size(originalPositions, 1)
                        if (z3<=size(listBlopsInFrame,1))
                            [PosVector, I, ~] = find(distances==min(distances(:)));      %detect smallest distance
                            
                            if I==1
                                if (min(distances(:))<=BlopDistThresh)
                                    path1(h1,:)=listBlopsInFrame(PosVector,:);
                                else
                                    path1(h1,:)=path1(h1-1,:);
                                end
                                h1=h1+1;
                            elseif I==2
                                if (min(distances(:))<=BlopDistThresh)
                                    path2(h2,:)=listBlopsInFrame(PosVector,:);
                                else
                                    path2(h2,:)=path2(h2-1,:);
                                end
                                h2=h2+1;
                            elseif I==3
                                if (min(distances(:))<=BlopDistThresh)
                                    path3(h3,:)=listBlopsInFrame(PosVector,:);
                                else
                                    path3(h3,:)=path3(h3-1,:);
                                end
                                h3=h3+1;
                            elseif I==4
                                if (min(distances(:))<=BlopDistThresh)
                                    path4(h4,:)=listBlopsInFrame(PosVector,:);
                                else
                                    path4(h4,:)=path4(h4-1,:);
                                end
                                h4=h4+1;
                            elseif I==5
                                if (min(distances(:))<=BlopDistThresh)
                                    path5(h5,:)=listBlopsInFrame(PosVector,:);
                                else
                                    path5(h5,:)=path5(h5-1,:);
                                end
                                h5=h5+1;
                            else
                                disp('That was unexpected! 1')
                            end
                            if (z3<=size(originalPositions, 1))
                                distances(:, I)=10000;
                                distances(PosVector, :)=10000;
                            else
                                disp('That was unexpected! 2')
                            end
                        else                            %if all blops are already used, copy the x and y values from the last frame
                            if (h1<h2 || h1<h3 || h1<h4 || h1<h5)
                                path1(h1,:)=path1(h1-1,:);
                                h1=h1+1;
                            elseif (h2<h1 || h2<h3 || h2<h4 || h2<h5)
                                path2(h2,:)=path2(h2-1,:);
                                h2=h2+1;
                            elseif (h3<h1 || h3<h2 || h3<h4 || h3<h5)
                                path3(h3,:)=path3(h3-1,:);
                                h3=h3+1;
                            elseif (h4<h1 || h4<h2 || h4<h3 || h4<h5)
                                path4(h4,:)=path4(h4-1,:);
                                h4=h4+1;
                            elseif (h5<h1 || h5<h2 || h5<h3 || h5<h4)
                                path5(h5,:)=path5(h5-1,:);
                                h5=h5+1;
                            else
                                disp('That was unexpected! 3')
                            end
                        end
                    end
                    
                    %checking circle size
                    i=0;
                    while i<1
                        imshow(imgStart);
                        hold on
                        plot(path1(x,1), path1(x,2), 'r--o', 'MarkerSize', circSize);
                        plot(path2(x,1), path2(x,2), 'y--o', 'MarkerSize', circSize);
                        plot(path3(x,1), path3(x,2), 'c--o', 'MarkerSize', circSize);
                        plot(path4(x,1), path4(x,2), 'm--o', 'MarkerSize', circSize);
                        plot(path5(x,1), path5(x,2), 'color', dg, 'Marker', 'o', 'MarkerSize', circSize);
                        hold off
                        message = sprintf('Are you happy with this circle size for tracking?');
                        reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Check circle size', 'Yes', 'No', 'Yes');
                        goEsc=isempty(reply);
                        if goEsc==1
                            terminateExecution
                        else
                            switch reply
                                case 'Yes'
                                    i=1;
                                case 'No'
                                    prompt={'Define the size of the circles that mark the animals´ positions (Recommended: 5 for small, 10 for medium-sized, 15 for larger animals).'};
                                    answer=inputdlg(prompt,'Tracking circle size',1,{'10'});
                                    circSize=str2double(answer{1});
                                    imshow(imgStart);
                                    hold on
                                    plot(path1(x,1), path1(x,2), 'r--o', 'MarkerSize', circSize);
                                    plot(path2(x,1), path2(x,2), 'y--o', 'MarkerSize', circSize);
                                    plot(path3(x,1), path3(x,2), 'c--o', 'MarkerSize', circSize);
                                    plot(path4(x,1), path4(x,2), 'm--o', 'MarkerSize', circSize);
                                    plot(path5(x,1), path5(x,2), 'color', dg, 'Marker', 'o', 'MarkerSize', circSize);
                                    hold off
                            end
                        end      
                    end
                    setappdata(h.main, 'circSize', circSize)
                    x=x+1;
                    % ---------------------------------------------------------------------
                    % ---------------------------------------------------------------------
                    % loop over the third and following frames in the video
                    errFrames=0;
                    c=c+1;
                    while c<k-StartFrame_Red2
                        listBlopsInFrame=cat(1,blobM.(['frame' num2str(c)]).Centroid);
                        pause(delay)
                        if (interruption==0)
                        elseif (interruption==1)
                            disp('Tracking interrupted!');
                            x=x-1;
                            c=c-1;
                            h1=h1-1;
                            h2=h2-1;
                            h3=h3-1;
                            h4=h4-1;
                            h5=h5-1;
                            
                            %this is for position correction in tracking
                            for i=1:100
                                choice = MFquestdlg([ 1.4 , 0.45 ], 'Press ´backwards´/´forwards´ to find the first frame of wrong position assignement. Press ´choose´ to start the correction.', ...
                                    'Finding tracking error', ...
                                    'backwards','choose','forwards', 'backwards');
                                goEsc=isempty(choice);
                                if goEsc==1
                                    terminateExecution
                                else
                                    switch choice
                                        case 'backwards'
                                            x=x-5;
                                            if x<1
                                                x=x+5;
                                                disp('You cannot proceed to frames that are not part of the analysis.')
                                            else
                                                c=c-5;
                                                disp(c)
                                                h1=h1-5;
                                                h2=h2-5;
                                                h3=h3-5;
                                                h4=h4-5;
                                                h5=h5-5;
                                                
                                                imgBackground=read(vid1, c);
                                                hold on
                                                imagesc(imgBackground);
                                                xlabel('(negative) x-axis');
                                                ylabel('z-axis');
                                                
                                                imshow(imgBackground)
                                                plot(path1(x,1), path1(x,2), 'r--o', 'MarkerSize', circSize);
                                                plot(path2(x,1), path2(x,2), 'y--o', 'MarkerSize', circSize);
                                                plot(path3(x,1), path3(x,2), 'c--o', 'MarkerSize', circSize);
                                                plot(path4(x,1), path4(x,2), 'm--o', 'MarkerSize', circSize);
                                                plot(path5(x,1), path5(x,2), 'color', dg, 'Marker', 'o', 'MarkerSize', circSize);
                                                hold off
                                                set(gca,'YDir', 'reverse');
                                                set(gcf,'position',[100 50 1500 900])
                                                title('Tracks from Raspberry Pi red')
                                                drawnow;
                                                textVideo{1,6}=['Current frame: ', num2str(c)];
                                                set(h.vid_Info, 'String', textVideo)
                                            end
                                        case 'choose'
                                            disp(c)
                                            textVideo{1,6}=['Current frame: ', num2str(c)];
                                            set(h.vid_Info, 'String', textVideo)
                                            break;
                                        case 'forwards'
                                            x=x+1;
                                            if x>length(path1(:,1))
                                                x=x-1;
                                                disp('You cannot proceed to frames not yet tracked.')
                                            else
                                                c=c+1;
                                                disp(c)
                                                h1=h1+1;
                                                h2=h2+1;
                                                h3=h3+1;
                                                h4=h4+1;
                                                h5=h5+1;
                                                
                                                imgBackground=read(vid1, c);
                                                hold on
                                                imagesc(imgBackground);
                                                xlabel('(negative) x-axis');
                                                ylabel('z-axis');
                                                
                                                imshow(imgBackground)
                                                plot(path1(x,1), path1(x,2), 'r--o', 'MarkerSize', circSize);
                                                plot(path2(x,1), path2(x,2), 'y--o', 'MarkerSize', circSize);
                                                plot(path3(x,1), path3(x,2), 'c--o', 'MarkerSize', circSize);
                                                plot(path4(x,1), path4(x,2), 'm--o', 'MarkerSize', circSize);
                                                plot(path5(x,1), path5(x,2), 'color', dg, 'Marker', 'o', 'MarkerSize', circSize);
                                                hold off
                                                set(gca,'YDir', 'reverse');
                                                set(gcf,'position',[100 50 1500 900])
                                                title('Tracks from Raspberry Pi red')
                                                drawnow;
                                                textVideo{1,6}=['Current frame: ', num2str(c)];
                                                set(h.vid_Info, 'String', textVideo)
                                            end
                                    end
                                end
                            end
                            
                            choice = MFquestdlg([ 1.4 , 0.45 ],'Do you want to continue with the tracking or correct the animals positions?', ...
                                'Correcting animal positions', ...
                                'Continue','Correct','Continue');
                            switch choice
                                case 'Continue'
                                    disp(x)
                                    interruption=0;
                                case 'Correct'
                                    message = sprintf('Red: Press "Correct" to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Red(1) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX1, corrY1]=ginputW(1);
                                            path1(x,:)=[corrX1 corrY1];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 1.')
                                    end
                                    
                                    message = sprintf('Yellow: Press "Correct" to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Yellow(2) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX2, corrY2]=ginputW(1);
                                            path2(x,:)=[corrX2 corrY2];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 2.')
                                    end
                                    message = sprintf('Cyan: Press "Correct" to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Cyan(3) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX3, corrY3]=ginputW(1);
                                            path3(x,:)=[corrX3 corrY3];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 3.')
                                    end
                                    
                                    message = sprintf('Magenta: Press "Correct" to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Magenta(4) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX4, corrY4]=ginputW(1);
                                            path4(x,:)=[corrX4 corrY4];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 4.')
                                    end
                                    message = sprintf('Green: Press "Correct" to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Green(5) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX5, corrY5]=ginputW(1);
                                            path5(x,:)=[corrX5 corrY5];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 5.')
                                    end
                            end
                            
                            x=x+1;
                            c=c+1;
                            h1=h1+1;
                            h2=h2+1;
                            h3=h3+1;
                            h4=h4+1;
                            h5=h5+1;
                            interruption=0;
                            disp(c)
                        else 
                            disp('There is a problem with the interruption of tracking.')
                        end
                        
                        
                        % calculate the distance between the blop position in the current frame and the frame before
                        for z1 = 1:(size(listBlopsInFrame,1))
                            
                            p1=listBlopsInFrame(z1,:);                  %current blops' position
                            for z2 = 1:p
                                if z2==1
                                    P2=path1((x-1),:);                     %blops' position in the previous frame
                                elseif z2==2
                                    P2=path2((x-1),:);
                                elseif z2==3
                                    P2=path3((x-1),:);
                                elseif z2==4
                                    P2=path4((x-1),:);
                                elseif z2==5
                                    P2=path5((x-1),:);
                                else
                                    disp('That was unexpected!_4')
                                end
                                distances(z1, z2)= pdist2(p1,P2,'euclidean');
                            end
                        end
                        
                        for z3 = 1:p
                            if (z3<=(size(listBlopsInFrame,1)))
                                [PosVector, I, ~] = find(distances==min(distances(:)));      %detect smallest distance
                                if I==1
                                    if (min(distances(:))<=BlopDistThresh)
                                        path1(h1,:)=listBlopsInFrame(PosVector,:);
                                    else
                                        path1(h1,:)=path1(h1-1,:);
                                    end
                                    h1=h1+1;
                                elseif I==2
                                    if (min(distances(:))<=BlopDistThresh)
                                        path2(h2,:)=listBlopsInFrame(PosVector,:);
                                    else
                                        path2(h2,:)=path2(h2-1,:);
                                    end
                                    h2=h2+1;
                                elseif I==3
                                    if (min(distances(:))<=BlopDistThresh)
                                        path3(h3,:)=listBlopsInFrame(PosVector,:);
                                    else
                                        path3(h3,:)=path3(h3-1,:);
                                    end
                                    h3=h3+1;
                                elseif I==4
                                    if (min(distances(:))<=BlopDistThresh)
                                        path4(h4,:)=listBlopsInFrame(PosVector,:);
                                    else
                                        path4(h4,:)=path4(h4-1,:);
                                    end
                                    h4=h4+1;
                                elseif I==5
                                    if (min(distances(:))<=BlopDistThresh)
                                        path5(h5,:)=listBlopsInFrame(PosVector,:);
                                    else
                                        path5(h5,:)=path5(h5-1,:);
                                    end
                                    h5=h5+1;
                                else
                                    disp('That was unexpected!_1')
                                    
                                    errFrames1=x;
                                    errFrames=vertcat(errFrames, errFrames1);
                                end
                                
                                if (z3<=size(originalPositions, 1))
                                    distances(:, I)=10000;
                                    distances(PosVector, :)=10000;
                                else
                                    disp('That was unexpected! 2')
                                end
                            else                            %if all blops are already used, copy the x and y values from the last frame
                                if (h1<h2 || h1<h3 || h1<h4 || h1<h5)
                                    path1(h1,:)=path1(h1-1,:);
                                    h1=h1+1;
                                elseif (h2<h1 || h2<h3 || h2<h4 || h2<h5)
                                    path2(h2,:)=path2(h2-1,:);
                                    h2=h2+1;
                                elseif (h3<h1 || h3<h2 || h3<h4 || h3<h5)
                                    path3(h3,:)=path3(h3-1,:);
                                    h3=h3+1;
                                elseif (h4<h1 || h4<h2 || h4<h3 || h4<h5)
                                    path4(h4,:)=path4(h4-1,:);
                                    h4=h4+1;
                                elseif (h5<h1 || h5<h2 || h5<h3 || h5<h4)
                                    path5(h5,:)=path5(h5-1,:);
                                    h5=h5+1;
                                else
                                    disp('That was unexpected! 3_')
                                end
                            end
                        end
                        %check the length of each path before plotting i
                        if size(path1(:,1))<x
                            path1=[path1;path1(x-1,:)];
                            h1=h1+1;
                            disp('path1 exists now!')
                        else
                        end
                        if size(path2(:,1))<x
                            path2=[path2;path2(x-1,:)];
                            h2=h2+1;
                            disp('path2 exists now!')
                        else
                        end
                        if size(path3(:,1))<x
                            path3=[path3;path3(x-1,:)];
                            h3=h3+1;
                            disp('path3 exists now!')
                        else
                        end
                        if size(path4(:,1))<x
                            path4=[path4;path4(x-1,:)];
                            h4=h4+1;
                            disp('path4 exists now!')
                        else
                        end
                        if size(path5(:,1))<x
                            path5=[path5;path5(x-1,:)];
                            h5=h5+1;
                            disp('path5 exists now!')
                        else
                        end
                        
                        c=c+1;
                        disp(c)
                        
                        imgBackground=read(vid1, c);
                        
                        if mod(x,20)==0
                            close figure 4
                            f=figure(4);
                            set(f,'KeyPressFcn', @key_pressed)
                        else
                            f=figure(4);
                            set(f,'KeyPressFcn', @key_pressed)
                        end
                        
                        hold on
                        imagesc(imgBackground);
                        xlabel('(negative) x-axis');
                        ylabel('z-axis');
                        
                        imshow(imgBackground)
                        plot(path1(x,1), path1(x,2), 'r--o', 'MarkerSize', circSize);
                        plot(path2(x,1), path2(x,2), 'y--o', 'MarkerSize', circSize);
                        plot(path3(x,1), path3(x,2), 'c--o', 'MarkerSize', circSize);
                        plot(path4(x,1), path4(x,2), 'm--o', 'MarkerSize', circSize);
                        plot(path5(x,1), path5(x,2), 'color', dg, 'Marker', '  o', 'MarkerSize', circSize);
                        set(gca,'YDir', 'reverse');
                        set(gcf,'position', [100 50 1500 900])
                        hold off
                        title('Tracks from Raspberry Pi red')
                        drawnow;
                        x=x+1;
                    end
                case 'Cancel'
                    terminateExecution;
                    disp('2D tracking was interrupted by user.')
            end
            close figure 4
            disp('Position assignment finished for video 1.')
            
            tracking1=1;
            %save data and figures
            cd 'S:\Admin\Tracking\raw data-input\5_tracking2D'
            progress='TR1';
            filename3=sprintf('%s_%s_%s.fig', timecode2, freeText, progress);
            
            setappdata(h.main, 'filename3', filename3)
            setappdata(h.main, 'path1', path1)
            setappdata(h.main, 'path2', path2)
            setappdata(h.main, 'path3', path3)
            setappdata(h.main, 'path4', path4)
            setappdata(h.main, 'path5', path5)
            setappdata(h.main, 'p', p)
            setappdata(h.main, 'offset', offset)
            setappdata(h.main, 'noAnimals', noAnimals)
            setappdata(h.main, 'errFrames', errFrames)
            setappdata(h.main, 'offset', offset)
            setappdata(h.main, 'StartFrame_Green', StartFrame_Green)
            setappdata(h.main, 'k2', k2)
            setappdata(h.main, 'StartFrame_Green2', StartFrame_Green2)
            setappdata(h.main, 'circSize', circSize)
            setappdata(h.main, 'tracking1', tracking1)
            
            
            
            curFol=pwd;
            set(h.cur_Fol, 'String', curFol)
            savefig(1, filename3);
            
            % -------------------------------------------------------------------------------------------------
            % -------------------------------------------------------------------------------------------------
            % -------------------------------------------------------------------------------------------------
            
            % camera 2:
            % Define the Position of water fleas in the start frame of video 1
            c=calib.firstFrame+StartFrame_Green+offset;
            setappdata(h.main, 'startGreen', c)
            x=1;        %variable to count the length of the track
            imgStart = read(vid2, c); %k must be the first frame of the video to be analysed
            figure(5);
            set(gcf,'KeyPressFcn', @key_pressed)
            imshow(imgStart)
            set(gcf,'position',[1780 50 1500 900])
            
            message = sprintf('Please click on every animal to mark the starting positions for camera green. \nIf you have less than five animals, please place the superfluous starting positions in the margins of the figure. \nPress "Start" to begin, "Cancel" to interrupt.');
            reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Animal starting positions camera green', 'Start', 'Cancel', 'Start');
            switch reply
                case 'Start'
                    [orginalPositions2X, orginalPositions2Y]=ginputW(5);
                    close(figure(5))
                    
                    figure(2);
                    set(gcf,'KeyPressFcn', @key_pressed)
                    figPos_2=[1780 50 1500 900];
                    
                    a=imshow(imgStart);
                    set(gcf,'position',figPos_2)
                    hold on
                    scatter(orginalPositions2X(1),orginalPositions2Y(1),100,'r', 'o');
                    scatter(orginalPositions2X(2),orginalPositions2Y(2),100,'y', 'o');
                    scatter(orginalPositions2X(3),orginalPositions2Y(3),100,'c', 'o');
                    scatter(orginalPositions2X(4),orginalPositions2Y(4),100,'m', 'o');
                    scatter(orginalPositions2X(5),orginalPositions2Y(5),100, dg, 'Marker', 'o');
                    text(orginalPositions2X(1),orginalPositions2Y(1), '\leftarrow animal 1', 'Color', 'w')
                    text(orginalPositions2X(2),orginalPositions2Y(2), '\leftarrow animal 2', 'Color', 'w')
                    text(orginalPositions2X(3),orginalPositions2Y(3), '\leftarrow animal 3', 'Color', 'w')
                    text(orginalPositions2X(4),orginalPositions2Y(4), '\leftarrow animal 4', 'Color', 'w')
                    text(orginalPositions2X(5),orginalPositions2Y(5), '\leftarrow animal 5', 'Color', 'w')
                    hold off
                    
                    filename5=sprintf('%s_%s_2.png', timecode2, freeText);
                    saveas(a, filename5)
                    
                    im=imread(filename5);
                    imshow(im);
                    
                    figure (6);
                    set(gcf,'position',[100 50 1500 900])
                    set(gcf,'KeyPressFcn', @key_pressed)
                    originalPositions2=[orginalPositions2X, orginalPositions2Y];
                    listBlopsInFrame2=cat(1,blobM2.(['frame' num2str(c)]).Centroid);
                    
                    % generate path-arrays with individual name
                    for p = 1:size(originalPositions2, 1)
                        paths=genvarname(['path2' num2str(p)]);
                        eval([paths '=originalPositions2(p,:);']);
                    end
                    
                    % calculate the distance between the blop position in the current frame and the frame before (here it is the start frame)
                    for z1 = 1:(size(listBlopsInFrame2, 1))
                        p1=listBlopsInFrame2(z1,:);
                        for z2 = 1:size(originalPositions2, 1)
                            P2=originalPositions2(z2,:);
                            distances2(z1, z2)= pdist2(p1,P2,'euclidean');
                        end
                    end
                    
                    x=x+1;          %counting the length of the tracks
                    
                    h1=2;
                    h2=2;
                    h3=2;
                    h4=2;
                    h5=2;
                    clear I;
                    for z3 = 1:size(originalPositions2, 1)
                        if (z3<=size(listBlopsInFrame2,1))
                            [PosVector, I, ~] = find(distances2==min(distances2(:)));      %detect smallest distance
                            if I==1
                                if (min(distances2(:))<=BlopDistThresh)
                                    path21(h1,:)=listBlopsInFrame2(PosVector,:);
                                else
                                    path21(h1,:)=path21(h1-1,:);
                                end
                                h1=h1+1;
                            elseif I==2
                                if (min(distances2(:))<=BlopDistThresh)
                                    path22(h2,:)=listBlopsInFrame2(PosVector,:);
                                else
                                    path22(h2,:)=path22(h2-1,:);
                                end
                                h2=h2+1;
                            elseif I==3
                                if (min(distances2(:))<=BlopDistThresh)
                                    path23(h3,:)=listBlopsInFrame2(PosVector,:);
                                else
                                    path23(h3,:)=path23(h3-1,:);
                                end
                                h3=h3+1;
                            elseif I==4
                                if (min(distances2(:))<=BlopDistThresh)
                                    path24(h4,:)=listBlopsInFrame2(PosVector,:);
                                else
                                    path24(h4,:)=path24(h4-1,:);
                                end
                                h4=h4+1;
                            elseif I==5
                                if (min(distances2(:))<=BlopDistThresh)
                                    path25(h5,:)=listBlopsInFrame2(PosVector,:);
                                else
                                    path25(h5,:)=path25(h5-1,:);
                                end
                                h5=h5+1;
                            else
                                disp('That was unexpected! 1')
                            end
                            if (z3<=size(originalPositions2, 1))
                                distances2(:, I)=10000;
                                distances2(PosVector, :)=10000;
                            else
                                disp('That was unexpected! 2')
                            end
                        else                            %if all blops are already used, copy the x and y values from the last frame
                            if (h1<h2 || h1<h3 || h1<h4 || h1<h5)
                                path21(h1,:)=path21(h1-1,:);
                                h1=h1+1;
                            elseif (h2<h1 || h2<h3 || h2<h4 || h2<h5)
                                path22(h2,:)=path22(h2-1,:);
                                h2=h2+1;
                            elseif (h3<h1 || h3<h2 || h3<h4 || h3<h5)
                                path23(h3,:)=path23(h3-1,:);
                                h3=h3+1;
                            elseif (h4<h1 || h4<h2 || h4<h3 || h4<h5)
                                path24(h4,:)=path24(h4-1,:);
                                h4=h4+1;
                            elseif (h5<h1 || h5<h2 || h5<h3 || h5<h4)
                                path25(h5,:)=path25(h5-1,:);
                                h5=h5+1;
                            else
                                disp('That was unexpected! 3')
                            end
                        end
                    end
                    
                    x=x+1;
                    
                    % ---------------------------------------------------------------------
                    % ---------------------------------------------------------------------
                    % loop over the third and following frames in the video
                    errFrames_2=0;
                    c=c+1;
                    while c<k2-StartFrame_Green2
                        listBlopsInFrame2=cat(1,blobM2.(['frame' num2str(c)]).Centroid);
                        pause(delay)
                        if (interruption==0)
                        elseif (interruption==1)
                            disp('Tracking interrupted!');
                            x=x-1;
                            c=c-1;
                            h1=h1-1;
                            h2=h2-1;
                            h3=h3-1;
                            h4=h4-1;
                            h5=h5-1;
                            
                            %this is for position correction in tracking
                            for i=1:100
                                choice = MFquestdlg([ 1.4 , 0.45 ],'Press ´backwards´/´forwards´ to find the first frame of the tracking error. Press ´choose´ to start the correction.', ...
                                    'Finding tracking error', ...
                                    'backwards','choose','forwards', 'backwards');
                                goEsc=isempty(choice);
                                if goEsc==1
                                    terminateExecution
                                else
                                    switch choice
                                        case 'backwards'
                                            x=x-5;
                                            if x<1
                                                x=x+5;
                                                disp('You cannot proceed to frames that are not part of the analysis.')
                                            else
                                                c=c-5;
                                                disp(c)
                                                h1=h1-5;
                                                h2=h2-5;
                                                h3=h3-5;
                                                h4=h4-5;
                                                h5=h5-5;
                                                
                                                imgBackground=read(vid2, c);
                                                hold on
                                                 imagesc(imgBackground);
                                                xlabel('y-axis');
                                                ylabel('z-axis');
                                                
                                                imshow(imgBackground)
                                                plot(path21(x,1), path21(x,2), 'r--o', 'MarkerSize', circSize);
                                                plot(path22(x,1), path22(x,2), 'y--o', 'MarkerSize', circSize);
                                                plot(path23(x,1), path23(x,2), 'c--o', 'MarkerSize', circSize);
                                                plot(path24(x,1), path24(x,2), 'm--o', 'MarkerSize', circSize);
                                                plot(path25(x,1), path25(x,2), 'color', dg, 'Marker', 'o', 'MarkerSize', circSize);
                                                hold off
                                                set(gca,'YDir', 'reverse');
                                                set(gcf,'position',[100 50 1500 900])
                                                title('Tracks from Raspberry Pi green')
                                                drawnow;
                                                
                                                textVideo{1,6}=['Current frame: ', num2str(c)];
                                                set(h.vid_Info, 'String', textVideo)
                                            end
                                        case 'choose'
                                            disp(c)
                                            textVideo{1,6}=['Current frame: ', num2str(c)];
                                            set(h.vid_Info, 'String', textVideo)
                                            break;
                                        case 'forwards'
                                            x=x+1;
                                            if x>length(path21(:,1))
                                                x=x-1;
                                                disp('You cannot proceed to frames not yet tracked.')
                                            else
                                                c=c+1;
                                                disp(c)
                                                h1=h1+1;
                                                h2=h2+1;
                                                h3=h3+1;
                                                h4=h4+1;
                                                h5=h5+1;
                                                
                                                imgBackground=read(vid2, c);
                                                hold on
                                                imagesc(imgBackground);
                                                xlabel('y-axis');
                                                ylabel('z-axis');
                                                
                                                imshow(imgBackground)
                                                plot(path21(x,1), path21(x,2), 'r--o', 'MarkerSize', circSize);
                                                plot(path22(x,1), path22(x,2), 'y--o', 'MarkerSize', circSize);
                                                plot(path23(x,1), path23(x,2), 'c--o', 'MarkerSize', circSize);
                                                plot(path24(x,1), path24(x,2), 'm--o', 'MarkerSize', circSize);
                                                plot(path25(x,1), path25(x,2), 'color', dg, 'Marker', 'o', 'MarkerSize', circSize);
                                                hold off
                                                set(gca,'YDir', 'reverse');
                                                set(gcf,'position',[100 50 1500 900])
                                                title('Tracks from Raspberry Pi green')
                                                drawnow;
                                                
                                                textVideo{1,6}=['Current frame: ', num2str(c)];
                                                set(h.vid_Info, 'String', textVideo)
                                            end
                                    end
                                end
                            end
                            
                            choice = MFquestdlg([ 1.4 , 0.45 ],'Do you want to continue with the tracking or correct the animal positions?', ...
                                'Correcting animal positions', ...
                                'Continue','Correct','Continue');
                            switch choice
                                case 'Continue'
                                    interruption=0;
                                case 'Correct'
                                    message = sprintf('Red: Press correct to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Red(1) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX1, corrY1]=ginputW(1);
                                            path21(x,:)=[corrX1 corrY1];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 1.')
                                    end
                                    
                                    message = sprintf('Yellow: Press correct to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Yellow(2) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX2, corrY2]=ginputW(1);
                                            path22(x,:)=[corrX2 corrY2];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 2.')
                                    end
                                    message = sprintf('Cyan: Press correct to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Cyan(3) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX3, corrY3]=ginputW(1);
                                            path23(x,:)=[corrX3 corrY3];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 3.')
                                    end
                                    
                                    message = sprintf('Magenta: Press correct to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Magenta(4) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX4, corrY4]=ginputW(1);
                                            path24(x,:)=[corrX4 corrY4];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 4.')
                                    end
                                    message = sprintf('Green: Press correct to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Green(5) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX5, corrY5]=ginputW(1);
                                            path25(x,:)=[corrX5 corrY5];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 5.')
                                    end
                            end
                            
                            x=x+1;
                            c=c+1;
                            h1=h1+1;
                            h2=h2+1;
                            h3=h3+1;
                            h4=h4+1;
                            h5=h5+1;
                            interruption=0;
                        else
                            disp('There is a problem with the interruption of tracking.')
                        end
                        
                        % calculate the distance between the blop position in the current frame and the frame before
                        for z1 = 1:(size(listBlopsInFrame2,1))
                            p1=listBlopsInFrame2(z1,:);                  %current blops' position
                            for z2 = 1:p
                                if z2==1
                                    P2=path21((x-1),:);                     %blops' position in the previous frame
                                elseif z2==2
                                    P2=path22((x-1),:);
                                elseif z2==3
                                    P2=path23((x-1),:);
                                elseif z2==4
                                    P2=path24((x-1),:);
                                elseif z2==5
                                    P2=path25((x-1),:);
                                else
                                    disp('That was unexpected!_4')
                                end
                                distances2(z1, z2)= pdist2(p1,P2,'euclidean');
                            end
                        end
                        for z3 = 1:p
                            if (z3<=(size(listBlopsInFrame2,1)))
                                [PosVector, I, ~] = find(distances2==min(distances2(:)));      %detect smallest distance
                                if I==1
                                    if (min(distances2(:))<=BlopDistThresh)
                                        path21(h1,:)=listBlopsInFrame2(PosVector,:);
                                    else
                                        path21(h1,:)=path21(h1-1,:);
                                    end
                                    h1=h1+1;
                                elseif I==2
                                    if (min(distances2(:))<=BlopDistThresh)
                                        path22(h2,:)=listBlopsInFrame2(PosVector,:);
                                    else
                                        path22(h2,:)=path22(h2-1,:);
                                    end
                                    h2=h2+1;
                                elseif I==3
                                    if (min(distances2(:))<=BlopDistThresh)
                                        path23(h3,:)=listBlopsInFrame2(PosVector,:);
                                    else
                                        path23(h3,:)=path23(h3-1,:);
                                    end
                                    h3=h3+1;
                                elseif I==4
                                    if (min(distances2(:))<=BlopDistThresh)
                                        path24(h4,:)=listBlopsInFrame2(PosVector,:);
                                    else
                                        path24(h4,:)=path24(h4-1,:);
                                    end
                                    h4=h4+1;
                                elseif I==5
                                    if (min(distances2(:))<=BlopDistThresh)
                                        path25(h5,:)=listBlopsInFrame2(PosVector,:);
                                    else
                                        path25(h5,:)=path25(h5-1,:);
                                    end
                                    h5=h5+1;
                                else
                                    disp('That was unexpected!_1')
                                    
                                    errFrames1=x;
                                    errFrames_2=vertcat(errFrames_2, errFrames1);
                                end
                                
                                if (z3<=size(originalPositions2, 1))
                                    distances2(:, I)=10000;
                                    distances2(PosVector, :)=10000;
                                else
                                    disp('That was unexpected! 2')
                                end
                            else                            %if all blops are already used, copy the x and y values from the last frame
                                if (h1<h2 || h1<h3 || h1<h4 || h1<h5)
                                    path21(h1,:)=path21(h1-1,:);
                                    h1=h1+1;
                                elseif (h2<h1 || h2<h3 || h2<h4 || h2<h5)
                                    path22(h2,:)=path22(h2-1,:);
                                    h2=h2+1;
                                elseif (h3<h1 || h3<h2 || h3<h4 || h3<h5)
                                    path23(h3,:)=path23(h3-1,:);
                                    h3=h3+1;
                                elseif (h4<h1 || h4<h2 || h4<h3 || h4<h5)
                                    path24(h4,:)=path24(h4-1,:);
                                    h4=h4+1;
                                elseif (h5<h1 || h5<h2 || h5<h3 || h5<h4)
                                    path25(h5,:)=path25(h5-1,:);
                                    h5=h5+1;
                                else
                                    disp('That was unexpected! 3_')
                                end
                            end
                        end
                        
                        %check the length of each path before plotting it
                        if size(path21(:,1))<x
                            path21=[path21;path21(x-1,:)];
                            h1=h1+1;
                            disp('path21 exists now!')
                        else
                        end
                        if size(path22(:,1))<x
                            path22=[path22;path22(x-1,:)];
                            h2=h2+1;
                            disp('path22 exists now!')
                        else
                        end
                        if size(path23(:,1))<x
                            path23=[path23;path23(x-1,:)];
                            h3=h3+1;
                            disp('path23 exists now!')
                        else
                        end
                        if size(path24(:,1))<x
                            path24=[path24;path24(x-1,:)];
                            h4=h4+1;
                            disp('path24 exists now!')
                        else
                        end
                        if size(path25(:,1))<x
                            path25=[path25;path25(x-1,:)];
                            h5=h5+1;
                            disp('path25 exists now!')
                        else
                        end
                        
                        c=c+1;
                        disp(c)
                        
                        imgBackground=read(vid2, c);
                        
                        %live plotting of tracking
                        if mod(x,20)==0
                            close figure 6
                            f=figure(6);
                            set(f,'KeyPressFcn', @key_pressed)
                        else
                            f=figure(6);
                            set(f,'KeyPressFcn', @key_pressed)
                        end
                        
                        hold on
                        imagesc(imgBackground);
                        xlabel('y-axis');
                        ylabel('z-axis');
                        
                        %imshow(imgBackground)
                        plot(path21(x,1), path21(x,2), 'r--o', 'MarkerSize', circSize);
                        plot(path22(x,1), path22(x,2), 'y--o', 'MarkerSize', circSize);
                        plot(path23(x,1), path23(x,2), 'c--o', 'MarkerSize', circSize);
                        plot(path24(x,1), path24(x,2), 'm--o', 'MarkerSize', circSize);
                        plot(path25(x,1), path25(x,2), 'color', dg, 'Marker', 'o', 'MarkerSize', circSize);
                        set(gca,'YDir', 'reverse');
                        set(gcf,'position', [100 50 1500 900])
                        hold off
                        title('Tracks from Raspberry Pi green')
                        drawnow
                        x=x+1;
                    end
                case 'Cancel'
                    terminateExecution;
                    disp('2D tracking was interrupted by user.')
            end
            
            close figure 6
            close figure 2
            disp('Position assignment finished for video 2.')
            
            %save data and figures
            cd 'S:\Admin\Tracking\raw data-input\5_tracking2D'
            progress='TR';
            filename3=sprintf('%s_%s_%s.fig', timecode2, freeText, progress);
            
            tracking1=0;
            setappdata(h.main, 'tracking1', tracking1)
            setappdata(h.main, 'filename3', filename3)
            setappdata(h.main, 'path21', path21)
            setappdata(h.main, 'path22', path22)
            setappdata(h.main, 'path23', path23)
            setappdata(h.main, 'path24', path24)
            setappdata(h.main, 'path25', path25)
            setappdata(h.main, 'path1', path1)
            setappdata(h.main, 'path2', path2)
            setappdata(h.main, 'path3', path3)
            setappdata(h.main, 'path4', path4)
            setappdata(h.main, 'path5', path5)
            setappdata(h.main, 'p', p)
            setappdata(h.main, 'offset', offset)
            setappdata(h.main, 'noAnimals', noAnimals)
            setappdata(h.main, 'errFrames', errFrames)
            setappdata(h.main, 'errFrames_2', errFrames_2)
            
            curFol=pwd;
            set(h.cur_Fol, 'String', curFol)
            set(h.TRACK, 'BackgroundColor', [0 0.9 0])
            savefig(1, filename3);
            disp('Erroneus Frames in Video 1: ')
            errFrames
            disp('Erroneus Frames in Video 2: ')
            errFrames_2
            
            disp('2D tracking successful!')
            
            
        elseif tracking1==1     %if the first video has already been tracked
            set(h.TRACK, 'BackgroundColor', [0.9 0.2 0])
            StartFrame_Red=getappdata(h.main, 'StartFrame_Red');
            StartFrame_Green=getappdata(h.main, 'StartFrame_Green');
            StartFrame_Green2=getappdata(h.main, 'StartFrame_Green2');
            vid1=getappdata(h.main, 'vid1');
            vid2=getappdata(h.main, 'vid2');
            blobM=getappdata(h.main, 'blobM');
            blobM2=getappdata(h.main, 'blobM2');
            timecode2=getappdata(h.main, 'timecode2');
            freeText=getappdata(h.main, 'freeText');
            delay=0;
            figPos_1=getappdata(h.main, 'figPos_1');
            offset=getappdata(h.main, 'offset');
            path1=getappdata(h.main, 'path1');
            path2=getappdata(h.main, 'path2');
            path3=getappdata(h.main, 'path3');
            path4=getappdata(h.main, 'path4');
            path5=getappdata(h.main, 'path5');
            p=getappdata(h.main, 'p');
            noAnimals=getappdata(h.main, 'noAnimals');
            errFrames=getappdata(h.main, 'errFrames');
            k2=getappdata(h.main, 'k2');
            circSize=getappdata(h.main, 'circSize');
            
            BlopDistThresh=40;
            disp('Starting with video number 2.')
            MFquestdlg([ 1.4 , 0.45 ],'The video from Pi red has already been analysed. You will start with video number 2. If you want to track both videos again, please cancel this tracking via "ESC" and redo the synchronisation. For help with the animals positions, see the 5_tracking2D-folder with an image of positions from video 1.', ...
                'Starting Tracking Video from Pi green', ...
                'OK','OK');
            interruption=0;
            
            % camera 2:
            % Define the Position of water fleas in the start frame of video 1
            c=calib.firstFrame+StartFrame_Green+offset;
            setappdata(h.main, 'startGreen', c)
            x=1;        %variable to count the length of the track
            imgStart = read(vid2, c); %k must be the first frame of the video to be analysed
            figure(5);
            set(gcf,'KeyPressFcn', @key_pressed)
            imshow(imgStart)
            set(gcf,'position',[1780 50 1500 900])
            
            message = sprintf('Please click on every animal to mark the starting positions for camera green. \nIf you have less than five animals, please place the superfluous starting positions in the margins of the figure. \nPress "Start" to begin, "Cancel" to interrupt.');
            reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Animal starting positions camera green', 'Start', 'Cancel', 'Start');
            switch reply
                case 'Start'
                    [orginalPositions2X, orginalPositions2Y]=ginputW(5);
                    close(figure(5))
                    
                    figure(2);
                    set(gcf,'KeyPressFcn', @key_pressed)
                    figPos_2=[1780 50 1500 900];
                    
                    a=imshow(imgStart);
                    set(gcf,'position',figPos_2)
                    hold on
                    scatter(orginalPositions2X(1),orginalPositions2Y(1),100,'r', 'o');
                    scatter(orginalPositions2X(2),orginalPositions2Y(2),100,'y', 'o');
                    scatter(orginalPositions2X(3),orginalPositions2Y(3),100,'c', 'o');
                    scatter(orginalPositions2X(4),orginalPositions2Y(4),100,'m', 'o');
                    scatter(orginalPositions2X(5),orginalPositions2Y(5),100, dg, 'Marker', 'o');
                    text(orginalPositions2X(1),orginalPositions2Y(1), '\leftarrow animal 1', 'Color', 'w')
                    text(orginalPositions2X(2),orginalPositions2Y(2), '\leftarrow animal 2', 'Color', 'w')
                    text(orginalPositions2X(3),orginalPositions2Y(3), '\leftarrow animal 3', 'Color', 'w')
                    text(orginalPositions2X(4),orginalPositions2Y(4), '\leftarrow animal 4', 'Color', 'w')
                    text(orginalPositions2X(5),orginalPositions2Y(5), '\leftarrow animal 5', 'Color', 'w')
                    hold off
                    
                    filename5=sprintf('%s_%s_2.png', timecode2, freeText);
                    saveas(a, filename5)
                    
                    im=imread(filename5);
                    imshow(im);
                    figure (6);
                    set(gcf,'position', [100 50 1500 900])
                    set(gcf,'KeyPressFcn', @key_pressed)
                    
                    originalPositions2=[orginalPositions2X, orginalPositions2Y];
                    listBlopsInFrame2=cat(1,blobM2.(['frame' num2str(c)]).Centroid);
                    
                    % generate path-arrays with individual name
                    for p = 1:size(originalPositions2, 1)
                        paths=genvarname(['path2' num2str(p)]);
                        eval([paths '=originalPositions2(p,:);']);
                    end
                    
                    % calculate the distance between the blop position in the current frame and the frame before (here it is the start frame)
                    for z1 = 1:(size(listBlopsInFrame2, 1))
                        p1=listBlopsInFrame2(z1,:);
                        for z2 = 1:size(originalPositions2, 1)
                            P2=originalPositions2(z2,:);
                            distances2(z1, z2)= pdist2(p1,P2,'euclidean');
                        end
                    end
                    x=x+1;          %counting the length of the tracks
                    
                    h1=2;
                    h2=2;
                    h3=2;
                    h4=2;
                    h5=2;
                    clear I;
                    for z3 = 1:size(originalPositions2, 1)
                        if (z3<=size(listBlopsInFrame2,1))
                            [PosVector, I, ~] = find(distances2==min(distances2(:)));      %detect smallest distance
                            if I==1
                                if (min(distances2(:))<=BlopDistThresh)
                                    path21(h1,:)=listBlopsInFrame2(PosVector,:);
                                else
                                    path21(h1,:)=path21(h1-1,:);
                                end
                                h1=h1+1;
                            elseif I==2
                                if (min(distances2(:))<=BlopDistThresh)
                                    path22(h2,:)=listBlopsInFrame2(PosVector,:);
                                else
                                    path22(h2,:)=path22(h2-1,:);
                                end
                                h2=h2+1;
                            elseif I==3
                                if (min(distances2(:))<=BlopDistThresh)
                                    path23(h3,:)=listBlopsInFrame2(PosVector,:);
                                else
                                    path23(h3,:)=path23(h3-1,:);
                                end
                                h3=h3+1;
                            elseif I==4
                                if (min(distances2(:))<=BlopDistThresh)
                                    path24(h4,:)=listBlopsInFrame2(PosVector,:);
                                else
                                    path24(h4,:)=path24(h4-1,:);
                                end
                                h4=h4+1;
                            elseif I==5
                                if (min(distances2(:))<=BlopDistThresh)
                                    path25(h5,:)=listBlopsInFrame2(PosVector,:);
                                else
                                    path25(h5,:)=path25(h5-1,:);
                                end
                                h5=h5+1;
                            else
                                disp('That was unexpected! 1')
                            end
                            if (z3<=size(originalPositions2, 1))
                                distances2(:, I)=10000;
                                distances2(PosVector, :)=10000;
                            else
                                disp('That was unexpected! 2')
                            end
                        else                            %if all blops are already used, copy the x and y values from the last frame
                            if (h1<h2 || h1<h3 || h1<h4 || h1<h5)
                                path21(h1,:)=path21(h1-1,:);
                                h1=h1+1;
                            elseif (h2<h1 || h2<h3 || h2<h4 || h2<h5)
                                path22(h2,:)=path22(h2-1,:);
                                h2=h2+1;
                            elseif (h3<h1 || h3<h2 || h3<h4 || h3<h5)
                                path23(h3,:)=path23(h3-1,:);
                                h3=h3+1;
                            elseif (h4<h1 || h4<h2 || h4<h3 || h4<h5)
                                path24(h4,:)=path24(h4-1,:);
                                h4=h4+1;
                            elseif (h5<h1 || h5<h2 || h5<h3 || h5<h4)
                                path25(h5,:)=path25(h5-1,:);
                                h5=h5+1;
                            else
                                disp('That was unexpected! 3')
                            end
                        end
                    end
                    x=x+1;
                    disp(c)
                    % ---------------------------------------------------------------------
                    % ---------------------------------------------------------------------
                    % loop over the third and following frames in the video
                    errFrames_2=0;
                    c=c+1;
                    disp(c)
                    while c<k2-StartFrame_Green2
                        listBlopsInFrame2=cat(1,blobM2.(['frame' num2str(c)]).Centroid);
                        pause(delay)
                        if (interruption==0)
                        elseif (interruption==1)
                            disp('Tracking interrupted!');
                            x=x-1;
                            c=c-1;
                            h1=h1-1;
                            h2=h2-1;
                            h3=h3-1;
                            h4=h4-1;
                            h5=h5-1;
                            
                            %this is for position correction in tracking
                            for i=1:100
                                choice = MFquestdlg([ 1.4 , 0.45 ],'Press ´backwards´/´forwards´ to find the first frame of the tracking error. Press ´choose´ to start the correction.', ...
                                    'Finding tracking error', ...
                                    'backwards','choose','forwards', 'backwards');
                                goEsc=isempty(choice);
                                if goEsc==1
                                    terminateExecution
                                else
                                    switch choice
                                        case 'backwards'
                                            x=x-5;
                                            if x<1
                                                x=x+5;
                                                disp('You cannot proceed to frames that are not part of the analysis.')
                                            else
                                                c=c-5;
                                                disp(c)
                                                h1=h1-5;
                                                h2=h2-5;
                                                h3=h3-5;
                                                h4=h4-5;
                                                h5=h5-5;
                                                
                                                imgBackground=read(vid2, c);
                                                hold on
                                                imagesc(imgBackground);
                                                xlabel('y-axis');
                                                ylabel('z-axis');
                                                
                                                imshow(imgBackground)
                                                plot(path21(x,1), path21(x,2), 'r--o', 'MarkerSize', circSize);
                                                plot(path22(x,1), path22(x,2), 'y--o', 'MarkerSize', circSize);
                                                plot(path23(x,1), path23(x,2), 'c--o', 'MarkerSize', circSize);
                                                plot(path24(x,1), path24(x,2), 'm--o', 'MarkerSize', circSize);
                                                plot(path25(x,1), path25(x,2), 'color', dg, 'Marker', 'o', 'MarkerSize', circSize);
                                                hold off
                                                set(gca,'YDir', 'reverse');
                                                set(gcf,'position',[100 50 1500 900])
                                                title('Tracks from Raspberry Pi green')
                                                drawnow;
                                                disp(c)
                                                textVideo{1,6}=['Current frame: ', num2str(c)];
                                                set(h.vid_Info, 'String', textVideo)
                                            end
                                        case 'choose'
                                            disp(c)
                                            textVideo{1,6}=['Current frame: ', num2str(c)];
                                            set(h.vid_Info, 'String', textVideo)
                                            break;
                                        case 'forwards'
                                            x=x+1;
                                            if x>length(path21(:,1))
                                                x=x-1;
                                                disp('You cannot proceed to frames not yet tracked.')
                                            else
                                                c=c+1;
                                                disp(c)
                                                h1=h1+1;
                                                h2=h2+1;
                                                h3=h3+1;
                                                h4=h4+1;
                                                h5=h5+1;
                                                
                                                imgBackground=read(vid2, c);
                                                hold on
                                                imagesc(imgBackground);
                                                xlabel('y    -axis');
                                                ylabel('z-axis');
                                                
                                                imshow(imgBackground)
                                                plot(path21(x,1), path21(x,2), 'r--o', 'MarkerSize', circSize);
                                                plot(path22(x,1), path22(x,2), 'y--o', 'MarkerSize', circSize);
                                                plot(path23(x,1), path23(x,2), 'c--o', 'MarkerSize', circSize);
                                                plot(path24(x,1), path24(x,2), 'm--o', 'MarkerSize', circSize);
                                                                 plot(path25(x,1), path25(x,2), 'color', dg, 'Marker', 'o', 'MarkerSize', circSize);
                                                hold off
                                                set(gca,'YDir', 'reverse');
                                                set(gcf,'position',[100 50 1500 900])
                                                title('Tracks from Raspberry Pi green ')
                                                drawnow;
                                               
                                                textVideo{1,6}=['Current frame: ', num2str(c)];
                                                set(h.vid_Info, 'String', textVideo)
                                            end
                                    end
                                end
                            end
                            
                            choice = MFquestdlg([ 1.4 , 0.45 ],'Do you want to continue with the tracking or correct the animal positions?', ...
                                'Correcting animal positions', ...
                                'Continue','Correct','Continue');
                            switch choice
                                case 'Continue'
                                    interruption=0;
                                case 'Correct'
                                    message = sprintf('Red: Press correct to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Red(1) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX1, corrY1]=ginputW(1);
                                            path21(x,:)=[corrX1 corrY1];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 1.')
                                    end
                                     
                                    message = sprintf('Yellow: Press correct to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Yellow(2) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX2, corrY2]=ginputW(1);
                                            path22(x,:)=[corrX2 corrY2];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 2.')
                                    end
                                    message = sprintf('Cyan: Press correct to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Cyan(3) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX3, corrY3]=ginputW(1);
                                            path23(x,:)=[corrX3 corrY3];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 3.')
                                    end
                                    
                                    message = sprintf('Magenta: Press correct to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Magenta(4) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX4, corrY4]=ginputW(1);
                                            path24(x,:)=[corrX4 corrY4];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 4.')
                                    end
                                    message = sprintf('Green: Press correct to correct the position. You can mark the right position with crosshairs. Press ´Don´t correct´ if you want to leave the position assignment as it is.');
                                    reply = MFquestdlg([ 1.4 , 0.45 ],message, 'Green(5) position correction', 'Correct', 'Don´t correct', 'Correct');
                                    
                                    switch reply
                                        case 'Correct'
                                            [corrX5, corrY5]=ginputW(1);
                                            path25(x,:)=[corrX5 corrY5];
                                        case 'Don´t correct'
                                            disp('No changes carried out in position 5.')
                                    end
                            end
                            
                            x=x+1;
                            c=c+1;
                            h1=h1+1;
                            h2=h2+1;
                            h3=h3+1;
                            h4=h4+1;
                            h5=h5+1;
                            interruption=0;
                        else
                            disp('There is a problem with the interruption of tracking.')
                        end
                        
                        % calculate the distance between the blop position in the current frame and the frame before
                        for z1 = 1:(size(listBlopsInFrame2,1))
                            p1=listBlopsInFrame2(z1,:);                  %current blops' position
                            for z2 = 1:p
                                if z2==1
                                    P2=path21((x-1),:);                     %blops' position in the previous frame
                                elseif z2==2
                                    P2=path22((x-1),:);
                                elseif z2==3
                                    P2=path23((x-1),:);
                                elseif z2==4
                                    P2=path24((x-1),:);
                                elseif z2==5
                                    P2=path25((x-1),:);
                                else
                                    disp('That was unexpected!_4')
                                end
                                distances2(z1, z2)= pdist2(p1,P2,'euclidean');
                            end
                        end
                        for z3 = 1:p
                            if (z3<=(size(listBlopsInFrame2,1)))
                                [PosVector, I, ~] = find(distances2==min(distances2(:)));      %detect smallest distance
                                if I==1
                                    if (min(distances2(:))<=BlopDistThresh)
                                        path21(h1,:)=listBlopsInFrame2(PosVector,:);
                                    else
                                        path21(h1,:)=path21(h1-1,:);
                                    end
                                    h1=h1+1;
                                elseif I==2
                                    if (min(distances2(:))<=BlopDistThresh)
                                        path22(h2,:)=listBlopsInFrame2(PosVector,:);
                                    else
                                        path22(h2,:)=path22(h2-1,:);
                                    end
                                    h2=h2+1;
                                elseif I==3
                                    if (min(distances2(:))<=BlopDistThresh)
                                          path23(h3,:)=listBlopsInFrame2(PosVector,:);
                                    else
                                        path23(h3,:)=path23(h3-1,:);
                                    end
                                    h3=h3+1;
                                elseif I==4
                                    if (min(distances2(:))<=BlopDistThresh)
                                        path24(h4,:)=listBlopsInFrame2(PosVector,:);
                                    else
                                        path24(h4,:)=path24(h4-1,:);
                                    end
                                    h4=h4+1;
                                elseif I==5
                                    if (min(distances2(:))<=BlopDistThresh)
                                        path25(h5,:)=listBlopsInFrame2(PosVector,:);
                                    else
                                        path25(h5,:)=path25(h5-1,:);
                                    end
                                    h5=h5+1;
                                else
                                    disp('That was unexpected!_1')
                                    
                                    errFrames1=x;
                                    errFrames_2=vertcat(errFrames_2, errFrames1);
                                end
                                
                                if (z3<=size(originalPositions2, 1))
                                    distances2(:, I)=10000;
                                    distances2(PosVector, :)=10000;
                                else
                                    disp('That was unexpected! 2')
                                end
                            else                            %if all blops are already used, copy the x and y values from the last frame
                                if (h1<h2 || h1<h3 || h1<h4 || h1<h5)
                                    path21(h1,:)=path21(h1-1,:);
                                    h1=h1+1;
                                elseif (h2<h1 || h2<h3 || h2<h4 || h2<h5)
                                    path22(h2,:)=path22(h2-1,:);
                                    h2=h2+1;
                                elseif (h3<h1 || h3<h2 || h3<h4 || h3<h5)
                                    path23(h3,:)=path23(h3-1,:);
                                    h3=h3+1;
                                elseif (h4<h1 || h4<h2 || h4<h3 || h4<h5)
                                    path24(h4,:)=path24(h4-1,:);
                                    h4=h4+1;
                                elseif (h5<h1 || h5<h2 || h5<h3 || h5<h4)
                                    path25(h5,:)=path25(h5-1,:);
                                    h5=h5+1;
                                else
                                    disp('That was unexpected! 3_')
                                end
                            end
                        end
                        
                        %check the length of each path before plotting it
                        if size(path21(:,1))<x
                            path21=[path21;path21(x-1,:)];
                            h1=h1+1;
                            disp('path21 exists now!')
                        else
                        end
                        if size(path22(:,1))<x
                            path22=[path22;path22(x-1,:)];
                            h2=h2+1;
                            disp('path22 exists now!')
                        else
                        end
                        if size(path23(:,1))<x
                            path23=[path23;path23(x-1,:)];
                            h3=h3+1;
                            disp('path23 exists now!')
                        else
                        end
                        if size(path24(:,1))<x
                            path24=[path24;path24(x-1,:)];
                            h4=h4+1;
                            disp('path24 exists now!')
                        else
                        end
                        if size(path25(:,1))<x
                            path25=[path25;path25(x-1,:)];
                            h5=h5+1;
                            disp('path25 exists now!')
                        else
                        end
                        
                        c=c+1;
                        disp(c)
                        
                        imgBackground=read(vid2, c);
                        
                        %live plotting of tracking
                        if mod(x,20)==0
                            close figure 6
                            f=figure(6);
                            set(f,'KeyPressFcn', @key_pressed)
                        else
                            f=figure(6);
                            set(f,'KeyPressFcn', @key_pressed)
                        end
                        
                        hold on
                        imagesc(imgBackground);
                        xlabel('y-axis');
                        ylabel('z-axis');
                        
                        %imshow(imgBackground)
                        plot(path21(x,1), path21(x,2), 'r--o', 'MarkerSize', circSize);
                        plot(path22(x,1), path22(x,2), 'y--o', 'MarkerSize', circSize);
                        plot(path23(x,1), path23(x,2), 'c--o', 'MarkerSize', circSize);
                        plot(path24(x,1), path24(x,2), 'm--o', 'MarkerSize', circSize);
                        plot(path25(x,1), path25(x,2), 'color', dg, 'Marker', 'o', 'MarkerSize', circSize);
                        set(gca,'YDir', 'reverse');
                        set(gcf,'position',[100 50 1500 900])
                        hold off
                        title('Tracks from Raspberry Pi green')
                        drawnow
                        x=x+1;
                    end
                case 'Cancel'
                    terminateExecution;
                    disp('2D tracking was interrupted by user.')
            end
            
            close figure 6
            close figure 2
            disp('Position assignment finished for video 2.')
            
            %save data and figures
            cd 'S:\Admin\Tracking\raw data-input\5_tracking2D'
            progress='TR';
            filename3=sprintf('%s_%s_%s.fig', timecode2, freeText, progress);
            
            tracking1=0;
            setappdata(h.main, 'tracking1', tracking1)
            setappdata(h.main, 'filename3', filename3)
            setappdata(h.main, 'path21', path21)
            setappdata(h.main, 'path22', path22)
            setappdata(h.main, 'path23', path23)
            setappdata(h.main, 'path24', path24)
            setappdata(h.main, 'path25', path25)
            setappdata(h.main, 'path1', path1)
            setappdata(h.main, 'path2', path2)
            setappdata(h.main, 'path3', path3)
            setappdata(h.main, 'path4', path4)
            setappdata(h.main, 'path5', path5)
            setappdata(h.main, 'p', p)
            setappdata(h.main, 'offset', offset)
            setappdata(h.main, 'noAnimals', noAnimals)
            setappdata(h.main, 'errFrames', errFrames)
            setappdata(h.main, 'errFrames_2', errFrames_2)
            
            curFol=pwd;
            set(h.cur_Fol, 'String', curFol)
            set(h.TRACK, 'BackgroundColor', [0 0.9 0])
            savefig(1, filename3);
            disp('Erroneus Frames in Video 1: ')
            disp(errFrames)
            disp('Erroneus Frames in Video 2: ')
            disp(errFrames_2)
            
            disp('2D tracking successful!')
        else
            disp('Please synchronise again!')
        end
    end


    function Calculation(~,~)
        calib=load('cameraCalibrations_200918.mat');
        set(h.CALC, 'BackgroundColor', [0.9 0.2 0])
        %get necessary variables back from figure
        path21=getappdata(h.main, 'path21');
        path22=getappdata(h.main, 'path22');
        path23=getappdata(h.main, 'path23');
        path24=getappdata(h.main, 'path24');
        path25=getappdata(h.main, 'path25');
        path1=getappdata(h.main, 'path1');
        path2=getappdata(h.main, 'path2');
        path3=getappdata(h.main, 'path3');
        path4=getappdata(h.main, 'path4');
        path5=getappdata(h.main, 'path5');
        p=getappdata(h.main, 'p');
        captureDuration=getappdata(h.main, 'captureDuration');
        timecode2=getappdata(h.main, 'timecode2');
        vid1=getappdata(h.main, 'vid1');
        freeText=getappdata(h.main, 'freeText');
        noAnimals=getappdata(h.main, 'noAnimals');
        
        % calculate 2D Positions for all paths
        for r=1:size(path1(:,1),1)          %calculate Positions for all frames
            for t=1:p                           %loop through all five tracks
                if t==1
                    posX1=path1(r,1);
                    posY1=path1(r,2);
                    posX2=path21(r,1);
                    posY2=path21(r,2);
                    
                    % transfer blop-track-data into actual mm-position data
                    actPos_Cam1(r, t+2*t)=(posX1-calib.originX1)/calib.d_mm_1;
                    actPos_Cam1(r, t+2*t+1)=0;
                    actPos_Cam1(r, t+2*t+2)=(posY1-calib.originY1)/calib.d_mm_1;
                    
                    actPos_Cam2(r, t+2*t)=0;
                    actPos_Cam2(r, t+2*t+1)=(posX2-calib.originX2)/calib.d_mm_2;
                    actPos_Cam2(r, t+2*t+2)=(posY2-calib.originY2)/calib.d_mm_2;
                    
                elseif t==2
                    posX1=path2(r,1);
                    posY1=path2(r,2);
                    posX2=path22(r,1);
                    posY2=path22(r,2);
                    % transfer blop-track-data into actual mm-position data
                    
                    actPos_Cam1(r, t+2*t)=(posX1-calib.originX1)/calib.d_mm_1;
                    actPos_Cam1(r, t+2*t+1)=0;
                    actPos_Cam1(r, t+2*t+2)=(posY1-calib.originY1)/calib.d_mm_1;
                    
                    actPos_Cam2(r, t+2*t)=0;
                    actPos_Cam2(r, t+2*t+1)=(posX2-calib.originX2)/calib.d_mm_2;
                    actPos_Cam2(r, t+2*t+2)=(posY2-calib.originY2)/calib.d_mm_2;
                    
                elseif t==3
                    posX1=path3(r,1);
                    posY1=path3(r,2);
                    posX2=path23(r,1);
                    posY2=path23(r,2);
                    % transfer blop-track-data into actual mm-position data
                    
                    actPos_Cam1(r, t+2*t)=(posX1-calib.originX1)/calib.d_mm_1;
                    actPos_Cam1(r, t+2*t+1)=0;
                    actPos_Cam1(r, t+2*t+2)=(posY1-calib.originY1)/calib.d_mm_1;
                    
                    actPos_Cam2(r, t+2*t)=0;
                    actPos_Cam2(r, t+2*t+1)=(posX2-calib.originX2)/calib.d_mm_2;
                    actPos_Cam2(r, t+2*t+2)=(posY2-calib.originY2)/calib.d_mm_2;
                    
                elseif t==4
                    posX1=path4(r,1);
                    posY1=path4(r,2);
                    posX2=path24(r,1);
                    posY2=path24(r,2);
                    % transfer blop-track-data into actual mm-position data
                    
                    actPos_Cam1(r, t+2*t)=(posX1-calib.originX1)/calib.d_mm_1;
                    actPos_Cam1(r, t+2*t+1)=0;
                    actPos_Cam1(r, t+2*t+2)=(posY1-calib.originY1)/calib.d_mm_1;
                    
                    actPos_Cam2(r, t+2*t)=0;
                    actPos_Cam2(r, t+2*t+1)=(posX2-calib.originX2)/calib.d_mm_2;
                    actPos_Cam2(r, t+2*t+2)=(posY2-calib.originY2)/calib.d_mm_2;
                    
                elseif t==5
                    posX1=path5(r,1);
                    posY1=path5(r,2);
                    posX2=path25(r,1);
                    posY2=path25(r,2);
                    % transfer blop-track-data into actual mm-position data
                    
                    actPos_Cam1(r, t+2*t)=(posX1-calib.originX1)/calib.d_mm_1;
                    actPos_Cam1(r, t+2*t+1)=0;
                    actPos_Cam1(r, t+2*t+2)=(posY1-calib.originY1)/calib.d_mm_1;
                    
                    actPos_Cam2(r, t+2*t)=0;
                    actPos_Cam2(r, t+2*t+1)=(posX2-calib.originX2)/calib.d_mm_2;
                    actPos_Cam2(r, t+2*t+2)=(posY2-calib.originY2)/calib.d_mm_2;
                else
                    disp('That was unexpected_10!')
                end
            end
        end
        
        % ------------------------------------------------------------------------
        % ------------------------------------------------------------------------
        
        % calculate 3D Positions for all paths based on lines
        
        % lines: g=a+r*v for camera 1 and h=b+s*w for camera 2
        
        for r=1:size(path1(:,1),1)                  %calculate Positions for all frames
            for t=1:p                               %loop through all five tracks
                
                % measured points:
                xcam1=actPos_Cam1(r, t+2*t);          %entweder oben mit einbauen oder neu ansetzen zur Berechnung, nach p=1:5 und dann nach frames
                ycam1=actPos_Cam1(r, t+2*t+1);
                zcam1=actPos_Cam1(r, t+2*t+2);
                
                xcam2=actPos_Cam2(r, t+2*t);
                ycam2=actPos_Cam2(r, t+2*t+1);
                zcam2=actPos_Cam2(r, t+2*t+2);
                
                % % define lines' coordinates
                % calculate direction vectors
                vx=xcam1 - calib.cam1x;
                vy=ycam1 - calib.cam1y;
                vz=zcam1 - calib.cam1z;
                
                wx=xcam2 - calib.cam2x;
                wy=ycam2 - calib.cam2y;
                wz=zcam2 - calib.cam2z;
                
                % set up parameters for lines
                a(r,1:3)=[calib.cam1x calib.cam1y calib.cam1z];
                b(r,1:3)=[calib.cam2x calib.cam2y calib.cam2z];
                v(r,1:3)=[vx vy vz];
                w(r,1:3)=[wx wy wz];
                
                % calculate cross product to determine normal vector of supporting plane
                n(r,1:3) = cross(v(r,1:3),w(r,1:3));
                
                % determining the foots on the lines
                n1(r,1:3)=cross(v(r,1:3), n(r,1:3));
                Fh(r,1:3)=((dot(a(r,1:3),n1(r,1:3))-dot(b(r,1:3),n1(r,1:3)))/dot(w(r,1:3),n1(r,1:3)))*w(r,1:3)+b(r,1:3);
                
                n2(r,1:3)=cross(w(r,1:3), n(r,1:3));
                Fg(r,1:3)=((dot(b(r,1:3),n2(r,1:3))-dot(a(r,1:3),n2(r,1:3)))/dot(v(r,1:3),n2(r,1:3)))*v(r,1:3)+a(r,1:3);
                
                % determining the average point inbetween
                PosDaph(r,1:3)=(Fh(r,1:3)+Fg(r,1:3))/2;
                
                %determining accuracy as distance between foots, again for all five tracks
                dist(r,t) = sqrt((Fh(r,1)-Fg(r,1))^2 + (Fh(r,2)-Fg(r,2))^2 + (Fh(r,3)-Fg(r,3))^2);
                
                if t==1
                    ParamsTrack1(r,1:10)=[Fh(r,1:3) Fg(r,1:3) PosDaph(r,1:3) dist(r,1)];
                elseif t==2
                    ParamsTrack2(r,1:10)=[Fh(r,1:3) Fg(r,1:3) PosDaph(r,1:3) dist(r,2)];
                elseif t==3
                    ParamsTrack3(r,1:10)=[Fh(r,1:3) Fg(r,1:3) PosDaph(r,1:3) dist(r,3)];
                elseif t==4
                    ParamsTrack4(r,1:10)=[Fh(r,1:3) Fg(r,1:3) PosDaph(r,1:3) dist(r,4)];
                elseif t==5
                    ParamsTrack5(r,1:10)=[Fh(r,1:3) Fg(r,1:3) PosDaph(r,1:3) dist(r,5)];
                else
                    disp('Something is wrong with the track assignment')
                end
            end
            disp(r)
        end
        
        %calculate accuracy of tracking
        error_quotient=dist/2;
        CoordsTrack1=ParamsTrack1(:, 7:9);
        CoordsTrack2=ParamsTrack2(:, 7:9);
        CoordsTrack3=ParamsTrack3(:, 7:9);
        CoordsTrack4=ParamsTrack4(:, 7:9);
        CoordsTrack5=ParamsTrack5(:, 7:9);
        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------
        %--------------------------------------------------------------------------
        
        %determine velocities
        
        %-----------------------------
        %preparation for frame-wise velocity
        r=1;
        while r<size(CoordsTrack1(:,1),1)
            distance_covered(r,1)=sqrt((CoordsTrack1(r+1,1)-CoordsTrack1(r,1))^2+(CoordsTrack1(r+1,2)-CoordsTrack1(r,2))^2+(CoordsTrack1(r+1,3)-CoordsTrack1(r,3))^2);
            distance_covered(r,2)=sqrt((CoordsTrack2(r+1,1)-CoordsTrack2(r,1))^2+(CoordsTrack2(r+1,2)-CoordsTrack2(r,2))^2+(CoordsTrack2(r+1,3)-CoordsTrack2(r,3))^2);
            distance_covered(r,3)=sqrt((CoordsTrack3(r+1,1)-CoordsTrack3(r,1))^2+(CoordsTrack3(r+1,2)-CoordsTrack3(r,2))^2+(CoordsTrack3(r+1,3)-CoordsTrack3(r,3))^2);
            distance_covered(r,4)=sqrt((CoordsTrack4(r+1,1)-CoordsTrack4(r,1))^2+(CoordsTrack4(r+1,2)-CoordsTrack4(r,2))^2+(CoordsTrack4(r+1,3)-CoordsTrack4(r,3))^2);
            distance_covered(r,5)=sqrt((CoordsTrack5(r+1,1)-CoordsTrack5(r,1))^2+(CoordsTrack5(r+1,2)-CoordsTrack5(r,2))^2+(CoordsTrack5(r+1,3)-CoordsTrack5(r,3))^2);
            r=r+1;
        end
        
        %velocity in [mm/s] in every frame
        %duration of one frame:
        lengthOfFrame=1/(vid1.NumberOfFrames/captureDuration);
        distance_covered_mm_s=distance_covered/lengthOfFrame;
        
        %--------------------------------------
        %determine velocity for approximately every second
        x=1;
        for r=1:30:(floor(size(CoordsTrack1(:,1),1)/30)*30-30)
            distance_covered_s(x,1)=sqrt((CoordsTrack1(r+30,1)-CoordsTrack1(r,1))^2+(CoordsTrack1(r+30,2)-CoordsTrack1(r,2))^2+(CoordsTrack1(r+30,3)-CoordsTrack1(r,3))^2);
            distance_covered_s(x,2)=sqrt((CoordsTrack2(r+30,1)-CoordsTrack2(r,1))^2+(CoordsTrack2(r+30,2)-CoordsTrack2(r,2))^2+(CoordsTrack2(r+30,3)-CoordsTrack2(r,3))^2);
            distance_covered_s(x,3)=sqrt((CoordsTrack3(r+30,1)-CoordsTrack3(r,1))^2+(CoordsTrack3(r+30,2)-CoordsTrack3(r,2))^2+(CoordsTrack3(r+30,3)-CoordsTrack3(r,3))^2);
            distance_covered_s(x,4)=sqrt((CoordsTrack4(r+30,1)-CoordsTrack4(r,1))^2+(CoordsTrack4(r+30,2)-CoordsTrack4(r,2))^2+(CoordsTrack4(r+30,3)-CoordsTrack4(r,3))^2);
            distance_covered_s(x,5)=sqrt((CoordsTrack5(r+30,1)-CoordsTrack5(r,1))^2+(CoordsTrack5(r+30,2)-CoordsTrack5(r,2))^2+(CoordsTrack5(r+30,3)-CoordsTrack5(r,3))^2);
            r=r+1;
            x=x+1;
        end
        %velocity in [mm/s]
        %duration of 30 frames:
        lengthOf30Frames=lengthOfFrame*30;
        distance_covered_s_mm_s=distance_covered_s/lengthOf30Frames;
        
        %--------------------------------------
        %determine velocity for approximately every half second
        x=1;
        for r=1:15:(floor(size(CoordsTrack1(:,1),1)/15)*15-15)
            distance_covered_s05(x,1)=sqrt((CoordsTrack1(r+15,1)-CoordsTrack1(r,1))^2+(CoordsTrack1(r+15,2)-CoordsTrack1(r,2))^2+(CoordsTrack1(r+15,3)-CoordsTrack1(r,3))^2);
            distance_covered_s05(x,2)=sqrt((CoordsTrack2(r+15,1)-CoordsTrack2(r,1))^2+(CoordsTrack2(r+15,2)-CoordsTrack2(r,2))^2+(CoordsTrack2(r+15,3)-CoordsTrack2(r,3))^2);
            distance_covered_s05(x,3)=sqrt((CoordsTrack3(r+15,1)-CoordsTrack3(r,1))^2+(CoordsTrack3(r+15,2)-CoordsTrack3(r,2))^2+(CoordsTrack3(r+15,3)-CoordsTrack3(r,3))^2);
            distance_covered_s05(x,4)=sqrt((CoordsTrack4(r+15,1)-CoordsTrack4(r,1))^2+(CoordsTrack4(r+15,2)-CoordsTrack4(r,2))^2+(CoordsTrack4(r+15,3)-CoordsTrack4(r,3))^2);
            distance_covered_s05(x,5)=sqrt((CoordsTrack5(r+15,1)-CoordsTrack5(r,1))^2+(CoordsTrack5(r+15,2)-CoordsTrack5(r,2))^2+(CoordsTrack5(r+15,3)-CoordsTrack5(r,3))^2);
            r=r+1;
            x=x+1;
        end
        
        
        %velocity in [mm/s]
        %duration of 15 frames:
        lengthOf15Frames=lengthOfFrame*15;
        distance_covered_s_mm_s_2=distance_covered_s05/lengthOf15Frames;
        
        %--------------------------------------
        %determine velocity for approximately 1/5th second
        x=1;
        for r=1:6:(floor(size(CoordsTrack1(:,1),1)/6)*6-6)
            distance_covered_s6f(x,1)=sqrt((CoordsTrack1(r+6,1)-CoordsTrack1(r,1))^2+(CoordsTrack1(r+6,2)-CoordsTrack1(r,2))^2+(CoordsTrack1(r+6,3)-CoordsTrack1(r,3))^2);
            distance_covered_s6f(x,2)=sqrt((CoordsTrack2(r+6,1)-CoordsTrack2(r,1))^2+(CoordsTrack2(r+6,2)-CoordsTrack2(r,2))^2+(CoordsTrack2(r+6,3)-CoordsTrack2(r,3))^2);
            distance_covered_s6f(x,3)=sqrt((CoordsTrack3(r+6,1)-CoordsTrack3(r,1))^2+(CoordsTrack3(r+6,2)-CoordsTrack3(r,2))^2+(CoordsTrack3(r+6,3)-CoordsTrack3(r,3))^2);
            distance_covered_s6f(x,4)=sqrt((CoordsTrack4(r+6,1)-CoordsTrack4(r,1))^2+(CoordsTrack4(r+6,2)-CoordsTrack4(r,2))^2+(CoordsTrack4(r+6,3)-CoordsTrack4(r,3))^2);
            distance_covered_s6f(x,5)=sqrt((CoordsTrack5(r+6,1)-CoordsTrack5(r,1))^2+(CoordsTrack5(r+6,2)-CoordsTrack5(r,2))^2+(CoordsTrack5(r+6,3)-CoordsTrack5(r,3))^2);
            r=r+1;
            x=x+1;
        end
        
        
        %velocity in [mm/s]
        %duration of 6 frames:
        lengthOf6Frames=lengthOfFrame*6;
        distance_covered_s_mm_s_6f=distance_covered_s6f/lengthOf6Frames;
        
         %--------------------------------------
        %determine velocity for approximately 1/10th second
        x=1;
        for r=1:3:(floor(size(CoordsTrack1(:,1),1)/3)*3-3)
            distance_covered_s3f(x,1)=sqrt((CoordsTrack1(r+3,1)-CoordsTrack1(r,1))^2+(CoordsTrack1(r+3,2)-CoordsTrack1(r,2))^2+(CoordsTrack1(r+3,3)-CoordsTrack1(r,3))^2);
            distance_covered_s3f(x,2)=sqrt((CoordsTrack2(r+3,1)-CoordsTrack2(r,1))^2+(CoordsTrack2(r+3,2)-CoordsTrack2(r,2))^2+(CoordsTrack2(r+3,3)-CoordsTrack2(r,3))^2);
            distance_covered_s3f(x,3)=sqrt((CoordsTrack3(r+3,1)-CoordsTrack3(r,1))^2+(CoordsTrack3(r+3,2)-CoordsTrack3(r,2))^2+(CoordsTrack3(r+3,3)-CoordsTrack3(r,3))^2);
            distance_covered_s3f(x,4)=sqrt((CoordsTrack4(r+3,1)-CoordsTrack4(r,1))^2+(CoordsTrack4(r+3,2)-CoordsTrack4(r,2))^2+(CoordsTrack4(r+3,3)-CoordsTrack4(r,3))^2);
            distance_covered_s3f(x,5)=sqrt((CoordsTrack5(r+3,1)-CoordsTrack5(r,1))^2+(CoordsTrack5(r+3,2)-CoordsTrack5(r,2))^2+(CoordsTrack5(r+3,3)-CoordsTrack5(r,3))^2);
            r=r+1;
            x=x+1;
        end
        
        
        %velocity in [mm/s]
        %duration of 3 frames:
        lengthOf3Frames=lengthOfFrame*3;
        distance_covered_s_mm_s_3f=distance_covered_s3f/lengthOf3Frames;
        
        
        %----------------------------------------------------------------------
        %----------------------------------------------------------------------
        %calculate NGDRs for all five tracks
        
        % calculation of NGDR for 2.5 second-fragments (2.5 seconds ca. 75 frames)
        
        %add 75 frames results each
        y=1;
        x=1;
        
        distance_covered_added=zeros(1000,5);  %preallocation for speed
        %summation of distances covered during a frame
        for r=1:(floor(size(CoordsTrack1(:,1),1)/75)*75)
            if mod(r,75)==0
                y=y+1;
            else
                distance_covered_added(y,1)=distance_covered_added(y,1)+distance_covered(r,1);
                distance_covered_added(y,2)=distance_covered_added(y,2)+distance_covered(r,2);
                distance_covered_added(y,3)=distance_covered_added(y,3)+distance_covered(r,3);
                distance_covered_added(y,4)=distance_covered_added(y,4)+distance_covered(r,4);
                distance_covered_added(y,5)=distance_covered_added(y,5)+distance_covered(r,5);
            end
        end
        distance_covered_NGDR=zeros(1000,5);  %preallocation for speed
        %calculate the distance covered within 75 frames/2.5 seconds
        for r=1:75:(floor(size(CoordsTrack1(:,1),1)/75)*75-75)
            distance_covered_NGDR(x,1)=sqrt((CoordsTrack1(r+75,1)-CoordsTrack1(r,1))^2+(CoordsTrack1(r+75,2)-CoordsTrack1(r,2))^2+(CoordsTrack1(r+75,3)-CoordsTrack1(r,3))^2);
            distance_covered_NGDR(x,2)=sqrt((CoordsTrack2(r+75,1)-CoordsTrack2(r,1))^2+(CoordsTrack2(r+75,2)-CoordsTrack2(r,2))^2+(CoordsTrack2(r+75,3)-CoordsTrack2(r,3))^2);
            distance_covered_NGDR(x,3)=sqrt((CoordsTrack3(r+75,1)-CoordsTrack3(r,1))^2+(CoordsTrack3(r+75,2)-CoordsTrack3(r,2))^2+(CoordsTrack3(r+75,3)-CoordsTrack3(r,3))^2);
            distance_covered_NGDR(x,4)=sqrt((CoordsTrack4(r+75,1)-CoordsTrack4(r,1))^2+(CoordsTrack4(r+75,2)-CoordsTrack4(r,2))^2+(CoordsTrack4(r+75,3)-CoordsTrack4(r,3))^2);
            distance_covered_NGDR(x,5)=sqrt((CoordsTrack5(r+75,1)-CoordsTrack5(r,1))^2+(CoordsTrack5(r+75,2)-CoordsTrack5(r,2))^2+(CoordsTrack5(r+75,3)-CoordsTrack5(r,3))^2);
            x=x+1;
        end
        
        %add 30 frames results each
        y=1;
        x=1;
        
        distance_covered_added1=zeros(1000,5);  %preallocation for speed
        %summation of distances covered during a frame
        for r=1:(floor(size(CoordsTrack1(:,1),1)/30)*30)
            if mod(r,30)==0
                y=y+1;
            else
                distance_covered_added1(y,1)=distance_covered_added1(y,1)+distance_covered(r,1);
                distance_covered_added1(y,2)=distance_covered_added1(y,2)+distance_covered(r,2);
                distance_covered_added1(y,3)=distance_covered_added1(y,3)+distance_covered(r,3);
                distance_covered_added1(y,4)=distance_covered_added1(y,4)+distance_covered(r,4);
                distance_covered_added1(y,5)=distance_covered_added1(y,5)+distance_covered(r,5);
            end
        end
        distance_covered_NGDR1=zeros(1000,5);  %preallocation for speed
        %calculate the distance covered within 30 frames/1 second
        for r=1:30:(floor(size(CoordsTrack1(:,1),1)/30)*30-31)
            distance_covered_NGDR1(x,1)=sqrt((CoordsTrack1(r+30,1)-CoordsTrack1(r,1))^2+(CoordsTrack1(r+30,2)-CoordsTrack1(r,2))^2+(CoordsTrack1(r+30,3)-CoordsTrack1(r,3))^2);
            distance_covered_NGDR1(x,2)=sqrt((CoordsTrack2(r+30,1)-CoordsTrack2(r,1))^2+(CoordsTrack2(r+30,2)-CoordsTrack2(r,2))^2+(CoordsTrack2(r+30,3)-CoordsTrack2(r,3))^2);
            distance_covered_NGDR1(x,3)=sqrt((CoordsTrack3(r+30,1)-CoordsTrack3(r,1))^2+(CoordsTrack3(r+30,2)-CoordsTrack3(r,2))^2+(CoordsTrack3(r+30,3)-CoordsTrack3(r,3))^2);
            distance_covered_NGDR1(x,4)=sqrt((CoordsTrack4(r+30,1)-CoordsTrack4(r,1))^2+(CoordsTrack4(r+30,2)-CoordsTrack4(r,2))^2+(CoordsTrack4(r+30,3)-CoordsTrack4(r,3))^2);
            distance_covered_NGDR1(x,5)=sqrt((CoordsTrack5(r+30,1)-CoordsTrack5(r,1))^2+(CoordsTrack5(r+30,2)-CoordsTrack5(r,2))^2+(CoordsTrack5(r+30,3)-CoordsTrack5(r,3))^2);
            x=x+1;
        end
        
        %NGDR-calculation
        NGDR=distance_covered_NGDR./distance_covered_added;
        NGDR1=distance_covered_NGDR1./distance_covered_added1;
        NGDR_total=[nanmean(NGDR1(1:(x-1),1)) nanmean(NGDR1(1:(x-1),2)) nanmean(NGDR1(1:(x-1),3)) nanmean(NGDR1(1:(x-1),4)) nanmean(NGDR1(1:(x-1),5))];
        %NGDR1(find(isnan(NGDR1)))=[];
        
        %AND/NND-calculation
        AND=0;
        NND=0;
        u=1;
        for i=1:30:numel(CoordsTrack1(:,1))
            dist12p=[CoordsTrack1(i,:); CoordsTrack2(i,:)];
            dist13p=[CoordsTrack1(i,:); CoordsTrack3(i,:)];
            dist14p=[CoordsTrack1(i,:); CoordsTrack4(i,:)];
            dist15p=[CoordsTrack1(i,:); CoordsTrack5(i,:)];
            dist23p=[CoordsTrack2(i,:); CoordsTrack3(i,:)];
            dist24p=[CoordsTrack2(i,:); CoordsTrack4(i,:)];
            dist25p=[CoordsTrack2(i,:); CoordsTrack5(i,:)];
            dist34p=[CoordsTrack3(i,:); CoordsTrack4(i,:)];
            dist35p=[CoordsTrack3(i,:); CoordsTrack5(i,:)];
            dist45p=[CoordsTrack4(i,:); CoordsTrack5(i,:)];
            
            dist12=pdist(dist12p);
            dist13=pdist(dist13p);
            dist14=pdist(dist14p);
            dist15=pdist(dist15p);
            dist23=pdist(dist23p);
            dist24=pdist(dist24p);
            dist25=pdist(dist25p);
            dist34=pdist(dist34p);
            dist35=pdist(dist35p);
            dist45=pdist(dist45p);
            
            if noAnimals==1
                disp('No nearest neighbor distance can be calculated.')
                AND(u,1)=0;
                distances=0;
                NND(u,1)=min(distances);
            elseif noAnimals==2
                AND(u,1)=dist12;
                distances=[dist12];
                NND(u,1)=min(distances);
            elseif noAnimals==3
                AND(u,1)=(dist12+dist13+dist23)/3;
                distances=[dist12; dist13;dist23];
                NND(u,1)=min(distances);
            elseif noAnimals==4
                AND(u,1)=(dist12+dist13+dist14+dist23+dist24+dist34)/6;
                distances=[dist12; dist13;dist14;dist23;dist24;dist34];
                NND(u,1)=min(distances);
            elseif noAnimals==5
                AND(u,1)=(dist12+dist13+dist14+dist15+dist23+dist24+dist25+dist34+dist35+dist45)/10;
                distances=[dist12; dist13;dist14;dist15;dist23;dist24;dist25;dist34;dist35;dist45];
                NND(u,1)=min(distances);
            else
                disp('You specified the number of animals to be out of the allowed range. Please specify again.')
                u=u-1;
                prompt={'You specified the number of animals to be out of the allowed range. Please confirm again how many animals you marked (1-5):'};
                answer=inputdlg(prompt,'Number of animals',1,{'5'});
                noAnimals=str2double(answer{1});
            end

            u=u+1;
        end
        
        %calculate the probability of swimming modes
        woNAN=x-1;
        NGDR1=NGDR1(1:woNAN,:);
        NGDR1(isnan(NGDR1))=0;
        
        nomov=zeros(5,1);
        spin=zeros(5,1);
        loop=zeros(5,1);
        hop=zeros(5,1);
        zoom=zeros(5,1);
        for u=1:5
        for i=1:size(NGDR1(:,1),1)
        if NGDR1(i,u)<0.02
            nomov(u,1)=nomov(u,1)+1;
        elseif NGDR1(i,u)<0.25 && NGDR1(i,u)>=0.02
            spin(u,1)=spin(u,1)+1;
        elseif NGDR1(i,u)<0.6 && NGDR1(i,u)>=0.25
            loop(u,1)=loop(u,1)+1;
        elseif NGDR1(i,u)<0.9 && NGDR1(i,u)>=0.6
            hop(u,1)=hop(u,1)+1;
        elseif NGDR1(i,u)>=0.9
            zoom(u,1)=zoom(u,1)+1;
        else
            disp('Could not calculate percentage due to NaN.')
        end
        end
        end
        
        nomov(:,1)=nomov(:,1)./woNAN*100;
        spin(:,1)=spin(:,1)./woNAN*100;
        loop(:,1)=loop(:,1)./woNAN*100;
        hop(:,1)=hop(:,1)./woNAN*100;
        zoom(:,1)=zoom(:,1)./woNAN*100;
                
        swimModes=[nomov spin loop hop zoom];
        swimModes=transpose(swimModes);
        movements={'no movement [%]'; 'spinning [%]'; 'looping [%]'; 'hop&sink [%]'; 'zooming [%]'};
        animals={'movement type' 'animal_1' 'animal_2' 'animal_3' 'animal_4' 'animal_5'};
        swimModes=[movements  num2cell(swimModes)];
        swimModes=[animals; swimModes];
        
        % calculate probability of heights
        %preparation animal1
        low1=0;
        medium1=0;
        high1=0;
        errcount1=0;
        
        %preparation animal2
        low2=0;
        medium2=0;
        high2=0;
        errcount2=0;
        
        %preparation animal3
        low3=0;
        medium3=0;
        high3=0;
        errcount3=0;
        
        %preparation animal4
        low4=0;
        medium4=0;
        high4=0;
        errcount4=0;
        
        %preparation animal5
        low5=0;
        medium5=0;
        high5=0;
        errcount5=0;
        
        for i=1:numel(CoordsTrack1(:,1))
            
            z1=-CoordsTrack1(i,3);
            z2=-CoordsTrack2(i,3);
            z3=-CoordsTrack3(i,3);
            z4=-CoordsTrack4(i,3);
            z5=-CoordsTrack5(i,3);
            
            if z1<33
                low1=low1+1;
            elseif z1>=33 && z1<66
                medium1=medium1+1;
            elseif z1>=66
                high1=high1+1;
            else
                errcount1=errcount1+1;
            end
            
            if z2<33
                low2=low2+1;
            elseif z2>=33 && z2<66
                medium2=medium2+1;
            elseif z2>=66
                high2=high2+1;
            else
                errcount2=errcount2+1;
            end
            
            
            if z3<33
                low3=low3+1;
            elseif z3>=33 && z3<66
                medium3=medium3+1;
            elseif z3>=66
                high3=high3+1;
            else
                errcount3=errcount3+1;
            end
            
            if z4<33
                low4=low4+1;
            elseif z4>=33 && z4<66
                medium4=medium4+1;
            elseif z4>=66
                high4=high4+1;
            else
                errcount4=errcount4+1;
            end
            
            if z5<33
                low5=low5+1;
            elseif z5>=33 && z5<66
                medium5=medium5+1;
            elseif z5>=66
                high5=high5+1;
            else
                errcount5=errcount5+1;
            end
            
        end
        
        probLow1=low1/(numel(CoordsTrack1(:,1)))*100;
        probMedium1=medium1/(numel(CoordsTrack1(:,1)))*100;
        probHigh1=high1/(numel(CoordsTrack1(:,1)))*100;
        prob1=[probLow1,probMedium1,probHigh1];
        
        probLow2=low2/(numel(CoordsTrack1(:,1)))*100;
        probMedium2=medium2/(numel(CoordsTrack1(:,1)))*100;
        probHigh2=high2/(numel(CoordsTrack1(:,1)))*100;
        prob2=[probLow2,probMedium2,probHigh2];
        
        
        probLow3=low3/(numel(CoordsTrack1(:,1)))*100;
        probMedium3=medium3/(numel(CoordsTrack1(:,1)))*100;
        probHigh3=high3/(numel(CoordsTrack1(:,1)))*100;
        prob3=[probLow3,probMedium3,probHigh3];
        
        
        probLow4=low4/(numel(CoordsTrack1(:,1)))*100;
        probMedium4=medium4/(numel(CoordsTrack1(:,1)))*100;
        probHigh4=high4/(numel(CoordsTrack1(:,1)))*100;
        prob4=[probLow4,probMedium4,probHigh4];
        
        
        probLow5=low5/(numel(CoordsTrack1(:,1)))*100;
        probMedium5=medium5/(numel(CoordsTrack1(:,1)))*100;
        probHigh5=high5/(numel(CoordsTrack1(:,1)))*100;
        prob5=[probLow5,probMedium5,probHigh5];
        
        probHeight=[prob1; prob2; prob3; prob4; prob5];
        probHeight=transpose(probHeight);
        height={'low [%]'; 'middle [%]'; 'high [%]'};
        animals2={'depth selection' 'animal_1' 'animal_2' 'animal_3' 'animal_4' 'animal_5'};
        probHeight=[height  num2cell(probHeight)];
        probHeight=[animals2; probHeight];
        
        
        %save results to figure
        setappdata(h.main, 'AND', AND);
        setappdata(h.main, 'NND', NND);
        setappdata(h.main, 'NGDR', NGDR);
        setappdata(h.main, 'NGDR_total', NGDR_total);
        %setappdata(h.main, 'distance_covered', distance_covered);
        setappdata(h.main, 'distance_covered_s_mm_s_3f', distance_covered_s_mm_s_3f);
        setappdata(h.main, 'distance_covered_s_mm_s_6f', distance_covered_s_mm_s_6f);
        setappdata(h.main, 'distance_covered_s_mm_s_2', distance_covered_s_mm_s_2);
        setappdata(h.main, 'distance_covered_s_mm_s', distance_covered_s_mm_s);
        setappdata(h.main, 'distance_covered_mm_s', distance_covered_mm_s);
        setappdata(h.main, 'error_quotient', error_quotient);
        setappdata(h.main, 'CoordsTrack1', CoordsTrack1);
        setappdata(h.main, 'CoordsTrack2', CoordsTrack2);
        setappdata(h.main, 'CoordsTrack3', CoordsTrack3);
        setappdata(h.main, 'CoordsTrack4', CoordsTrack4);
        setappdata(h.main, 'CoordsTrack5', CoordsTrack5);
        setappdata(h.main, 'ParamsTrack1', ParamsTrack1);
        setappdata(h.main, 'ParamsTrack2', ParamsTrack2);
        setappdata(h.main, 'ParamsTrack3', ParamsTrack3);
        setappdata(h.main, 'ParamsTrack4', ParamsTrack4);
        setappdata(h.main, 'ParamsTrack5', ParamsTrack5);
        setappdata(h.main, 'actPos_Cam1', actPos_Cam1);
        setappdata(h.main, 'actPos_Cam2', actPos_Cam2);
        setappdata(h.main, 'probHeight', probHeight);
        setappdata(h.main, 'swimModes', swimModes);
        setappdata(h.main, 'NGDR1', NGDR1);
        
        cd 'S:\Admin\Tracking\raw data-input\6_calculation'
        progress='CA';
        filename3=sprintf('%s_%s_%s.fig', timecode2, freeText, progress);
        setappdata(h.main, 'filename3', filename3)
        curFol=pwd;
        set(h.cur_Fol, 'String', curFol)
        set(h.CALC, 'BackgroundColor', [0 0.9 0])
        
        savefig(filename3);
        disp('3D calculation successful!')
    end

    function D_Plot(~,~)
        set(h.PLOT, 'BackgroundColor', [0.9 0.2 0])
        %load necessary variables
        CoordsTrack1=getappdata(h.main, 'CoordsTrack1');
        CoordsTrack2=getappdata(h.main, 'CoordsTrack2');
        CoordsTrack3=getappdata(h.main, 'CoordsTrack3');
        CoordsTrack4=getappdata(h.main, 'CoordsTrack4');
        CoordsTrack5=getappdata(h.main, 'CoordsTrack5');
        dg=[0,0.6,0.2];
        %plot the single tracks
        answer=inputdlg('Which tracks do you want to plot? (1)-(5): single tracks, (6): all tracks or (7): developing tracks', ...
            '3D plot',1, {'6'});
        
        if answer{1}=='1'
            % Plot Track 1 (red)
            figure;
            scatter3(CoordsTrack1(:,1),CoordsTrack1(:,2),-CoordsTrack1(:,3),10,'r', 'filled');
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            axis equal
            xlim([-180 0]);
            ylim([0 180]);
            zlim([0 150]);
            set(gca,'YDir','Reverse')
            
        elseif answer{1}=='2'
            % Plot Track 2 (yellow)
            figure;
            scatter3(CoordsTrack2(:,1),CoordsTrack2(:,2),-CoordsTrack2(:,3),10,'y', 'filled');
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            axis equal
            xlim([-180 0]);
            ylim([0 180]);
            zlim([0 150]);
            set(gca,'YDir','Reverse')
            
        elseif answer{1}=='3'
            % Plot Track 3 (cyan)
            figure;
            scatter3(CoordsTrack3(:,1),CoordsTrack3(:,2),-CoordsTrack3(:,3),10,'c', 'filled');
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            axis equal
            xlim([-180 0]);
            ylim([0 180]);
            zlim([0 150]);
            set(gca,'YDir','Reverse')
            
        elseif answer{1}=='4'
            % Plot Track 4 (magenta)
            figure;
            scatter3(CoordsTrack4(:,1),CoordsTrack4(:,2),-CoordsTrack4(:,3),10,'m', 'filled');
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            axis equal
            xlim([-180 0]);
            ylim([0 180]);
            zlim([0 150]);
            set(gca,'YDir','Reverse')
            
        elseif answer{1}=='5'
            % Plot Track 5 (green)
            figure;
            scatter3(CoordsTrack5(:,1),CoordsTrack5(:,2),-CoordsTrack5(:,3),10, dg, 'filled');
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            axis equal
            xlim([-180 0]);
            ylim([0 180]);
            zlim([0 150]);
            set(gca,'YDir','Reverse')
            
        elseif answer{1}=='6'
            % Plot cumulative
            figure;
            hold on
            scatter3(CoordsTrack1(1,1),CoordsTrack1(1,2),-CoordsTrack1(1,3),100,'r', 'filled', '^');      %plot the start points as large triangles
            scatter3(CoordsTrack2(1,1),CoordsTrack2(1,2),-CoordsTrack2(1,3),100,'y', 'filled', '^');
            scatter3(CoordsTrack3(1,1),CoordsTrack3(1,2),-CoordsTrack3(1,3),100,'c', 'filled', '^');
            scatter3(CoordsTrack4(1,1),CoordsTrack4(1,2),-CoordsTrack4(1,3),100,'m', 'filled', '^');
            scatter3(CoordsTrack5(1,1),CoordsTrack5(1,2),-CoordsTrack5(1,3),100, dg, 'filled', '^');
            
            text(CoordsTrack1(1,1),CoordsTrack1(1,2),-CoordsTrack1(1,3), '\leftarrow animal 1')
            text(CoordsTrack2(1,1),CoordsTrack2(1,2),-CoordsTrack2(1,3), '\leftarrow animal 2')
            text(CoordsTrack3(1,1),CoordsTrack3(1,2),-CoordsTrack3(1,3), '\leftarrow animal 3')
            text(CoordsTrack4(1,1),CoordsTrack4(1,2),-CoordsTrack4(1,3), '\leftarrow animal 4')
            text(CoordsTrack5(1,1),CoordsTrack5(1,2),-CoordsTrack5(1,3), '\leftarrow animal 5')
            
            scatter3(CoordsTrack1(:,1),CoordsTrack1(:,2),-CoordsTrack1(:,3),10,'r', 'filled');
            scatter3(CoordsTrack2(:,1),CoordsTrack2(:,2),-CoordsTrack2(:,3),10,'y', 'filled');
            scatter3(CoordsTrack3(:,1),CoordsTrack3(:,2),-CoordsTrack3(:,3),10,'c', 'filled');
            scatter3(CoordsTrack4(:,1),CoordsTrack4(:,2),-CoordsTrack4(:,3),10,'m', 'filled');
            scatter3(CoordsTrack5(:,1),CoordsTrack5(:,2),-CoordsTrack5(:,3),10, dg, 'filled');
            hold off
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            axis equal
            xlim([-180 20]);
            ylim([0 180]);
            zlim([0 150]);
            
        elseif answer{1}=='7'
            % Plot developing
            figure;
            set(gcf,'KeyPressFcn', @key_pressed)
            hold on
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            axis equal
            xlim([-180 0]);
            ylim([0 180]);
            zlim([0 150]);
            %pause('on')
            for i=1:(size(CoordsTrack1,1))
                scatter3(CoordsTrack1(i,1),CoordsTrack1(i,2),-CoordsTrack1(i,3),10,'r', 'filled');
                scatter3(CoordsTrack2(i,1),CoordsTrack2(i,2),-CoordsTrack2(i,3),10,'y', 'filled');
                scatter3(CoordsTrack3(i,1),CoordsTrack3(i,2),-CoordsTrack3(i,3),10,'c', 'filled');
                scatter3(CoordsTrack4(i,1),CoordsTrack4(i,2),-CoordsTrack4(i,3),10,'m', 'filled');
                scatter3(CoordsTrack5(i,1),CoordsTrack5(i,2),-CoordsTrack5(i,3),10, dg, 'filled');
                pause(0.5)
                disp(i)
            end
            hold off
            axis equal
        else
            disp('Enter "1"-"7", "1"-"5" for single tracks, "6" for all tracks and "7" for a developing plot');
        end
        set(h.PLOT, 'BackgroundColor', [0 0.9 0])
    end

    function ViewResults(~,~)
        set(h.VRES, 'BackgroundColor', [0.9 0.2 0])
        
        %get variables back from figure
        captureDuration=getappdata(h.main, 'captureDuration');
        NND=getappdata(h.main, 'NND');
        AND=getappdata(h.main, 'AND');
        NGDR=getappdata(h.main, 'NGDR');
        NGDR_total=getappdata(h.main, 'NGDR_total');
        %distance_covered=getappdata(h.main, 'distance_covered');
        distance_covered_mm_s=getappdata(h.main, 'distance_covered_mm_s');
        distance_covered_s_mm_s_2=getappdata(h.main, 'distance_covered_s_mm_s_2');
        distance_covered_s_mm_s=getappdata(h.main, 'distance_covered_s_mm_s');
        error_quotient=getappdata(h.main, 'error_quotient');
        ParamsTrack1=getappdata(h.main, 'ParamsTrack1');
        ParamsTrack2=getappdata(h.main, 'ParamsTrack2');
        ParamsTrack3=getappdata(h.main, 'ParamsTrack3');
        ParamsTrack4=getappdata(h.main, 'ParamsTrack4');
        ParamsTrack5=getappdata(h.main, 'ParamsTrack5');
        timecode2=getappdata(h.main, 'timecode2');
        CoordsTrack1=getappdata(h.main, 'CoordsTrack1');
        CoordsTrack2=getappdata(h.main, 'CoordsTrack2');
        CoordsTrack3=getappdata(h.main, 'CoordsTrack3');
        CoordsTrack4=getappdata(h.main, 'CoordsTrack4');
        CoordsTrack5=getappdata(h.main, 'CoordsTrack5');
        thresh=getappdata(h.main, 'thresh');
        upperB=getappdata(h.main, 'upperB');
        lowerB=getappdata(h.main, 'lowerB');
        startGreen=getappdata(h.main, 'startGreen');
        startRed=getappdata(h.main, 'startRed');
        probHeight=getappdata(h.main, 'probHeight');        
        swimModes=getappdata(h.main, 'swimModes');
        NGDR1=getappdata(h.main, 'NGDR1');

        
        
        %write variables to the base workspace, view them from there
        assignin('base', 'captureDuration', captureDuration);
        assignin('base', 'NGDR', NGDR);
        assignin('base', 'NND', NND);
        assignin('base', 'AND', AND);
        assignin('base', 'NGDR_total', NGDR_total);
        %assignin('base', 'distance_covered', distance_covered);
        assignin('base', 'distance_covered_mm_s', distance_covered_mm_s);
        assignin('base', 'distance_covered_s_mm_s_2', distance_covered_s_mm_s_2);
        assignin('base', 'distance_covered_s_mm_s', distance_covered_s_mm_s);
        assignin('base', 'error_quotient', error_quotient);
        assignin('base', 'ParamsTrack1', ParamsTrack1);
        assignin('base', 'ParamsTrack2', ParamsTrack2);
        assignin('base', 'ParamsTrack3', ParamsTrack3);
        assignin('base', 'ParamsTrack4', ParamsTrack4);
        assignin('base', 'ParamsTrack5', ParamsTrack5);
        assignin('base', 'timecode2', timecode2);
        assignin('base', 'CoordsTrack1', CoordsTrack1);
        assignin('base', 'CoordsTrack2', CoordsTrack2);
        assignin('base', 'CoordsTrack3', CoordsTrack3);
        assignin('base', 'CoordsTrack4', CoordsTrack4);
        assignin('base', 'CoordsTrack5', CoordsTrack5);
        assignin('base', 'thresh', thresh);
        assignin('base', 'upperB', upperB);
        assignin('base', 'lowerB', lowerB);
        assignin('base', 'startRed', startRed);
        assignin('base', 'startGreen', startGreen);
        assignin('base', 'probHeight', probHeight);        
        assignin('base', 'NGDR1', NGDR1);
        assignin('base', 'swimModes', swimModes);
        
        workspace
        set(h.VRES, 'BackgroundColor', [0 0.9 0])
        disp('Transferring of results to workspace successful!')
    end

    function SaveResults(~,~)
        set(h.SRES, 'BackgroundColor', [0.9 0.2 0])
        pause(0.5)
        disp('Initializing writing of data...please be patient...');
        %get variables back from figure
        captureDuration=getappdata(h.main, 'captureDuration');
        NND=getappdata(h.main, 'NND');
        AND=getappdata(h.main, 'AND');
        NGDR=getappdata(h.main, 'NGDR');
        NGDR_total=getappdata(h.main, 'NGDR_total');
        %distance_covered=getappdata(h.main, 'distance_covered');
        distance_covered_mm_s=getappdata(h.main, 'distance_covered_mm_s');
        distance_covered_s_mm_s_2=getappdata(h.main, 'distance_covered_s_mm_s_2');
        distance_covered_s_mm_s=getappdata(h.main, 'distance_covered_s_mm_s');
        distance_covered_s_mm_s_6f=getappdata(h.main, 'distance_covered_s_mm_s_6f');
        distance_covered_s_mm_s_3f=getappdata(h.main, 'distance_covered_s_mm_s_3f');
        error_quotient=getappdata(h.main, 'error_quotient');
        ParamsTrack1=getappdata(h.main, 'ParamsTrack1');
        ParamsTrack2=getappdata(h.main, 'ParamsTrack2');
        ParamsTrack3=getappdata(h.main, 'ParamsTrack3');
        ParamsTrack4=getappdata(h.main, 'ParamsTrack4');
        ParamsTrack5=getappdata(h.main, 'ParamsTrack5');
        CoordsTrack1=getappdata(h.main, 'CoordsTrack1');
        CoordsTrack2=getappdata(h.main, 'CoordsTrack2');
        CoordsTrack3=getappdata(h.main, 'CoordsTrack3');
        CoordsTrack4=getappdata(h.main, 'CoordsTrack4');
        CoordsTrack5=getappdata(h.main, 'CoordsTrack5');
        timecode2=getappdata(h.main, 'timecode2');
        thresh=getappdata(h.main, 'thresh');
        freeText=getappdata(h.main, 'freeText');
        upperB=getappdata(h.main, 'upperB');
        lowerB=getappdata(h.main, 'lowerB');
        circSize=getappdata(h.main, 'circSize');
        startGreen=getappdata(h.main, 'startGreen');
        startRed=getappdata(h.main, 'startRed');
        probHeight=getappdata(h.main, 'probHeight');        
        errFrames=getappdata(h.main, 'errFrames');
        errFrames_2=getappdata(h.main, 'errFrames_2');
        swimModes=getappdata(h.main, 'swimModes');
        NGDR1=getappdata(h.main, 'NGDR1');

        
        %Can be deleted once all data are collected and tracked with the new version of the tracking
        if isempty(errFrames)
            errFrames=0;
        else
        end        
        if isempty(errFrames_2)
            errFrames_2=0;
        else
        end
        %end of deleteable part 
            
        %write variables to excelfile with specified name
        cd 'S:\Admin\Tracking\raw data-input\7_excelData'
        
        progress='SV';
        filename4=sprintf('%s_%s_%s.xlsx', timecode2, freeText, progress);
        xlswrite(filename4, captureDuration, 'captureDuration');
        header={'X [mm]','Y [mm]','Z [mm]'};
        CoordsTrack1=[header; num2cell(CoordsTrack1)];
        xlswrite(filename4, CoordsTrack1, 'CoordsTrack1');
        CoordsTrack2=[header; num2cell(CoordsTrack2)];
        xlswrite(filename4, CoordsTrack2, 'CoordsTrack2');
        CoordsTrack3=[header; num2cell(CoordsTrack3)];
        xlswrite(filename4, CoordsTrack3, 'CoordsTrack3');
        CoordsTrack4=[header; num2cell(CoordsTrack4)];
        xlswrite(filename4, CoordsTrack4, 'CoordsTrack4');
        CoordsTrack5=[header; num2cell(CoordsTrack5)];
        xlswrite(filename4, CoordsTrack5, 'CoordsTrack5');
        header={'X_Line1 [mm]','Y_Line1 [mm]','Z_Line1 [mm]','X_Line2 [mm]','Y_Line2 [mm]','Z_Line [mm]','X_Calc [mm]','Y_Calc [mm]','Z_Calc [mm]','accuracy [mm]'};
        ParamsTrack1=[header; num2cell(ParamsTrack1)];
        xlswrite(filename4, ParamsTrack1, 'ParamsTrack1');
        ParamsTrack2=[header; num2cell(ParamsTrack2)];
        xlswrite(filename4, ParamsTrack2, 'ParamsTrack2');
        ParamsTrack3=[header; num2cell(ParamsTrack3)];
        xlswrite(filename4, ParamsTrack3, 'ParamsTrack3');
        ParamsTrack4=[header; num2cell(ParamsTrack4)];
        xlswrite(filename4, ParamsTrack4, 'ParamsTrack4');
        ParamsTrack5=[header; num2cell(ParamsTrack5)];
        xlswrite(filename4, ParamsTrack5, 'ParamsTrack5');
        header={'animal_1 [mm]','animal_2 [mm]','animal_3 [mm]','animal_4 [mm]','animal_5 [mm]'};
        error_quotient=[header; num2cell(error_quotient)];
        xlswrite(filename4, error_quotient, 'error_quotient');
        header={'animal_1 [mm/s]','animal_2 [mm/s]','animal_3 [mm/s]','animal_4 [mm/s]','animal_5 [mm/s]'};
        distance_covered_s_mm_s_3f=[header; num2cell(distance_covered_s_mm_s_3f)];
        xlswrite(filename4, distance_covered_s_mm_s_3f, 'velocityPer3Frames');
        distance_covered_s_mm_s_6f=[header; num2cell(distance_covered_s_mm_s_6f)];
        xlswrite(filename4, distance_covered_s_mm_s_6f, 'velocityPer6Frames');
        distance_covered_mm_s=[header; num2cell(distance_covered_mm_s)];
        xlswrite(filename4, distance_covered_mm_s, 'velocityPerFrame');
        distance_covered_s_mm_s=[header; num2cell(distance_covered_s_mm_s)];
        xlswrite(filename4, distance_covered_s_mm_s, 'velocityPerSec');
        distance_covered_s_mm_s_2=[header; num2cell(distance_covered_s_mm_s_2)];
        xlswrite(filename4, distance_covered_s_mm_s_2, 'velocityPer0.5Sec');
        header={'animal_1','animal_2','animal_3','animal_4','animal_5'};
        NGDR1=[header; num2cell(NGDR1)];
        xlswrite(filename4, NGDR1, 'NGDRevery1Sec');
        NGDR=[header; num2cell(NGDR)];
        xlswrite(filename4, NGDR, 'NGDRevery2.5Sec');
        NGDR_total=[header; num2cell(NGDR_total)];
        xlswrite(filename4, NGDR_total, 'NGDRwholeVideo');
        xlswrite(filename4, swimModes, 'probability swim modes');
        header={'NND [mm]'};
        NND=[header; num2cell(NND)];
        xlswrite(filename4, NND, 'NNDPerSec');
        header={'AND [mm]'};
        AND=[header; num2cell(AND)];
        xlswrite(filename4, AND, 'ANDPerSec');        
        xlswrite(filename4, probHeight, 'probabilities height');        
        xlswrite(filename4, captureDuration, 'captureDuration');
        xlswrite(filename4, thresh, 'thresh');
        xlswrite(filename4, upperB, 'upperB');
        xlswrite(filename4, lowerB, 'lowerB');
        xlswrite(filename4, circSize, 'circSize');
        xlswrite(filename4, captureDuration, 'captureDuration');
        xlswrite(filename4, startRed, 'startRed');
        xlswrite(filename4, startGreen, 'startGreen');
        xlswrite(filename4, errFrames, 'errFrames');
        xlswrite(filename4, errFrames_2, 'errFrames_2');
        
        %delete the unused sheets in the excelfile
        sheetname='Tabelle';    %specify how unused sheets are called in your Excel version
        objExcel=actxserver('Excel.Application');       %open Excel in ActiveX-Server
        ewb=objExcel.Workbooks.Open(fullfile(pwd, filename4));
        
        try
            objExcel.ActiveWorkbook.Worksheets.Item([sheetname '1']).Delete;        %delete the unused sheets
            objExcel.ActiveWorkbook.Worksheets.Item([sheetname '2']).Delete;
            objExcel.ActiveWorkbook.Worksheets.Item([sheetname '3']).Delete;
        catch
        end
        
        ewb.Save;       %save and close the spreadsheets and the ActiveX-Server
        ewb.Close;
        objExcel.Quit;
        objExcel.delete;
        
        %save the really necessary data as Matlab workspace
        cd 'S:\Admin\Tracking\raw data-input\8_matlabSave'
        progress='MS';
        filename3=sprintf('%s_%s_%s.mat', timecode2, freeText, progress);
        setappdata(h.main, 'filename3', filename3)
        save(filename3);
        
        curFol=pwd;
        set(h.cur_Fol, 'String', curFol)
        set(h.SRES, 'BackgroundColor', [0 0.9 0])
        
        disp('Saving of results successful!')
    end
end
%--------------------------------------------------------------------------

%Addtional functions necessary in the above script
%--------------------------------------------------------------------------

%GinputW for White Crosshairs
function [out1,out2,out3] = ginputW(arg1)
%GINPUT Graphical input from mouse.
%   [X,Y] = GINPUT(N) gets N points from the current axes and returns
%   the X- and Y-coordinates in length N vectors X and Y.  The cursor
%   can be positioned using a mouse.  Data points are entered by pressing
%   a mouse button or any key on the keyboard except carriage return,
%   which terminates the input before N points are entered.
%
%   [X,Y] = GINPUT gathers an unlimited number of points until the
%   return key is pressed.
%
%   [X,Y,BUTTON] = GINPUT(N) returns a third result, BUTTON, that
%   contains a vector of integers specifying which mouse button was
%   used (1,2,3 from left) or ASCII numbers if a key on the keyboard
%   was used.
%
%   Examples:
%       [x,y] = ginput;
%
%       [x,y] = ginput(5);
%
%       [x, y, button] = ginput(1);
%
%   See also GTEXT, WAITFORBUTTONPRESS.

%   Copyright 1984-2015 The MathWorks, Inc.

out1 = []; out2 = []; out3 = []; y = [];

if ~matlab.ui.internal.isFigureShowEnabled
    error(message('MATLAB:hg:NoDisplayNoFigureSupport', 'ginput'))
end

% Check Inputs
if nargin == 0
    how_many = -1;
    b = [];
else
    how_many = arg1;
    b = [];
    if  ~isPositiveScalarIntegerNumber(how_many)
        error(message('MATLAB:ginput:NeedPositiveInt'))
    end
    if how_many == 0
        % If input argument is equal to zero points,
        % give a warning and return empty for the outputs.
        warning (message('MATLAB:ginput:InputArgumentZero'));
    end
end

% Get figure
fig = gcf;
figure(gcf);

% Make sure the figure has an axes
gca(fig);

% Setup the figure to disable interactive modes and activate pointers.
initialState = setupFcn(fig);

% onCleanup object to restore everything to original state in event of
% completion, closing of figure errors or ctrl+c.
c = onCleanup(@() restoreFcn(initialState));

drawnow
char = 0;

while how_many ~= 0
    waserr = 0;
    try
        keydown = wfbp;
    catch %#ok<CTCH>
        waserr = 1;
    end
    if(waserr == 1)
        if(ishghandle(fig))
            cleanup(c);
            error(message('MATLAB:ginput:Interrupted'));
        else
            cleanup(c);
            error(message('MATLAB:ginput:FigureDeletionPause'));
        end
    end
    % g467403 - ginput failed to discern clicks/keypresses on the figure it was
    % registered to operate on and any other open figures whose handle
    % visibility were set to off
    figchildren = allchild(0);
    if ~isempty(figchildren)
        ptr_fig = figchildren(1);
    else
        error(message('MATLAB:ginput:FigureUnavailable'));
    end
    %         old code -> ptr_fig = get(0,'CurrentFigure'); Fails when the
    %         clicked figure has handlevisibility set to callback
    if(ptr_fig == fig)
        if keydown
            char = get(fig, 'CurrentCharacter');
            button = abs(get(fig, 'CurrentCharacter'));
        else
            button = get(fig, 'SelectionType');
            if strcmp(button,'open')
                button = 1;
            elseif strcmp(button,'normal')
                button = 1;
            elseif strcmp(button,'extend')
                button = 2;
            elseif strcmp(button,'alt')
                button = 3;
            else
                error(message('MATLAB:ginput:InvalidSelection'))
            end
        end
        axes_handle = gca;
        drawnow;
        pt = get(axes_handle, 'CurrentPoint');
        
        how_many = how_many - 1;
        
        if(char == 13) % & how_many ~= 0)
            % if the return key was pressed, char will == 13,
            % and that's our signal to break out of here whether
            % or not we have collected all the requested data
            % points.
            % If this was an early breakout, don't include
            % the <Return> key info in the return arrays.
            % We will no longer count it if it's the last input.
            break;
        end
        
        out1 = [out1;pt(1,1)]; %#ok<AGROW>
        y = [y;pt(1,2)]; %#ok<AGROW>
        b = [b;button]; %#ok<AGROW>
    end
end

% Cleanup and Restore
cleanup(c);

if nargout > 1
    out2 = y;
    if nargout > 2
        out3 = b;
    end
else
    out1 = [out1 y];
end

end

function valid = isPositiveScalarIntegerNumber(how_many)
valid = ~ischar(how_many) && ...            % is numeric
    isscalar(how_many) && ...           % is scalar
    (fix(how_many) == how_many) && ...  % is integer in value
    how_many >= 0;                      % is positive
end

function key = wfbp
%WFBP   Replacement for WAITFORBUTTONPRESS that has no side effects.

fig = gcf;
current_char = []; %#ok<NASGU>

% Now wait for that buttonpress, and check for error conditions
waserr = 0;
try
    h=findall(fig,'Type','uimenu','Accelerator','C');   % Disabling ^C for edit menu so the only ^C is for
    set(h,'Accelerator','');                            % interrupting the function.
    keydown = waitforbuttonpress;
    current_char = double(get(fig,'CurrentCharacter')); % Capturing the character.
    if~isempty(current_char) && (keydown == 1)          % If the character was generated by the
        if(current_char == 3)                           % current keypress AND is ^C, set 'waserr'to 1
            waserr = 1;                                 % so that it errors out.
        end
    end
    
    set(h,'Accelerator','C');                           % Set back the accelerator for edit menu.
catch %#ok<CTCH>
    waserr = 1;
end
drawnow;
if(waserr == 1)
    set(h,'Accelerator','C');                          % Set back the accelerator if it errored out.
    error(message('MATLAB:ginput:Interrupted'));
end

if nargout>0, key = keydown; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

function initialState = setupFcn(fig)

% Store Figure Handle.
initialState.figureHandle = fig;

% Suspend figure functions
initialState.uisuspendState = uisuspend(fig);

% Disable Plottools Buttons
initialState.toolbar = findobj(allchild(fig),'flat','Type','uitoolbar');
if ~isempty(initialState.toolbar)
    initialState.ptButtons = [uigettool(initialState.toolbar,'Plottools.PlottoolsOff'), ...
        uigettool(initialState.toolbar,'Plottools.PlottoolsOn')];
    initialState.ptState = get (initialState.ptButtons,'Enable');
    set (initialState.ptButtons,'Enable','off');
end

%Setup empty pointer
cdata = NaN(16,16);
hotspot = [8,8];
set(gcf,'Pointer','custom','PointerShapeCData',cdata,'PointerShapeHotSpot',hotspot)

% Create uicontrols to simulate fullcrosshair pointer.
initialState.CrossHair = createCrossHair(fig);

% Adding this to enable automatic updating of currentpoint on the figure
% This function is also used to update the display of the fullcrosshair
% pointer and make them track the currentpoint.
set(fig,'WindowButtonMotionFcn',@(o,e) dummy()); % Add dummy so that the CurrentPoint is constantly updated
initialState.MouseListener = addlistener(fig,'WindowMouseMotion', @(o,e) updateCrossHair(o,initialState.CrossHair));

% Get the initial Figure Units
initialState.fig_units = get(fig,'Units');
end

function restoreFcn(initialState)
if ishghandle(initialState.figureHandle)
    delete(initialState.CrossHair);
    
    % Figure Units
    set(initialState.figureHandle,'Units',initialState.fig_units);
    
    set(initialState.figureHandle,'WindowButtonMotionFcn','');
    delete(initialState.MouseListener);
    
    % Plottools Icons
    if ~isempty(initialState.toolbar) && ~isempty(initialState.ptButtons)
        set (initialState.ptButtons(1),'Enable',initialState.ptState{1});
        set (initialState.ptButtons(2),'Enable',initialState.ptState{2});
    end
    
    % UISUSPEND
    uirestore(initialState.uisuspendState);
end
end

function updateCrossHair(fig, crossHair)
% update cross hair for figure.
gap = 3; % 3 pixel view port between the crosshairs
cp = hgconvertunits(fig, [fig.CurrentPoint 0 0], fig.Units, 'pixels', fig);
cp = cp(1:2);
figPos = hgconvertunits(fig, fig.Position, fig.Units, 'pixels', fig.Parent);
figWidth = figPos(3);
figHeight = figPos(4);

% Early return if point is outside the figure
if cp(1) < gap || cp(2) < gap || cp(1)>figWidth-gap || cp(2)>figHeight-gap
    return
end

set(crossHair, 'Visible', 'on');
thickness = 1; % 1 Pixel thin lines.
set(crossHair(1), 'Position', [0 cp(2) cp(1)-gap thickness]);
set(crossHair(2), 'Position', [cp(1)+gap cp(2) figWidth-cp(1)-gap thickness]);
set(crossHair(3), 'Position', [cp(1) 0 thickness cp(2)-gap]);
set(crossHair(4), 'Position', [cp(1) cp(2)+gap thickness figHeight-cp(2)-gap]);
end

function crossHair = createCrossHair(fig)
% Create thin uicontrols with black backgrounds to simulate fullcrosshair pointer.
% 1: horizontal left, 2: horizontal right, 3: vertical bottom, 4: vertical top
for k = 1:4
    crossHair(k) = uicontrol(fig, 'Style', 'text', 'Visible', 'off', 'Units', 'pixels', 'BackgroundColor', [0.5 0.5 0.5], 'HandleVisibility', 'off', 'HitTest', 'off'); %#ok<AGROW>
end
end

function cleanup(c)
if isvalid(c)
    delete(c);
end
end

function dummy(~,~)
end

%Key Press Function for interruption/abortion
function key_pressed (~,evnt)
if strcmp(evnt.Key, 'escape')==1
    terminateExecution;
    
elseif strcmp(evnt.Key, 'space')==1
    global interruption
    interruption=1;
else
    disp('Press Esc to stop execution, press space within the tracking function to hold execution.')
end


end

function terminateExecution
%terminateExecution  Emulates CTRL-C
%    terminateExecution   Stops operation of a program by emulating a
%    CTRL-C press by the user.

%1) request focus be transferred to the command window
%   (H/T http://undocumentedmatlab.com/blog/changing-matlab-command-window-colors/)
cmdWindow = com.mathworks.mde.cmdwin.CmdWin.getInstance();
cmdWindow.grabFocus();

%2) Wait for focus transfer to complete (up to 2 seconds)
focustransferTimer = tic;
while ~cmdWindow.isFocusOwner
    pause(0.1);  %Pause some small interval
    if (toc(focustransferTimer) > 2)
        error('Error transferring focus for CTRL+C press.')
    end
end

%3) Use Java robot to execute a CTRL+C in the (now focused) command window.

%3.1)  Setup a timer to relase CTRL + C in 1 second
%  Try to reuse an existing timer if possible (this would be a holdover
%  from a previous execution)
t_all = timerfindall;
releaseTimer = [];
ix_timer = 1;
while isempty(releaseTimer) && (ix_timer<= length(t_all))
    if isequal(t_all(ix_timer).TimerFcn, @releaseCtrl_C)
        releaseTimer = t_all(ix_timer);
    end
    ix_timer = ix_timer+1;
end
if isempty(releaseTimer)
    releaseTimer = timer;
    releaseTimer.TimerFcn = @releaseCtrl_C;
end
releaseTimer.StartDelay = 1;
start(releaseTimer);

%3.2)  Press press CTRL+C
pressCtrl_C

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function pressCtrl_C
        import java.awt.Robot;
        import java.awt.event.*;
        SimKey=Robot;
        SimKey.keyPress(KeyEvent.VK_CONTROL);
        SimKey.keyPress(KeyEvent.VK_C);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function releaseCtrl_C(~, ~)
        import java.awt.Robot;
        import java.awt.event.*;
        SimKey=Robot;
        SimKey.keyRelease(KeyEvent.VK_CONTROL);
        SimKey.keyRelease(KeyEvent.VK_C);
    end
disp('Execution of current function stopped by user.')
end

function ButtonName=MFquestdlg(Pos,Question,Title,Btn1,Btn2,Btn3,Default)
% MFQUESTDLG Question dialog box.
% -----------------------------------------------------------------------
%  --------------------- Modified Function Help ----------------------
%  ‘MFquestdlg’ is a simple modification of ‘questdlg’ which enables user
%  to specify the position of 'questdlg' question dialog box on the screen.
%  Everything is like the original ‘questdlg’, except that you need to determine
%  your desirable position with a two-element vector of the form:
%  [left, bottom]
%  where ‘left’ and ‘bottom’ define the distance from the lower-left corner
%  of the screen to the lower-left corner of the question dialog box.
%  ‘left’ and ‘bottom’ are NORMALIZED units, obviously between 0 and 1.
%  The position vector must be added as the first element of ‘MFquestdlg’.
%  Example:
%  button = MFquestdlg ( [ 0.6 , 0.1 ] , 'Is the position proper?' , 'Is it OK?' );
% -------------------------------------------------------------------------
%  ------------------------ Original Function Help ---------------------------
%  ButtonName = QUESTDLG(Question) creates a modal dialog box that
%  automatically wraps the cell array or string (vector or matrix)
%  Question to fit an appropriately sized window.  The name of the
%  button that is pressed is returned in ButtonName.  The Title of
%  the figure may be specified by adding a second string argument:
%
%    ButtonName = questdlg(Question, Title)
%
%  Question will be interpreted as a normal string.
%
%  QUESTDLG uses UIWAIT to suspend execution until the user responds.
%
%  The default set of buttons names for QUESTDLG are 'Yes','No' and
%  'Cancel'.  The default answer for the above calling syntax is 'Yes'.
%  This can be changed by adding a third argument which specifies the
%  default Button:
%
%    ButtonName = questdlg(Question, Title, 'No')
%
%  Up to 3 custom button names may be specified by entering
%  the button string name(s) as additional arguments to the function
%  call.  If custom button names are entered, the default button
%  must be specified by adding an extra argument, DEFAULT, and
%  setting DEFAULT to the same string name as the button you want
%  to use as the default button:
%
%    ButtonName = questdlg(Question, Title, Btn1, Btn2, DEFAULT);
%
%  where DEFAULT is set to Btn1.  This makes Btn1 the default answer.
%  If the DEFAULT string does not match any of the button string names,
%  a warning message is displayed.
%
%  To use TeX interpretation for the Question string, a data
%  structure must be used for the last argument, i.e.
%
%    ButtonName = questdlg(Question, Title, Btn1, Btn2, OPTIONS);
%
%  The OPTIONS structure must include the fields Default and Interpreter.
%  Interpreter may be 'none' or 'tex' and Default is the default button
%  name to be used.
%
%  If the dialog is closed without a valid selection, the return value
%  is empty.
%
%  Example:
%
%  ButtonName = questdlg('What is your favorite color?', ...
%                        'Color Question', ...
%                        'Red', 'Green', 'Blue', 'Green');
%  switch ButtonName,
%    case 'Red',
%     disp('Your favorite color is Red');
%    case 'Blue',
%     disp('Your favorite color is Blue.')
%     case 'Green',
%      disp('Your favorite color is Green.');
%  end % switch
%
%  See also DIALOG, ERRORDLG, HELPDLG, INPUTDLG, LISTDLG,
%    MSGBOX, WARNDLG, FIGURE, TEXTWRAP, UIWAIT, UIRESUME.


%  Copyright 1984-2009 The MathWorks, Inc.
%  $Revision: 5.55.4.15 $



if nargin<1
    error('MATLAB:questdlg:TooFewArguments', 'Too few arguments for QUESTDLG');
end

Interpreter='none';
if ~iscell(Question),Question=cellstr(Question);end

%%%%%%%%%%%%%%%%%%%%%
%%% General Info. %%%
%%%%%%%%%%%%%%%%%%%%%
Black      =[0       0        0      ]/255;
% LightGray  =[192     192      192    ]/255;
% LightGray2 =[160     160      164    ]/255;
% MediumGray =[128     128      128    ]/255;
% White      =[255     255      255    ]/255;

%%%%%%%%%%%%%%%%%%%%
%%% Nargin Check %%%
%%%%%%%%%%%%%%%%%%%%
if nargout>1
    error('MATLAB:questdlg:WrongNumberOutputs', 'Wrong number of output arguments for QUESTDLG');
end
if nargin==2,Title=' ';end
if nargin<=3, Default='Yes';end
if nargin==4, Default=Btn1 ;end
if nargin<=4, Btn1='Yes'; Btn2='No'; Btn3='Cancel';NumButtons=3;end
if nargin==5, Default=Btn2;Btn2=[];Btn3=[];NumButtons=1;end
if nargin==6, Default=Btn3;Btn3=[];NumButtons=2;end
if nargin==7, NumButtons=3;end
if nargin>7
    error('MATLAB:questdlg:TooManyInputs', 'Too many input arguments');NumButtons=3; %#ok
end

if isstruct(Default),
    Interpreter=Default.Interpreter;
    Default=Default.Default;
end

set(0,'Units','pixels');  % <<<<<<<<<<----------MODIFIED
scnsize=get(0,'ScreenSize');  % <<<<<<<<<<----------MODIFIED
% FigPos    = get(0,'DefaultFigurePosition'); % <<<<<<<<<<----------MODIFIED
FigPos(1)=Pos(1)*scnsize(3);  % <<<<<<<<<<----------MODIFIED
FigPos(2)=Pos(2)*scnsize(4);  % <<<<<<<<<<----------MODIFIED
FigPos(3) = 267;
FigPos(4) =  70;
% FigPos    = getnicedialoglocation(FigPos, get(0,'DefaultFigureUnits')); % <<<<<<<<<<----------MODIFIED


QuestFig=dialog(                                    ...
    'Visible'         ,'off'                      , ...
    'Name'            ,Title                      , ...
    'Pointer'         ,'arrow'                    , ...
    'Position'        ,FigPos                     , ...
    'KeyPressFcn'     ,@doFigureKeyPress          , ...
    'IntegerHandle'   ,'off'                      , ...
    'WindowStyle'     ,'normal'                   , ...
    'HandleVisibility','callback'                 , ...
    'CloseRequestFcn' ,@doDelete                  , ...
    'Tag'             ,Title                        ...
    );

%%%%%%%%%%%%%%%%%%%%%
%%% Set Positions %%%
%%%%%%%%%%%%%%%%%%%%%
DefOffset  =10;

IconWidth  =54;
IconHeight =54;
IconXOffset=DefOffset;
IconYOffset=FigPos(4)-DefOffset-IconHeight;  %#ok
IconCMap=[Black;get(QuestFig,'Color')];  %#ok

DefBtnWidth =56;
BtnHeight   =22;

BtnYOffset=DefOffset;

BtnWidth=DefBtnWidth;

ExtControl=uicontrol(QuestFig   , ...
    'Style'    ,'pushbutton', ...
    'String'   ,' '          ...
    );

btnMargin=1.4;
set(ExtControl,'String',Btn1);
BtnExtent=get(ExtControl,'Extent');
BtnWidth=max(BtnWidth,BtnExtent(3)+8);
if NumButtons > 1
    set(ExtControl,'String',Btn2);
    BtnExtent=get(ExtControl,'Extent');
    BtnWidth=max(BtnWidth,BtnExtent(3)+8);
    if NumButtons > 2
        set(ExtControl,'String',Btn3);
        BtnExtent=get(ExtControl,'Extent');
        BtnWidth=max(BtnWidth,BtnExtent(3)*btnMargin);
    end
end
BtnHeight = max(BtnHeight,BtnExtent(4)*btnMargin);

delete(ExtControl);

MsgTxtXOffset=IconXOffset+IconWidth;

FigPos(3)=max(FigPos(3),MsgTxtXOffset+NumButtons*(BtnWidth+2*DefOffset));
set(QuestFig,'Position',FigPos);

BtnXOffset=zeros(NumButtons,1);

if NumButtons==1,
    BtnXOffset=(FigPos(3)-BtnWidth)/2;
elseif NumButtons==2,
    BtnXOffset=[MsgTxtXOffset
        FigPos(3)-DefOffset-BtnWidth];
elseif NumButtons==3,
    BtnXOffset=[MsgTxtXOffset
        0
        FigPos(3)-DefOffset-BtnWidth];
    BtnXOffset(2)=(BtnXOffset(1)+BtnXOffset(3))/2;
end

MsgTxtYOffset=DefOffset+BtnYOffset+BtnHeight;
% Calculate current msg text width and height. If negative,
% clamp it to 1 since its going to be recalculated/corrected later
% based on the actual msg string
MsgTxtWidth=max(1, FigPos(3)-DefOffset-MsgTxtXOffset-IconWidth);
MsgTxtHeight=max(1, FigPos(4)-DefOffset-MsgTxtYOffset);

MsgTxtForeClr=Black;
MsgTxtBackClr=get(QuestFig,'Color');

CBString='uiresume(gcbf)';
DefaultValid = false;
DefaultWasPressed = false;
BtnHandle = cell(NumButtons, 1);
DefaultButton = 0;

% Check to see if the Default string passed does match one of the
% strings on the buttons in the dialog. If not, throw a warning.
for i = 1:NumButtons
    switch i
        case 1
            ButtonString=Btn1;
            ButtonTag='Btn1';
            if strcmp(ButtonString, Default)
                DefaultValid = true;
                DefaultButton = 1;
            end
            
        case 2
            ButtonString=Btn2;
            ButtonTag='Btn2';
            if strcmp(ButtonString, Default)
                DefaultValid = true;
                DefaultButton = 2;
            end
        case 3
            ButtonString=Btn3;
            ButtonTag='Btn3';
            if strcmp(ButtonString, Default)
                DefaultValid = true;
                DefaultButton = 3;
            end
    end
    
    BtnHandle{i}=uicontrol(QuestFig            , ...
        'Style'              ,'pushbutton', ...
        'Position'           ,[ BtnXOffset(1) BtnYOffset BtnWidth BtnHeight ]           , ...
        'KeyPressFcn'        ,@doControlKeyPress , ...
        'CallBack'           ,CBString    , ...
        'String'             ,ButtonString, ...
        'HorizontalAlignment','center'    , ...
        'Tag'                ,ButtonTag     ...
        );
end

if ~DefaultValid
    warnstate = warning('backtrace','off');
    warning('MATLAB:QUESTDLG:stringMismatch','Default string does not match any button string name.');
    warning(warnstate);
end

MsgHandle=uicontrol(QuestFig            , ...
    'Style'              ,'text'         , ...
    'Position'           ,[MsgTxtXOffset MsgTxtYOffset 0.95*MsgTxtWidth MsgTxtHeight ]              , ...
    'String'             ,{' '}          , ...
    'Tag'                ,'Question'     , ...
    'HorizontalAlignment','left'         , ...
    'FontWeight'         ,'bold'         , ...
    'BackgroundColor'    ,MsgTxtBackClr  , ...
    'ForegroundColor'    ,MsgTxtForeClr    ...
    );

[WrapString,NewMsgTxtPos]=textwrap(MsgHandle,Question,75);

% NumLines=size(WrapString,1);

AxesHandle=axes('Parent',QuestFig,'Position',[0 0 1 1],'Visible','off');

texthandle=text( ...
    'Parent'              ,AxesHandle                      , ...
    'Units'               ,'pixels'                        , ...
    'Color'               ,get(BtnHandle{1},'ForegroundColor')   , ...
    'HorizontalAlignment' ,'left'                          , ...
    'FontName'            ,get(BtnHandle{1},'FontName')    , ...
    'FontSize'            ,get(BtnHandle{1},'FontSize')    , ...
    'VerticalAlignment'   ,'bottom'                        , ...
    'String'              ,WrapString                      , ...
    'Interpreter'         ,Interpreter                     , ...
    'Tag'                 ,'Question'                        ...
    );

textExtent = get(texthandle, 'extent');

% (g357851)textExtent and extent from uicontrol are not the same. For window, extent from uicontrol is larger
%than textExtent. But on Mac, it is reverse. Pick the max value.
MsgTxtWidth=max([MsgTxtWidth NewMsgTxtPos(3)+2 textExtent(3)]);
MsgTxtHeight=max([MsgTxtHeight NewMsgTxtPos(4)+2 textExtent(4)]);

MsgTxtXOffset=IconXOffset+IconWidth+DefOffset;
FigPos(3)=max(NumButtons*(BtnWidth+DefOffset)+DefOffset, ...
    MsgTxtXOffset+MsgTxtWidth+DefOffset);


% Center Vertically around icon
if IconHeight>MsgTxtHeight,
    IconYOffset=BtnYOffset+BtnHeight+DefOffset;
    MsgTxtYOffset=IconYOffset+(IconHeight-MsgTxtHeight)/2;
    FigPos(4)=IconYOffset+IconHeight+DefOffset;
    % center around text
else
    MsgTxtYOffset=BtnYOffset+BtnHeight+DefOffset;
    IconYOffset=MsgTxtYOffset+(MsgTxtHeight-IconHeight)/2;
    FigPos(4)=MsgTxtYOffset+MsgTxtHeight+DefOffset;
end

if NumButtons==1,
    BtnXOffset=(FigPos(3)-BtnWidth)/2;
elseif NumButtons==2,
    BtnXOffset=[(FigPos(3)-DefOffset)/2-BtnWidth
        (FigPos(3)+DefOffset)/2
        ];
    
elseif NumButtons==3,
    BtnXOffset(2)=(FigPos(3)-BtnWidth)/2;
    BtnXOffset=[BtnXOffset(2)-DefOffset-BtnWidth
        BtnXOffset(2)
        BtnXOffset(2)+BtnWidth+DefOffset
        ];
end
set(QuestFig ,'Position',FigPos); % <<<<<<<<<<----------MODIFIED
% set(QuestFig ,'Position',getnicedialoglocation(FigPos, get(QuestFig,'Units'))); % <<<<<<<<<<----------MODIFIED
assert(iscell(BtnHandle));
BtnPos=cellfun(@(bh)get(bh,'Position'), BtnHandle, 'UniformOutput', false);
BtnPos=cat(1,BtnPos{:});
BtnPos(:,1)=BtnXOffset;
BtnPos=num2cell(BtnPos,2);

assert(iscell(BtnPos));
cellfun(@(bh,pos)set(bh, 'Position', pos), BtnHandle, BtnPos, 'UniformOutput', false);

if DefaultValid
    %   setdefaultbutton(QuestFig, BtnHandle{DefaultButton}); % <<<<<<<<<<----------MODIFIED
end

delete(MsgHandle);


set(texthandle, 'Position',[MsgTxtXOffset MsgTxtYOffset 0]);


IconAxes=axes(                                      ...
    'Parent'      ,QuestFig              , ...
    'Units'       ,'Pixels'              , ...
    'Position'    ,[IconXOffset IconYOffset IconWidth IconHeight], ...
    'NextPlot'    ,'replace'             , ...
    'Tag'         ,'IconAxes'              ...
    );

set(QuestFig ,'NextPlot','add');

load dialogicons.mat questIconData questIconMap;
IconData=questIconData;
questIconMap(256,:)=get(QuestFig,'color');
IconCMap=questIconMap;

Img=image('CData',IconData,'Parent',IconAxes);
set(QuestFig, 'Colormap', IconCMap);
set(IconAxes, ...
    'Visible','off'           , ...
    'YDir'   ,'reverse'       , ...
    'XLim'   ,get(Img,'XData'), ...
    'YLim'   ,get(Img,'YData')  ...
    );

% make sure we are on screen
movegui(QuestFig)


set(QuestFig ,'WindowStyle','modal','Visible','on');
drawnow;

if DefaultButton ~= 0
    uicontrol(BtnHandle{DefaultButton});
end

if ishghandle(QuestFig)
    % Go into uiwait if the figure handle is still valid.
    % This is mostly the case during regular use.
    uiwait(QuestFig);
end

% Check handle validity again since we may be out of uiwait because the
% figure was deleted.
if ishghandle(QuestFig)
    if DefaultWasPressed
        ButtonName=Default;
    else
        ButtonName=get(get(QuestFig,'CurrentObject'),'String');
    end
    doDelete;
else
    ButtonName='';
end

    function doFigureKeyPress(obj, evd)  %#ok
        switch(evd.Key)
            case {'return','space'}
                if DefaultValid
                    DefaultWasPressed = true;
                    uiresume(gcbf);
                end
            case 'escape'
                doDelete
        end
    end

    function doControlKeyPress(obj, evd)  %#ok
        switch(evd.Key)
            case {'return'}
                if DefaultValid
                    DefaultWasPressed = true;
                    uiresume(gcbf);
                end
            case 'escape'
                doDelete
        end
    end

    function doDelete(varargin)
        delete(QuestFig);
    end
end










    










 









   
       


     

 

                            
    
                                                                                 
                                                                                                  

 