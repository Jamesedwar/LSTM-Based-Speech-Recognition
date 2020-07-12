% I - Acquiring isolated words from user for training
k=1;
for k=1:10
str = input('Enter Filename   :','s');% accepting filename string from user
rec=audiorecorder(16000,16,1);
disp('Get Ready......');
pause(2);
disp('Start Speaking');
recordblocking(rec,2); % Recording speech for 2 sec
display('End of Recording');
play(rec);
y=getaudiodata(rec);
%plot(y);
audiowrite(strcat('Training_Data\',str),y,16000);% concatenating WAV/ with filename
%[z,fs] = audioread(strcat('WAV\',str));
% disp(fs);
% sound(z,fs);
end