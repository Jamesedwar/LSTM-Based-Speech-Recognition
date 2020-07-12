clear all;
clc;
close all;
 
C={'Where_is_Samsung_located.wav', 'Who_is_the_founder_of_Samsung.wav', 'Which_OS_is_present_in_S6.wav', 'The_main_competitor_of_Samsung_is.wav', 'Tell_the_RAM_size_of_S6.wav', 'Alternate_flight_to_Perth.wav', 'Does_the_computer_have_a_name.wav', 'Conclude_the_event.wav', 'Greet_everyone.wav', 'Thank_you_for_the_details.wav'};
D={'Where is Samsung located', 'Who is the founder of Samsung', 'Which OS is present in S6','The main competitor of Samsung is', 'Tell the RAM size of S6', 'Alternate flight to Perth', 'Does the computer have a name', 'Conclude the event', 'Greet everyone', 'Thank you for the details'};
index=0;

for k=1:length(C)
    x=audioread(strcat('Training_Data\',C{k}));
    fs=16000;
%     figure; plot(x);
    z = Preprocessing(x);
    X=mfcc39(z,fs,12,120);
    
     Hval{k}=X;
end

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
    inputSize = 39;
    HiddenLayer = 736;
    outputMode = 'last';
    numClasses = 10;
    layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(HiddenLayer,'OutputMode',outputMode)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
    maxEpochs = 100;
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
     z = Preprocessing(y);
    Y=mfcc39(z,fs,12,120);
    
    for i=1:length(C)
    XTest{i}=Y;
    end
    
    
    miniBatchSize = 27;
    YPred = classify(net,XTest, ...
                     'MiniBatchSize',miniBatchSize, ...
                     'SequenceLength','longest');
    
    Val=YPred(1);
    
    for i=1:length(C)
    if(ismember(string(D{i}),Val))
     index=i;
    end
    end
    disp(Val);
    disp(index);
    end