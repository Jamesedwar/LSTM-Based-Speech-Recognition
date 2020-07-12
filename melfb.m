function H=melfb(Q,N,Fs)
% Mel-Scaled Filter Banks
m=log10(1+(0:N/2)/N*Fs/700);
n=max(m)*(0:Q+1)/(Q+1);
c=n(2:Q+1);
d=n(3:Q+2)-n(2:Q+1);
for k=1:Q
h=1-abs(m-c(k))/d(k);
h(h<0)=0;
H(k,:)=h.^2/sum(h.^2);

end