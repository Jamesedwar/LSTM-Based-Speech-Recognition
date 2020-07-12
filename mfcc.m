function Y=mfcc(x,Fs,Q,wlen)
% Mel Frequency Cepstral Coefficients
N=2*2^nextpow2(wlen);
w=hamming(wlen);
X=buffer(x,wlen,wlen*2/3);
L=size(X,2);
H=melfb(Q,N,Fs);
for k=1:L
  y=fft(w.*X(:,k),N);
  s=H*abs(y(1:N/2+1)).^2;
  Y(:,k)=dct(log(s));
end
  [m5,n5]=size(Y);
  for col=1:n5
  for row=1:m5
  E(col)=sum(abs(Y(row,col)).^2);
  end
  end
  