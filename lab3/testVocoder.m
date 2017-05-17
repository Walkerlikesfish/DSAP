
% Test vocoder script
% The output is saved in the 'out' variable
% Use soundsc(out,fs) to listen to the result


[xMod,fsMod] = audioread('vocal.mp3');
%Sound file containing the voice (modulator). 

[xCarr,fsCarr] = audioread('instrument.mp3');
%Sound file containing the instrument (carrier). 

windowLength = 50e-3;
%Length of the window in seconds.

lpcOrder = 8;
%Order of the linear prediction.


%% process

xMod = xMod(:,1);
xCarr = xCarr(:,1);

% convert to same sampling freq.
[fs,i] = min([fsMod fsCarr]);
if i==1
    xCarr = resample(xCarr,fsMod,fsCarr);
else
    xMod = resample(xMod,fsCarr,fsMod);
end

%make lengths the same
xCarr = xCarr(1:min(length(xCarr),length(xMod)));
xMod = xMod(1:min(length(xCarr),length(xMod)));
    

Nwin = round(windowLength*fs);
Nwin = Nwin+(1-mod(Nwin,2));%make length odd
Nhop = (Nwin-1)/2;
win = hann(Nwin);

% clip the first silent part
xCarr = xCarr(8*Nwin:end);

out = zeros(length(xCarr),1);

for n = 1:Nhop:length(xCarr)-Nwin+1
    xCarrw = win.*xCarr(n:n+Nwin-1);
    xModw = win.*xMod(n:n+Nwin-1);
    outw = vocodeLPC(xModw,xCarrw,lpcOrder);
    
    out(n:n+length(outw)-1) = out(n:n+length(outw)-1) + outw;
end
    