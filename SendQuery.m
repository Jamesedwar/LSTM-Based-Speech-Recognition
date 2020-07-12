function SQ = SendQuery()

%SREC_LSTM_realtime();
instrfind;
delete(instrfind);
sObject=serial('COM3','BaudRate',9600, 'TimeOut',5, 'Terminator', 'LF');


 fopen(sObject);
% for i=1:n
fwrite(sObject,str);


fclose(sObject);
SQ = 'Send Successfull';