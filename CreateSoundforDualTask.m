%% Generate upward and downward chirps

clear; clc;

fs = 44100;      % Sampling rate (Hz)
dur = 0.25;      % Duration (s)

t = (0:1/fs:dur-1/fs)';

%% Upward chirp: 400 -> 1200 Hz
up = chirp(t,300,dur,2200,'linear');

%% Downward chirp: 1200 -> 400 Hz
down = chirp(t,2200,dur,300,'linear');

%% Apply smooth onset/offset ramp
rampDur = 0.01; % 10 ms
nRamp = round(rampDur*fs);

rampUp = linspace(0,1,nRamp)';
rampDown = linspace(1,0,nRamp)';

env = ones(length(t),1);
env(1:nRamp) = rampUp;
env(end-nRamp+1:end) = rampDown;

up = up .* env;
down = down .* env;

%% Normalize
up = 0.95 * up / max(abs(up));
down = 0.95 * down / max(abs(down));

%% Save wav files
audiowrite('up.wav',up,fs);
audiowrite('down.wav',down,fs);

%% Listen
disp('Playing upward chirp...');
sound(up,fs);

pause(dur + 0.5);

disp('Playing downward chirp...');
sound(down,fs);