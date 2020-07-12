function [z] = Preprocessing(x)
% [x, fs]= audioread('WAV/Praveen-01.wav'); 
% II - Noise Removal using Butterworth bandpass filter 800Hz to 8000 Hz
%      of order 10
fs=16000;
order    = 10;
fcutlow  = 50;
fcuthigh =7900;
[b,a]    = butter(order,[fcutlow,fcuthigh]/(fs/2), 'bandpass');
y1        = filter(b,a,x);

% III - Design and apply high pass filter (Preemphasis filter)
B = [-0.95 1]; % Apply function H(Z) = 1-0.95z-1
y = filter(B,1,y1);
% figure; plot(y);
% IV End point Detection (Voice Activation Detection)
THRESHOLD=0.5;
samplePerFrame=floor(fs/100);
bgSampleCount=floor(fs/5); %according to formula, 1600 sample needed for 8 khz

%----------
%calculation of mean and std
bgSample=[];
for i=1:1:bgSampleCount
    bgSample=[bgSample y(i)];
end
meanVal=mean(bgSample);
sDev=std(bgSample);
%----------
%identify voiced or not for each value
for i=1:1:length(y)
   if(abs(y(i)-meanVal)/sDev > THRESHOLD)
       voiced(i)=1;
   else
       voiced(i)=0;
   end
end
% Identify voiced or not for each frame
% Discard insufficient samples of last frame
usefulSamples=length(y)-mod(length(y),samplePerFrame);
frameCount=usefulSamples/samplePerFrame;
voicedFrameCount=0;
for i=1:1:frameCount
   cVoiced=0;
   cUnVoiced=0;
   for j=i*samplePerFrame-samplePerFrame+1:1:(i*samplePerFrame)
       if(voiced(j)==1)
           cVoiced=(cVoiced+1);
       else
           cUnVoiced=cUnVoiced+1;
       end
   end
   %mark frame for voiced/unvoiced
   if(cVoiced>cUnVoiced)
       voicedFrameCount=voicedFrameCount+1;
       voicedUnvoiced(i)=1;
   else
       voicedUnvoiced(i)=0;
   end
end

z=[];

%-----
for i=1:1:frameCount
    if(voicedUnvoiced(i)==1)
    for j=i*samplePerFrame-samplePerFrame+1:1:(i*samplePerFrame)
        z= [z y(j)];
    end
    end
end

% %---display plot and play both sounds
%     figure; plot(y);
%     figure; plot(z);
%     sound(z,fs);

