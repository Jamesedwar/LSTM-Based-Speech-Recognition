clear all;
clc;
close all;
 
C={'Where_is_Samsung_located.wav', 'Who_is_the_founder_of_Samsung.wav', 'Which_OS_is_present_in_S6.wav', 'The_main_competitor_of_Samsung_is.wav', 'Tell_the_RAM_size_of_S6.wav', 'Alternate_flight_to_Perth.wav', 'Does_the_computer_have_a_name.wav', 'Conclude_the_event.wav', 'Greet_everyone.wav', 'Thank_you_for_the_details.wav'};
D={'Where is Samsung located', 'Who is the founder of Samsung', 'Which OS is present in S6','The main competitor of Samsung is', 'Tell the RAM size of S6', 'Alternate flight to Perth', 'Does the computer have a name', 'Conclude the event', 'Greet everyone', 'Thank you for the details'};
index=0; 

for k=1:length(C)
    
 % Define variables
    Tw = 25;                % analysis frame duration (ms)
    Ts = 10;                % analysis frame shift (ms)
    alpha = 0.97;           % preemphasis coefficient
    M = 20;                 % number of filterbank channels 
    C1 = 12;                 % number of cepstral coefficients
    L = 22;                 % cepstral sine lifter parameter
    LF = 300;               % lower frequency limit (Hz)
    HF = 3700;              % upper frequency limit (Hz)
    

    x=audioread(strcat('Training_Data\',C{k}));
    fs=8000;
%     sound(x,fs);
%     pause(2);
    % MFCC Feature Extraction
    [ X, FBEs, frames ] = ...
                    mfcc( x, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C1+1, L );
 
    Hval{k}=X;
 
end   

    %Identifying sequences
    numObservations = numel(Hval);
    
    for i=1:numObservations
    sequence = Hval{i};
     sequenceLengths(i) = size(sequence,2);
    end
    [sequenceLengths,idx] = sort(sequenceLengths);
    
    XTrain = Hval(idx);
    YTrain = D(idx);
    
   % Training the network 
    G=categorical(YTrain');
    inputSize = 13;
    HiddenLayer = 198;
    outputMode = 'last';
    numClasses = 10;
    layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(HiddenLayer,'OutputMode',outputMode)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
    maxEpochs = 40;
    miniBatchSize = 27;
    options = trainingOptions('adam', ...
             'ExecutionEnvironment','cpu', ...
             'GradientThreshold',1, ...
             'MaxEpochs',maxEpochs, ...
             'MiniBatchSize',miniBatchSize, ...
             'SequenceLength','longest', ...
             'Shuffle','never', ...
             'Verbose',0, ...
             'Plots','training-progress');

    net = trainNetwork(XTrain,G,layers,options);
    
    %Testing data 1
    
    for times=1:10
    y = recording(); % Getting real time speech input
    
    [ Y, FBEs, frames ] = ...
                    mfcc( y, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C1+1, L );
    for i=1:length(C)
    XTest{i}=Y;
    end
    
    
    miniBatchSize = 27;
    YPred = classify(net,XTest, ...
                     'MiniBatchSize',miniBatchSize, ...
                     'SequenceLength','longest');
    
    Val=YPred(1);
    disp(Val);
    for i=1:length(C)
    if(ismember(string(D{i}),Val))
     index=i;
    end
    end
    disp(index);
    pause(2);
    end