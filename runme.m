function varargout = runme(str,varargin)
% Speech Recognition (RNN-MFCC)
% > @rnet, melfb

addpath 'D:\Boo!\Matlab\13 Speech processing\Extras\'

L      = 30;     % Dimension of observations
h      = 20;     % Number of hidden units
lambda = 1e-3;   % Weight decay parameter
iter   = 100;    % Maximum iteration

ID = {'Oh','One','Two','Three','Four','Five','Six','Seven','Eight','Nine','Zero'};

switch str
   case 'train'
      mat = varargin{1};
      
      load(mat,'train')
      
      for k = 1:length(train), X{k} = getobsv(L,train(k).data); end
      
      id = cellfun(@(x)strmatch(x,ID),{train.id});
      Y  = sparse(id,1:length(id),1,11,length(id));
      
      H = rnet([L h 11],0.1);
      H = rnet_bp(H,X,Y,lambda,iter);
      
      varargout{1} = H;
      
   case 'test'
      mat = varargin{1};
      H   = varargin{2};
      
      load(mat,'test')
      
      for k = 1:length(test)
         X = getobsv(L,test(k).data);
         
         Y = rnet_ff(H,X);
         Y = sum(Y(:,2:end),2);
         
         [~,v] = max(Y);
         
         out(k).h = ID{v};
         out(k).t = test(k).id;
      end
      
      varargout{1} = out; end

% FUNCTIONS

function ob = getobsv(L,x)

Lh = 128;
Lx = length(x);
Ls = Lh/4;
Nf = floor((Lx-Lh+Ls)/Ls);
N  = 2^nextpow2(Lh);
Fs = 10000;
w  = hamming(Lh);

x = filter([1 -15/16],1,x-mean(x));

M = melfb(L,N,Fs);

for k = 1:Nf
   x1     = w.*x((k-1)*Ls+(1:Lh));
   c1     = fft(x1,N);
   c2     = M*abs(c1(1:N/2+1)).^2;
   y(:,k) = dct(log(c2));
end

ob = y;
