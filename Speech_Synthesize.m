D={'Samsung is in South Korea', 'Lee Byung is the founder of Samsung', 'The focus of Samsung is Smart phones', 'S6 was launched in 2016', 'S6 uses Android OS', 'Samsung is an international company', 'Main competitor of Samsung is Apple', 'S6 costs 1000 ringgits', 'S6 RAM size is3 GB', 'Airasia office is in Subang Jaya', 'Ak021 arrives in 4 hours', 'Next Perth flight is at 5 pm', 'Research office is at C6', 'It is Max', 'Next conference is in June  2019', 'Thank you for coming', 'Hi to all', 'My native is India', 'I study at Taylors university', 'You are Welcome'};
% 


instrfind;
delete(instrfind);
sObject=serial('COM3','BaudRate',9600, 'TimeOut',5, 'Terminator', 'LF');


 fopen(sObject);

 
rec=fgets(sObject);
disp(rec);
a=rec(1);

N=uint8(a);
disp(N);
tts(D{N},[],-1,16000);
fclose(sObject);


