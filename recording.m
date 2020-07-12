function [y] =recording()
rec=audiorecorder(16000,16,1);
disp('Get Ready......');
pause(2);
disp('Start Speaking');
recordblocking(rec,2); % Recording speech for 2 sec
display('End of Recording');
play(rec);
y=getaudiodata(rec);
