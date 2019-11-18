%MMN script for Rachel's Mandarin tone study
%
%
%
%(C)This script was written by Charles Wu
% Holt Lab
%

%% INITIALIZATION
close all;
clear all; %#ok<CLALL>
clc;

cd('C:\Users\Lab User\Desktop\Experiments\Charles\EEG') %%specify your path

fprintf('Rachel MMN senior thesis.\n\n')

repNumber = 4; %%the baseline block should be repeated 4 times
                
trialNumber = 36;%%Number of trials within a block, should always be 36
                 %%%for this experiment
scale=db2mag(-25);%%scale the sound down to a certain degree so it's at a 
                  %%comfortable listening level using earphones

% Step One: Connect to and properly initialize RME sound card
fprintf('Initializing connection to sound card...\n')
Devices=playrec('getDevices');
if isempty(Devices)
    error(sprintf('There are no devices available using the selected host APIs.\nPlease make sure the RME is powered on!')); %#ok<SPERR>
else
    i=1;
    while ~strcmp(Devices(i).name,'ASIO MADIface USB') && i <= length(Devices)
        i=i+1;
    end
end
fs = Devices(i).defaultSampleRate;
playDev = Devices(i).deviceID;
playrec('init',fs,playDev,-1,14,-1);
fprintf('Success! Connected to %s.\n', Devices(i).name);
stimchanList=[1,2];

% Step Two: Yippee, we're online. Now, we establish the subject's ID number
% Load the stimuli that you are going to present
fprintf('\nPlease follow the prompt in the pop-up window.\n\n')

subj = char(inputdlg('Please enter the subject ID number:','Subject ID'));

fprintf('Loading sound files. This may take a moment...')
load('BPmaster_baseline.mat');
load('BPmaster_canonical.mat');
load('BPmaster_reverse.mat');
load('BPresp.mat');
fprintf('Done.\n')
%%column names of the stimfiles: 
%%1.sound file 2. VOT value 3. F0 value 4. VOT level 5. F0 level. 6. block
%%7.stimulus type 8. audio

%Step Three: Launch PsychToolbox; display instructions
screens = Screen('Screens');
screenNumber = max(screens);
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
grey = white / 2;
Screen('Preference','DefaultFontSize',40);
Screen('Preference','VisualDebugLevel',1);
Screen('Preference', 'TextAntiAliasing', 2);
Screen('Preference', 'TextRenderer', 1);
Screen('Preference','SyncTestSettings', 0.002);
%%auditory
[win,winRect] = Screen('OpenWindow',screenNumber,black);
[width,height] = Screen('WindowSize',screenNumber);
Screen('TextFont', win, 'Helvetica');
Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

responseKeyIdx = KbName('space');
enabledkeys = RestrictKeysForKbCheck(responseKeyIdx);

%%%step four, present the baseline block first. This is done while the
%%%participant is being capped. Only one block omitted for now

Screen('TextFont', win, 'Helvetica');
Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

responseKeyIdx = KbName('space');
enabledkeys = RestrictKeysForKbCheck(responseKeyIdx);

%% some experiment instructions to start with. Please change these instructions
curText = ['<color=ffffff>In this experiment, you will hear Mandarin... '...
    '<color=ffff00><b>"Beer"<b> <color=ffffff>or the word <color=ffff00><b>"Pier'...
    '"<b> <color=ffffff>\n\n'...
    'If you hear "beer" click the box labeled "beer"'...
    '\nIf you hear "pier", click the box labeled "pier".'...
    '\n\nIf you are unsure, '...
    'make your best guess.\n\n'...
    'This is the first part of the experiment while the experimenter '...
    'is setting up the EEG equipment on your scalp. \n'...
    'There is only one block in this part \n\n'...
    '<b>Press "spacebar" to begin.<b>'];
%curText = 'In this experiment, you will hear either the word "BEER" or the word "PIER" \n\n\n\n If you hear "BEER", click the box labelled "BEER". \n\n If you hear "PIER" click the box labelled "PIER". \n\n If you are unsure, make your best guess.\n\n\n\n Every once in a while, you can take a break \n\n and we will show you a short cartoon with the same sounds in the background. \n\n You just need to watch the cartoon and relax and ignore the sounds. \n\n\n\n Press SPACEBAR to begin';
DrawFormattedText2(curText,'win',win,'sx',400,'sy',400,'xalign','left','yalign','top','wrapat',59);
%DrawFormattedText(win, curText, 'center', 'center', white);
Screen('Flip',win);
oldtype = ShowCursor(0);
KbWait([],2);

baselineTN = 25*repNumber;

presentation = [];
for i = 1:repNumber
    A = randperm(25);
    presentation=[presentation, A];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MMN BLOCK WITH  SILENT MOVIES  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%This code was written specifically for my BEER/PIER MMN study so
%%%%%%%%%there might be significant edits to be made for Rachel's study.
%%%%%%%%%But basically in my MMN experiment, I have 1s of silence at the
%%%%%%%%%beginning and end of each MMN block. Then there are 20 speech
%%%%%%%%%sounds with standard and deviant sounds of BEER/PIER
%%%%%%%%%(counterbalanced). The stimuli were structured in a way as blocks
%%%%%%%%%(b = 1:6)
%%%%%%%%%of standard/deviant sounds. The first block (b = 1) is 3 standard
%%%%%%%%%sounds--they are always at the beginnning of each block. Then if b
%%%%%%%%%is odd, it's always the block with 3 standard sounds, but if b is
%%%%%%%%%even, it's a random permutation of standard/deviant sounds. This
%%%%%%%%%way we guarantee there are at least 3 standard sounds but at most 6 standard sounds
%%%%%%%%%before a deviant. Then the last block (b = 6) is always standard,
%%%%%%%%%standard and then deviant. The ISI is set to be 700ms in this
%%%%%%%%%experiment. Note that the EEG triggers are built-in into every
%%%%%%%%%block simultaneously with the speech sounds such that they can
%%%%%%%%%synchronize.

    %%%first create 1s silent period
    silence = zeros(fs,1);
    %%%Then create our counterbalancing conditions such that in odd blocks,
    %%%we have b as standard, p as deviant and in even blocks, we have the
    %%%opposite
    %%%we do this by loading different scripts depending on the block
    %%%number
    %%Now counterbalance the standard/deviant stimuli
    if (mod(i, 2) ~= 0) %%load different
        load('BPmaster_test_v1.mat'); %%load version 1
        %%the block number is odd
    else
        load('BPmaster_test_v2.mat');%%%load version 2 when 
        %%the block number is even 
    end
    %%use v and last to index the stimulus positions in a sequence
    v = [1,1,1,2];
    last = [1,1,2];
    standard = BPCWmaster_test.Stimuli{1,8}; %%standard stimulus is alwas
    %%the first one in the file
    
    %%start 'building' our speech sequence and store in vector 'build'
    %%and store the trigger vector in 'trigger_build'
    %%here we break the sequence of 20 stims into 6 chunks
    %%hence, b = 1:6
    build = [];
    trigger_build = [];
    MMNtrig = 50+BI;
    for b = 1:6
        pos = v(randperm(numel(v)));
        pos_end = last(randperm(numel(last)));     

        ISI_length = 700; %%%ISI should not be jittered!!
        ISI = int16(ISI_length/1000*44100);

        if (mod(b, 2) ~= 0) %%all the blocks of 3 standard stimuli in odd numbers
            Block = [zeros(ISI,1);standard;...
                     zeros(ISI,1);standard;...
                     zeros(ISI,1);standard];
            %%%EEG trigger for standard: 41 or 61
            trig = zeros(length(standard),1);
            trig(find(standard>.005,1):(find(standard>.005,1)+trig_len-1))...
            = trignum2scalar(MMNtrig+1)*ones(trig_len,1);
        
            trig_Block = [zeros(ISI,1);trig;...
            zeros(ISI,1);trig;...
            zeros(ISI,1);trig];

        elseif (mod(b, 2) == 0) && (b<6) %% randomize standard+deviant blocks in <6 even numbers
            s1 = BPCWmaster_test.Stimuli{pos(1),8}; s2 = BPCWmaster_test.Stimuli{pos(2),8};
            s3 = BPCWmaster_test.Stimuli{pos(3),8}; s4 = BPCWmaster_test.Stimuli{pos(4),8};
            
            %%%EEG trigger for standard is always 41 or 61
            %%%and for deviant is always 42 or 62
            %%%but because we are randomizing here so we don't know which
            %%%is which so we need t1:t4 to index it.
            t1 = MMNtrig+pos(1); t2 = MMNtrig+pos(2); t3 = MMNtrig+pos(3); t4 = MMNtrig+pos(4);
            fprintf('\nThe trigger numbers are \n t1=%.1f\nt2=%.1f\nt3=%.1f\nt4=%.1f\n',...
                    t1, t2, t3, t4);
            Block = [zeros(ISI,1); s1;...
                     zeros(ISI,1); s2;...
                     zeros(ISI,1); s3;...
                     zeros(ISI,1); s4];
                 
            trig1 = zeros(length(s1),1);
            trig1(find(s1>.005,1):(find(s1>.005,1)+trig_len-1))...
            = trignum2scalar(t1)*ones(trig_len,1);
        
            trig2 = zeros(length(s2),1);
            trig2(find(s2>.005,1):(find(s2>.005,1)+trig_len-1))...
            = trignum2scalar(t2)*ones(trig_len,1);
        
            trig3 = zeros(length(s3),1);
            trig3(find(s3>.005,1):(find(s3>.005,1)+trig_len-1))...
            = trignum2scalar(t3)*ones(trig_len,1);
        
            trig4 = zeros(length(s4),1);
            trig4(find(s4>.005,1):(find(s4>.005,1)+trig_len-1))...
            = trignum2scalar(t4)*ones(trig_len,1);
        
            trig_Block = [zeros(ISI,1);trig1;...
             zeros(ISI,1);trig2;...
             zeros(ISI,1);trig3;
             zeros(ISI,1);trig4];
         

        elseif (b==6)
            s1 = BPCWmaster_test.Stimuli{pos_end(1),8};
            s2 = BPCWmaster_test.Stimuli{pos_end(2),8};
            s3 = BPCWmaster_test.Stimuli{pos_end(3),8};
            
            Block = [zeros(ISI,1); s1;...
                     zeros(ISI,1); s2;...
                     zeros(ISI,1); s3];
                 
            t1 = MMNtrig+pos_end(1); t2 = MMNtrig+pos_end(2); t3 = MMNtrig+pos_end(3);
                 
            trig1 = zeros(length(s1),1);
            trig1(find(s1>.005,1):find(s1>.005,1)+trig_len-1)...
            = trignum2scalar(t1)*ones(trig_len,1);
        
            trig2 = zeros(length(s2),1);
            trig2(find(s2>.005,1):find(s2>.005,1)+trig_len-1)...
            = trignum2scalar(t2)*ones(trig_len,1);
        
            trig3 = zeros(length(s3),1);
            trig3(find(s3>.005,1):find(s3>.005,1)+trig_len-1)...
            = trignum2scalar(t3)*ones(trig_len,1);
        
            trig_Block = [zeros(ISI,1);trig1;...
            zeros(ISI,1);trig2;...
            zeros(ISI,1);trig3];
            fprintf('\nThe trigger numbers are \n t1=%.1f\nt2=%.1f\nt3=%.1f\n',...
                    t1, t2, t3);
        end

        build = [build; Block];
        trigger_build = [trigger_build; trig_Block];

    end
    
    %%%put together all the stimuli and the EEG triggers that we just built 
    signal = [silence; build; silence];
    trigger_MMN = [silence; trigger_build; silence];
    
    %%%The next part is code to display movie. Here what I did for my
    %%%experiment was to chop the movie into segments and the code below
    %%%play each segment during each block so we can automate the whole
    %%%process
    
    % Select screen for display of movie:
    moviename = ['C:\Users\Lab User\Desktop\Experiments\Charles\EEG\Movies\Movie_', int2str(i),'.MP4' ];
    screenid = max(Screen('Screens'));
    % Open 'windowrect' sized window on screen, with black [0] background color:
    screen=max(Screen('Screens'));
    % Open movie file:
    movie = Screen('OpenMovie', win, moviename, [], [], 2);

    % Start playback engine:
    Screen('PlayMovie', movie, 1);
    rect1=SetRect(400,100,1600,1100);
    
    %%%put the stimuli in the first two channels and the EEG trigger in the
    %%%third channel AFTER we prepare the screen for movies
    signalthree=[scale*signal,scale*signal,trigger_MMN];
    pageno = playrec('play',signalthree,stimchanList);
    
%     PsychPortAudio('FillBuffer', pamaster, signalthree);
%     t1 = PsychPortAudio('Start', pamaster, 1, 0, 0);

    % Playback loop: Runs until end of movie or ke   ypress:
    while(1)
        % Wait for next movie frame, retrieve texture handle to it
        tex = Screen('GetMovieImage', win, movie);

        % Valid texture returned? A negative value means end of movie reached:
        if tex<=0
            % We're done, break out of loop:
            break;
        end

        % Draw the new texture immediately to screen:
        Screen('DrawTexture', win, tex, [], rect1);

        % Update display:
        Screen('Flip', win);

        % Release texture:
        Screen('Close', tex);
    end

    while playrec('isFinished',pageno) == 0
    end
    %PsychPortAudio('Stop', pamaster , 1, 1);


    % Stop playback:
    Screen('PlayMovie', movie, 0);
    % Close movie:
    Screen('CloseMovie', movie);
end

%% CLOSEOUT
% Close PTB Screen
Screen('CloseAll');

% Since in this experiment we are not recording behavioral responses, no
% behavioral data will be saved

% fnamemat = ['C:\Users\Lab User\Desktop\Experiments\Charles\EEG\Results\' subj '_BP_' datestr(datetime('now'),'yyyymmdd') '.mat'];
% save(fnamemat,'BPCWresp')
% 
% sIDcell=cell(length(BPCWresp),1);
% sIDcell(:)={subj};
% BPCWresp=cell2table([sIDcell,BPCWresp]);
% fnamecsv = ['C:\Users\Lab User\Desktop\Experiments\Charles\EEG\Results\' subj '_BP_' datestr(datetime('now'),'yyyymmdd') '.csv'];
% BPCWresp.Properties.VariableNames={'sID','Sound','VOT','F0','VOTlevel','F0level','Block','StimulusType','Response'};
% writetable(BPCWresp,fnamecsv);

% Disconnect RME
fprintf('Disconnecting PsychPortAudio...\n')
playrec('reset');
%PsychPortAudio('Close')
fprintf('Playrec successfully disconnected. Goodbye!\n')
