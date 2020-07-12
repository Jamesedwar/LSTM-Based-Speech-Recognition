clear all;
clc;
close all;
 
C={'Samsung_founder_is.wav', 'Where_is_Samsung_located.wav', 'Greet_everyone.wav', 'Where_are_we.wav','Call_Dr_Aravind.wav', 'What_is_your_name.wav', 'The_main_competitor_of_Samsung.wav', 'Send_email_to_Praveen.wav', 'Turn_on_the_camera.wav', 'Conclude_the_event.wav','what_is_the_OS_of_Samsung.wav','Tell_the_RAM_size_of_S6.wav','S6_was_released_in.wav','The_cost_of_S6_is.wav','Do_you_own_S6.wav','Flights_to_Boston_today.wav','Next_flight_to_Perth.wav','Is_flight_AK021_delayed.wav','Send_message_to_Dr.Mun.wav','Are_seats_avilable.wav'};
D={'Samsung founder is', 'Where is Samsung located', 'Greet everyone', 'Where are we','Call Dr Aravind', 'What is your name', 'The main Competitor of Samsung', 'Send email to Praveen', 'Turn on the camera', 'Conclude the event','what is the OS of Samsung','Tell the RAM size of S6','S6 was released in','The cost of S6 is','Do you own S6','Flights to Boston today','Next flight to Perth','Is flight AK021 delayed','Send message to Dr.Mun','Are seats available'};

% disp( 'The words are: ')
% for y=1:length(C)
% disp (D{y});
% end
% disp('Speak any word from this list');

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
    

    x=audioread(strcat('Training_Data2\',C{k}));
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
    numClasses = 20;
    layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(HiddenLayer,'OutputMode',outputMode)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
    maxEpochs = 50;
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
for k=1:length(C)

    x=audioread(strcat('Training_Data3\',C{k}));
    fs=8000;
%     sound(x,fs);
%     pause(2);
    % MFCC Feature Extraction
    [ X, FBEs, frames ] = ...
                    mfcc( x, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C1+1, L );
 
    Hval1{k}=X;
 
end   
    
    %Testing data 1
    XTest=Hval1;
    miniBatchSize = 27;
    YPred = classify(net,XTest, ...
                     'MiniBatchSize',miniBatchSize, ...
                     'SequenceLength','longest');
    disp('Answer');
    disp(YPred);
    
    
