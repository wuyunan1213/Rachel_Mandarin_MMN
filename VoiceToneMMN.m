%VoiceToneMMN.m
%Code to collect MMN data for Rachel's Honor's Thesis
%Created by MD on 12/8/2019

%LAST EDIT on 1/5/2019 by Charles Wu at midnight

%% INITIALIZATION
close all;
clear;
clc;

cd('C:\Users\Lab User\Desktop\Experiments\Musicianship\VoiceTone')


fprintf('Beginning VoiceTone MMN protocol.\n\n')

% Step One: Connect to and properly initialize RME sound card
soundCard = initRME_MADIface(44100);

if ~playrec('isInitialised')
    error('ERROR: A problem occurred with the final connection. Please ensure the device is connected properly and powered on, and try again.');
else
    fprintf('\nSuccess! RME connected and online.\n')
end

Fs = 44100;
stimchanlist=[1,2,14];

% Step Two: Now, we establish the subject's ID number and load in stimuli
fprintf('\nPlease follow the prompt in the pop-up window.\n\n')

subject = char(inputdlg('Please enter the subject ID number:','Subject ID'));

fprintf('Loading sound files. This may take a moment...')
load('C:\Users\Lab User\Desktop\Experiments\MusicianShip\VoiceToneMaster.mat');
fprintf('Done.\n')

#%Set insensity level for stimuli

%There will be 150 trials in each condition
%120 standard presentations, 30 deviant presentations for each condition

%Set interstimulus interval length
ISI_length = 500; %Value in ms
ISIcalc = int16(ISI_length/1000*Fs);
ISI = zeros(1,ISIcalc);%ISI relative to sampling frequency
trig_threshold = .005; %%change this intensity level
%Build presentation order
playlist=zeros(4,150);
dev_perc = 0.20; dis_perc = 0.00; N = 150;
for idx = 1:4
    playlist(idx,:) = randomizePlayListRachel(dev_perc,dis_perc,N);
end
%Experiment 1
%Condition 1: female falling, female flat
%Condition 2: female flat, female falling
%Condition 3: male falling, male flat
%Condition 4: male flat, male falling
          
%Randomize condition order
ConditionOrder = randperm(4);

%%%%%Still working on this

for i = 1:length(ConditionOrder)
    cond = ConditionOrder(i);
    stimbuffer = [];
    triggerbuffer = [];
    for j = 1:length(playlist(1,:))
        stimName = VoiceToneMaster.Conditions{cond, playlist(1,j)};
        %%the line above finds the name of the sound to be presented
        %%given the condition and playlist number
        stim = VoiceToneMaster.Stimuli(strcmp(VoiceToneMaster.Stimuli(:,1), stimName),:);
        %%The line above finds all names that match the stimulus name in the condition list 
        %%i.e., all 5 stimuli that match the name
        sound = stim(randperm(5,1), 5)+ISI;%%randomly select one from a stimulus list of 5
        %%%The line above randomly selects a sound from the 5 sounds and
        %%%add ISI to it
        %%the code below adds trigger to the stimuli. Note that we don't
        %%need an if statement to separate standard from deviant because
        %%the playlist(1,j) number takes care of it. 
        stimbuffer = [stimbuffer,sound];
        MMNtrig = (100*playlist(1,j)+(i*10)+r);
        trig = zeros(length(sound),1);
        trig_len = (.001*Fs);
        %Find amplitude - may need to change .005 value
        trig(find(sound>trig_threshold,1):(find(sound>trig_threshold,1)+trig_len-1))...
            = trignum2scalar(MMNtrig)*ones(trig_len,1);
        triggerbuffer = [triggerbuffer, trig];
    end
end

%%Play the stuff; concatenate 2x sound channels and trigger using
%%playrec('play',[stim,stim,trigger], stimchanlist=[1,2,14])
playrec('play',[stimbuffer,stimbuffer,triggerbuffer]);

%Experiment 2


% Disconnect RME
fprintf('Disconnecting PsychPortAudio...\n')
playrec('reset');
%PsychPortAudio('Close')
fprintf('Playrec successfully disconnected. Goodbye!\n')
%We're done!